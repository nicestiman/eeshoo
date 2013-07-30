class CreateTranslationsTable < ActiveRecord::Migration
  def change
    create_table(:translations) do |t|
      t.column :language, :string, limit: 2
      t.column :reference, :string
      t.column :translation, :string
    end
  end
end
