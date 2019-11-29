class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :update, :destroy]

  def get_chats
    app = App.find_by_token(params[:app_token])
    if app
      render json: app.chats.as_json(only: [:chat_number, :created_at])
    else
      render json: ErrorController.invalid_token(params[:app_token].to_s)
    end
  end

  def get_messages_count
    application = App.find_by_token(params[:app_token])
    if application
      chat = application.chats.find_by_chat_number(params[:chat_number])
      if chat
        render json: chat.messages_count
      else
        render json: ErrorController.invalid_chat_number(params[:chat_number].to_s)
      end
    else
      render json: ErrorController.invalid_token(params[:app_token].to_s)
    end
  end

  def post_chat
    application = App.find_by_token(params[:app_token])
    if application
      max_till_now = application.chats.maximum('chat_number')
      if max_till_now
        new_chat_number = max_till_now + 1
      else
        new_chat_number = 1
      end
      chat = Chat.new({chat_number: new_chat_number,app_id: application.id})
      if chat.save
        render json: chat.as_json(only: [:chat_number, :created_at])
      else
        render json: chat.errors, status: :unprocessable_entity
      end
    else
      render json: ErrorController.invalid_token(params[:app_token].to_s)
    end
  end

  def delete_chat
    application = App.find_by_token(params[:app_token])
    if application
      chat = Chat.find_by(app_id: application.id, chat_number: params[:chat_number])
      if chat
        if chat.destroy
          render json: "Successful: Deleted chat number " +  params[:chat_number].to_s
        else
          render json: "Unsuccessful: Valid parameters but could not Delete"
        end
      else
        render json: ErrorController.invalid_chat_number(params[:chat_number].to_s)
      end
    else
      render json: ErrorController.invalid_token(params[:app_token].to_s)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = Chat.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def chat_params
      params.fetch(:chat, {})
    end
end
