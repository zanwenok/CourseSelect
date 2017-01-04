class CoursesController < ApplicationController

  before_action :student_logged_in, only: [:select, :quit, :list]
  before_action :teacher_logged_in, only: [:new, :create, :edit, :destroy, :update]
  before_action :logged_in, only: :index
  
  @@hash = {
    "department"=>{
                  "数学科学学院"=>"01",
                  "物理科学学院"=>"02",
                  "天文与空间科学学院"=>"03",
                  "化学与化工学院"=>"04",
                  "材料科学与光电技术学院"=>"05"  ,
                  "生命科学学院"=>"06"  ,
                  "地球科学学院"=>"07"  ,
                  "资源与环境学院"=>"08"  ,
                  "计算机与控制学院"=>"09"  ,
                  "电子电气与通信工程学院"=>"10"  ,
                  "工程科学学院"=>"11"  ,
                  "经济与管理学院"=>"12"  ,
                  "公共政策与管理学院"=>"13"  ,
                  "人文学院"=>"14"  ,
                  "外语学院"=>"15"  ,
                  "中丹学院"=>"16"  ,
                  "国际学院"=>"17"  ,
                  "存济医学院"=>"18"  ,
                  "微电子学院"=>"19"  ,
                  "网络空间安全学院"=>"20"  ,
                  "未来技术学院"=>"21"  ,
                  "体育教研室"=>"TY"  
                  },
  "subject"=>{
              "01" => {"数学"=>"1",  "系统科学"=>"2", "统计学"=>"3"},
              "02" => {"物理学"=>"1", "核科学与技术"=>"2"},
              "03" => {"天文学"=>"1"},
              "04" => {"化学"=>"1", "化学工程与技术"=>"2"},
              "05" => {"材料科学与工程"=>"1", "光学工程"=>"2", "机械工程"=>"3"},
              "06" => {"生物学"=>"1"},
              "07" => {"地球物理学"=>"1","地质学"=>"2", "大气科学"=>"3", "海洋科学"=>"4", "地质资源与地质工程"=>"5",  "测绘科学与技术"=>"6"},
              "08" => {"地理学"=>"1", "生态学"=>"2", "环境科学与工程"=>"3", "农业资源利用"=>"4"},
              "09" => {"计算机科学与技术"=>"1", "控制科学与工程"=>"2", "软件工程"=>"3"},
              "10" => {"信息与通信工程"=>"1", "电子科学与技术"=>"2",  "电气工程"=>"3"},
              "11" => {"力学"=>"1", "动力工程及工程热物理"=>"2",  "土木工程"=>"3"},
              "12" => {"管理科学与工程"=>"1","工商管理"=>"2",  "应用经济学"=>"3", "图书情报与档案管理"=>"4"},
              "13" => {"管理科学与工程"=>"1", "公共管理"=>"2",  "法学"=>"3"},
              "14" => {"哲学"=>"1", "心理学"=>"2",  "新闻传播学"=>"3", "科学技术史"=>"4"},
              "18" => {"基础医学"=>"1", "药学"=>"2",  "生物医学工程"=>"3"},
              "19" => {"电子与通信工程"=>"1", "集成电路工程"=>"2"},
              "20" => {"网络空间安全"=>"1"}
              },
  "campus"=>{"雁栖湖"=>"H", "玉泉路"=>"Y", "中关村"=>"Z"},
  "property"=>{
                "一级学科核心课"=>"1",
                "一级学科普及课"=>"2",
                "一级学科研讨课"=>"3",
                "专业核心课"=>"4",
                "专业普及课"=>"5",
                "专业研讨课"=>"6",
                "高级强化课"=>"7",
                "公共必修课"=>"GB",
                "公共选修课"=>"GX"
              },
  "for"=>{"硕士生"=>"M",  "博士生"=>"D"}
}

@@option=[
      '01-1 数学', '01-2 系统科学','01-3 统计学',
      '02-1 物理学', '02-2 核科学与技术',
      '03-1 天文学',
      '04-1 化学', '04-2 化学工程与技术',
      '05-1 材料科学与工程', '05-2 光学工程','05-3 机械工程',
      '06-1 生物学',
      '07-1 地球物理学', '07-2 地质学','07-3 大气科学','07-4 海洋科学','07-5 地质资源与地质工程','07-6 测绘科学与技术',
      '08-1 地理学', '08-2 生态学','08-3 环境科学与工程','08-4 农业资源利用',
      '09-1 计算机科学与技术', '09-2 控制科学与工程','09-3 软件工程',
      '10-1 信息与通信工程', '10-2 电子科学与技术','10-3 电气工程',
      '11-1 力学', '11-2 动力工程及工程热物理','11-3 土木工程',
      '12-1 管理科学与工程', '12-2 工商管理','12-3 应用经济学','12-4 图书情报与档案管理',
      '13-1 管理科学与工程', '13-2 公共管理','13-3 法学',
      '14-1 哲学', '14-2 心理学','14-3 新闻传播学','14-4 新闻传播学',
      '18-1 基础医学', '18-2 药学','18-3 生物医学工程',
      '19-1 电子与通信工程', '19-2 集成电路工程',
      '20-1 网络空间安全']
  #-------------------------for teachers----------------------

  def new
    @course=Course.new
    @course1=Course.new
    @option=@@option
  end

  def create

    @course = Course.new(course_params)
    get_course_code
    if @course.save
      current_user.teaching_courses<<@course
      redirect_to courses_path, flash: {success: "新课程申请成功"}
    else
      flash[:info] = "请继续"
      render 'new'
    end
  end

  def edit
    @option=@@option
    @course=Course.find_by_id(params[:id])
  end

  def update
    @course = Course.find_by_id(params[:id])
    get_course_code
    
    if @course.update_attributes(course_params)
      flash={:info => "更新成功"}
      redirect_to courses_path, flash: flash
    else
      flash={:warning => "更新失败"}
      render 'edit', flash: flash
    end
  end

  def destroy
    @course=Course.find_by_id(params[:id])
    current_user.teaching_courses.delete(@course)
    @course.destroy
    flash={:success => "成功删除课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end

  def open
    @course=Course.find_by_id(params[:id])
    @course.update_attribute(:open,true)
    redirect_to courses_path, flash: {:success => "已经成功开启该课程:#{ @course.name}"}
  end
  
  def close
    @course=Course.find_by_id(params[:id])
    @course.update_attribute(:open,false)
    redirect_to courses_path, flash: {:success => "已经成功关闭该课程:#{ @course.name}"}
  end
  


  #-------------------------for students----------------------

  def list
    @course=Course.all
    @course=@course.where(open:true).all
    @course=@course-current_user.courses
  end

  def select
    @course=Course.find_by_id(params[:id])
    current_user.courses<<@course
    flash={:success => "成功选择课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end

  def quit
    @course=Course.find_by(id:params[:id])
    current_user.courses.delete(@course)
    flash={:success => "成功退选课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end


  #-------------------------for both teachers and students----------------------

  def index
    @course=current_user.teaching_courses if teacher_logged_in?
    @course=current_user.courses if student_logged_in?
  end
  
  def detail
    
    @course=Course.find_by(id:params[:id])
  end

  private

  # Confirms a student logged-in user.
  def student_logged_in
    unless student_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a teacher logged-in user.
  def teacher_logged_in
    unless teacher_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a  logged-in user.
  def logged_in
    unless logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  def course_params
    temp = params.require(:course).permit(:course_code, :name, :course_department, :course_firstlevel, :teaching_object, :course_type, 
                                   :teaching_type, :exam_type,:period, :credit, :limit_num, :campus, :building, :class_room, 
                                   :course_time, :start_week, :end_week)
    temp["course_department"] = temp["course_department"][3..-1]
    temp["course_firstlevel"] = temp["course_firstlevel"][5..-1]
    temp["teaching_object"] = temp["teaching_object"][2..-1]
    temp["course_type"] = temp["course_type"][3..-1]
    if temp["campus"][0,1] == "G"
      temp["campus"] = temp["campus"][3..-1]
    else 
      temp["campus"] = temp["campus"][2..-1]
    end
    
    temp
  end

  def get_course_code
     
    # @course.course_code= @course.course_department[0,2] + @course.course_firstlevel[3,1]+@course.teaching_object[0,1]+@course.course_type[0,1]+"#{params[:id].to_i+100}"+@course.campus[0,1]
    depart_num =  @@hash["department"][@course.course_department]
    sort_num ="#{params[:id].to_i+100}"
    campus_num = @@hash["campus"][@course.campus]
    
    if (@course.teaching_object == "硕士生" or @course.teaching_object == "博士生") and @course.course_type =="公共必修课"
      if (@course.teaching_object == "硕士生")
        first_lev_num = "MGB"
      else
        first_lev_num = "DGB"
      end
      type_num= ""
      property_num=""
    elsif  @course.course_type =="公共选修课"
      first_lev_num = "MGX"
      type_num= ""
      property_num=""
    else
      first_lev_num =  @@hash["subject"][depart_num][@course.course_firstlevel]
      type_num = @@hash["for"][@course.teaching_object]
      property_num = @@hash["property"][@course.course_type]
    end
    
    @course.course_code = depart_num + first_lev_num + type_num  + property_num  + sort_num  + campus_num
  end
end
