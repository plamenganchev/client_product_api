class CreateUserRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :user_roles do |t|
      t.string :role, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
