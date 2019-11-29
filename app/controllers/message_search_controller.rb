require 'json'
class MessageSearchController < ApplicationController

  def search
      if params[:query]  
            application = App.find_by_token(params[:app_token])
            if application
              chat = Chat.find_by(app_id: application.id, chat_number: params[:chat_number])
              if chat
                search_results = Message.search( params[:query] )
                return_results = {"results"=>[]}
                search_results.each do |result_item|
                  if chat.id == result_item["_source"]["chat_id"] then
                  message_number = result_item["_source"]["message_number"]
                  content = result_item["_source"]["content"]
                  return_results["results"] << {:message_number => message_number, :content => content}   
                  end
                end
                render json: return_results
              else
                render json: ErrorController.invalid_chat_number(params[:chat_number].to_s)
              end
            else
              render json: ErrorController.invalid_token(params[:app_token].to_s)
            end
      else
        render json: "Unsuccessful: Invalid query parameter"
      end
  end
end    
