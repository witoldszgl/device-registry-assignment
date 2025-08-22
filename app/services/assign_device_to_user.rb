# frozen_string_literal: true

class AssignDeviceToUser
  attr_reader :user, :serial_number

  def initialize(user:, serial_number:)
    @user = user
    @serial_number = serial_number
  end

  def call
    device = Device.find_or_create_by(serial_number: serial_number)
    
    if device.user_id.present?
      raise StandardError, "Device is already assigned"
    end

    if device.returned_by_user?(user.id)
      raise StandardError, "User has previously returned this device and cannot reassign it"
    end

    device.assign(user)
  end
end
