require 'test_helper'

class TeacherUpdateTest < ActionDispatch::IntegrationTest
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

  test "teacher update info with right password" do
    get edit_user_path(@current_user)
    assert_template 'users/edit'

    @new_name = "teacher_new"
    @new_email ="teacher_test_new@test.com"
    @new_department = "信息工程研究所_new"
    @wrong_password = "password_wrong"

    patch user_path(@current_user), user:{ name:@new_name,
                                           email:@new_email,
                                           department:@new_department,
                                           password:@origin_password}

    @current_user = User.find_by(id: session[:user_id])
    assert_equal flash[:info], "更新成功"


    assert_equal @current_user.name, @origin_name
    assert_equal @current_user.email, @new_email
    assert_equal @current_user.department, @origin_department
  end

  test "teacher update info with wrong password" do
    get edit_user_path(@current_user)
    assert_template 'users/edit'

    @new_name = "teacher_new"
    @new_email ="teacher_test_new@test.com"
    @new_department = "信息工程研究所_new"
    @wrong_password = "password_wrong"


    patch user_path(@current_user), user:{ name:@new_name,
                                           email:@new_email,
                                           department:@new_department,
                                           password:@wrong_password}
    @current_user = User.find_by(id: session[:user_id])
    assert_equal flash[:warning], "更新失败：密码错误"

    assert_equal @current_user.name, @origin_name
    assert_equal @current_user.email, @origin_email
    assert_equal @current_user.department, @origin_department
  end

  test "student update password with right old_password" do
    @new_password = "password_new"
    @new_passwrod_confirmarion = "password_new"
    @wrong_password_confirmation = "password_new_wrong"

    get edit_password_user_url(@current_user)
    assert_template "users/edit_password"

    patch update_password_user_path(@current_user), user:{ old_password:@origin_password,
                                                           password:@new_password,
                                                           password_confirmation:@new_passwrod_confirmarion}
    @current_user = User.find_by(id: session[:user_id])
    assert_equal flash[:info], "修改成功"
    assert @current_user.authenticate(@new_password)
  end

  test "student update password with wrong old_password" do
    @new_password = "password_new"
    @new_passwrod_confirmarion = "password_new"
    @wrong_password_confirmation = "password_new_wrong"

    get edit_password_user_url(@current_user)
    assert_template "users/edit_password"

    patch update_password_user_path(@current_user), user:{ old_password:@wrong_password,
                                                           password:@new_password,
                                                           password_confirmation:@new_passwrod_confirmarion}
    @current_user = User.find_by(id: session[:user_id])
    assert_equal flash[:warning], "修改失败：旧密码错误"
    assert @current_user.authenticate(@origin_password)
  end

  test "student update password with short new_password" do
    @new_password = "short"
    @new_passwrod_confirmarion =  "short"
    @wrong_password_confirmation = "password_new_wrong"

    get edit_password_user_url(@current_user)
    assert_template "users/edit_password"

    patch update_password_user_path(@current_user), user:{ old_password:@origin_password,
                                                           password:@new_password,
                                                           password_confirmation:@new_passwrod_confirmarion}
    @current_user = User.find_by(id: session[:user_id])
    assert_equal flash[:warning], "修改失败:密码最少为6个字符"
    assert @current_user.authenticate(@origin_password)
  end

  test "student update password with wrong confirmation" do
    @new_password = "short"
    @new_passwrod_confirmarion =  "short"
    @wrong_password_confirmation = "password_new_wrong"

    get edit_password_user_url(@current_user)
    assert_template "users/edit_password"

    patch update_password_user_path(@current_user), user:{ old_password:@origin_password,
                                                           password:@new_passwrod_confirmarion,
                                                           password_confirmation:@wrong_password_confirmation}
    @current_user = User.find_by(id: session[:user_id])
    assert_equal flash[:warning], "修改失败：两次密码输入不一致"
    assert @current_user.authenticate(@origin_password)
  end
end