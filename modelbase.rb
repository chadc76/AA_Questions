require 'active_support/inflector'

class ModelBase

  def self.table
    self.to_s.tableize
  end

  def self.find_by_id(id)
    object = QuestionDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        #{table}
      WHERE
        id = :id
    SQL
    object.nil? ? nil : self.new(object)
  end

  def self.all
    objects = QuestionDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table}
    SQL
    parse_all(data)
  end

  def self.where(options)
    if options.is_a?(Hash)
      where_line = options.keys.map { |key| "#{key} = ?"}.join(", ")
      vals = options.values
    else
      where_line = options
      vals = []
    end

    objects = QuestionDatabase.instance.execute(<<-SQL, *vals)
      SELECT
        *
      FROM
        #{self.table}
      WHERE
        #{where_line}
    SQL

    parse_all(objects)
  end

  def attrs
    Hash[instance_variables.map do |name|
      [name.to_s[1..-1], instance_variable_get(name)]
    end]
  end

  def save
    self.id ? update : create
  end

  def create
    raise 'already saved!' unless id.nil?

    instance_attrs = attrs
    instance_attrs.delete("id")
    col_names = instance_attrs.keys.join(", ")
    question_marks = (["?"] * instance_attrs.count).join(", ")
    values = instance_attrs.values

    QuestionDatabase.instance.execute(<<-SQL, *values)
      INSERT INTO
        #{self.class.table} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    @id = QuestionDatabase.instance.last_insert_row_id
  end

  def update
    raise 'must create before updating' if id.nil?

    instance_attrs = attrs
    instance_attrs.delete("id")
    set_line = instance_attrs.keys.map { |attr| "#{attr} = ?"}.join(", ")
    values = instance_attrs.values

    QuestionDatabase.instance.execute(<<-SQL, *values, id)
      UPDATE
        #{self.class.table}
      SET
        #{set_line}
      WHERE
       id = ?
    SQL

    self
  end

  def self.parse_all(data)
    data.map { |attrs| self.new(attrs) }
  end
end