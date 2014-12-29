RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:stripe_token) do
    Stripe::Token.create(
                               card: {
                                 number: '4242424242424242',
                                 exp_month: 3,
                                 exp_year: 2016,
                                 cvc: 314
                               }
                             ).id
  end

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
    it 'must be unique' do
      user = create(:user)
      expect(build(:user, email: user.email).valid?).to be false
    end

    it 'must a valid email address' do
      expect(build(:user, email: 'example_email').valid?).to be false
    end
  end

  describe 'create_by_pledge_form!' do
    it 'creates user' do
      expect do
        User.create_by_pledge_form!(
          name: 'Name',
          email: 'example@email.com',
          stripe_auth_token: Stripe::Token.create(
                                 card: {
                                   number: '4242424242424242',
                                   exp_month: 3,
                                   exp_year: 2016,
                                   cvc: 314
                                 }
                               ).id
          )
      end.to change { User.count }.by(1)
    end
  end

  describe 'stripe_customer' do
    it 'updates stripe_customer_id when set' do
      expect do
        user.stripe_customer = ::Stripe::Customer.create(card: stripe_token, email: user.email)
      end.to change { user.stripe_customer_id }
    end

    it 'retrieves ::Stripe::Customer when accessed' do
      stripe_customer = ::Stripe::Customer.create(card: stripe_token, email: user.email)
      user.stripe_customer = stripe_customer
      expect(user.stripe_customer).to be stripe_customer
    end
  end

  describe 'register_stripe_customer' do
    it 'creates a stripe_customer' do
      user.register_stripe_customer(stripe_token)
      expect(user.stripe_customer).to_not be nil
    end
  end
end
