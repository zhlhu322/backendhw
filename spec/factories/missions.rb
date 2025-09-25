FactoryBot.define do
  factory :mission do
    name { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    end_date    { Time.current + rand(2..5).days }
    created_at  { Time.current }
    state      { %w[pending in_progress completed].sample }

    trait :to_be_deleted do
      description { "A mission to be deleted." }
    end
  end
end
