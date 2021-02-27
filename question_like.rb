require_relative 'questions_databse.rb'
require_relative 'modelbase.rb'

class QuestionLike < ModelBase
  attr_accessor :id, :user_id, :question_id

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
    return 0 if num.first.nil?
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

  def self.most_liked_questions(n)
    liked = QuestionDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.id, questions.title, questions.body, questions.author_id
      FROM
        question_likes
      JOIN
        questions ON question_likes.question_id = questions.id
      Group BY
        questions.id
      ORDER BY
        COUNT(questions.id) DESC
      LIMIT
        ?
    SQL

    liked.map { |question| Question.new(question) }
  end

  def initialize(options)
    @id = options["id"]
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end
end
