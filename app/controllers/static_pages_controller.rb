class StaticPagesController < ApplicationController
  before_action :set_initial_date, only: :home
  before_action :set_dish_categories, only: :home #ApplicationController
  before_action :set_eating_times, only: :home #ApplicationController

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

    def set_display_times
      # dparams = [params[:breakfast], params[:lunch], params[:dinner]]
      # @dtimes = []
      # dparams.each do |ptime|
      #   ptime ? @dtimes << ptime : @dtimes << "1"
      # end
      params[:breakfast] ? breakfast = [params[:breakfast]] : breakfast = ["1"]
      params[:lunch] ? lunch = [params[:lunch]] : lunch = ["1"]
      params[:dinner] ? dinner = [params[:dinner]] : dinner = ["1"]
      @dtimes = [breakfast, lunch, dinner]
      @dtimes.each do |dtime|
<<<<<<< HEAD
        dtime == ["1"] ? dtime << true : dtime << false
      end　#test
=======
        dtime == ["1"] ? dtime << true : dtime << false #git push test
      end
>>>>>>> origin/master
    end
end
