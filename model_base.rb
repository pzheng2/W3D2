require_relative 'QuestionsDatabase'
require_relative 'user'
require_relative 'question'
require_relative 'reply'
require_relative 'question_like'
require_relative 'question_follow'

require 'byebug'

class ModelBase

  attr_accessor :id

  def initialize(options = {})
    @id = options['id']
  end

  def self.all
    raise "not a table" if self == ModelBase
    results = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self::TABLE_NAME}
    SQL

    results.map { |result| Question.new(result) }

  end

  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self::TABLE_NAME}
      WHERE
        id = ?
    SQL

    results.map { |result| Question.new(result) }.first
  end


  def save
    if self.id.nil?
      i_vars = self.instance_variables
      params = i_vars.map { |ivar| self.instance_variable_get(ivar) }.pop
      column_names = params.join(',').gsub('@', ' ')

      QuestionsDatabase.instance.execute(<<-SQL, *params)
        INSERT INTO
          "#{self.table}(#{column_names})"
        VALUES
          "(#{('?,' * params.count).chomp(',')})"
      SQL

      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      update
    end

    nil
  end

  def update
    byebug
    i_vars = self.instance_variables
    params = i_vars.map { |ivar| self.instance_variable_get(ivar) || 'NULL'}
    column_names = i_vars.join(',').gsub('@', '')

    set_arr = []
    column_names.split(',').each_with_index do |name, index|
      set_arr << "#{name} = ?"
    end
    set_string = set_arr[0..-2].join(',').chomp(',')

    sql = <<-SQL
      UPDATE
       #{self.class::TABLE_NAME}
      SET
       #{set_string}
      WHERE
        id = ?
    SQL

    p sql

    QuestionsDatabase.instance.execute(sql, *params)
    nil
  end

end
