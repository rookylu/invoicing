class ClientsController < ApplicationController
  def index
    @clients = Client.all.paginate :page => params[:page], :per_page => params[:per_page] || 10
  end

  def show
    @client = Client.find(params[:id])
    @invoices = @client.invoices.paginate :page => params[:page], :per_page => params[:per_page] || 5
  end

  def new
    @client = Client.new
  end

  def edit
    @client = Client.find(params[:id])
  end

  def create
    @client = Client.new(params[:client])
    
    if @client.save
      flash[:notice] = 'Client was successfully created.'
      redirect_to(@client)
    else
      render :action => "new"
    end
  end

  def update
    @client = Client.find(params[:id])

    if @client.update_attributes(params[:client])
      flash[:notice] = 'Client was successfully updated.'
      redirect_to(@client)
    else
      render :action => "edit"
    end
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy

    redirect_to(clients_url) 
  end
end
