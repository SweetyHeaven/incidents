class TagsController < ApplicationController
  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tags }
    end
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    @tag = Tag.find(params[:id])


    #check user privilage
    if current_user.role == "Manager"
      if params.has_key?("user_id")
        @incidents = @tag.incidents.where("assigned_to_id = ?",params["user_id"])
      else
        @incidents = @tag.incidents  
      end
    else  #role = Employee
      if params.has_key?("user_id")
         @incidents = @tag.incidents.where("incident_type = ? and assigned_to_id = ?",1,params["user_id"])
      else
         @incidents = @tag.incidents.where("incident_type = ?",1) 
      end
     
    end
    

    respond_to do |format|
      format.html {render "incidents/index"}
      format.json { render json: @tag }
    end
  end

  # GET /tags/new
  # GET /tags/new.json
  def new
    @tag = Tag.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tag }
      format.js{render json: @tag}
    end
  end

  # GET /tags/1/edit
  def edit
    @tag = Tag.find(params[:id])
  end

  # POST /tags
  # POST /tags.json
  def create
    @tag = Tag.new(params[:tag])

    respond_to do |format|
      if @tag.save
        #format.html { redirect_to @tag, notice: 'Tag was successfully created.' }
        format.json { render json: @tag, status: :created, location: @tag }
        format.js {render json: @tag}
      else
        format.html { render action: "new" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tags/1
  # PUT /tags/1.json
  def update
    @tag = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to tags_url }
      format.json { head :no_content }
    end
  end


  # returns a list of tags that contains the query
  # GET /tags/search/name
  def search
    query = params[:q]
    @tags = Tag.find(:all, :conditions => ['lower(name) LIKE ?', "%#{query.downcase}%"])
    @foundResults = @tags.map{|tag| {"id" => tag.id ,"name" => tag.name}}

    respond_to do |format|
      format.js { render json: @foundResults }
    end
  end
end
