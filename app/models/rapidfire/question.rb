module Rapidfire
  class Question < ActiveRecord::Base
    belongs_to :survey, :inverse_of => :questions
    has_many   :answers
    has_many   :conditionals, dependent: :destroy
    has_many   :question_groups, through: :question_groups_questions, inverse_of: :questions
    has_many   :question_groups_questions, dependent: :destroy, inverse_of: :question

    default_scope { order(:position) }

    validates :question_text, :presence => true
    validates :survey, :presence => true, unless: :in_type
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

    def has_nested?
      false
    end

    def self.available_for_conditionals
      self.where(type: %w[Rapidfire::Questions::Checkbox
                          Rapidfire::Questions::Select
                          Rapidfire::Questions::Radio])
    end

    private

    def in_type
      %w[Rapidfire::Questions::Radio].include?(self.type)
    end
  end
end
