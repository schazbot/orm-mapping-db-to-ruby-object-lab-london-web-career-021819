class Student
  attr_accessor :id, :name, :grade
  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new  # self.new is the same as running Student.new
    new_student.id = row[0]
    new_student.name =  row[1]
    new_student.grade = row[2]
    new_student  # return the newly created instance
  end

    def self.find_by_name(name)
      query = <<-SQL
        SELECT *
        FROM students
        WHERE name = ?
        LIMIT 1
      SQL
      DB[:conn].execute(query, name).map do |row|
        self.new_from_db(row)
      end.first
    end

    def self.all
      query = <<-SQL
        SELECT *
        FROM students
        SQL
      DB[:conn].execute(query).map do |row|
        self.new_from_db(row)
      end
    end

    def self.all_students_in_grade_9
      query = <<-SQL
        SELECT *
        FROM students
        WHERE grade = '9'
      SQL
      DB[:conn].execute(query)
    end

    def self.all_students_in_grade_x(num)
      query = <<-SQL
        SELECT *
        FROM students
        WHERE grade = (num)
      SQL
      DB[:conn].execute(query)
    end

    def self.students_below_12th_grade
        query = <<-SQL
          SELECT *
          FROM students
          WHERE grade<12
        SQL
        DB[:conn].execute(query).map do |row|
          self.new_from_db(row)
      end
  end

    def self.first_student_in_grade_10
      query = <<-SQL
        SELECT *
        FROM students
        WHERE grade = '10'
      SQL
      DB[:conn].execute(query).map do |row|
        self.new_from_db(row)
      end.first
    end

  def save
    query = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(query, self.name, self.grade)
  end

  def self.create_table
    query = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL
    DB[:conn].execute(query)
  end

  def self.drop_table
    query = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(query)
  end

  def self.first_X_students_in_grade_10(number)
    query = <<-SQL
      SELECT *
      FROM students
      WHERE grade= 10
      LIMIT (?)
    SQL
  DB[:conn].execute(query,number)
end
def self.all_students_in_grade_X(grade)
  query = <<-SQL
  SELECT * FROM students
  WHERE grade = (?)
  SQL
  result = DB[:conn].execute(query,grade)
  result.map {|student| new_from_db(student)}
end
end
