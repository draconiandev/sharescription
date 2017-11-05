# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, :name, presence: true
  validates :email, uniqueness: {  case_sensitive: false }
  validates :name, format: { with: /\A[a-zA-Z. ]*\z/, message: 'please use only English alphabets' },
                   length: { in: 4..60 }

  has_many :medical_records, dependent: :destroy
  has_many :share_records, dependent: :destroy
  has_many :prescriptions, through: :medical_records
  has_many :notifications, dependent: :destroy

  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
