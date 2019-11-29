class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.bigint :chat_id
      t.integer :message_number 
      t.text :content
      t.timestamps
    end
    add_foreign_key :messages, :chats, on_delete: :cascade
    add_index :messages, :message_number
  end
end
