require_relative 'questions_databse.rb'

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
    Reply.new(reply.first)
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
  
  def initialize(options)
    @id = options["id"]
    @body = options["body"]
    @subject_question_id = options["subject_question_id"]
    @parent_reply_id = options["parent_reply_id"]
    @user_id = options["user_id"]
  end
end