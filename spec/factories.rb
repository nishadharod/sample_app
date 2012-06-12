FactoryGirl.define do
  factory :user do
    name     "Michael Hartl"
    email    "michael@example.com"
    password "foolsbar"
    password_confirmation "foolsbar"
  end
end