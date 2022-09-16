class CreateOrganizations < ActiveRecord::Migration[6.1]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :address
      t.integer :phone
      t.string :email, null: false
      t.text :welcomeText, null: false
      t.text :aboutUsText
      t.datetime :discarded_at
      t.index :discarded_at

      t.timestamps
    end
  end
end
