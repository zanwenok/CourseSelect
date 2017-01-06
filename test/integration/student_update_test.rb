require 'test_helper'

class StudentUpdateTest < ActionDispatch::IntegrationTest
  def setup
    @student = User.create(
        name: "student",
        email:"student@test.com",
        num:"2016#{Faker::Number.number(11)}",
        major: "信息安全", department:"信息工程研究所",
        password:"password", password_confirmation:"password"
    )

    assert @student.valid? "valid teacher"

    # login as student
    get sessions_login_path
    assert_template 'sessions/new','render login page'
    post sessions_login_path session:{  email: "student@test.com",
                                        password:"password"}
    assert(User.find_by_id(session[:user_id]).teacher,"login as student")
  end

  test "student update info" do

  end


end