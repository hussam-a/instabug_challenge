class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :update, :destroy]

  def get_messages
    application = App.find_by_token(params[:app_token])
    if application
      chat = Chat.find_by(app_id: application.id, chat_number: params[:chat_number])
      if chat
        render json: chat.messages.as_json(only: [:message_number, :content, :created_at, :updated_at])
      else
        render json: ErrorController.invalid_chat_number(params[:chat_number].to_s)
      end
    else
      render json: ErrorController.invalid_token(params[:app_token].to_s)
    end    
  end

  def post_message  
    content_to_use = request.body.read()
    if content_to_use != nil
      application = App.find_by_token(params[:app_token])
      if application
        chat = application.chats.find_by_chat_number(params[:chat_number])
        if chat
          max_till_now =  chat.messages.maximum('message_number')
          if max_till_now
            new_message_number = max_till_now + 1
          else
            new_message_number = 1
          end
          message = Message.new({chat_id: chat.id,message_number: new_message_number, 
            content: content_to_use})
          if message.save
            render json: message.as_json(only: [:message_number, :content, :created_at, :updated_at])
          else
            render json: message.errors, status: :unprocessable_entity
          end
        else
          render json: ErrorController.invalid_chat_number(params[:chat_number].to_s)
        end
      else
        render json: ErrorController.invalid_token(params[:app_token].to_s)
      end
    else
      render json: "Unsuccessful: cannot accept nil POST body for message content"
    end
  end

  def get_message
    application = App.find_by_token(params[:app_token])
    if application
      chat = Chat.find_by(app_id: application.id, chat_number: params[:chat_number])
      if chat
        message = Message.find_by(chat_id: chat.id, message_number: params[:message_number])
        if message
          render json: message.as_json(only: [:message_number, :content, :created_at, :updated_at])
        else
          render json: ErrorController.invalid_message_number(params[:message_number].to_s)
        end
      else
        render json: ErrorController.invalid_chat_number(params[:chat_number].to_s)
      end
    else
      render json: ErrorController.invalid_token(params[:app_token].to_s)
    end
  end

  def delete_message
    application = App.find_by_token(params[:app_token])
    if application
      chat = Chat.find_by(app_id: application.id, chat_number: params[:chat_number])
      if chat
        message = Message.find_by(chat_id: chat.id, message_number: params[:message_number])
        if message
          if message.destroy
            render json: "Successful: Deleted message number " +  params[:message_number].to_s
          else
            render json: "Unsuccessful: Valid parameters but could not Delete"
          end
        else
          render json: ErrorController.invalid_message_number(params[:message_number].to_s)
        end
      else
        render json: ErrorController.invalid_chat_number(params[:chat_number].to_s)
      end
    else
      render json: ErrorController.invalid_token(params[:app_token].to_s)
    end
  end

  def update_message
    content_to_use = request.body.read()
    if content_to_use != nil
      application = App.find_by_token(params[:app_token])
      if application
        chat = application.chats.find_by_chat_number(params[:chat_number])
        if chat
          max_till_now =  chat.messages.maximum('message_number')
          if max_till_now
            new_message_number = max_till_now + 1
          else
            new_message_number = 1
          end
          message = Message.find_by(chat_id: chat.id, message_number: params[:message_number])
          if message
            if message.update({content: content_to_use})
              render json: message.as_json(only: [:message_number, :content, :created_at, :updated_at])
            else
              render json: message.errors, status: :unprocessable_entity
            end
          else
            render json: ErrorController.invalid_message_number(params[:message_number].to_s)
          end
        else
          render json: ErrorController.invalid_chat_number(params[:chat_number].to_s)
        end
      else
        render json: ErrorController.invalid_token(params[:app_token].to_s)
      end
    else
      render json: "Unsuccessful: cannot accept nil POST body for message content"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def message_params
      params.fetch(:message, {})
    end
end
