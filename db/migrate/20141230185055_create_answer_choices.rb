class CreateAnswerChoices < ActiveRecord::Migration
  def change
    create_table :answer_choices do |t|
      t.string :text, null:false
      t.integer :question_id, null:false

      t.timestamps null: false
    end
    add_index :answer_choices, [:question_id, :text], unique: true
  end
end
