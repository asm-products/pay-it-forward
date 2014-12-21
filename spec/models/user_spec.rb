RSpec.describe User, type: :model do

  describe 'password' do
    it 'must be at least 5 characters' do
      expect(build(:user, password: '12345', password_confirmation: '12345').valid?).to be false
      expect(build(:user, password: '123456', password_confirmation: '123456').valid?).to be true
    end

    it 'must be confirmed' do
      expect(build(:user, password: '12345').valid?).to be false
      expect(build(:user, password: '123456', password_confirmation: '123456').valid?).to be true
    end
  end

  describe 'email' do
    it 'must be unique'
    it 'must a valid email address'
  end

  describe 'create_by_stripe!' do
    it 'creates user'
  end

  describe 'stripe_customer' do
    it 'updates stripe_customer_id when set'
    it 'retrieves ::Stripe::Customer when accessed'
  end

  describe 'register_stripe_customer!' do
    it 'creates a stripe_customer'
  end
end
