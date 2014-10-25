FactoryGirl.define do

  factory :pledge do
    user        { create(:user) }
    expiration  { 7.days.from_now }
  end
    
  factory :pledge_referral, class: Pledge  do
    referrer    { create(:pledge) }
    user        { create(:user) }
    expiration  { 7.days.from_now }
  end

end
