class AddGroupsRoles < ActiveRecord::Migration
  def change
    create_table :groups_roles do  |t|
      t.belongs_to :group
      t.belongs_to :role
    end
  end
end
