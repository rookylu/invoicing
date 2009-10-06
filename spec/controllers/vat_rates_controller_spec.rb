require 'spec_helper'

describe VATRatesController do

  def mock_vat_rate(stubs={})
    @mock_vat_rate ||= mock_model(VATRate, stubs)
  end

  describe "GET index" do
    it "assigns all vat_rates as @vat_rates" do
      VATRate.stub!(:find).with(:all).and_return([mock_vat_rate])
      get :index
      assigns[:vat_rates].should == [mock_vat_rate]
    end
  end

  describe "GET show" do
    it "assigns the requested vat_rate as @vat_rate" do
      VATRate.stub!(:find).with("37").and_return(mock_vat_rate)
      get :show, :id => "37"
      assigns[:vat_rate].should equal(mock_vat_rate)
    end
  end

  describe "GET new" do
    it "assigns a new vat_rate as @vat_rate" do
      VATRate.stub!(:new).and_return(mock_vat_rate)
      get :new
      assigns[:vat_rate].should equal(mock_vat_rate)
    end
  end

  describe "GET edit" do
    it "assigns the requested vat_rate as @vat_rate" do
      VATRate.stub!(:find).with("37").and_return(mock_vat_rate)
      get :edit, :id => "37"
      assigns[:vat_rate].should equal(mock_vat_rate)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created vat_rate as @vat_rate" do
        VATRate.stub!(:new).with({'these' => 'params'}).and_return(mock_vat_rate(:save => true))
        post :create, :vat_rate => {:these => 'params'}
        assigns[:vat_rate].should equal(mock_vat_rate)
      end

      it "redirects to the created vat_rate" do
        VATRate.stub!(:new).and_return(mock_vat_rate(:save => true))
        post :create, :vat_rate => {}
        response.should redirect_to(vat_rate_url(mock_vat_rate))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved vat_rate as @vat_rate" do
        VATRate.stub!(:new).with({'these' => 'params'}).and_return(mock_vat_rate(:save => false))
        post :create, :vat_rate => {:these => 'params'}
        assigns[:vat_rate].should equal(mock_vat_rate)
      end

      it "re-renders the 'new' template" do
        VATRate.stub!(:new).and_return(mock_vat_rate(:save => false))
        post :create, :vat_rate => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested vat_rate" do
        VATRate.should_receive(:find).with("37").and_return(mock_vat_rate)
        mock_vat_rate.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :vat_rate => {:these => 'params'}
      end

      it "assigns the requested vat_rate as @vat_rate" do
        VATRate.stub!(:find).and_return(mock_vat_rate(:update_attributes => true))
        put :update, :id => "1"
        assigns[:vat_rate].should equal(mock_vat_rate)
      end

      it "redirects to the vat_rate" do
        VATRate.stub!(:find).and_return(mock_vat_rate(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(vat_rate_url(mock_vat_rate))
      end
    end

    describe "with invalid params" do
      it "updates the requested vat_rate" do
        VATRate.should_receive(:find).with("37").and_return(mock_vat_rate)
        mock_vat_rate.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :vat_rate => {:these => 'params'}
      end

      it "assigns the vat_rate as @vat_rate" do
        VATRate.stub!(:find).and_return(mock_vat_rate(:update_attributes => false))
        put :update, :id => "1"
        assigns[:vat_rate].should equal(mock_vat_rate)
      end

      it "re-renders the 'edit' template" do
        VATRate.stub!(:find).and_return(mock_vat_rate(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested vat_rate" do
      VATRate.should_receive(:find).with("37").and_return(mock_vat_rate)
      mock_vat_rate.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the vat_rates list" do
      VATRate.stub!(:find).and_return(mock_vat_rate(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(vat_rates_url)
    end
  end

end
