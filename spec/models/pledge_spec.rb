RSpec.describe Pledge, type: :model do

  it 'is not valid if user_id not present' do
    skip('Create User')
    expect(build(:pledge, user_id: nil).valid?).to be false
  end

  it 'it sets expiration on creation'

end
