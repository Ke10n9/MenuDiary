class StaticPagesController < ApplicationController
  def home
    @meal = current_user.meals.build if logged_in?
    @dish = current_user.dishes.build if logged_in?
    @meals = current_user.meals.paginate(page: params[:page]) if logged_in?
  end

  def contact
  end

  # def help
  # end
  #
  # def about
  # end
end
