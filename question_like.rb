require_relative 'question_database'
require_relative 'user'
require_relative 'question'
require_relative 'modelbase'

class QuestionLike < ModelBase

  def self.likers_for_question_id(question_id)
    likers = QuestionDatabase.execute(<<-SQL, question_id)
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
   QuestionDatabase.get_first_value(<<-SQL, question_id)
      SELECT
        COUNT(question_likes.user_id) as likes
      FROM
        question_likes
      WHERE
        question_likes.question_id = ?
      GROUP BY
        question_likes.question_id
    SQL
  end

  def self.liked_questions_for_user_id(user_id)
    questions = QuestionDatabase.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes ON question_likes.question_id = questions.id
      WHERE
        question_likes.user_id = ?
    SQL

    questions.map { |question| Question.new(question) }
  end

  def self.most_liked_questions(n)
    liked = QuestionDatabase.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes ON question_likes.question_id = questions.id
      Group BY
        questions.id
      ORDER BY
        COUNT(questions.id) DESC
      LIMIT
        ?
    SQL

    liked.map { |question| Question.new(question) }
  end
end
