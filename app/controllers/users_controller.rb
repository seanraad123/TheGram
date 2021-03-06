class UsersController < ApplicationController
  skip_before_action :authorized, only: [:new, :create, :show, :edit, :update]
  before_action :set_user
  skip_before_action :set_user, only: [:followers, :following]

  def index
      # byebug
      if params[:search]
        @users = User.all.select do |user|
           user.username == params[:search]
        end
      else
        @users = User.all
      end
    end

  def show
    if @user.id != params[:id]
      @user = User.find_by(id: params[:id])
      @like = Like.new
    else
      render :show
    end
  end

  def new
    @user = User.new
    render :new
  end

  def create
    # byebug
    @user = User.create(user_params)
    if @user.save
      flash[:notice] = "WELCOME #{@user.username}, your account has been created!"
      session[:logged_in_user_id] = @user.id
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def edit
    render :edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your updates have been saved!"
      redirect_to user_path
    else
      flash[:notice] = "Uh oh, please check to see your edits are allowed."
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = "Your account has been deleted. Thanks for using TheGram and we hope to see you back soon!"
    redirect_to login_path
  end


  def followers
    @user = User.find_by(id: params[:id])
    @followers = @user.followers
    # byebug

    render :followers
  end

  def following
    @user = User.find_by(id: params[:id])
    @following = @user.following
    render :following
  end


  private

  def user_params
    params.require(:user).permit(:username, :password, :avatar, :search)
  end

  def set_user
    @user = User.find_by(id: session[:logged_in_user_id])
  end

end
