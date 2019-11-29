class CreateApps < ActiveRecord::Migration[5.2]
  def change
    create_table :apps do |t|
      t.string :name
      t.string :token
      t.integer :chats_count
      t.timestamps
    end
    add_index :apps, :token
    change_column_default :apps, :chats_count, 0

  end
end
