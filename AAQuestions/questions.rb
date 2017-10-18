require 'sqlite3'
require 'singleton'


class QuestionsDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Question
  attr_accessor :title, :body, :user_id

  def self.all
    #accesses questions database and creates a new questions instance for each row

  end

  def self.find_by_id(id)
    question = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    Question.new(question.first)
  end



  def self.find_by_author_id(user_id)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?

    SQL

    questions.map {|question| Question.new(question) }
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end


  def author
    name = QuestionsDBConnection.instance.execute(<<-SQL, @user_id)
      SELECT
        fname, lname
      FROM
        users
      WHERE
        id = ?
    SQL
    User.new(name.first)
  end





end





class User
  attr_accessor :fname, :lname


  def self.find_by_id(id)
    user = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    User.new(user.first)
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end


  def self.find_by_name(fname, lname)
    users = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname LIKE ? AND lname LIKE ?
    SQL

    users.map {|user| User.new(user)}
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end


end



class Reply


  attr_accessor :body, :parent_id, :question_id, :user_id

  def self.find_by_id(id)
    reply = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL

    Reply.new(reply.first)
  end

  def self.find_by_user_id(user_id)
    replies = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?

    SQL

    replies.map {|reply| Reply.new(reply) }
  end

  def self.find_by_question_id(question_id)
    replies = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?

    SQL

    replies.map {|reply| Reply.new(reply) }
  end



  def initialize(options)
    @id = options['id']
    @body = options['body']
    @parent_id = options['parent_id']
    @question_id = options['question_id']
    @user_id = options['user_id']

  end


end

class QuestionFollow


  attr_accessor :user_id, :question_id

  def self.find_by_id(id)
    follow = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL

    QuestionFollow.new(follow.first)
  end

  def self.most_followed_questions(n)
    follow = QuestionsDBConnection.instance.execute(<<-SQL, n)
      SELECT
        *
      FROM
        questions
      JOIN
        question_follows ON questions.id = question_follows.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*)
      LIMIT
        ?
    SQL
    follow.map {|question| Question.new(question)}
  end


  def self.followers_for_question_id(question_id)
    follow = QuestionsDBConnection.instance.execute(<<-SQL,question_id)
      SELECT
        *
      FROM
        users
      JOIN
        question_follows ON users.id = question_follows.user_id
      WHERE
        question_follows.question_id = ?
    SQL
    follow.map {|user| User.new(user)}
  end

  def self.followed_questions_for_user_id(user_id)
    followed_questions = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_follows ON questions.id = question_follows.question_id
      WHERE
        question_follows.user_id = ?

    SQL
    followed_questions.map {|question| Question.new(question)}

  end



  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']

  end
end

class QuestionLike
  attr_accessor :user_id, :question_id

  def self.find_by_id(id)
    likes = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL

    QuestionLike.new(likes.first)
  end



  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']

  end
end
