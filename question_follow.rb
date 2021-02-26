require_relative 'questions_databse.rb'

class QuestionsFollow
  attr_accessor :id, :user_id, :question_id

  def self.find_by_id(id)
   question_follow = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        question_follows.id = ?
    SQL
    QuestionsFollow.new(question_follow.first)
  end

  def initialize(options)
    @id = options["id"]
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end
end