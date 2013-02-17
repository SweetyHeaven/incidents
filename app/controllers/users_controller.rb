class UsersController < ApplicationController
  
   before_filter :authenticate_user!   
   before_filter :authenticate_manager, :only => [:index]

   def authenticate_manager
    if !current_user.isManager?
      redirect_to :action => :show, :id => current_user.id
    end
   end


  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @incident }
    end
  end
end