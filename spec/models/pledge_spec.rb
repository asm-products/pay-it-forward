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

  describe 'stripe_authorization_charge' do
    let(:pledge) { create(:pledge) }

    it 'retrieves ::Stripe::Charge when accessed' do
      pledge.authorize!
      expect(pledge.stripe_authorization_charge).to_not be nil
    end
  end

  describe 'states' do
    context 'when created' do
      let(:pledge) { create(:pledge) }

      describe 'authorize' do
        it 'transitions to authorized' do
          expect { pledge.authorize! }.to change { pledge.state }.from('created').to('authorized')
        end
      end

      describe 'capture' do
        it 'fails to transition' do
          expect { pledge.capture! }.to raise_error
        end
      end

      describe 'refund' do
        it 'fails to transition' do
          expect { pledge.refund! }.to raise_error
        end
      end
    end

    context 'when authorized' do
      let(:pledge) { create(:pledge, :authorized) }

      describe 'authorize' do
        it 'fails to transition' do
          expect { pledge.authorize! }.to raise_error
        end
      end

      describe 'capture' do
        it 'transitions to captured' do
          expect { pledge.capture! }.to change { pledge.state }.from('authorized').to('captured')
        end
      end

      describe 'refund' do
        it 'transitions to refunded' do
          expect { pledge.refund! }.to change { pledge.state }.from('authorized').to('refunded')
        end
      end
    end

    context 'when captured' do
      let(:pledge) { create(:pledge, :captured) }

      describe 'authorize' do
        it 'fails to transition' do
          expect { pledge.authorize! }.to raise_error
        end
      end

      describe 'capture' do
        it 'fails to transition' do
          expect { pledge.capture! }.to raise_error
        end
      end

      describe 'refund' do
        it 'transitions to refunded' do
          expect { pledge.refund! }.to change { pledge.state }.from('captured').to('refunded')
        end
      end
    end

    context 'when refunded' do
      let(:pledge) { create(:pledge, :capture_refunded) }

      describe 'authorize' do
        it 'fails to transition' do
          expect { pledge.authorize! }.to raise_error
        end
      end

      describe 'capture' do
        it 'fails to transition' do
          expect { pledge.capture! }.to raise_error
        end
      end

      describe 'refund' do
        it 'fails to transition' do
          expect { pledge.refund! }.to raise_error
        end
      end
    end
  end

  describe 'transitions' do
    describe 'authorize' do
      let(:pledge) { create(:pledge) }

      it 'creates authorization charge' do
        expect { pledge.authorize! }.to change { pledge.stripe_authorization_charge_id }.from(nil)
      end
    end

    describe 'capture' do
      let(:pledge) { create(:pledge, :authorized) }

      it 'refunds authorization charge' do
        expect { pledge.capture! }.to change { pledge.stripe_authorization_charge.refunds.count }.from(0).to(1)
      end
      it 'creates capture charge' do
        expect { pledge.capture! }.to change { pledge.stripe_charge_id }.from(nil)
      end
    end

    describe 'refund' do
      context 'from authorized' do
        let(:pledge) { create(:pledge, :authorized) }

        it 'refunds authorization charge' do
          expect { pledge.refund! }.to change { pledge.stripe_authorization_charge.refunds.count }.from(0).to(1)
        end
      end

      context 'from captured' do
        let(:pledge) { create(:pledge, :captured) }

        it 'refunds capture charge' do
          expect { pledge.refund! }.to change { pledge.stripe_charge.refunds.count }.from(0).to(1)
        end
      end
    end
  end
end
