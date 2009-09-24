require 'spec_helper'

describe "/vat_rates/show.html.erb" do
  include VATRatesHelper
  before(:each) do
    assigns[:vat_rate] = @vat_rate = stub_model(VATRate,
      :name => "value for name",
      :vat_rate => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ name/)
    response.should have_text(/1/)
  end
end
