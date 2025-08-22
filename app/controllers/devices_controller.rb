# frozen_string_literal: true

class DevicesController < ApplicationController
  before_action :authenticate_user!, only: %i[assign unassign]
  def assign
    user = User.find(params[:current_user_id])
    service = AssignDeviceToUser.new(
      user: user,
      serial_number: params[:serial_number]
    )
    service.call
    render json: { message: 'Device assigned successfully' }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def unassign
    user = User.find(params[:current_user_id])
    service = ReturnDeviceFromUser.new(
      user: user,
      serial_number: params[:serial_number]
    )
    service.call
    render json: { message: 'Device unassigned successfully' }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def device_params
    params.permit(:current_user_id, :serial_number)
  end
end
