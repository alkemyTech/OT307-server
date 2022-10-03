class CreateSlides < ActiveRecord::Migration[6.1]
  def change
    create_table :slides do |t|
      t.integer :order
      t.string :text
      t.string :image_url
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
