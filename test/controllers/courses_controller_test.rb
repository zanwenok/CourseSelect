require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  #路由测试
  test "filter方法为nil参数时不应该出错" do
    get :filter
    assert true
  end
  test "filter方法空字符串能重定向" do
    get :filter, {:exchange => ""}
    assert_response :redirect
  end
  test "filter方法非空字符串能重定向" do
    get :filter, {:exchange => "b14 cGX h"}
    assert_response :redirect
  end
  
  #空/nil条件测试
  test "筛选字符串为nil时不应该出错" do
    Filter.filter nil, [courses(:CA)]
    assert true
  end
  test "被筛选课程为nil时不应该出错" do
    Filter.filter "aM", nil
    assert true
  end
  test "空列表筛选后还是空列表" do
    Filter.filter "b09", []
    assert_equal Filter.filtered_courses, []
  end
  test "[计算机体系结构]应该被空条件匹配" do
    Filter.filter "", [courses(:CA)]
    assert_not_equal Filter.filtered_courses, []
  end
  
  #单个条件匹配测试
  test "[计算机体系结构]应该被学院09匹配" do
    Filter.filter "b09", [courses(:CA)]
    assert_not_equal Filter.filtered_courses, []
  end
  test "[计算机体系结构]不应该被学院10匹配" do
    Filter.filter "b10", [courses(:CA)]
    assert_equal Filter.filtered_courses, []
  end
  
  test "[计算机体系结构]应该被课程类型4匹配" do
    Filter.filter "c4", [courses(:CA)]
    assert_not_equal Filter.filtered_courses, []
  end
  test "[计算机体系结构]不应该被课程类型GX匹配" do
    Filter.filter "cGX", [courses(:CA)]
    assert_equal Filter.filtered_courses, []
  end
  
  test "[计算机体系结构]应该被上课地点[Hall]匹配" do
    Filter.filter "dHall", [courses(:CA)]
    assert_not_equal Filter.filtered_courses, []
  end
  test "[计算机体系结构]应该被上课地点[H教1]匹配" do
    Filter.filter "dH教1", [courses(:CA)]
    assert_not_equal Filter.filtered_courses, []
  end
  test "[计算机体系结构]不应该被上课地点[Hother]匹配" do
    Filter.filter "dHother", [courses(:CA)]
    assert_equal Filter.filtered_courses, []
  end
  test "[计算机体系结构]不应该被上课地点[Yall]匹配" do
    Filter.filter "dYall", [courses(:CA)]
    assert_equal Filter.filtered_courses, []
  end
  
  test "[计算机体系结构]应该被周1匹配" do
    Filter.filter "e1", [courses(:CA)]
    assert_not_equal Filter.filtered_courses, []
  end
  test "[计算机体系结构]不应该被周3匹配" do
    Filter.filter "e3", [courses(:CA)]
    assert_equal Filter.filtered_courses, []
  end
  
  test "[计算机体系结构]应该被授课对象M匹配" do
    Filter.filter "aM", [courses(:CA)]
    assert_not_equal Filter.filtered_courses, []
  end
  test "[计算机体系结构]不应该被授课对象D匹配" do
    Filter.filter "aD", [courses(:CA)]
    assert_equal Filter.filtered_courses, []
  end
  
  test "[计算机体系结构]应该被9-11节精确匹配" do
    Filter.filter "fP0911", [courses(:CA)]
    assert_not_equal Filter.filtered_courses, []
  end
  test "[计算机体系结构]不应该被8-11节精确匹配" do
    Filter.filter "fP0811", [courses(:CA)]
    assert_equal Filter.filtered_courses, []
  end
  test "[计算机体系结构]应该被8-11节模糊匹配" do
    Filter.filter "fV0911", [courses(:CA)]
    assert_not_equal Filter.filtered_courses, []
  end
  test "[计算机体系结构]不应该被8-10节模糊匹配" do
    Filter.filter "fV0810", [courses(:CA)]
    assert_equal Filter.filtered_courses, []
  end
  
  test "[计算机体系结构]应该被学分==3.0匹配" do
    Filter.filter "geq3.0", [courses(:CA)]
    assert_not_equal Filter.filtered_courses, []
  end
  test "[计算机体系结构]应该被学分>=2.0匹配" do
    Filter.filter "gge2.0", [courses(:CA)]
    assert_not_equal Filter.filtered_courses, []
  end
  test "[计算机体系结构]不应该被学分<2.0确匹配" do
    Filter.filter "gls2.0", [courses(:CA)]
    assert_equal Filter.filtered_courses, []
  end
  test "[计算机体系结构]不应该被学分>3.0确匹配" do
    Filter.filter "ggt3.0", [courses(:CA)]
    assert_equal Filter.filtered_courses, []
  end
  
  #复合条件测试
  test "空条件复合测试" do
    Filter.filter "", [courses(:CA), courses(:Algo), courses(:IS), courses(:CAHL)]
    assert_equal Filter.filtered_courses, [courses(:CA), courses(:Algo), courses(:IS), courses(:CAHL)]
  end
  test "在我没选课的时间段，有哪些人文学院开设的公共选修课？" do
    Filter.filter "b14 cGX h", [courses(:CA), courses(:Algo), courses(:IS), courses(:CAHL)]
    assert_equal Filter.filtered_courses, [courses(:CAHL)]
  end
  test "在玉泉路校区为硕士生开设的公共必修课有哪些？" do
    Filter.filter "aM cGB dYall", [courses(:CA), courses(:Algo), courses(:IS), courses(:CAHL)]
    assert_equal Filter.filtered_courses, []
  end
  test "周一上午上课的学分大于等于2的课有哪些？" do
    Filter.filter "e1 fV0104 ggt2.0", [courses(:CA), courses(:Algo), courses(:IS), courses(:CAHL)]
    assert_equal Filter.filtered_courses, [courses(:Algo)]
  end
  test "在雁栖湖校区学园1，有哪些课恰好在5~7节上课？" do
    Filter.filter "dH学园1 fP0507", [courses(:CA), courses(:Algo), courses(:IS), courses(:CAHL)]
    assert_equal Filter.filtered_courses, [courses(:CAHL)]
  end
end
