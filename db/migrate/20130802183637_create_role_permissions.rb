class CreateRolePermissions < ActiveRecord::Migration
  def change
    create_table :role_permissions do |t|
      t.string  :name
      t.string  :key
      t.integer :role_if

      t.timestamps
    end
  end
end
