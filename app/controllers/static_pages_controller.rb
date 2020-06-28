class StaticPagesController < ApplicationController
  before_action :set_initial_date, only: :home
  before_action :set_dish_categories, only: :home #ApplicationController
  before_action :set_eating_times, only: :home #ApplicationController
  before_action :set_display_times, only: :home

  def home
    @meal = current_user.meals.build if logged_in?
    @dish = current_user.dishes.build if logged_in?
    @meals = current_user.meals.all if logged_in?

    dtrue_indexes = @dtimes.each_index.select{ |i| @dtimes[i][0] == "1" }
    @dtrue_names = []
    @dtrue_ids = []
    dtrue_indexes.each do |index|
      @dtrue_names << @eating_times[index][0]
      @dtrue_ids << @eating_times[index][1]
    end
    @dtrue_count = dtrue_indexes.length
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
        dtime == ["1"] ? dtime << true : dtime << false
      end　#test
    end
end
