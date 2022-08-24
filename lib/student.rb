require_relative "../config/environment.rb"
# DB = {:conn => SQLite3::Database.new("db/students.db")}
class Student

  attr_accessor :id, :name, :grade

  def initialize(id=nil,name, grade)
      @id = id
      @name = name
      @grade = grade
  end

  # Method to create the table
  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL

    DB[:conn].execute(sql)
  end
  
  # Method to drop the table
  def self.drop_table
    sql = "DROP TABLE IF EXISTS students;"

    DB[:conn].execute(sql)
  end

  # Method to save records in a database table
  def save
    if self.id
      self.update
    else
      sql = <<-SQL
          INSERT INTO students (name, grade) VALUES(?, ?)
      SQL

      # insert dog into the dogs table
      DB[:conn].execute(sql, self.name, self.grade)

      # get the dof ID from the database and save it to a ruby instance
      self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
    # return the ruby instance
    self
  end

  # Create amd save instance
  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
  end

  # create object from db
  def self.new_from_db(row)
    self.new(id = row[0], name = row[1], grade = row[2])
  end

  #find an object by name from database
  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1;"

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  # update a record from the database
  def update 
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"

    DB[:conn].execute(sql, self.name, self.grade, id)
  end

end


moli = Student.new('Moli', 'A')
 moli.save

