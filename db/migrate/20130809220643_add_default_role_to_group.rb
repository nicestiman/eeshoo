class AddDefaultRoleToGroup < ActiveRecord::Migration
  def up
    change_table :groups do |t|
      t.integer :default_role_id
    end
  end
  
  def down
    change_table :groups do |t|
      t.remove  :default_role_id
    end
  end
end
