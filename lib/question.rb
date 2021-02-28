require_relative 'question_database'
require_relative 'question_follow'
require_relative 'question_like'
require_relative 'user'
require_relative 'reply'
require_relative 'modelbase'

class Question < ModelBase
  attr_reader :id
  attr_accessor :title, :body, :author_id

  def self.find_by_author_id(author_id)
    questions = QuestionDatabase.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.author_id = ?
    SQL
    questions.map { |question| Question.new(question) }
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def initialize(options)
    @id, @title, @body, @author_id = 
      options.values_at("id", "title", "body", "author_id")
  end

  def author
    User.find_by_id(self.author_id)
  end

  def replies
    Reply.find_by_question_id(self.id)
  end

  def followers
    QuestionFollow.followers_for_question_id(self.id)
  end

  def likers
    QuestionLike.likers_for_question_id(self.id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(self.id)
  end
end