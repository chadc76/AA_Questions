require_relative 'questions_databse.rb'

class Question
  attr_accessor :id, :title, :body, :author_id

  def self.find_by_id(id)
   question = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = ?
    SQL
    Question.new(question.first)
  end

  def self.find_by_author_id(author_id)
    questions = QuestionDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.author_id = ?
    SQL
    questions.map { |question| Question.new(question) }
  end

  def initialize(options)
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @author_id = options["author_id"]
  end
end