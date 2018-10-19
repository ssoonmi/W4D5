class UsersController < ApplicationController
  before_action :ensure_not_logged_in, only: [:new, :create]
  before_action :ensure_logged_in, only: [:index, :show, :update]

  def new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_url(@user.id)
    else
      flash.now[:errors] = ['Invalid username or password']
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    render :show
  end

  def index
    @users = User.all
    render :index
  end

  def edit
    @user = User.find(params[:id])
    render :edit
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_url(@user.id)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :edit
    end
  end

end
