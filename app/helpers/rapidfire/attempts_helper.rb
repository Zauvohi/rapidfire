module Rapidfire
  module AttemptsHelper
    def set_attributes(question)
      attributes = "data-question=#{question.id} class=fn-question-attempt "
      conditional = question.survey.get_conditional(question)
      attributes += conditional && conditional.action.include?('show') ? 'style=display:none' : ''
      attributes
    end
  end
end
