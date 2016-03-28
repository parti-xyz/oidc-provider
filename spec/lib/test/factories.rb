require 'factories'

FactoryGirl.define do
  factory :user_account do
  end

  factory :user_account_parti, parent: :user_account do
    transient do
      parti nil
    end

    after :build do |account, evaluator|
      parti_attrs = evaluator.parti.nil? ? {} : evaluator.parti
      parti_attrs.merge account: account
      account.parti = build :connect_parti, parti_attrs
    end
  end
end