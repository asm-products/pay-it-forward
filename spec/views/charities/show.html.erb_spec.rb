require 'rails_helper'

RSpec.describe 'charities/show', type: :view do
  before(:each) do
    @charity = assign(:charity, Charity.create!(
      name: 'Name',
      description: 'MyText',
      url: 'Url'
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Url/)
  end
end
