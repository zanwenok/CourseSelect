require 'test_helper'

# author @zanwen

class CourseNumTest < ActionDispatch::IntegrationTest
  def setup
    @origin_name = "teacher"
    @origin_email = "teacher_test@test.com"
    @origin_department = "信息工程研究所"
    @origin_password = "password"
    @teacher = User.create(
        name: @origin_name,
        email: @origin_email,
        department:@origin_department,
        password: @origin_password, password_confirmation: @origin_password,
        teacher: true
    )

    assert @teacher.valid? "valid teacher"

    # login as teacher
    get sessions_login_path
    assert_template 'sessions/new','render login page'
    post sessions_login_path session:{  email: "teacher_test@test.com",
                                        password:"password",
                                        remember_me: 0}
    assert(User.find_by_id(session[:user_id]).teacher,"login as teacher")

    @current_user = User.find_by(id: session[:user_id])
  end

  test "open new course page correctly" do
    get new_course_path
    assert_response :success
    assert_template "courses/_form"
  end

  test "创建课程： {name:"

end