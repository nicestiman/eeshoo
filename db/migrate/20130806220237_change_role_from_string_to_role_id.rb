class ChangeRoleFromStringToRoleId < ActiveRecord::Migration
  def up
    change_table :assignments do |t|
      t.remove :role
      t.integer :role_id
    end
  end

  def down
    change_table :assinments do |t|
      t.remove :role_id
      t.string :role
    end
  end
end 
