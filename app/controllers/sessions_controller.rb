class SessionsController < ApplicationController
  def new
  end

  # @user: test/integration/users_login_test.rb で assigns(:user) を使用する為
  def create
    @user = User.find_by(name: params[:session][:name])#.downcase)
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or root_url
    else
      flash.now[:danger] = 'ユーザー名とパスワードの組み合わせが不正です。'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
