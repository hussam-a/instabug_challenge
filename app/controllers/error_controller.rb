class ErrorController < ApplicationController

    def self.invalid_token(app_token)
        return "Unsuccessful: Invalid token sent " +  app_token
    end

    def self.invalid_chat_number(chat_number)
        return "Unsuccessful: Invalid chat number sent " + chat_number
    end

    def self.invalid_message_number(message_number)
        return "Unsuccessful: Invalid message number sent " +  message_number
    end

end
