require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do #this expects 0 difference between before and after count 
      post users_path, params: { user: { name:  "",                            #before_count = User.count
                                         email: "user@invalid",                #post users_path, ...
                                         password:              "foo",         #after_count  = User.count
                                         password_confirmation: "bar" } }      #assert_equal before_count, after_count
    end
    assert_template 'users/new'       #assert_template to check that a failed submission re-renders the new action
  end
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do  #this expects 1 difference between before and after count 
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
