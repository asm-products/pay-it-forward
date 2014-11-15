FactoryGirl.define do

  factory :pledge do
    charity         { create(:charity) }
    tip_percentage  { 5 }
    amount          { 2000 }
    #user           { create(:user) }
    expiration      { 7.days.from_now }
    
    trait :referrered do
      referrer { create(:pledge) }
    end
  end

end