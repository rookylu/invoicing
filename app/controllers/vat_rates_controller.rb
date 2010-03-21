class VatRatesController < ApplicationController
  # GET /vat_rates
  # GET /vat_rates.xml
  def index
    @vat_rates = VatRate.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vat_rates }
    end
  end

  # GET /vat_rates/1
  # GET /vat_rates/1.xml
  def show
    @vat_rate = VatRate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vat_rate }
    end
  end

  # GET /vat_rates/new
  # GET /vat_rates/new.xml
  def new
    @vat_rate = VatRate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vat_rate }
    end
  end

  # GET /vat_rates/1/edit
  def edit
    @vat_rate = VatRate.find(params[:id])
  end

  # POST /vat_rates
  # POST /vat_rates.xml
  def create
    @vat_rate = VatRate.new(params[:vat_rate])

    respond_to do |format|
      if @vat_rate.save
        flash[:notice] = 'VatRate was successfully created.'
        format.html { redirect_to(@vat_rate) }
        format.xml  { render :xml => @vat_rate, :status => :created, :location => @vat_rate }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vat_rate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vat_rates/1
  # PUT /vat_rates/1.xml
  def update
    @vat_rate = VatRate.find(params[:id])

    respond_to do |format|
      if @vat_rate.update_attributes(params[:vat_rate])
        flash[:notice] = 'VatRate was successfully updated.'
        format.html { redirect_to(@vat_rate) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vat_rate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vat_rates/1
  # DELETE /vat_rates/1.xml
  def destroy
    @vat_rate = VatRate.find(params[:id])
    @vat_rate.destroy

    respond_to do |format|
      format.html { redirect_to(vat_rates_url) }
      format.xml  { head :ok }
    end
  end
end
