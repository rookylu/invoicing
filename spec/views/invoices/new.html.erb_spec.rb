require 'spec_helper'

describe "/invoices/new.html.erb" do
  include InvoicesHelper

  before(:each) do
    assigns[:invoice] = stub_model(Invoice,
      :new_record? => true,
      :ident => "value for ident"
    )
  end

  it "renders new invoice form" do
    render

    response.should have_tag("form[action=?][method=post]", invoices_path) do
      with_tag("input#invoice_ident[name=?]", "invoice[ident]")
    end
  end
end
