class ClingGroupsController < ApplicationController
  # GET /cling_groups
  # GET /cling_groups.xml
  def index
    @cling_groups = ClingGroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cling_groups }
    end
  end

  # GET /cling_groups/1
  # GET /cling_groups/1.xml
  def show
    @cling_group = ClingGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cling_group }
    end
  end

  # GET /cling_groups/new
  # GET /cling_groups/new.xml
  def new
    @cling_group = ClingGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cling_group }
    end
  end

  # GET /cling_groups/1/edit
  def edit
    @cling_group = ClingGroup.find(params[:id])
  end

  # POST /cling_groups
  # POST /cling_groups.xml
  def create
    @cling_group = ClingGroup.new(params[:cling_group])

    respond_to do |format|
      if @cling_group.save
        flash[:notice] = 'ClingGroup was successfully created.'
        format.html { redirect_to(@cling_group) }
        format.xml  { render :xml => @cling_group, :status => :created, :location => @cling_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cling_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cling_groups/1
  # PUT /cling_groups/1.xml
  def update
    @cling_group = ClingGroup.find(params[:id])

    respond_to do |format|
      if @cling_group.update_attributes(params[:cling_group])
        flash[:notice] = 'ClingGroup was successfully updated.'
        format.html { redirect_to(@cling_group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cling_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cling_groups/1
  # DELETE /cling_groups/1.xml
  def destroy
    @cling_group = ClingGroup.find(params[:id])
    @cling_group.destroy

    respond_to do |format|
      format.html { redirect_to(cling_groups_url) }
      format.xml  { head :ok }
    end
  end
end
