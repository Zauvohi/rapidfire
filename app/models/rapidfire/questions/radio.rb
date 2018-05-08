module Rapidfire
  module Questions
    class Radio < Select
      belongs_to :parent_question, class_name: 'RadioGrid', foreign_key: 'parent_question_id'
      validates :survey, presence: true, if: :validates_parent

      private

      def validates_parent
        parent_question.nil?
      end
    end
  end
end
