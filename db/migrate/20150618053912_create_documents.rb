class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :user_id
      t.text :content
      t.float :lat
      t.float :lng
      t.string :date
      t.string :weather

      t.timestamps
    end
    add_index :documents, [:user_id, :created_at]
  end
end
