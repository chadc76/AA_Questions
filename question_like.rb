require_relative 'questions_databse.rb'
require_relative 'question.rb'
require_relative 'user.rb'

class QuestionLike
  attr_accessor :id, :user_id, :question_id

  def self.find_by_id(id)
   question_like = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        question_likes.id = ?
    SQL
    question_like.map { |question_like| QuestionLike.new(question_like) }.first
  end

  def self.likers_for_question_id(question_id)
    likers = QuestionDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.fname, users.lname
      FROM
        question_likes
      JOIN
        users ON question_likes.user_id = users.id
      WHERE
        question_likes.question_id = ?
    SQL
    likers.map { |liker| User.new(liker) }
  end

  def self.num_likes_for_question_id(question_id)
    num = QuestionDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(question_likes.user_id) as likes
      FROM
        question_likes
      WHERE
        question_likes.question_id = ?
      GROUP BY
        question_likes.question_id
    SQL
    num.first["likes"]
  end

  def self.liked_questions_for_user_id(user_id)
    questions = QuestionDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.title, questions.body, questions.author_id
      FROM
        question_likes
      JOIN
        questions ON question_likes.question_id = questions.id
      WHERE
        question_likes.user_id = ?
    SQL
  end

  def initialize(options)
    @id = options["id"]
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end
end
