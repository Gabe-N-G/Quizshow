class CreateQuestionsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :category #<- stretch goal
      t.string :difficulty #<- stretch goal
      t.string :question_text
      t.string :correct_answer
      t.string :incorrect_answer_1
      t.string :incorrect_answer_2
      t.string :incorrect_answer_3
        #in the future different class for answers.
        #split incorrect to 3 different incorrects
      t.timestamps
    end
  end
end
