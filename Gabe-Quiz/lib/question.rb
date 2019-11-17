class Question < ActiveRecord::Base
    has_many :player_questions
    has_many :players, through: :player_questions
end

