class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.string :question
      t.string :correct_answer
      t.string :option1
      t.string :option2
      t.string :option3
      t.string :difficulty
      t.string :category
    end
  end
end
