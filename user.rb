require_relative 'questions_databse.rb'
require_relative 'question.rb'
require_relative 'reply.rb'
require_relative 'question_follow.rb'
require_relative 'question_like.rb'

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
    user.map { |user| User.new(user) }.first
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
    user.map { |person| User.new(person) }.first
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

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(self.id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(self.id)
  end

  def average_karma
    karma = QuestionDatabase.instance.execute(<<-SQL, self.id)
      SELECT
        CAST(COUNT(question_likes.user_id) AS FLOAT) / COUNT(DISTINCT(questions.id)) AS average_karma
      FROM
        question_likes
      LEFT OUTER JOIN
        questions ON question_likes.question_id = questions.id
      WHERE
        questions.author_id = ?
      GROUP BY 
        questions.author_id
    SQL
    karma_hash = karma.first
    karma_hash["average_karma"] unless karma_hash.nil?
  end

  def save
    self.id.nil? ? insert : update
  end
  
  def insert
    QuestionDatabase.instance.execute(<<-SQL, @fname, @lname)
      INSERT INTO
        users(fname, lname)
      VALUES
        (?, ?)
    SQL
    @id = QuestionDatabase.instance.last_insert_row_id
  end

  def update
    QuestionDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
    UPDATE
      users
    SET
      fname = ?, lname = ?
    WHERE
      id = ?
    SQL
  end
end