FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :document do
  	content "Lorem ipsum"
    lat 10.0
    lng 10.0
  	date "2020/5/16"
  	weather "はれ"
  	user
  end
end