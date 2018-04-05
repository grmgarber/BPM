FactoryBot.define do
  factory :book do
    sequence(:id) { |n| n }
    sequence(:title) { |n| "Book Title #{n}" }
    release_date Date.today
    price 3.25
    # association :format, factory: :format
    # association :authors, factory: :author
  end

  factory :author do
    sequence(:id) { |n| n }
    sequence(:name) { |n| "Author #{n} Name" }
  end

  factory :format do
    id 1
    name 'Hardcover'
  end
end
