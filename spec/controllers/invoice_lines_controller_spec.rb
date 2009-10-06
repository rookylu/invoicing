require 'spec_helper'

describe InvoiceLinesController do

  def mock_invoice_line(stubs={})
    @mock_invoice_line ||= mock_model(InvoiceLine, stubs)
  end

  describe "GET index" do
    it "assigns all invoice_lines as @invoice_lines" do
      InvoiceLine.stub!(:find).with(:all).and_return([mock_invoice_line])
      get :index
      assigns[:invoice_lines].should == [mock_invoice_line]
    end
  end

  describe "GET show" do
    it "assigns the requested invoice_line as @invoice_line" do
      InvoiceLine.stub!(:find).with("37").and_return(mock_invoice_line)
      get :show, :id => "37"
      assigns[:invoice_line].should equal(mock_invoice_line)
    end
  end

  describe "GET new" do
    it "assigns a new invoice_line as @invoice_line" do
      InvoiceLine.stub!(:new).and_return(mock_invoice_line)
      get :new
      assigns[:invoice_line].should equal(mock_invoice_line)
    end
  end

  describe "GET edit" do
    it "assigns the requested invoice_line as @invoice_line" do
      InvoiceLine.stub!(:find).with("37").and_return(mock_invoice_line)
      get :edit, :id => "37"
      assigns[:invoice_line].should equal(mock_invoice_line)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created invoice_line as @invoice_line" do
        InvoiceLine.stub!(:new).with({'these' => 'params'}).and_return(mock_invoice_line(:save => true))
        post :create, :invoice_line => {:these => 'params'}
        assigns[:invoice_line].should equal(mock_invoice_line)
      end

      it "redirects to the created invoice_line" do
        InvoiceLine.stub!(:new).and_return(mock_invoice_line(:save => true))
        post :create, :invoice_line => {}
        response.should redirect_to(invoice_line_url(mock_invoice_line))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved invoice_line as @invoice_line" do
        InvoiceLine.stub!(:new).with({'these' => 'params'}).and_return(mock_invoice_line(:save => false))
        post :create, :invoice_line => {:these => 'params'}
        assigns[:invoice_line].should equal(mock_invoice_line)
      end

      it "re-renders the 'new' template" do
        InvoiceLine.stub!(:new).and_return(mock_invoice_line(:save => false))
        post :create, :invoice_line => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested invoice_line" do
        InvoiceLine.should_receive(:find).with("37").and_return(mock_invoice_line)
        mock_invoice_line.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :invoice_line => {:these => 'params'}
      end

      it "assigns the requested invoice_line as @invoice_line" do
        InvoiceLine.stub!(:find).and_return(mock_invoice_line(:update_attributes => true))
        put :update, :id => "1"
        assigns[:invoice_line].should equal(mock_invoice_line)
      end

      it "redirects to the invoice_line" do
        InvoiceLine.stub!(:find).and_return(mock_invoice_line(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(invoice_line_url(mock_invoice_line))
      end
    end

    describe "with invalid params" do
      it "updates the requested invoice_line" do
        InvoiceLine.should_receive(:find).with("37").and_return(mock_invoice_line)
        mock_invoice_line.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :invoice_line => {:these => 'params'}
      end

      it "assigns the invoice_line as @invoice_line" do
        InvoiceLine.stub!(:find).and_return(mock_invoice_line(:update_attributes => false))
        put :update, :id => "1"
        assigns[:invoice_line].should equal(mock_invoice_line)
      end

      it "re-renders the 'edit' template" do
        InvoiceLine.stub!(:find).and_return(mock_invoice_line(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested invoice_line" do
      InvoiceLine.should_receive(:find).with("37").and_return(mock_invoice_line)
      mock_invoice_line.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the invoice_lines list" do
      InvoiceLine.stub!(:find).and_return(mock_invoice_line(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(invoice_lines_url)
    end
  end

end
