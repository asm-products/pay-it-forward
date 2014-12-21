RSpec.describe Pledge, type: :model do

  describe 'user' do
    it 'must be present' do
      expect(build(:pledge, user_id: nil).valid?).to be false
      expect(build(:pledge, user_id: create(:user).id).valid?).to be true
    end
  end

  describe 'expiration' do
    it 'is set on creation' do
      expect(create(:pledge, expiration: nil).expiration).to_not be nil
    end
  end

  describe 'charity' do
    it 'must be present' do
      expect(build(:pledge, charity_id: nil).valid?).to be false
      expect(build(:pledge, charity_id: create(:charity).id).valid?).to be true
    end
  end

  describe 'tip_percentage' do
    it 'must be present' do
      expect(build(:pledge, tip_percentage: nil).valid?).to be false
      expect(build(:pledge, tip_percentage: 5).valid?).to be true
    end

    it 'must be an integer' do
      expect(build(:pledge, tip_percentage: 'A').valid?).to be false
      expect(build(:pledge, tip_percentage: 50).valid?).to be true
    end

    it 'must be greater than or equal to 0' do
      expect(build(:pledge, tip_percentage: -50).valid?).to be false
      expect(build(:pledge, tip_percentage:   0).valid?).to be true
      expect(build(:pledge, tip_percentage:  50).valid?).to be true
    end

    it 'must be less than or equal to 100' do
      expect(build(:pledge, tip_percentage: 150).valid?).to be false
      expect(build(:pledge, tip_percentage: 100).valid?).to be true
      expect(build(:pledge, tip_percentage:  50).valid?).to be true
    end
  end

  describe 'amount' do
    it 'must be present' do
      expect(build(:pledge, amount: nil).valid?).to be false
      expect(build(:pledge, amount: 20).valid?).to be true
    end

    it 'must be an integer' do
      expect(build(:pledge, amount: 'A').valid?).to be false
      expect(build(:pledge, amount: 50).valid?).to be true
    end

    it 'must be greater than 0' do
      expect(build(:pledge, amount: -50).valid?).to be false
      expect(build(:pledge, amount:   0).valid?).to be false
      expect(build(:pledge, amount:  50).valid?).to be true
    end
  end

  describe 'stripe_charge' do
    it 'updates stripe_charge_id when set'
    it 'retrieves ::Stripe::Charge when accessed'
  end

  describe 'authorize!' do
    it 'creates a stripe_charge'
  end

end
