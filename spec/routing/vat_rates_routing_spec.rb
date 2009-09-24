require 'spec_helper'

describe VATRatesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/vat_rates" }.should route_to(:controller => "vat_rates", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/vat_rates/new" }.should route_to(:controller => "vat_rates", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/vat_rates/1" }.should route_to(:controller => "vat_rates", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/vat_rates/1/edit" }.should route_to(:controller => "vat_rates", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/vat_rates" }.should route_to(:controller => "vat_rates", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/vat_rates/1" }.should route_to(:controller => "vat_rates", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/vat_rates/1" }.should route_to(:controller => "vat_rates", :action => "destroy", :id => "1") 
    end
  end
end
