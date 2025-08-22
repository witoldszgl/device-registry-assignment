require 'rails_helper'

RSpec.describe Device, type: :model do
  let(:user) { create(:user) }
  let(:device) { create(:device) }

  it 'works with basic assignment flow' do

    device.assign(user)
    expect(device.user_id).to eq(user.id)
    expect(device.user).to eq(user)


    device.unassign(user)
    expect(device.user_id).to eq(nil)
    expect(device.user).to eq(nil)
  end

  it 'should track history somehow' do
    device.assign(user)
    device.unassign(user)
    
    expect(device.device_assignments.count).to eq(2) 
    expect(device.returned_by_user?(user.id)).to eq(true)
  end

  it 'needs unique serial numbers' do

    bad_device = build(:device, serial_number: nil)
    expect(bad_device.valid?).to eq(false)


    device1 = create(:device, serial_number: "ABC123")
    device2 = build(:device, serial_number: "ABC123")
    expect(device2.valid?).to eq(false)
  end

  describe 'assignment tracking' do
    it 'tracks when user assigns device' do
      device.assign(user)
      assignment = device.device_assignments.last
      expect(assignment.operation_type).to eq('assign')
      expect(assignment.user).to eq(user)
    end

    it 'tracks when user returns device' do
      device.assign(user)
      device.unassign(user)
      return_op = device.device_assignments.last
      expect(return_op.operation_type).to eq('return')
    end
  end
end
