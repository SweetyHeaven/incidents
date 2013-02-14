class IncidentsController < ApplicationController
  # GET /incidents
  # GET /incidents.json
  def index
    @incidents = Incident.all

    respond_to do |format|
      format.html # index.html.erb
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

  # GET /incidents/new
  # GET /incidents/new.json
  def new
    @incident = Incident.new(:incident_type => 1, :creator_id => current_user.id)

    #retreive all users to be assigned to that incident
    @users = User.all.map {|user| [user.name, user.id]}

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
    @incident = Incident.new(params[:incident])
    @incident.creator_id = current_user.id #set incident creator

    respond_to do |format|
      if @incident.save
        format.html { redirect_to @incident, notice: 'Incident was successfully created.' }
        format.json { render json: @incident, status: :created, location: @incident }
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
    @incident.destroy

    respond_to do |format|
      format.html { redirect_to incidents_url }
      format.json { head :no_content }
    end
  end
end
