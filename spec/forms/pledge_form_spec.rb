require 'rails_helper'

RSpec.describe PledgeForm, type: :form do
  let(:params) do
    {
      charity_id: create(:charity).id,
      user_id: nil,
      amount: 2000,
      tip_percentage: 5,
      stripe_auth_token: Stripe::Token.create(
                               card: {
                                 number: '4242424242424242',
                                 exp_month: 3,
                                 exp_year: 2016,
                                 cvc: 314
                               }
                             ).id,
      name: 'Smith',
      email: 'email@example.com'
    }
  end

  describe 'validations' do
    it 'validates the presence of charity' do
      pledge_form = PledgeForm.new(params.except(:charity_id))
      expect(pledge_form.valid?).to be false
      expect(pledge_form.errors.messages[:charity]).to_not eq nil
    end

    it 'validates the presence of amount' do
      pledge_form = PledgeForm.new(params.except(:amount))
      expect(pledge_form.valid?).to be false
      expect(pledge_form.errors.messages[:amount]).to_not eq nil
    end

    it 'validates the presence of tip_percentage' do
      pledge_form = PledgeForm.new(params.except(:tip_percentage))
      expect(pledge_form.valid?).to be false
      expect(pledge_form.errors.messages[:tip_percentage]).to_not eq nil
    end

    it 'validates the presence of stripe_auth_token' do
      pledge_form = PledgeForm.new(params.except(:stripe_auth_token))
      expect(pledge_form.valid?).to be false
      expect(pledge_form.errors.messages[:stripe_auth_token]).to_not eq nil
    end

    it 'validates the presence of name' do
      pledge_form = PledgeForm.new(params.except(:name))
      expect(pledge_form.valid?).to be false
      expect(pledge_form.errors.messages[:name]).to_not eq nil
    end

    it 'validates the presence of email' do
      pledge_form = PledgeForm.new(params.except(:email))
      expect(pledge_form.valid?).to be false
      expect(pledge_form.errors.messages[:email]).to_not eq nil
    end

    it 'validates that amount is an integer' do
      pledge_form = PledgeForm.new(params.merge(amount: '30.0'))
      expect(pledge_form.amount).to eq 30

      pledge_form = PledgeForm.new(params.merge(amount: 30.0))
      expect(pledge_form.amount).to eq 30
    end

    it 'validates that tip_percentage is an integer' do
      pledge_form = PledgeForm.new(params.merge(tip_percentage: '30.0'))
      expect(pledge_form.tip_percentage).to eq 30

      pledge_form = PledgeForm.new(params.merge(tip_percentage: 30.0))
      expect(pledge_form.tip_percentage).to eq 30
    end

    it 'validates that amount is greater_than 0' do
      pledge_form = PledgeForm.new(params.merge(amount: -20))
      expect(pledge_form.valid?).to be false
      expect(pledge_form.errors.messages[:amount]).to_not eq nil

      pledge_form = PledgeForm.new(params.merge(amount: 20))
      expect(pledge_form.valid?).to be true
      expect(pledge_form.errors.messages[:amount]).to eq nil
    end

    it 'validates that tip_percentage is greater_than_or_equal_to than 0' do
      pledge_form = PledgeForm.new(params.merge(tip_percentage: -50))
      expect(pledge_form.valid?).to be false
      expect(pledge_form.errors.messages[:tip_percentage]).to_not eq nil

      pledge_form = PledgeForm.new(params.merge(tip_percentage: 0))
      expect(pledge_form.valid?).to be true
      expect(pledge_form.errors.messages[:tip_percentage]).to eq nil

      pledge_form = PledgeForm.new(params.merge(tip_percentage: 50))
      expect(pledge_form.valid?).to be true
      expect(pledge_form.errors.messages[:tip_percentage]).to eq nil
    end

    it 'validates that tip_percentage is less_than_or_equal_to 100' do
      pledge_form = PledgeForm.new(params.merge(tip_percentage: 150))
      expect(pledge_form.valid?).to be false
      expect(pledge_form.errors.messages[:tip_percentage]).to_not eq nil

      pledge_form = PledgeForm.new(params.merge(tip_percentage: 100))
      expect(pledge_form.valid?).to be true
      expect(pledge_form.errors.messages[:tip_percentage]).to eq nil

      pledge_form = PledgeForm.new(params.merge(tip_percentage: 50))
      expect(pledge_form.valid?).to be true
      expect(pledge_form.errors.messages[:tip_percentage]).to eq nil
    end

    it 'validates the email address' do
      pledge_form = PledgeForm.new(params.merge(email: 'test'))
      expect(pledge_form.valid?).to be false
      expect(pledge_form.errors.messages[:email]).to_not eq nil

      pledge_form = PledgeForm.new(params.merge(email: 'email@test.com'))
      expect(pledge_form.valid?).to be true
      expect(pledge_form.errors.messages[:email]).to eq nil
    end

    it 'validates the presence of referrer if referrer_id.present?'

    it 'validates the presence of user if user_id.present?' do
      user = create(:user)
      pledge_form = PledgeForm.new(params.merge(user_id: user.id, email: user.email))
      expect(pledge_form.valid?).to be true
      expect(pledge_form.errors.messages[:user]).to eq nil

      pledge_form = PledgeForm.new(params.merge(user_id: User.last.id + 1))
      expect(pledge_form.valid?).to be false
      expect(pledge_form.errors.messages[:user]).to_not eq nil
    end

    it 'validates the stripe_auth_token' do
      pledge_form = PledgeForm.new(params.merge(stripe_auth_token: 'not_a_real_token'))
      expect(pledge_form.valid?).to be false
      expect(pledge_form.errors.messages[:stripe_auth_token]).to_not eq nil

      pledge_form = PledgeForm.new(params.merge(stripe_auth_token: 'tok_abc123'))
      expect(pledge_form.valid?).to be false
      expect(pledge_form.errors.messages[:stripe_auth_token]).to_not eq nil
    end

    context 'when new user' do
      it 'validates that the email is not taken' do
        user = create(:user)
        pledge_form = PledgeForm.new(params.merge(user_id: nil, email: user.email))
        expect(pledge_form.valid?).to be false
        expect(pledge_form.errors.messages[:email]).to_not eq nil
      end
    end

    context 'when existing user' do
      it 'validates that the email is not mismatched' do
        user = create(:user)
        pledge_form = PledgeForm.new(params.merge(user_id: user.id, email: 'email@example.com'))
        expect(pledge_form.valid?).to be false
        expect(pledge_form.errors.messages[:email]).to_not eq nil
      end
    end
  end

  describe 'save' do
    it 'returns false if data is not valid' do
      pledge_form = PledgeForm.new
      expect(pledge_form.save).to be false
    end

    context 'new user' do
      it 'creates a new user' do
        pledge_form = PledgeForm.new(params)
        expect { pledge_form.save }.to change { User.count }.by(1)
      end

      it 'user has stripe_customer_id' do
        pledge_form = PledgeForm.new(params)
        pledge_form.save
        expect(pledge_form.user.stripe_customer_id).to_not be nil
      end
    end

    context 'existing user' do
      it 'does not create a new user' do
        user = create(:user)
        pledge_form = PledgeForm.new(params.merge(user_id: user.id, email: user.email))
        expect { pledge_form.save }.to_not change { User.count }
      end

      context 'new stripe_auth_token' do
        it 'user has stripe_customer_id applied to it' do
          user = create(:user)
          pledge_form = PledgeForm.new(params.merge(user_id: user.id, email: user.email))

          pledge_form.save
          user.reload
          expect(user.stripe_customer_id).to_not be nil
        end
      end

      context 'has existing stripe_auth_token' do
        it 'does not modify stripe_customer_id' do
          user = create(:user, :stripe_customer)
          pledge_form = PledgeForm.new(params.merge(user_id: user.id, email: user.email))

          expect do
            pledge_form.save
            user.reload
          end.to_not change { user.stripe_customer_id }
        end
      end
    end

    it 'creates new pledge' do
      pledge_form = PledgeForm.new(params)
      expect { pledge_form.save }.to change { Pledge.count }.by(1)
      expect(pledge_form.pledge).to_not be nil
    end

    it 'enqueues AuthorizePledgeJob'
  end
end
