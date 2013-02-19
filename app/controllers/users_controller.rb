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

  def report
    puts params

    startingDate = params["from"]
    startingDate = Date.new(startingDate[:year].to_i,startingDate[:month].to_i,startingDate[:day].to_i)
    endingDate = params["to"]
    endingDate = Date.new(endingDate[:year].to_i,endingDate[:month].to_i,endingDate[:day].to_i)

    #optimize DB queries
    User.includes(:assigned_incidents)

    #sort all users by incident_score(retreived value)
    time_interval = startingDate...endingDate

    @users = User.all.sort_by{|user| user.incidents_score(time_interval)}.reverse
    
    respond_to do |format|
      format.html {render :index , :locals => {:time_interval => time_interval}}
      format.json { render json: @users }
    end    
  end

end