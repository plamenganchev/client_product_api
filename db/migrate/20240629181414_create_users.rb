class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, index: { unique: true }
      t.string :password_digest
      t.string :authentication_token
      t.references :user_role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
