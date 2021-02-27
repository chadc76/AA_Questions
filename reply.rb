require_relative 'questions_databse.rb'
require_relative 'question.rb'
require_relative 'user.rb'

class Reply
  attr_accessor :id, :body, :subject_question_id, :parent_reply_id, :user_id

  def self.find_by_id(id)
   reply = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.id = ?
    SQL
    reply.map { |reply| Reply.new(reply) }.first
  end

  def self.find_by_user_id(user_id)
    replies = QuestionDatabase.instance.execute(<<-SQL, user_id)
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
    replies = QuestionDatabase.instance.execute(<<-SQL, question_id)
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
    @id = options["id"]
    @body = options["body"]
    @subject_question_id = options["subject_question_id"]
    @parent_reply_id = options["parent_reply_id"]
    @user_id = options["user_id"]
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
    replies = QuestionDatabase.instance.execute(<<-SQL, self.id)
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