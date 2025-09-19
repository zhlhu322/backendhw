FactoryBot.define do
  factory :mission do
    name { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph(sentence_count: 2) }

    trait :to_be_deleted do
      description { "A mission to be deleted." }
    end
  end
end
