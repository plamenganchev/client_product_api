class CreateBrands < ActiveRecord::Migration[7.1]
  def change
    create_table :brands do |t|
      t.string :name
      t.references :country, null: false, foreign_key: true
      t.text :description
      t.string :status

      t.timestamps
    end
    add_index :brands, [:name, :country_id], unique: true

  end
end
