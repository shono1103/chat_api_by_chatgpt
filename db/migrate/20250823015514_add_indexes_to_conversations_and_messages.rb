class AddIndexesToConversationsAndMessages < ActiveRecord::Migration[7.1]
  def change
    add_index :conversations, [ :user1_id, :user2_id ], unique: true
    add_index :conversations, :updated_at
    add_index :messages, :created_at
  end
end
