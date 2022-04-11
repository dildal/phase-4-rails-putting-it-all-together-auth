class SessionsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    skip_before_action :authorized, only: :create
    def create
        user = User.find_by(username: params[:username])
        if user&.authenticate(params[:password])
            session[:user_id] = user.id
            render json: user, status: :ok
        else
            render json: {errors: ["Not authorized"]}, status: :unauthorized
        end 
    end

    def destroy
        if session[:user_id]
            session.delete :user_id
            head :no_content
        end
        # else
        #     render json: {errors: "Not authorized"}, status: :unauthorized
        # end
    end

    private

    def user_params
        params.permit(:username, :password)
    end

    def render_not_found_response(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unauthorized
    end
end
