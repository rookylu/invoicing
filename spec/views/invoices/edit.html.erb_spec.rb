require 'spec_helper'

describe "/invoices/edit.html.erb" do
  include InvoicesHelper

  before(:each) do
    assigns[:invoice] = @invoice = stub_model(Invoice,
      :new_record? => false,
      :ident => "value for ident"
    )
  end

  it "renders the edit invoice form" do
    render

    response.should have_tag("form[action=#{invoice_path(@invoice)}][method=post]") do
      with_tag('input#invoice_ident[name=?]', "invoice[ident]")
    end
  end
end
