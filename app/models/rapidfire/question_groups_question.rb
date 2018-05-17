module Rapidfire
  class QuestionGroupsQuestion < ActiveRecord::Base
    belongs_to :question_group, inverse_of: :question_groups_questions
    belongs_to :question, inverse_of: :question_groups_questions
  end
end
