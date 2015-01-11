FactoryGirl.define do
  factory :pledge do
    user            { create(:user, :stripe_customer) }
    charity         { create(:charity) }
    tip_percentage  { 5 }
    amount          { 2000 }

    trait :referrered do
      referrer { create(:pledge) }
    end

    trait :authorized do
      after(:create) do |pledge|
        pledge.authorize!
      end
    end

    trait :captured do
      after(:create) do |pledge|
        pledge.authorize!
        pledge.capture!
      end
    end

    trait :authorize_refunded do
      after(:create) do |pledge|
        pledge.authorize!
        pledge.refund!
      end
    end

    trait :capture_refunded do
      after(:create) do |pledge|
        pledge.authorize!
        pledge.capture!
        pledge.refund!
      end
    end
  end
end
