class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :chat_number
      t.bigint :app_id
      t.integer :messages_count
      t.timestamps
    end
    add_foreign_key :chats, :apps, on_delete: :cascade
    add_index :chats, :chat_number
    change_column_default :chats, :messages_count, 0
  end
end
