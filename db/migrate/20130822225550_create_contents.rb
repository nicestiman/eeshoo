class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.integer :post_id
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
