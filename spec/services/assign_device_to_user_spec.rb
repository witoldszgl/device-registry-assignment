# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssignDeviceToUser do
  subject(:assign_device) do
    described_class.new(
      user: user,
      serial_number: serial_number
    ).call
  end

  let(:user) { create(:user) }
  let(:serial_number) { '123456' }

  context 'when user registers a device on self' do
    it 'creates a new device and assigns it to user' do
      expect { assign_device }.to change(Device, :count).by(1)
      
      device = Device.last
      expect(device.serial_number).to eq(serial_number)
      expect(device.user_id).to eq(user.id)
    end

    it 'creates a device assignment record' do
      expect { assign_device }.to change(DeviceAssignment, :count).by(1)
      
      assignment = DeviceAssignment.last
      expect(assignment.user_id).to eq(user.id)
      expect(assignment.operation_type).to eq('assign')
      expect(assignment.performed_at).to be_present
    end
  end

  context 'when device is already assigned to another user' do
    let(:other_user) { create(:user) }
    let!(:existing_device) { create(:device, user: other_user, serial_number: serial_number) }

    it 'raises an error' do
      expect { assign_device }.to raise_error(StandardError, 'Device is already assigned')
    end
  end

  context 'when user has previously returned this device' do
    before do

      device = create(:device, user: user, serial_number: serial_number)
      device.assign(user)
      

      ReturnDeviceFromUser.new(user: user, serial_number: serial_number).call
    end

    it 'raises an error' do
      expect { assign_device }.to raise_error(StandardError, 'User has previously returned this device and cannot reassign it')
    end
  end

  context 'when device is not found' do
    it 'creates a new device and assigns it' do
      expect { assign_device }.to change(Device, :count).by(1)
      
      device = Device.last
      expect(device.serial_number).to eq(serial_number)
      expect(device.user_id).to eq(user.id)
    end
  end
end

