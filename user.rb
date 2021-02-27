require_relative 'questions_databse.rb'
require_relative 'question.rb'
require_relative 'reply.rb'

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
    user.map { |user| User.new(user) }
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
    user.map { |person| User.new(person) }
  end
  
  def initialize(options)
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end

  def authored_questions
    Question.find_by_author_id(self.id)
  end

  def authored_replies
    Reply.find_by_user_id(self.id)
  end
end