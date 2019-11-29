class Chat < ApplicationRecord

    belongs_to :app, foreign_key: 'app_id', primary_key: 'id'

    has_many :messages, foreign_key: 'chat_id', primary_key: 'id'

    trigger.after(:insert) do
        "UPDATE apps SET chats_count = chats_count + 1 WHERE apps.id = NEW.app_id;"
      end

    trigger.after(:delete) do
      "UPDATE apps SET chats_count = chats_count - 1 WHERE apps.id = OLD.app_id;"
    end
end
