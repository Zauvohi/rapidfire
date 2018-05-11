module Rapidfire
    module ConditionalsHelper
      def collection_parent_questions(default = nil)
        options_from_collection_for_select(
          @survey.questions.available_for_conditionals,
          :id,
          :question_text,
          selected: default)
      end

      def collection_conditions(default = nil)
        options_for_select(
          Conditional.conditions
                     .keys
                     .collect{|m| [m.titleize, m]},
          selected: default)
      end

      def collection_values
        return {} if @conditional.new_record? || @conditional.question.blank?
        options = @conditional.question.options
        options_for_select(
          options.collect{|m| [m, m]},
          selected: @conditional.value)
      end

      def collection_actions(default = nil)
        options_for_select(
          Conditional.actions
                     .keys
                     .collect{|m| [m.titleize, m]},
          selected: default)
      end

      def collection_questions(default = nil)
        options_from_collection_for_select(
          @survey.questions,
          :id,
          :question_text,
          selected: default)
      end
    end
  end
