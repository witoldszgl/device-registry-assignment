# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DevicesController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #assign' do
    subject(:assign) do
      post :assign,
           params: { current_user_id: user.id, serial_number: '123456' }
    end

    context 'when the user is authenticated' do
      it 'returns a success response' do
        assign
        expect(response).to be_successful
        expect(JSON.parse(response.body)).to eq({ 'message' => 'Device assigned successfully' })
      end

      it 'assigns the device to the user' do
        expect { assign }.to change { Device.count }.by(1)
        
        device = Device.last
        expect(device.serial_number).to eq('123456')
        expect(device.user_id).to eq(user.id)
      end
    end

    context 'when device is already assigned' do
      let!(:existing_device) { create(:device, user: create(:user), serial_number: '123456') }

      it 'returns an error response' do
        assign
        expect(response.code).to eq('422')
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Device is already assigned' })
      end
    end

    context 'when user has previously returned this device' do
      before do

        device = create(:device, user: user, serial_number: '123456')
        device.assign(user)
        

        ReturnDeviceFromUser.new(user: user, serial_number: '123456').call
      end

      it 'returns an error response' do
        assign
        expect(response.code).to eq('422')
        expect(JSON.parse(response.body)).to eq({ 'error' => 'User has previously returned this device and cannot reassign it' })
      end
    end
  end

  describe 'POST #unassign' do
    subject(:unassign) do
      post :unassign,
           params: { current_user_id: user.id, serial_number: '123456' }
    end

    context 'when device is assigned to user' do
      let!(:device) { create(:device, user: user, serial_number: '123456') }

      it 'returns a success response' do
        unassign
        expect(response).to be_successful
        expect(JSON.parse(response.body)).to eq({ 'message' => 'Device unassigned successfully' })
      end

      it 'unassigns the device from the user' do
        expect { unassign }.to change { device.reload.user_id }.from(user.id).to(nil)
      end
    end

    context 'when device is not found' do
      it 'returns an error response' do
        unassign
        expect(response.code).to eq('422')
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Device not found' })
      end
    end

    context 'when device is not assigned' do
      let!(:device) { create(:device, user: nil, serial_number: '123456') }

      it 'returns an error response' do
        unassign
        expect(response.code).to eq('422')
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Device is not currently assigned' })
      end
    end
  end
end
