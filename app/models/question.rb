# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  text       :string           not null
#  pool_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Question < ActiveRecord::Base
  validates :text, presence: true, uniqueness: {scope: :poll_id}
  validates :poll_id, presence: true

  has_many(
    :answer_choices,
    class_name: 'AnswerChoice',
    foreign_key: :question_id,
    primary_key: :id,
    dependent: :destroy
  )

  belongs_to(
    :poll,
    class_name: 'Poll',
    foreign_key: :poll_id,
    primary_key: :id
  )

  has_many(:responses, through: :answer_choices, source: :responses)

  def results
    results = Hash.new(0)
    answer_choices
    .select("answer_choices.*, COUNT(responses.id) as response_count")
    .joins('LEFT JOIN responses ON answer_choices.id = responses.answer_choice_id')
    .group('answer_choices.id')
    .each do |answer_choice|
        results[answer_choice.text] = answer_choice.response_count
      end
    results
  end
end
