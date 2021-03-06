class UsersController < ApplicationController
  before_action :not_signed_in_user,
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :signed_in_user, only: [:new, :create]
  before_action :signed_in_admin, only: [:destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = user_by_username_or_id
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = t(:welcome)
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t(:user_update)
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t(:user_delete)
    redirect_to users_url
  end

  def following
    @title = t(:following)
    @user = user_by_username_or_id
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = t(:followers)
    @user = user_by_username_or_id
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:username, :name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    def signed_in_user
      if signed_in?
        redirect_to(root_url)
      end
    end

    def signed_in_admin
      if signed_in? && current_user.admin? && correct_user?
        redirect_to(root_url)
      end
    end

    def correct_user
      redirect_to(root_url) unless correct_user?
    end

    def correct_user?
      @user = User.find(params[:id])
      current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
