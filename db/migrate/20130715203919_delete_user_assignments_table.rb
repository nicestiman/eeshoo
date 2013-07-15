class DeleteUserAssignmentsTable < ActiveRecord::Migration
  def change
    drop_table :user_assignments
  end
end
