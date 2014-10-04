require 'rails_helper'

RSpec.describe "charities/edit", :type => :view do
  before(:each) do
    @charity = assign(:charity, Charity.create!(
      :name => "MyString",
      :description => "MyText",
      :url => "MyString"
    ))
  end

  it "renders the edit charity form" do
    render

    assert_select "form[action=?][method=?]", charity_path(@charity), "post" do

      assert_select "input#charity_name[name=?]", "charity[name]"

      assert_select "textarea#charity_description[name=?]", "charity[description]"

      assert_select "input#charity_url[name=?]", "charity[url]"
    end
  end
end
