class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]

  def index
    # @restaurant = Restaurant.all
    # Devido as regras do Scope definidas na minha RestaurantPolicy
    # essas duas linhas retornam exatamente a mesma coisa
    @restaurants = policy_scope(Restaurant)
  end

  def show
  end

  def new
    @restaurant = Restaurant.new
    authorize @restaurant
  end

  def edit
    # Código utilizado como exemplo de uma autorização
    # utilizando o 'Devise'
    # NÃO FAZEMOS ISSO. Utilizamos o 'Pundit'
    # unless @restaurant.user == current_user
    #   redirect_to restaurants_path
    # end
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user
    authorize @restaurant

    if @restaurant.save
      redirect_to @restaurant, notice: 'Restaurant was successfully created.'
    else
      render :new
    end
  end

  def update
    if @restaurant.update(restaurant_params)
      redirect_to @restaurant, notice: 'Restaurant was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @restaurant.destroy
    redirect_to restaurants_url, notice: 'Restaurant was successfully destroyed.'
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
    authorize @restaurant
  end

  def restaurant_params
    params.require(:restaurant).permit(:name)
  end
end
