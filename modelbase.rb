require 'active_support/inflector'

class ModelBase
  def self.find_by_id(id)
    object = QuestionDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      #{self.name.tableize}
    WHERE
      #{self.name.tableize}.id = ?
  SQL
  object.map { |object| self.name.constantize.new(object) }.first
  end

  def self.all
    objects = QuestionDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.name.tableize}
    SQL
    objects.map { |object| self.name.constantize.new(object) }
  end
end