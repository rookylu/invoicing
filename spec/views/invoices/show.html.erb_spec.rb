require 'spec_helper'

describe "/invoices/show.html.erb" do
  include InvoicesHelper
  before(:each) do
    assigns[:invoice] = @invoice = stub_model(Invoice,
      :ident => "value for ident"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ ident/)
  end
end
