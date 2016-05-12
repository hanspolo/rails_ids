require 'test_helper'

#
class UsersControllerTest < ActionController::TestCase
  test 'should create event if user is created' do
    count = RailsIds::Event.all.count
    get :create
    assert_equal count + 1, RailsIds::Event.all.count
  end

  test 'should create attack after 10 logins in a row' do
    event_count = RailsIds::Event.all.count
    attack_count = RailsIds::Attack.all.count
    9.times { get :create }
    assert_equal event_count + 9, RailsIds::Event.all.count
    assert_raises RuntimeError do
      get :create
    end
    assert_equal event_count + 10, RailsIds::Event.all.count
    assert_equal attack_count + 1, RailsIds::Attack.all.count
  end
end
