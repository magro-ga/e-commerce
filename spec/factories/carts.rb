FactoryBot.define do
  factory :cart do
    status { :active }
    last_interaction_at { Time.current }

    trait :abandoned do
      last_interaction_at { 4.hours.ago }
      status { :abandoned }
    end

    trait :old_abandoned do
      last_interaction_at { 8.days.ago }
      status { :abandoned }
    end

    trait :with_items do
      after(:create) do |cart|
        create_list(:cart_item, 2, cart: cart)
      end
    end
  end
end
