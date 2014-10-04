require 'rails_helper'

RSpec.describe "Charities", :type => :request do
  describe "GET /charities" do
    it "works! (now write some real specs)" do
      get charities_path
      expect(response.status).to be(200)
    end
  end
end
