class CreatePlayerQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :player_questions do |t|
      t.boolean :correct_questions
      t.integer :total_questions
      t.integer :player_id
      t.integer :question_id

      t.timestamps
    end
      
  end
end
