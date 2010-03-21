class AdminController < ApplicationController

  def index
    @vat_rates = VatRate.find(:all).paginate :page => params[:page], :per_page => params[:per_page] || 15
  end

end
