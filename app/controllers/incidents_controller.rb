class IncidentsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :load_incidents, :only => [:index]
  

  #This method checks logged in user role
  #if user role = Employee => only positive incidents are load
  #if user role = Manager =>  all incidents are load
  def load_incidents
    if current_user.isManager?  #load everything
      @incidents = Incident.all
    else     #load only positive incidents
      @incidents = Incident.where("incident_type = ?",1)
    end
  end

  # GET /incidents
  # GET /incidents.json
  def index
    #@incidents = Incident.all

    respond_to do |format|
      format.html{render :index, :locals => {:edit_enabled => false}} # index.html.erb
      format.json { render json: @incidents }
    end
  end

  # GET /incidents/1
  # GET /incidents/1.json
  def show
    @incident = Incident.find(params[:id])
    @tags = @incident.tags.map { |tag| [tag.name, tag.id] }

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @incident }
    end
  end

  # GET /users/:userId/incidents/assigned
  # GET /users/:userId/incidents/assigned.json
  #showing assigned incidents for a given user
  def assigned
    @user = User.find(params[:id])
    @incidents = @user.assigned_incidents.where("incident_type = ?",1)

    respond_to do |format|
      format.html{render :index , :locals => {:edit_enabled => false}}
      format.json { render json: @incidents }
    end

  end

  # GET /users/:userId/incidents/assigned
  # GET /users/:userId/incidents/assigned.json
  #showing created incidents for a given user
  def created
    @user = User.find(params[:id])

    #check if request came from the creator itself
    if @user.id == current_user.id
        @incidents = @user.created_incidents
        respond_to do |format|
          format.html{render :index, :locals => {:edit_enabled => true}}
          format.json { render json: @incidents }
        end
    else
        @incidents = @user.created_incidents.where("incident_type = ?",1)
        respond_to do |format|
          format.html{render :index, :locals => {:edit_enabled => false}}
          format.json { render json: @incidents }
        end
    end

    

  end

  # GET /incidents/new
  # GET /incidents/new.json
  def new
    @incident = Incident.new(:incident_type => 1, :creator_id => current_user.id)

    #retreive all users to be assigned to that incident
    @users = User.where("id != ?", current_user.id).map {|user| [user.name, user.id]}

    #retreive all tags to be shown in the input form
    @tags = Tag.all.map { |tag| [tag.name, tag.id] }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @incident }
    end
  end

  # GET /incidents/1/edit
  def edit
    @incident = Incident.find(params[:id]) 
    
    #retreive all users to be assigned to that incident
    @users = User.all.map {|user| [user.name, user.id]}

    @selected_user = @incident.assigned_to.id

    #retreive all tags to be shown in the input form
    @tags = Tag.all.map { |tag| [tag.name, tag.id] }

    #retreive the previously selected tags
    @selected_tags = @incident.tag_ids

  end

  # POST /incidents
  # POST /incidents.json
  def create
    #parse tag_ids
    params[:incident][:tag_ids] = params[:incident][:tag_ids].split(",");
    @incident = Incident.new(params[:incident])
    @incident.creator_id = current_user.id #set incident creator
    @incident.score = @incident.incident_type * 5;

    respond_to do |format|
      if @incident.save
        format.html { redirect_to @incident, notice: 'Incident was successfully created.' }
        format.json { render json: @incident, status: :created, location: @incident }

        #add incident's score to assigned user's score
        @assigned_user = @incident.assigned_to
        @assigned_user.score += @incident.score
        @assigned_user.save

        #send a notification mail to assigned user incase of +ve incidents
        if @incident.type == "positive"
          UserMailer.delay.incident_notification(@incident) 
          
          #send broadcast message for all users
          UserMailer.delay.incident_broadcast(@incident)

        else #negative incident
          UserMailer.delay.negative_incident_notification(@incident)
        end    

      
      else
        format.html { render action: "new" }
        format.json { render json: @incident.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /incidents/1
  # PUT /incidents/1.json
  def update
    @incident = Incident.find(params[:id])

    respond_to do |format|
      if @incident.update_attributes(params[:incident])
        format.html { redirect_to @incident, notice: 'Incident was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @incident.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /incidents/1
  # DELETE /incidents/1.json
  def destroy
    @incident = Incident.find(params[:id])

    #remove incident's score from assigned user's score
    @assigned_user = @incident.assigned_to
    @assigned_user.score -= @incident.score
    @assigned_user.save

    @incident.destroy

    respond_to do |format|
      format.html { redirect_to incidents_url }
      format.json { head :no_content }
    end
  end
end
