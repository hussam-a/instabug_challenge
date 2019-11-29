# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggerMessagesInsert < ActiveRecord::Migration[5.2]
  def up
    create_trigger("messages_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("messages").
        after(:insert) do
      "UPDATE chats SET messages_count = messages_count + 1 WHERE chats.id = NEW.chat_id;"
    end
  end

  def down
    drop_trigger("messages_after_insert_row_tr", "messages", :generated => true)
  end
end
