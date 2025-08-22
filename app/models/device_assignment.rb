class DeviceAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :device

  validates :operation_type, presence: true, inclusion: { in: %w[assign return] }
  validates :performed_at, presence: true

  scope :returns, -> { where(operation_type: 'return') }
end 