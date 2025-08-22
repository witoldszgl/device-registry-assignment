class Device < ApplicationRecord
  belongs_to :user, optional: true
  has_many :device_assignments, -> { order(:performed_at) }, dependent: :destroy

  validates :serial_number, presence: true, uniqueness: true

  def returned_by_user?(user_id)
    device_assignments.returns.where(user_id: user_id).exists?
  end

  def assign(user)
    ActiveRecord::Base.transaction do
      device_assignments.create!(
        user_id: user.id,
        operation_type: 'assign',
        performed_at: Time.current
      )
      update!(user_id: user.id)
    end
  end

  def unassign(user)
    ActiveRecord::Base.transaction do
      device_assignments.create!(
        user_id: user.id,
        operation_type: 'return',
        performed_at: Time.current
      )
      update!(user_id: nil)
    end
  end
end


