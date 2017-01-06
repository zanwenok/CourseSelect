require 'test_helper'

class MetaDataTest < ActiveSupport::TestCase
    test "单个上课时间转换为字符串" do
        str = Hashes.time_to_str("70911")
        assert_equal str, "周日(9~11) "
    end
    test "多个上课时间转换为字符串" do
        str = Hashes.time_to_str("10102 30304")
        assert_equal str, "周一(1~2) 周三(3~4) "
    end
    
    test "从课程编号中提取院系字符" do 
        str = Hashes.code_depart("091M4001H")
        assert_equal str, "09"
    end
    test "从课程编号推断院系" do
        str = Hashes.department("091M4001H")
        assert_equal str, "计算机与控制学院"
    end
    
    test "从课程编号中提取学科字符" do 
        str = Hashes.code_subject("091M4001H")
        assert_equal str, "1"
    end
    test "从课程编号推断学科" do
        str = Hashes.subject("091M4001H")
        assert_equal str, "计算机科学与技术"
    end
    
    test "从课程编号中提取校区字符" do 
        str = Hashes.code_campus("091M4001H")
        assert_equal str, "H"
    end
    test "从课程编号推断校区" do
        str = Hashes.campus("091M4001H")
        assert_equal str, "雁栖湖"
    end
    
    test "从课程编号中提取课程类型字符（非公共课）" do 
        str = Hashes.code_prop("091M4001H")
        assert_equal str, "4"
    end
    test "从课程编号推断课程类型（非公共课）" do
        str = Hashes.type("091M4001H")
        assert_equal str, "专业核心课"
    end
    test "从课程编号中提取课程类型字符（公共课）" do 
        str = Hashes.code_prop("09MGB001H")
        assert_equal str, "GB"
    end
    test "从课程编号推断课程类型（公共课）" do
        str = Hashes.type("09MGB001H")
        assert_equal str, "公共必修课"
    end
    
    test "从课程编号中提取授课对象字符（非公共课）" do 
        str = Hashes.code_for("091M4001H")
        assert_equal str, "M"
    end
    test "从课程编号推断授课对象（非公共课）" do
        str = Hashes.for_whom("091M4001H")
        assert_equal str, "硕士生"
    end
    test "从课程编号中提取授课对象字符（公共课）" do 
        str = Hashes.code_for("09MGB001H")
        assert_equal str, "M"
    end
    test "从课程编号推断授课对象（公共课）" do
        str = Hashes.for_whom("09MGB001H")
        assert_equal str, "硕士生"
    end
end
