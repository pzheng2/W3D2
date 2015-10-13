require_relative 'model_base'


class Reply

  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
      SQL

    results.map { |result| Reply.new(result) }.first
  end

  def self.find_by_user_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
      SQL

    results.map { |result| Reply.new(result) }
  end

  def self.find_by_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    results.empty? ? nil : results.map { |result| Reply.new(result) }
  end

  attr_accessor :id, :question_id, :parent_id, :user_id, :body

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']
  end

  def author
    User.find_by_id(user_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def parent_reply
    Reply.find_by_id(parent_id)
  end

  def child_replies
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end

  def save
    if self.id.nil?

      params = [question_id, parent_id, user_id, body]
      QuestionsDatabase.instance.execute(<<-SQL, *params)
        INSERT INTO
          replies(question_id, parent_id, user_id, body)
        VALUES
          (?, ?, ?, ?)
      SQL

      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      update
    end

    nil
  end

  def update
    params = [question_id, parent_id, user_id, body, id]
    QuestionsDatabase.instance.execute(<<-SQL, *params)
      UPDATE replies
      SET question_id = ?, parent_id = ?, user_id = ?, body = ?
      WHERE id = ?
    SQL

    nil
  end

end
