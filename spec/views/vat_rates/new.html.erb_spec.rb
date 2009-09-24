require 'spec_helper'

describe "/vat_rates/new.html.erb" do
  include VATRatesHelper

  before(:each) do
    assigns[:vat_rate] = stub_model(VATRate,
      :new_record? => true,
      :name => "value for name",
      :vat_rate => 1
    )
  end

  it "renders new vat_rate form" do
    render

    response.should have_tag("form[action=?][method=post]", vat_rates_path) do
      with_tag("input#vat_rate_name[name=?]", "vat_rate[name]")
      with_tag("input#vat_rate_vat_rate[name=?]", "vat_rate[vat_rate]")
    end
  end
end
