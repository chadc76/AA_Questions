require_relative 'question_database'
require_relative 'user'
require_relative 'question'
require_relative 'modelbase'

class QuestionFollow < ModelBase

  def self.followers_for_question_id(question_id)
    users = QuestionDatabase.execute(<<-SQL, question_id)
      SELECT
        users.id, users.fname, users.lname
      FROM
        question_follows
      JOIN
        users ON question_follows.user_id = users.id
      WHERE 
      question_follows.question_id = ?
    SQL

    users.map { |user| User.new(user) }
  end

  def self.followed_questions_for_user_id(user_id)
      questions = QuestionDatabase.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.title, questions.body, questions.author_id
      FROM
        question_follows
      JOIN
        questions ON question_follows.question_id = questions.id
      WHERE 
      question_follows.user_id = ?
    SQL

    questions.map { |question| Question.new(question) }
  end

  def self.most_followed_questions(n)
    question = QuestionDatabase.execute(<<-SQL, n)
      SELECT
        questions.id, questions.title, questions.body, questions.author_id
      FROM
        question_follows
      JOIN
        questions ON question_follows.question_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
      Count(questions.id) DESC
      LIMIT ?      
    SQL
    question.map { |q| Question.new(q) }
  end
end