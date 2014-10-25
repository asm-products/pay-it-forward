FactoryGirl.define do

  factory :stripe_charge do
    stripe_customer      { create(:stripe_customer) }
    sequence(:stripe_id) { |n| "stripe_id-#{n}" }
    value                { 2000 }
    currency             { 'USD' }
  end

end
