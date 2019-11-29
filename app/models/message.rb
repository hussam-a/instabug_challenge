class Message < ApplicationRecord

    belongs_to :chat, foreign_key: 'chat_id', primary_key: 'id'

  trigger.after(:insert) do
      "UPDATE chats SET messages_count = messages_count + 1 WHERE chats.id = NEW.chat_id;"
    end

  trigger.after(:delete) do
    "UPDATE chats SET messages_count = messages_count - 1 WHERE chats.id = OLD.chat_id;"
  end


  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name Rails.application.class.parent_name.underscore
  document_type self.name.downcase

  settings index: { number_of_shards: 1 } do
    mapping dynamic: false do
      indexes :message_number, type: :long
      indexes :chat_id, type: :long
      indexes :content, type: :text, analyzer: 'english'
    end
  end

  def self.search(query)
    __elasticsearch__.search(
      {
        size: 20,
        query: {
          query_string: {
            query: "*"+query.to_s+"*",
            fields: ['content']
          }
        }
      }
    )
  end

  def as_indexed_json(options = nil)
    self.as_json( only: [ :message_number, :chat_id, :content ] )
  end

end
