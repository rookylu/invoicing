require 'spec_helper'

describe "/vat_rates/index.html.erb" do
  include VATRatesHelper

  before(:each) do
    assigns[:vat_rates] = [
      stub_model(VATRate,
        :name => "value for name",
        :vat_rate => 1
      ),
      stub_model(VATRate,
        :name => "value for name",
        :vat_rate => 1
      )
    ]
  end

  it "renders a list of vat_rates" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
