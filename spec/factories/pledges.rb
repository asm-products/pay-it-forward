FactoryGirl.define do

  factory :pledge do
    user            { create(:user) }
    charity         { create(:charity) }
    tip_percentage  { 5 }
    amount          { 2000 }

    trait :referrered do
      referrer { create(:pledge) }
    end
  end

end
