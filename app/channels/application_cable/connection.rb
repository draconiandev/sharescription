# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    # Identify the user by current_user
    # Add tags for better debugging
    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.name
    end

    private

    # Using the warden env, we find who is logged in and use them as the identifier
    def find_verified_user
      if (verified_user = User.find_by(id: cookies.signed['user.id']) ||
        Doctor.find_by(id: cookies.signed['doctor.id']) ||
        Pharmacist.find_by(id: cookies.signed['pharmacist.id']))
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
