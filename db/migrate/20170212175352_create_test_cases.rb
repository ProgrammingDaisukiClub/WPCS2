class CreateTestCases < ActiveRecord::Migration[5.0]
  def change
    create_table :test_cases do |t|
      t.references :problem, foreign_key: true
      t.string :case_name
      t.text :input,       null: false
      t.text :output,      null: false
      t.integer :score,    null: false
      t.integer :accuracy, null: false, default: 0

      t.timestamps null: false
    end
  end
end
