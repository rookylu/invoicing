require 'spec_helper'

describe "/invoices/index.html.erb" do
  include InvoicesHelper

  before(:each) do
    assigns[:invoices] = [
      stub_model(Invoice,
        :ident => "value for ident"
      ),
      stub_model(Invoice,
        :ident => "value for ident"
      )
    ]
  end

  it "renders a list of invoices" do
    render
    response.should have_tag("tr>td", "value for ident".to_s, 2)
  end
end
