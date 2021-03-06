# frozen_string_literal: true

class ShareRecordsController < ApplicationController
  # CSRF can be complex. Skip only if it is a json request
  skip_before_action :verify_authenticity_token, if: :json_request?, only: %i[create temp_revoke destroy permit]
  before_action :authenticate!, only: %i[new create]

  def index
    @share_records = if current_user
                       current_user.share_records.includes(:medical_record, :shareable).order(created_at: :desc)
                     elsif current_doctor || current_pharmacist
                       current_resource.share_records.where(shared: true).includes(:medical_record, :user)
                                       .order(created_at: :desc)
                     end
  end

  def create
    share_record = resource.share_records.new(share_record_params)
    share_record.shared = user_signed_in?
    if share_record.save
      respond_to do |format|
        format.json { render json: { message: 'Record has been successfully shared' }, status: 200 }
      end
    else
      respond_to do |format|
        format.json do
          render json: { errors: share_record.errors, message: render_fail_message }, status: 400
        end
      end
    end
  end

  # Temporarily change the shared status
  def temp_revoke
    share_record = current_user.share_records.find(params[:id])
    share_record.safe_toggle(:shared)
    render json: { message: 'Permission has been toggled successfully', visible: share_record.shared? }, status: 200
  end

  # Permits the record to be shared
  def permit
    share_record = current_user.share_records.find(params[:id])
    share_record.update(shared: true)
    render json: { message: 'Permission has been granted successfully' }, status: 200
  end

  def destroy
    share_record = current_user.share_records.find(params[:id])
    share_record.destroy
    render json: { message: '' }, status: 204
  end

  private

  def resource
    @resource ||= if current_user
                    current_user
                  else
                    User.find(params[:share_record][:user_id])
                  end
  end

  # Render the fail message according to who has logged in
  def render_fail_message
    if current_user
      'This record has already been shared'
    else
      'This record has already been requested'
    end
  end

  def share_record_params
    params.require(:share_record).permit(:medical_record_id, :shareable_id, :shareable_type, :created_by, :action)
  end

  def json_request?
    request.format.json?
  end
end
