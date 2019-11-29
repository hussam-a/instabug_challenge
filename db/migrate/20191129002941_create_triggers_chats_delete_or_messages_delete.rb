# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersChatsDeleteOrMessagesDelete < ActiveRecord::Migration[5.2]
  def up
    create_trigger("chats_after_delete_row_tr", :generated => true, :compatibility => 1).
        on("chats").
        after(:delete) do
      "UPDATE apps SET chats_count = chats_count - 1 WHERE apps.id = OLD.app_id;"
    end

    create_trigger("messages_after_delete_row_tr", :generated => true, :compatibility => 1).
        on("messages").
        after(:delete) do
      "UPDATE chats SET messages_count = messages_count - 1 WHERE chats.id = OLD.chat_id;"
    end
  end

  def down
    drop_trigger("chats_after_delete_row_tr", "chats", :generated => true)

    drop_trigger("messages_after_delete_row_tr", "messages", :generated => true)
  end
end
