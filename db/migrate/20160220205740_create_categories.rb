class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :ebay_id
      t.references :parent
      t.timestamps null: false
    end
  end
end
