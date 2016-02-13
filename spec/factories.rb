FactoryGirl.define do
  factory :user do
    username "Pekka"
    password "Foobar1"
    password_confirmation "Foobar1"
  end

  factory :rating do
    score 10
  end

  factory :rating2, class: Rating do
    score 20
  end

  factory :brewery do
    name "anonymous"
    year 1900
  end

  factory :brewery2, class: Brewery do
    name "tsaiba"
    year 1900
  end

  factory :brewery3, class: Brewery do
    name "trulli"
    year 1900
  end

  factory :beer do
    name "Bisse"
    brewery
    style "IPA"
  end

end
