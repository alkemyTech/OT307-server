class CreateNews < ActiveRecord::Migration[6.1]
  def change
    create_table :news do |t|
      t.string :name, null: false
      t.text :content, null: false
      t.references :category, null: false, foreign_key: true
      t.datetime :discarded_at
      t.index :discarded_at

      t.timestamps
    end
  end
end
