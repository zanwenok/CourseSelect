require 'test_helper'

# author @zanwen

class AdminUpdateTest < ActionDispatch::IntegrationTest
  def setup
    @origin_name = "admin"
    @origin_email = "admin@test.com"
    @origin_num = "2016#{Faker::Number.number(11)}"
    @origin_major = "信息安全"
    @origin_department = "信息工程研究所"
    @origin_password = "password"
    @admin = User.create(
        name: @origin_name,
        email:@origin_email,
        num:@origin_num,
        major: @origin_major, department:@origin_department,
        password:@origin_password, password_confirmation:@origin_password,
        admin: true
    )

    assert @admin.valid? "valid admin"

    # login as admin
    get sessions_login_path
    assert_template 'sessions/new','render login page'
    post sessions_login_path session:{  email: @origin_email,
                                        password:@origin_password}
    assert(User.find_by_id(session[:user_id]).admin, "login as admin")

    @current_user = User.find_by(id: session[:user_id])
  end

  test "admin update info with right password" do
    get edit_user_path(@current_user)
    assert_template 'users/edit'

    @new_name = "admin_new"
    @new_email = "admin_new@test.com"
    @new_department = "信息工程研究所_new"

    patch user_path(@current_user), user:{ name:@new_name,
                                           email:@new_email,
                                           department:@new_department,
                                           password:@origin_password}

    @current_user = User.find_by(id: session[:user_id])
    assert_equal flash[:info], "更新成功"


    assert_equal @current_user.name, @new_name
    assert_equal @current_user.email, @new_email
    assert_equal @current_user.department, @new_department
  end

  test "admin update info with wrong password" do
    get edit_user_path(@current_user)
    assert_template 'users/edit'

    @new_name = "admin_new"
    @new_email = "admin_new@test.com"
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



end