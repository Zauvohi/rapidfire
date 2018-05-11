module Rapidfire
  class ConditionalsController < Rapidfire::ApplicationController
    if Rails::VERSION::MAJOR ==  5
      before_action :authenticate_administrator!
      before_action :find_survey!
      before_action :set_conditional!, only: %i[edit update destroy]
    else
      before_filter :authenticate_administrator!
      before_filter :find_survey!
      before_filter :set_conditional!, only: %i[edit update destroy]
    end

    def index
      @conditionals = @survey.conditionals
    end

    def new
      @conditional = Conditional.new(:survey => @survey)
    end

    def create
      @conditional = Conditional.new(conditional_params)
      add_questions_to_group
      @conditional.save
      save_and_redirect(:new)
    end

    def edit; end

    def update
      @conditional.attributes = conditional_params
      add_questions_to_group
      @conditional.valid? && @conditional.save
      save_and_redirect(:edit)
    end

    def destroy
      @conditional.destroy
      respond_to do |format|
        format.html { redirect_to index_location }
        format.js
      end
    end

    private

    def save_and_redirect(on_error_key)
      if @conditional.errors.empty?
        respond_to do |format|
          format.html { redirect_to index_location }
          format.js
        end
      else
        respond_to do |format|
          format.html { render on_error_key.to_sym }
          format.js
        end
      end
    end

    def find_survey!
      @survey = Survey.find_by(id: params[:survey_id])
    end

    def set_conditional!
      @conditional = Conditional.find_by(id: params[:id])
    end

    def index_location
      rapidfire.survey_conditionals_url(@survey)
    end

    def add_questions_to_group
      questions = params[:conditional][:question_group_attributes][:questions]
      @conditional.questions.delete_all
      questions.reject(&:empty?).each do | id |
        @conditional.questions << Question.find(id)
      end
    end

    def conditional_params
      params.require(:conditional)
            .permit(:survey_id, :question_id, :condition,
                    :value, :action)

    end
  end
end
