class CreateDeviceAssignments < ActiveRecord::Migration[7.1]
  def change
    add_reference :devices, :user, null: true, foreign_key: true
    
    create_table :device_assignments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :device, null: false, foreign_key: true
      t.string :operation_type, null: false, default: 'assign'
      t.datetime :performed_at, null: false
    end
  end
end 