require_relative 'questions_databse.rb'

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
    question_like.map { |question_like| QuestionLike.new(question_like) }
  end

  def initialize(options)
    @id = options["id"]
    @user_id = options["user_id"]
    @question_id = options["question_id"]
end
