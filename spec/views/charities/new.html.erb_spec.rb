require 'rails_helper'

RSpec.describe "charities/new", :type => :view do
  before(:each) do
    assign(:charity, Charity.new(
      :name => "MyString",
      :description => "MyText",
      :url => "MyString"
    ))
  end

  it "renders new charity form" do
    render

    assert_select "form[action=?][method=?]", charities_path, "post" do

      assert_select "input#charity_name[name=?]", "charity[name]"

      assert_select "textarea#charity_description[name=?]", "charity[description]"

      assert_select "input#charity_url[name=?]", "charity[url]"
    end
  end
end
