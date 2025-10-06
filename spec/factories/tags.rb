FactoryBot.define do
  factory :tag do
    sequence :name do |n|
      "Tag #{n}"
    end

    factory :work_tag do
      name { "Work" }
    end
  end
end
