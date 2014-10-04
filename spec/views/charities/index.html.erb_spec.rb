require 'rails_helper'

RSpec.describe "charities/index", :type => :view do
  before(:each) do
    assign(:charities, [
      Charity.create!(
        :name => "Name",
        :description => "MyText",
        :url => "Url"
      ),
      Charity.create!(
        :name => "Name",
        :description => "MyText",
        :url => "Url"
      )
    ])
  end

  it "renders a list of charities" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
  end
end
