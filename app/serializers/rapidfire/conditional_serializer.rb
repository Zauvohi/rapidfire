module Rapidfire
  class ConditionalSerializer < ActiveModel::Serializer
    attributes :id, :question_id, :condition,:value, :action
    has_one :question_group
  end
end
