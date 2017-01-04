class Course < ActiveRecord::Base

  has_many :grades
  has_many :users, through: :grades

  belongs_to :teacher, class_name: "User"

  validates :course_code, :name, 
            :course_time, :start_week, :end_week,  :building, :class_room, :period, :credit, :course_department, :course_firstlevel, 
            :teaching_object, :course_type, :campus, :teaching_type, :exam_type, presence: true, length: {maximum: 50}
  
  validates :course_department, :course_firstlevel, :teaching_object, :course_type, :campus, length:{maximum:50}
  validates :period, numericality: {greater_than: 0}
  validates :limit_num, numericality: {greater_than_or_equal_to: 0}
  validates :start_week,  numericality:{greater_than_or_equal_to: 1, less_than_or_equal_to: 20}
  validates :end_week, numericality:{greater_than_or_equal_to: :start_week, less_than_or_equal_to: 20}
  validates :class_room, format: {with: /\d{3}/ }, length: {maximum: 3}
  
end
