
class CreateApiRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :api_requests do |t|
      t.integer :user_id
      t.string :api_key
      t.string :endpoint
      t.string :remote_ip
      t.string :status
      t.json :payload
      t.timestamps
    end
  end
end
