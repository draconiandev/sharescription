# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id                :uuid             not null, primary key
#  sender_type       :string
#  sender_id         :uuid
#  recepient_type    :string
#  recepient_id      :uuid
#  action            :string           default(NULL), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  medical_record_id :uuid
#  share_record_id   :uuid
#

describe Notification, type: :model do
  let(:notification) { build :notification }

  it 'has a valid factory' do
    expect(build(:notification)).to be_valid
  end

  describe 'ActiveModel validations' do
    # Presence Validations
    it { expect(notification).to validate_presence_of(:action) }
  end

  context 'ActiveRecord Associations' do
    it { expect(notification).to belong_to(:sender) }
    it { expect(notification).to belong_to(:recepient) }
  end

  describe 'ActiveRecord databases' do
    it { expect(notification).to have_db_column(:action).of_type(:string).with_options(null: false, default: '') }
    it { expect(notification).to have_db_column(:sender_type).of_type(:string) }
    it { expect(notification).to have_db_column(:sender_id).of_type(:uuid) }
    it { expect(notification).to have_db_column(:recepient_type).of_type(:string) }
    it { expect(notification).to have_db_column(:recepient_id).of_type(:uuid) }
  end

  describe 'public class methods' do
    context 'responds to its methods' do
      it { expect(Notification).to respond_to(:create_from) }
    end

    context 'executes self.create_from properly' do
      it 'creates a notification from share record' do
        share_record = create :share_record, action: :granted
        expect(Notification.create_from(share_record)).to eq Notification.find_by(share_record: share_record)
      end
    end
  end
end
