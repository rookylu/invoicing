require 'spec_helper'

describe ClingGroupsController do

  def mock_cling_group(stubs={})
    @mock_cling_group ||= mock_model(ClingGroup, stubs)
  end

  describe "GET index" do
    it "assigns all cling_groups as @cling_groups" do
      ClingGroup.stub!(:find).with(:all).and_return([mock_cling_group])
      get :index
      assigns[:cling_groups].should == [mock_cling_group]
    end
  end

  describe "GET show" do
    it "assigns the requested cling_group as @cling_group" do
      ClingGroup.stub!(:find).with("37").and_return(mock_cling_group)
      get :show, :id => "37"
      assigns[:cling_group].should equal(mock_cling_group)
    end
  end

  describe "GET new" do
    it "assigns a new cling_group as @cling_group" do
      ClingGroup.stub!(:new).and_return(mock_cling_group)
      get :new
      assigns[:cling_group].should equal(mock_cling_group)
    end
  end

  describe "GET edit" do
    it "assigns the requested cling_group as @cling_group" do
      ClingGroup.stub!(:find).with("37").and_return(mock_cling_group)
      get :edit, :id => "37"
      assigns[:cling_group].should equal(mock_cling_group)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created cling_group as @cling_group" do
        ClingGroup.stub!(:new).with({'these' => 'params'}).and_return(mock_cling_group(:save => true))
        post :create, :cling_group => {:these => 'params'}
        assigns[:cling_group].should equal(mock_cling_group)
      end

      it "redirects to the created cling_group" do
        ClingGroup.stub!(:new).and_return(mock_cling_group(:save => true))
        post :create, :cling_group => {}
        response.should redirect_to(cling_group_url(mock_cling_group))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved cling_group as @cling_group" do
        ClingGroup.stub!(:new).with({'these' => 'params'}).and_return(mock_cling_group(:save => false))
        post :create, :cling_group => {:these => 'params'}
        assigns[:cling_group].should equal(mock_cling_group)
      end

      it "re-renders the 'new' template" do
        ClingGroup.stub!(:new).and_return(mock_cling_group(:save => false))
        post :create, :cling_group => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested cling_group" do
        ClingGroup.should_receive(:find).with("37").and_return(mock_cling_group)
        mock_cling_group.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :cling_group => {:these => 'params'}
      end

      it "assigns the requested cling_group as @cling_group" do
        ClingGroup.stub!(:find).and_return(mock_cling_group(:update_attributes => true))
        put :update, :id => "1"
        assigns[:cling_group].should equal(mock_cling_group)
      end

      it "redirects to the cling_group" do
        ClingGroup.stub!(:find).and_return(mock_cling_group(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(cling_group_url(mock_cling_group))
      end
    end

    describe "with invalid params" do
      it "updates the requested cling_group" do
        ClingGroup.should_receive(:find).with("37").and_return(mock_cling_group)
        mock_cling_group.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :cling_group => {:these => 'params'}
      end

      it "assigns the cling_group as @cling_group" do
        ClingGroup.stub!(:find).and_return(mock_cling_group(:update_attributes => false))
        put :update, :id => "1"
        assigns[:cling_group].should equal(mock_cling_group)
      end

      it "re-renders the 'edit' template" do
        ClingGroup.stub!(:find).and_return(mock_cling_group(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested cling_group" do
      ClingGroup.should_receive(:find).with("37").and_return(mock_cling_group)
      mock_cling_group.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the cling_groups list" do
      ClingGroup.stub!(:find).and_return(mock_cling_group(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(cling_groups_url)
    end
  end

end
