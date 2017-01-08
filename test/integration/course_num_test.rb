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



  test "网安学院 硕士生 雁栖湖 一级学科核心课 序号生成" do
    post "/courses" ,course:{
        name: "高级软件工程",
        course_department:"20 网络空间安全学院",
        course_firstlevel:"20-1 网络空间安全",
        teaching_object:"M 硕士生",
        course_type:"1 一级学科核心课",
        teaching_type:"课堂讲授为主",
        exam_type:"'闭卷笔试'",
        limit_num:"300",
        period:"60",
        credit:"2",
        campus:"'H 雁栖湖",
        building:"教1",
        class_room:"107",
        start_week:"2",
        end_week:"17",
        course_time:"30911"
    }
    @course = @current_user.teaching_courses.first

    assert_equal @course.course_code, "201M1#{@course.id}H"
  end

  test "网安学院 博士生 玉泉路 一级学科核心课 序号生成" do
    post "/courses" ,course:{
        name: "高级软件工程",
        course_department:"20 网络空间安全学院",
        course_firstlevel:"20-1 网络空间安全",
        teaching_object:"D 博士生",
        course_type:"1 一级学科核心课",
        teaching_type:"课堂讲授为主",
        exam_type:"'闭卷笔试'",
        limit_num:"300",
        period:"60",
        credit:"2",
        campus:"'Y 玉泉路",
        building:"教1",
        class_room:"107",
        start_week:"2",
        end_week:"17",
        course_time:"30911"
    }
    @course = @current_user.teaching_courses.first

    assert_equal @course.course_code, "201D1#{@course.id}Y"
  end

  test "网安学院 博士生 玉泉路 公共必修 序号生成" do
    post "/courses" ,course:{
        name: "高级软件工程",
        course_department:"20 网络空间安全学院",
        course_firstlevel:"20-1 网络空间安全",
        teaching_object:"D 博士生",
        course_type:"GB 公共必修课",
        teaching_type:"课堂讲授为主",
        exam_type:"'闭卷笔试'",
        limit_num:"300",
        period:"60",
        credit:"2",
        campus:"'Y 玉泉路",
        building:"教1",
        class_room:"107",
        start_week:"2",
        end_week:"17",
        course_time:"30911"
    }
    @course = @current_user.teaching_courses.first

    assert_equal @course.course_code, "20DGB#{@course.id}Y"
  end

  test "网安学院 博士生 中关村 公共选修 序号生成" do
    post "/courses" ,course:{
        name: "高级软件工程",
        course_department:"20 网络空间安全学院",
        course_firstlevel:"20-1 网络空间安全",
        teaching_object:"D 博士生",
        course_type:"GX 公共选修课",
        teaching_type:"课堂讲授为主",
        exam_type:"'闭卷笔试'",
        limit_num:"300",
        period:"60",
        credit:"2",
        campus:"'Y 玉泉路",
        building:"教1",
        class_room:"107",
        start_week:"2",
        end_week:"17",
        course_time:"30911"
    }
    @course = @current_user.teaching_courses.first

    assert_equal @course.course_code, "20MGX#{@course.id}Y"
  end
end