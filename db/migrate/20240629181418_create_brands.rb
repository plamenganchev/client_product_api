class CreateBrands < ActiveRecord::Migration[7.1]
  def change
    create_table :brands do |t|
      t.string :name
      t.string :country
      t.text :description
      t.string :status

      t.timestamps
    end
    add_index :brands, [:name, :country], unique: true

  end
end
