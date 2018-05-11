module Rapidfire
  class Conditional < ActiveRecord::Base

    belongs_to :question, inverse_of: :conditionals
    has_one :question_group, dependent: :destroy, inverse_of: :conditional

    belongs_to :survey, inverse_of: :conditionals

    accepts_nested_attributes_for :question_group, allow_destroy: true

    validates :question, :condition,
              :value, :action, presence: true
    before_validation :contains_questions

    delegate :questions, to: :question_group

    enum condition: [:is, :is_not, :is_empty, :is_not_empty]
    enum action: [:hide, :show]

    after_initialize do
      build_question_group unless question_group
    end

    private

    def contains_questions
      errors.add(:base,'Question(s)  can\'t be blank ') if question_group.questions.empty?
    end

  end
end
