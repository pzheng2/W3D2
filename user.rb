require_relative 'model_base'


class User

  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
      SQL

    results.map { |result| User.new(result) }.first
  end

  def self.find_by_name(fname, lname)
    results = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ?
        AND lname = ?
    SQL

    results.map { |result| User.new(result) }
  end

  attr_accessor :id, :fname, :lname

  def initialize(options = {})
    @id = options["id"]
    @fname = options["fname"]
    @lname = options['lname']
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_user_id(id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(id)
  end

  def liked_questions
    QuestionFollow.liked_questions_for_user_id(id)
  end

  def average_karma
    results = QuestionsDatabase.instance.execute(<<-SQL, id)

      SELECT
        (CAST(COUNT(question_likes.id) AS FLOAT) / CAST(COUNT(questions.id) AS FLOAT)) AS avg
      FROM
        questions
      LEFT OUTER JOIN
        question_likes
      ON
        questions.id = question_likes.question_id
      WHERE
        questions.author_id = ?
    SQL

    results.first['avg']
  end

  def save
    if self.id.nil?
      params = [fname, lname]
      QuestionsDatabase.instance.execute(<<-SQL, *params)
        INSERT INTO
          users(fname, lname)
        VALUES
          (?, ?)
      SQL

      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      update
    end

    nil
  end

  def update
    params = [fname, lname, id]
    QuestionsDatabase.instance.execute(<<-SQL, *params)
      UPDATE users
      SET fname = ?, lname = ?
      WHERE id = ?
    SQL

    nil
  end

end
