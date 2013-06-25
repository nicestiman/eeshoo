class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :group_id
      t.string :role
      t.integer :user_id

      t.timestamps
    end
  end
end
