class RecipesController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :render_unproccessable_entity_response
    def index
        render json: Recipe.all, status: :created
    end

    def create
        user = User.find(session[:user_id])
        recipe = Recipe.create!({
            title: params[:title],
            minutes_to_complete: params[:minutes_to_complete],
            instructions: params[:instructions],
            user_id: user.id
        })
        render json: recipe, status: :created
    end

    private

    def recipe_params
        params.permit(:title, :minutes_to_complete, :instructions)
    end

    def render_unproccessable_entity_response(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end
end
