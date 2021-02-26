require_relative 'questions_databse.rb'

class User
  attr_accessor :id, :fname, :lname
  
  def self.find_by_id(id)
   user = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        users.id = ?
    SQL
    User.new(user.first)
  end

  def self.find_by_name(name)
    first, last = name.split
    user = QuestionDatabase.instance.execute(<<-SQL, first, last)
      SELECT
        *
      FROM
        users
      WHERE
        users.fname = ? AND users.lname = ?
    SQL
    User.new(user.first)
  end
  
  def initialize(options)
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end
end