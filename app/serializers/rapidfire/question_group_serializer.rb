module Rapidfire
  class QuestionGroupSerializer < ActiveModel::Serializer
    attributes :id, :question_ids
  end
end
