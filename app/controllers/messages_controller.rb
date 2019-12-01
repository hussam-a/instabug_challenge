class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :update, :destroy]

  def get_messages
    cached_response = $redis.get("messages_get_messages_"+params[:app_token]+"_"+params[:chat_number])
    if !cached_response then    
      application = App.find_by_token(params[:app_token])
      if application
        chat = Chat.find_by(app_id: application.id, chat_number: params[:chat_number])
        if chat
          to_cache = chat.messages.as_json(only: [:message_number, :content, :created_at, :updated_at])
          $redis.set("messages_get_messages_"+params[:app_token]+"_"+params[:chat_number],to_cache)
          render json: to_cache
        else
          render json: ErrorController.invalid_chat_number(params[:chat_number].to_s)
        end
      else
        render json: ErrorController.invalid_token(params[:app_token].to_s)
      end
    else
      render json: cached_response
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
            keys_to_delete = $redis.keys(pattern = "chats_get_messages_count_"+params[:app_token]+"_"+params[:chat_number])
            keys_to_delete.each do |key|
              $redis.del(key)
            end
            keys_to_delete = $redis.keys(pattern = "messages_get_messages_"+params[:app_token]+"_"+params[:chat_number])
            keys_to_delete.each do |key|
              $redis.del(key)
            end
            keys_to_delete = $redis.keys(pattern = "search_"+params[:app_token]+"_*"+params[:chat_number]+"*")
            keys_to_delete.each do |key|
              $redis.del(key)
            end
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
    cached_response = $redis.get("messages_get_message_"+params[:app_token]+"_"+params[:chat_number]+"_"+params[:message_number])
    if !cached_response then  
      application = App.find_by_token(params[:app_token])
      if application
        chat = Chat.find_by(app_id: application.id, chat_number: params[:chat_number])
        if chat
          message = Message.find_by(chat_id: chat.id, message_number: params[:message_number])
          if message
            to_cache = message.as_json(only: [:message_number, :content, :created_at, :updated_at])
            $redis.set("messages_get_message_"+params[:app_token]+"_"+params[:chat_number]+"_"+params[:message_number],to_cache)
            render json: to_cache
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
    render json: cached_response
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
            keys_to_delete = $redis.keys(pattern = "*"+params[:app_token]+"_*"+params[:chat_number]+"_*"+params[:message_number]+"*")
            keys_to_delete.each do |key|
              $redis.del(key)
            end
            keys_to_delete = $redis.keys(pattern = "chats_get_messages_count_"+params[:app_token]+"_"+params[:chat_number])
            keys_to_delete.each do |key|
              $redis.del(key)
            end
            keys_to_delete = $redis.keys(pattern = "search_"+params[:app_token]+"_*"+params[:chat_number]+"*")
            keys_to_delete.each do |key|
              $redis.del(key)
            end
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
              keys_to_delete = $redis.keys(pattern = "*"+params[:app_token]+"_*"+params[:chat_number]+"_*"+params[:message_number]+"*")
              keys_to_delete.each do |key|
                $redis.del(key)
              end
              keys_to_delete = $redis.keys(pattern = "search_"+params[:app_token]+"_*"+params[:chat_number]+"*")
              keys_to_delete.each do |key|
                $redis.del(key)
              end
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
