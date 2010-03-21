class InvoicesController < ApplicationController
  def index
    params[:state] ||= 'invoice'
    @invoices = case params[:state]
                when 'proforma'
                  Invoice.proformas.paginate :page => params[:page]
                else
                  Invoice.invoices.paginate :page => params[:page]
                end
    @page_type = params[:state].capitalize
    @page_title = @page_type.pluralize
  end

  def show
    @invoice = Invoice.find(params[:id])
    if @invoice.invoice_lines.count == 0
      flash.now[:info] = "There are no products added to this invoice"
    end
  end

  def new
    @invoice = Invoice.new
    @clients = Client.all
  end

  def edit
    @invoice = Invoice.find(params[:id])
  end

  def create
    @invoice = Invoice.new(params[:invoice])

    if @invoice.save
      flash.now[:notice] = 'Invoice was successfully created.'
      redirect_to(@invoice)
    else
      flash.now[:error] = "There were problems saving this invoice"
      render :action => "new"
    end
  end

  def update
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        flash.now[:notice] = 'Invoice was successfully updated.'
        format.html { redirect_to(@invoice) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to(invoices_url) }
    end
  end

  def approve_proforma
    @invoice = Invoice.find(params[:id])
    @invoice.approved!
    redirect_to(@invoice)
  end

  def send_to_client
    @invoice = Invoice.find(params[:id])
    @invoice.send_to_client!
    redirect_to(@invoice)
  end

  def receive_payment
    @invoice = Invoice.find(params[:id])
    @invoice.receive_payment!
    redirect_to(@invoice)
  end
end
