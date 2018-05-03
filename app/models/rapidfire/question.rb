module Rapidfire
  class Question < ActiveRecord::Base
    belongs_to :survey, :inverse_of => :questions
    has_many   :answers
    belongs_to :parent_question, class_name: 'Question', foreign_key: 'parent_question_id'
    has_many :child_questions, class_name: 'Question', foreign_key: 'child_question_id'
    accepts_nested_attributes_for :child_quesitons, reject_if: :all_blank, allow_destroy: true

    default_scope { order(:position) }

    validates :survey, :question_text, :presence => true
    serialize :validation_rules

    if Rails::VERSION::MAJOR == 3
      attr_accessible :survey, :question_text, :position, :default_text, :placeholder, :validation_rules, :answer_options
    end

    def self.inherited(child)
      child.instance_eval do
        def model_name
          Question.model_name
        end
      end

      super
    end

    def rules
      validation_rules || {}
    end

    # answer will delegate its validation to question, and question
    # will inturn add validations on answer on the fly!
    def validate_answer(answer)
      if rules[:presence] == "1"
        answer.validates_presence_of :answer_text
      end

      if rules[:minimum].present? || rules[:maximum].present?
        min_max = { minimum: rules[:minimum].to_i }
        min_max[:maximum] = rules[:maximum].to_i if rules[:maximum].present?

        answer.validates_length_of :answer_text, min_max
      end
    end
  end
end
