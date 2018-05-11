module Rapidfire
  class QuestionGroup < ActiveRecord::Base
    belongs_to :conditional

    has_many :questions, through: :question_groups_questions,
                         inverse_of: :question_groups
    has_many :question_groups_questions, dependent: :destroy,
                                         inverse_of: :question_group
  end
end
