FactoryGirl.define do

  factory :stripe_charge do
    stripe_customer       { create(:stripe_customer) }
    pledge                { create(:pledge, user: stripe_customer.user) }
    sequence(:stripe_id)  { |n| "stripe_id-#{n}" }
    value                 { 2000 }
    currency              { 'USD' }
  end

end
