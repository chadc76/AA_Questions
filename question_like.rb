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

  def initialize(options)
    @id = options["id"]
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end
end
