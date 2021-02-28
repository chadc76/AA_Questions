require_relative 'question_database'
require_relative 'question'
require_relative 'question_follow'
require_relative 'question_like'
require_relative 'reply'
require_relative 'modelbase'


class User < ModelBase
  attr_reader :id
  attr_accessor :fname, :lname
  
  def self.find_by_name(name)
    first, last = name.split
    user = QuestionDatabase.get_first_row(<<-SQL, first, last)
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
    @id, @fname, @lname = options.values_at("id", "fname", "lname")
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
    QuestionDatabase.get_first_value(<<-SQL, self.id)
      SELECT
        CAST(COUNT(question_likes.id) AS FLOAT) / 
          COUNT(DISTINCT(questions.id)) AS average_karma
      FROM
        question_likes
      LEFT OUTER JOIN
        questions ON question_likes.question_id = questions.id
      WHERE
        questions.author_id = ?
      GROUP BY 
        questions.author_id
    SQL
  end
end