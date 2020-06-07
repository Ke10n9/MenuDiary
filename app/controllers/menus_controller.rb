class MenusController < ApplicationController

  def create
  end

  def destroy
    @menu = Menu.find(params[:id])
    @menu.destroy
    flash[:success] = "メニューを削除しました。"
    redirect_to request.referrer || root_url
  end

  def edit
  end

  def update
  end
end
