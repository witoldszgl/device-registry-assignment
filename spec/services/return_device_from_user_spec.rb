# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReturnDeviceFromUser do
  let(:user) { create(:user) }
  let(:device) { create(:device, user: user) }
  let(:service) { described_class.new(user: user, serial_number: device.serial_number) }

  describe '#call' do
    context 'when device exists and is assigned to user' do
      it 'successfully returns the device' do
        expect { service.call }.to change { device.reload.user_id }.from(user.id).to(nil)
      end

      it 'creates a return device assignment record' do
        expect { service.call }.to change(DeviceAssignment, :count).by(1)
        
        assignment = DeviceAssignment.last
        expect(assignment.user_id).to eq(user.id)
        expect(assignment.operation_type).to eq('return')
        expect(assignment.performed_at).to be_present
      end
    end

    context 'when device is not found' do
      let(:service) { described_class.new(user: user, serial_number: 'NONEXISTENT') }

      it 'raises an error' do
        expect { service.call }.to raise_error(StandardError, 'Device not found')
      end
    end

    context 'when device is not currently assigned' do
      let(:unassigned_device) { create(:device, user: nil) }
      let(:service) { described_class.new(user: user, serial_number: unassigned_device.serial_number) }

      it 'raises an error' do
        expect { service.call }.to raise_error(StandardError, 'Device is not currently assigned')
      end
    end

    context 'when device is assigned to different user' do
      let(:other_user) { create(:user) }
      let(:device_assigned_to_other) { create(:device, user: other_user) }
      let(:service) { described_class.new(user: user, serial_number: device_assigned_to_other.serial_number) }

      it 'raises an error' do
        expect { service.call }.to raise_error(StandardError, 'Only the user who assigned the device can return it')
      end
    end
  end
end