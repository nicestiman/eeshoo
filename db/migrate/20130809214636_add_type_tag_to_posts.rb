class AddTypeTagToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :species, :string
  end
end
