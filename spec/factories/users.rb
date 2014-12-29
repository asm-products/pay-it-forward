FactoryGirl.define do
  factory :user do
    sequence(:email)      { |n| "person#{n}@example.com" }
    password              { 'password' }
    password_confirmation { 'password' }

    trait :stripe_customer do
      stripe_customer_id do
        ::Stripe::Customer.create(card: Stripe::Token.create(
                               card: {
                                 number: '4242424242424242',
                                 exp_month: 3,
                                 exp_year: 2016,
                                 cvc: 314
                               }
                             ).id, email: email).id
      end
    end
  end
end
