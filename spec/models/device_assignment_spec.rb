require 'rails_helper'

RSpec.describe DeviceAssignment, type: :model do
  let(:user) { create(:user) }
  let(:device) { create(:device) }
  let(:assignment) { create(:device_assignment, user: user, device: device) }


  it 'has user and device' do
    expect(assignment.user).to eq(user)
    expect(assignment.device).to eq(device)
  end

  it 'needs operation_type' do
    assignment = build(:device_assignment, operation_type: nil)
    expect(assignment.valid?).to eq(false)
  end

  it 'needs performed_at' do
    assignment = build(:device_assignment, performed_at: nil)
    expect(assignment.valid?).to eq(false)
  end

  it 'knows operation types' do
    assign_op = create(:device_assignment, operation_type: 'assign')
    return_op = create(:device_assignment, operation_type: 'return')
    
    expect(assign_op.operation_type).to eq('assign')
    expect(return_op.operation_type).to eq('return')
  end
end 