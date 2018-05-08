module Rapidfire
  module Questions
    class RadioGrid < Question
      has_many :child_questions, class_name: 'Radio', foreign_key: 'parent_question_id'
      accepts_nested_attributes_for :child_questions, reject_if: :all_blank, allow_destroy: true

      def has_nested?
        true
      end

      def prepare_child_questions(params)
        child_questions_params = extract_params(params)
        params.delete(:child_questions)
        child_questions_params.each do |k, v|
          self.child_questions.build(
            question_text: v,
            answer_options: self.answer_options,
            parent_question: self,
          )
        end
      end

      def update_child_questions(params)
        child_questions_params = extract_params(params)
        updated_params = []
        child_questions_params.each do |k, v|
          updated_params << { id: k.to_s.gsub(/[^0-9]/, ''), question_text: v }
        end
        self.child_questions_attributes = updated_params
      end

      private

      def extract_params(params)
        params.reject { |k, v| v.empty? }
      end
    end
  end
end
