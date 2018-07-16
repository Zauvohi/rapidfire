module Rapidfire
  class Attempt < ActiveRecord::Base
    belongs_to :survey, inverse_of: :attempts
    belongs_to :user, polymorphic: true
    has_many   :answers, inverse_of: :attempt, autosave: true
    belongs_to :about_user, foreign_key: 'about_user_id', class_name: 'User'

    if Rails::VERSION::MAJOR == 3
      attr_accessible :survey, :user
    end
  end
end
