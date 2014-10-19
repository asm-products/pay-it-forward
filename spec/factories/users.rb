FactoryGirl.define do
  
  factory :user do
    name 'Francis Joseph Underwood'
    sequence(:email) { |n| "person#{n}@example.com" }
    password 'password1234'
  end
end


