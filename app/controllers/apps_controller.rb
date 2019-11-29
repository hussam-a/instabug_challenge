class AppsController < ApplicationController
  before_action :set_app, only: [:show, :update, :destroy]

  def get_token 
      if params[:name] and params[:name] != ""
        new_token = SecureRandom.uuid
        app = App.new({name: params[:name],token: new_token})
        if app.save
          render json: app.as_json(only: [:token, :name, :created_at])
        else
          render json: app.errors, status: :unprocessable_entity
        end
      else
        render json: "Unsuccessful: Invalid name sent"
      end
  end

  def delete_app
    application = App.find_by_token(params[:app_token])
    if application
      if application.destroy
        render json: "Successful: Deleted " +  params[:app_token].to_s
      else
        render json: "Unsuccessful: Valid token number but could not Delete"
      end
    else
      render json: ErrorController.invalid_token(params[:app_token].to_s)
    end
  end

  def get_chats_count
    application = App.find_by_token(params[:app_token])
    if application
      render json: application.chats_count
    else
      render json: ErrorController.invalid_token(params[:app_token].to_s)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app
      @app = App.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def app_params
      params.fetch(:app, {})
    end
end
