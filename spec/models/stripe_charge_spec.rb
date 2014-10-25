RSpec.describe StripeCharge, type: :model do

  let(:stripe_charge) { create(:stripe_charge) }

  it 'is not validate if stripe_id not unique' do
    expect(build(:stripe_charge, stripe_id: stripe_charge.stripe_id).valid?).to be false
  end

  it 'is not validate if pledge_id not unique' do
    expect(build(:stripe_charge, pledge_id: stripe_charge.pledge_id).valid?).to be false
  end

  it 'sets the status default value to authorized' do
    expect(stripe_charge.authorized?).to be true
  end

  it 'is not validate if stripe_id not present' do
    expect(build(:stripe_charge, stripe_id: nil).valid?).to be false
  end

  it 'is not validate if stripe_customer_id not present' do
    expect(build(:stripe_charge, stripe_customer_id: nil).valid?).to be false
  end

  it 'is not validate if value not present' do
    expect(build(:stripe_charge, value: nil).valid?).to be false
  end

  it 'is not validate if currency not present' do
    expect(build(:stripe_charge, currency: nil).valid?).to be false
  end

  it 'is not validate if status not present' do
    expect(build(:stripe_charge, status: nil).valid?).to be false
  end

  it 'is not validate if pledge_id not present' do
    expect(build(:stripe_charge, pledge_id: nil).valid?).to be false
  end

  it 'belongs_to a stripe_customer' do
    expect(stripe_charge.stripe_customer).to_not be nil
  end

  it 'belongs_to a pledge' do
    expect(stripe_charge.pledge).to_not be nil
  end

end
