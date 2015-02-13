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

  factory :beer do
    name "anonymous"
    brewery
    style
  end

  factory :brewery2, class: Brewery do
    name "anonymous2"
    year 1900
  end

  factory :beer2, class: Beer do
    name "nimi"
    brewery
    style
  end

  factory :style do
    name "Tyyli"
    description "tyylin kuvaus"
  end

  factory :style2, class: Style do
    name "Toinen tyyli"
    description "toisen tyylin kuvaus"
  end
end