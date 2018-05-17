module Rapidfire
  class QuestionsController < Rapidfire::ApplicationController
    if Rails::VERSION::MAJOR ==  5
      before_action :authenticate_administrator!
      before_action :find_survey!
      before_action :find_question!, :only => [:edit, :update, :destroy,
                                               :values, :conditional]
    else
      before_filter :authenticate_administrator!
      before_filter :find_survey!
      before_filter :find_question!, :only => [:edit, :update, :destroy,
                                               :values, :conditional]
    end

    def index
      @questions = @survey.questions
    end

    def new
      @question_form = QuestionForm.new(:survey => @survey)
    end

    def create
      form_params = question_params.merge(:survey => @survey)

      save_and_redirect(form_params, :new)
    end

    def edit
      @question_form = QuestionForm.new(:question => @question)
      @child_questions = @question.child_questions if @question.has_nested?
    end

    def update
      form_params = question_params.merge(:question => @question)
      save_and_redirect(form_params, :edit)
    end

    def destroy
      @question.destroy
      respond_to do |format|
        format.html { redirect_to index_location }
        format.js
      end
    end

    def values
      return render json: {message:'This Question not contains any options',
                           status: 400 } unless @question.answer_options?

      render json: {values: @question.options, status: 200 }
    end

    def conditional
      return render json: {message:'This Question not contains any conditional',
                           status: 400 } unless @question.conditionals

      render json: @question.conditionals
    end

    private

    def save_and_redirect(params, on_error_key)
      @question_form = QuestionForm.new(params)
      @question_form.save

      if @question_form.errors.empty?
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
      @survey = Survey.find(params[:survey_id])
    end

    def find_question!
      @question = @survey.questions.find(params[:id])
    end

    def index_location
      rapidfire.survey_questions_url(@survey)
    end

    def question_params
      if Rails::VERSION::MAJOR == 4 || Rails::VERSION::MAJOR == 5
        params.require(:question).permit!
      else
        params[:question]
      end
    end
  end
end
