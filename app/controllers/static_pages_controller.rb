class StaticPagesController < ApplicationController
  before_action :set_initial_date, only: :home

  def home
    @meal = current_user.meals.build if logged_in?
    @dish = current_user.dishes.build if logged_in?
    @meals = current_user.meals.all if logged_in?
  end

  def contact
  end

  private

    def set_initial_date
      params[:date] ? @date = params[:date].to_date : @date = Date.today
    end
end
