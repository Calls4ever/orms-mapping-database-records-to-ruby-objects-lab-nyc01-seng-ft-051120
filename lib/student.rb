class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student=self.new()
    student.id=row[0]
    student.name=row[1]
    student.grade=row[2]
    student
    # create a new Student object given a row from the database
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql= <<-SQL
    select * from students
      SQL
      DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
      end

  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    DB[:conn].execute("select * from students where name = ?", name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_9
    DB[:conn].execute("select * from students where grade = 9").map do |row|
      self.new_from_db(row)
    end
  end
  
  def self.students_below_12th_grade
    DB[:conn].execute("select * from students where grade < 12").map do |row|
      self.new_from_db(row)
    end

  end

  def self.first_X_students_in_grade_10(x)
    DB[:conn].execute("select * from students where grade = 10 order by id limit ?",x).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    self.new_from_db(DB[:conn].execute("select * from students where grade=10 order by id asc limit 1")[0])
  end

  def self.all_students_in_grade_X(x)
    DB[:conn].execute("select * from students where grade =?",x).map do |row|
      self.new_from_db(row)
    end
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
