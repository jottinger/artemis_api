require "test_helper"

class UserTest < Minitest::Test
  def setup
    options = {app_id: '12345',
               app_secret: '67890',
               base_uri: 'http://localhost:3000'}

    todays_date = DateTime.now
    @client = ArtemisApi::Client.new('ya29', 'eyJh', 7200, todays_date, options)

    stub_request(:get, 'http://localhost:3000/api/v3/user')
      .to_return(body: {data: {id: '41', type: 'users', attributes: {id: 41, full_name: 'Jamey Hampton', email: 'jhampton@artemisag.com'}}}.to_json)

    stub_request(:get, 'http://localhost:3000/api/v3/facilities/2/users')
      .to_return(body: {data: [{id: '41', type: 'users', attributes: {id: 41, full_name: 'Jamey Hampton', email: 'jhampton@artemisag.com'}}, {id: '42', type: 'users', attributes: {id: 42, full_name: 'Developer', email: 'developer@artemisag.com'}}]}.to_json)
  end

  def test_getting_current_user
    user = ArtemisApi::User.get_current(@client)
    assert_equal user.id, 41
    assert_equal user.full_name, 'Jamey Hampton'
    assert_equal user.email, 'jhampton@artemisag.com'
  end

  def test_finding_all_users
    users = ArtemisApi::User.find_all(2, @client)
    assert_equal 2, users.count
    assert_equal 2, @client.objects['users'].count
  end

  def test_finding_a_specific_user
    stub_request(:get, 'http://localhost:3000/api/v3/facilities/2/users/42')
      .to_return(body: {data: {id: '42', type: 'users', attributes: {id: 42, full_name: 'Developer', email: 'developer@artemisag.com'}}}.to_json)

    user = ArtemisApi::User.find(42, 2, @client)
    assert_equal user.full_name, 'Developer'
    assert_equal user.email, 'developer@artemisag.com'
  end

  def test_finding_a_user_with_included_organizations
    stub_request(:get, 'http://localhost:3000/api/v3/facilities/2/users/42?include=organizations')
      .to_return(body: {data:
                         {id: '42',
                          type: 'users',
                          attributes: {id: 42, full_name: 'Developer', email: 'developer@artemisag.com'}},
                        included: [{id: '1', type: 'organizations', attributes: {id: 1, name: 'Vegetable Sky'}}]}.to_json)

    user = ArtemisApi::User.find(42, 2, @client, include: "organizations")
    assert_equal user.full_name, 'Developer'
    assert_equal user.email, 'developer@artemisag.com'
    assert_equal @client.objects['organizations'].count, 1

    organization = ArtemisApi::Organization.find(1, @client)
    assert_equal organization.name, 'Vegetable Sky'
  end
end
