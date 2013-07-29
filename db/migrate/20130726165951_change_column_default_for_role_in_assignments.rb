class ChangeColumnDefaultForRoleInAssignments < ActiveRecord::Migration
  def change
    change_column_default :assignments, :role, 'user'
  end
end
