module Rapidfire
  class Survey < ActiveRecord::Base
    has_many  :questions
    validates :name, :presence => true
    has_many :conditionals, dependent: :destroy

    if Rails::VERSION::MAJOR == 3
      attr_accessible :name, :introduction
    end

    def get_conditional(question)
      conditionals.includes(:question_group).detect { |conditional|
        conditional.questions.include?(question) }
    end

  end
end
