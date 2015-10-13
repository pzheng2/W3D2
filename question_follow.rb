require_relative 'model_base'

class QuestionFollow

  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_follows
        ON users.id = question_follows.user_id
      WHERE
        question_follows.question_id = ?
    SQL

    results.map { |result| User.new(result) }
  end

  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_follows
        ON questions.id = question_follows.question_id
      WHERE
        question_follows.user_id = ?
    SQL

    results.map { |result| User.new(result) }
  end

  def self.most_followed_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_follows
      ON
        questions.id = question_follows.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(questions.id) DESC
      LIMIT
        ?
    SQL

    results.map { |result| Question.new(result) }

  end

  attr_accessor :question_id, :user_id

  def initialize(options = {})
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

end
