# == Schema Information
#
# Table name: responses
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  answer_choice_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Response < ActiveRecord::Base
  validates :user_id, :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :author_can_not_respond_to_own_question

  belongs_to(
    :respondent,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
  )

  belongs_to(
    :answer_choice,
    class_name: 'AnswerChoice',
    foreign_key: :answer_choice_id,
    primary_key: :id
  )

  has_one(:question, through: :answer_choice, source: :question)

  def respondent_has_not_already_answered_question
    unless sibling_responses.empty?
      errors[:base] << "Cannot respond to the same question"
    end
  end

  def sibling_responses
    # unless self.id == nil
    #   question.responses.where('user_id = ?', self.user_id).where.not('responses.id = ?', self.id)
    # else
    #   question.responses.where('user_id = ?', self.user_id)
    # end

    sib_responses = Response
    .joins('JOIN answer_choices ON answer_choices.id = responses.answer_choice_id')
    .joins(<<-SQL)
      INNER JOIN (
        SELECT *
        FROM questions
        WHERE questions.id IN (
          SELECT
          answer_choices.question_id
          FROM
          answer_choices
          WHERE
          answer_choices.id = #{self.answer_choice_id}))
         AS the_question
          ON the_question.id = answer_choices.question_id
        SQL
    .where('responses.user_id = ?', self.user_id)
    unless self.id == nil
        sib_responses.where.not('responses.id = ?', self.id)
      else
        sib_responses
    end
  end

  def author_can_not_respond_to_own_question
    # if question.poll.author_id == self.user_id
    #   errors[:base] << "Cannot respond to own question"
    # end
    the_author_id = Poll
      .select('polls.author_id')
      .joins(:questions)
      .joins('JOIN answer_choices ON answer_choices.question_id = questions.id')
      .where('answer_choices.id = ?', self.answer_choice_id).first

      if the_author_id.author_id == self.user_id
        errors[:base] << "Cannot respond to own question"
      end
  end
end
