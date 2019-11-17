class Player < ActiveRecord::Base
    has_many :player_questions
    has_many :questions, through: :player_questions
end