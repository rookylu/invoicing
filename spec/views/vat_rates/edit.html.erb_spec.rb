require 'spec_helper'

describe "/vat_rates/edit.html.erb" do
  include VATRatesHelper

  before(:each) do
    assigns[:vat_rate] = @vat_rate = stub_model(VATRate,
      :new_record? => false,
      :name => "value for name",
      :vat_rate => 1
    )
  end

  it "renders the edit vat_rate form" do
    render

    response.should have_tag("form[action=#{vat_rate_path(@vat_rate)}][method=post]") do
      with_tag('input#vat_rate_name[name=?]', "vat_rate[name]")
      with_tag('input#vat_rate_vat_rate[name=?]', "vat_rate[vat_rate]")
    end
  end
end
