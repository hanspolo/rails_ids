require 'test_helper'

#
class PostsControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test 'should get show' do
    p = Post.create!(title: 'test')
    get :show, id: p.id
    assert_response :success
    assert_equal assigns(:post), p
  end

  test 'should get response when calling show with wrong id' do
    assert_raises RuntimeError do
      get :show, id: '1 OR 1=1;--'
    end
    assert_equal 1, RailsIds::Event.all.count
    assert_equal 1, RailsIds::Attack.all.count
  end

  test 'should detect invalid csrf token' do
    response = get :new
    csrf_token = response.request.env['rack.session']['_csrf_token']
    post :create, post: { title: 'test' }, authenticity_token: csrf_token
    assert_equal 0, RailsIds::Event.all.count
    assert_raises ActionController::InvalidAuthenticityToken do
      post :create, post: { title: 'test' }, authenticity_token: 'I am invalid'
    end
    assert_equal 1, RailsIds::Event.where(weight: 'suspicious').count
  end
end
