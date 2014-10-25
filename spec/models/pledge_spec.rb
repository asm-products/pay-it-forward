RSpec.describe Pledge, type: :model do

  it 'is not valid if user_id not present' do
    expect(build(:pledge, user_id: nil).valid?).to be false
  end
  
  it 'is not valid if expiration not present' do
    expect(build(:pledge, expiration: nil).valid?).to be false
  end

end
