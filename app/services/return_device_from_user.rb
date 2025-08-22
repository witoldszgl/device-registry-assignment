# frozen_string_literal: true

class ReturnDeviceFromUser
  attr_reader :user, :serial_number

  def initialize(user:, serial_number:)
    @user = user
    @serial_number = serial_number
  end

  def call
    device = Device.find_by(serial_number: serial_number)
    raise StandardError, "Device not found" unless device

    unless device.user_id.present?
      raise StandardError, "Device is not currently assigned"
    end

    unless device.user == user
      raise StandardError, "Only the user who assigned the device can return it"
    end

    device.unassign(user)
  end
end