require_relative 'question_database'
require_relative 'user'
require_relative 'question'
require_relative 'modelbase'

class Reply < ModelBase
  attr_reader :id
  attr_accessor :body, :subject_question_id, :parent_reply_id, :user_id

  def self.find_by_user_id(user_id)
    replies = QuestionDatabase.execute(<<-SQL, user_id)
       SELECT
         *
       FROM
         replies
       WHERE
         replies.user_id = ?
     SQL
    replies.map { |reply| Reply.new(reply) }
  end

  def self.find_by_question_id(question_id)
    replies = QuestionDatabase.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.subject_question_id = ?
    SQL
    replies.map { |reply| Reply.new(reply) }
  end
  
  def initialize(options)
    @id, @body, @subject_question_id, @parent_reply_id, @user_id = 
      options.values_at(
        "id", "body", "subject_question_id", "parent_reply_id", "user_id")
  end

  def author
    User.find_by_id(self.user_id)
  end

  def question
    Question.find_by_id(self.subject_question_id)
  end

  def parent_reply
    Reply.find_by_id(self.parent_reply_id)
  end

  def child_replies
    replies = QuestionDatabase.execute(<<-SQL, self.id)
       SELECT
         *
       FROM
         replies
       WHERE
         replies.parent_reply_id = ?
     SQL
    replies.map { |reply| Reply.new(reply) }
  end
end