RSpec.describe StripeCustomer, type: :model do

  let(:stripe_customer) { create(:stripe_customer) }

  it 'does not validate if user not present' do
    expect(build(:stripe_customer, user: nil).valid?).to be false
  end

  it 'does not validate if stripe_id not present' do
    expect(build(:stripe_customer, stripe_id: nil).valid?).to be false
  end

  it 'does not validate if user not unique' do
    expect(build(:stripe_customer, user: stripe_customer.user).valid?).to be false
  end

  it 'does not validate if stripe_id not unique' do
    expect(build(:stripe_customer, stripe_id: stripe_customer.stripe_id).valid?).to be false
  end
  
  it 'belongs_to a user' do
    expect(stripe_customer.user).to_not be nil
  end

end
