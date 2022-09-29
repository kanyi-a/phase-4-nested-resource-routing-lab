class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
	wrap_parameters format: []

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end
  def show
    item = Item.find(params[:id])
      render json: item, status: :ok
  end
  
  def create
    user = find_user
    item = user.items.create(item_params)
    render json: item, status: :created
  end
    

  private

  def item_params
    params.permit(:name, :description, :price)
  end
  def render_not_found
		render json: {error: "We could not find what you are looking for"}, status: :not_found
	end
  def find_user
    User.find(params[:user_id])
  end
end
