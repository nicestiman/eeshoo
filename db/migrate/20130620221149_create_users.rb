class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string :first
      t.string :last
      t.string :digest

      t.timestamps
    end
    add_index :users, :login
  end
end
