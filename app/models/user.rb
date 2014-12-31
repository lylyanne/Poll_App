# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  user_name  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  validates :user_name, uniqueness: true, presence: true

  has_many(
    :authored_polls,
    class_name: 'Poll',
    foreign_key: :author_id,
    primary_key: :id,
    dependent: :destroy
  )

  has_many(
    :responses,
    class_name: 'Response',
    foreign_key: :user_id,
    primary_key: :id
  )

  def completed_polls
    Poll.select("polls.*, COUNT(distinct  questions.id) as question_count")
    .joins(:questions)
    .joins('JOIN answer_choices ON questions.id = answer_choices.question_id' )
    .joins(<<-SQL)
      LEFT JOIN (
        SELECT *
        FROM responses
        WHERE responses.user_id = #{self.id}
      ) as user_responses
      ON user_responses.answer_choice_id = answer_choices.id
      SQL
    .group('polls.id')
    .having('COUNT(user_responses.id) = COUNT( distinct questions.id)')
  end
end
