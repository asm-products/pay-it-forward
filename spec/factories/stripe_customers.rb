FactoryGirl.define do

  factory :stripe_customer do
    user                 { create(:user) }
    sequence(:stripe_id) { |n| "stripe_id-#{n}" }
  end

end
