require 'test_helper'

class AdminUpdateTest < ActionDispatch::IntegrationTest
  def setup
    @admin = User.create(
        name: "admin",
        email: "admin@test.com",
        num: "201628008629001",
        major: "信息安全",
        department: "信息工程研究所",
        password: "password",
        password_confirmation: "password",
        admin: true
    )

    assert @student.valid? "valid teacher"

    # login as admin
    get sessions_login_path
    assert_template 'sessions/new','render login page'
    post sessions_login_path session:{  email: "admin@test.com",
                                        password:"password"}
    assert(User.find_by_id(session[:user_id]).teacher,"login as admin")
  end


  test "admin update info" do
    # update teacher
  end


end