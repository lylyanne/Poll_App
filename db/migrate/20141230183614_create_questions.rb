class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :text, null: false
      t.integer :pool_id, null: false

      t.timestamps null: false
    end
    
    add_index :questions, [:pool_id, :text], unique: true
  end
end
