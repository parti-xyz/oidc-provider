# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

null_account = NullAccount.take
unless null_account
  null_account = NullAccount.new
  null_account.build_internal name: ConnectInternal::NULL_NAME
  null_account.save!
end

internal_account = UserAccount.joins(:internal).find_by connect_internals: { name: ConnectInternal::INTERNAL_NAME }
unless internal_account
  internal_account = UserAccount.new
  internal_account.build_internal name: ConnectInternal::INTERNAL_NAME
  internal_account.save!
end

unless Client.find_by user_account: internal_account, name: Client::PARTI_AUTH_API_TEST_CLIENT_NAME
  client = Client.create!(
    user_account: internal_account,
    name: Client::PARTI_AUTH_API_TEST_CLIENT_NAME,
    redirect_uris: ''
  )
  client.update(
    identifier: '45d3ab6922c7e2a0c8cc2a5b19080658',
    secret: '58a17ba804daa8011c3c2e4db2df0ea203eb1341fad6bd116d67eceebf580826'
  )
end

unless Client.find_by user_account: internal_account, name: Client::PARTI_AUTH_UI_TEST_CLIENT_NAME
  client = Client.create!(
    name: Client::PARTI_AUTH_UI_TEST_CLIENT_NAME,
    redirect_uris: '',
    user_account: internal_account,
  )
  client.update(
    identifier: '64b14471f5a3aaacce1f13a801367d6d',
    secret: '2556d3de7c2fc40a1b6bd0b2e8e6261c80f00f6a62426fc0de7d6a6a6551159c'
  )
end

['openid', 'profile', 'email', 'create_client'].each do |name|
  unless Scope.find_by name: name
    Scope.create! name: name
  end
end
