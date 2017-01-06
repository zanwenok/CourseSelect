class Course < ActiveRecord::Base

  has_many :grades
  has_many :users, through: :grades

  belongs_to :teacher, class_name: "User"

  validates :course_code, :name, 
            :course_time, :start_week, :end_week,  :building, :class_room, :period, :credit, 
            :teaching_type, :exam_type, presence: true, length: {maximum: 50}
  
  validates :course_department, :course_firstlevel, :teaching_object, :course_type, :campus, length:{maximum:50}
  validates :limit_num,:student_num,length: {maximum: 50}
end

#CourseLimit_num
#solve the problem about the limit student number of a couse
class CourseLimit
  def initialize course
    @limit_num=course.limit_num
    @student_num=course.student_num
  end
  def isLimited?
    if @limit_num==0 or @student_num<@limit_num
      return true
    else
      return false
    end
  end
end

#CourseTimeClass 
#solve the problem about the course time
class CourseTime 
  #Privte: 
  attr_accessor:start_week,:end_week;
  attr_accessor:course_time_pair_list
  # change String to TimePairList (for initialization)
  def ChangeStringToPairlist course_time;  
    time_fix_list=course_time.split;
    course_time_pair_list=Array.new
    time_fix_list.each do |time_fix|
      course_time_pair_list << TimePair.new(time_fix);
    end
    return course_time_pair_list;
  end

  #Interface:
  #1.initialize function (connect to a Course)
  def initialize course
    @re_course=course
    @start_week=course.start_week
    @end_week=course.end_week
    @course_time_pair_list=ChangeStringToPairlist course.course_time
  end
  
  #2.detect the conflict with a single Course
  def DectConflictByCourse course_other;
    if self.start_week>course_other.end_week
      return false;
    end
    if self.end_week<course_other.start_week
      return false;
    end
    @course_time_pair_list.each do |this_time_pair|
      course_other.course_time_pair_list.each do |other_time_pair|
        if this_time_pair.IsHaveOverLap? other_time_pair
          return true
        end
      end
    end
    return false
  end
  
  #3.detect the conflict with a set of Courses
  def DectConflictByList course_list;
    re_course_list=Array.new
    course_list.each do |course|
      if DectConflictByCourse (CourseTime.new (course))
        re_course_list << course
      end
    end
    return re_course_list
  end
  
  #Add any other function to deal with the problem about time
end

#TimePairClass
#represent a time interval
# change string to the constructed  data
class TimePair
  attr_accessor:start_time,:end_time;
  def initialize fix_time;
    fix_time=~/([0-9])([0-9][0-9])([0-9][0-9])/;
    @start_time=($1+$2).to_i;
    @end_time=($1+$3).to_i;
  end
  def IsHaveOverLap? course_time_pair;
    if self.start_time>course_time_pair.end_time or self.end_time<course_time_pair.start_time;
      return false;
    else
      return true;
    end
  end
end
  