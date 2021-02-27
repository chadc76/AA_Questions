require_relative 'questions_databse.rb'
require_relative 'modelbase.rb'

class User < ModelBase
  attr_accessor :id, :fname, :lname
  
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
    user.nil? ? nil : User.new(user)
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
end