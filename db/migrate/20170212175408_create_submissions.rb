class CreateSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :submissions do |t|
      t.references :user, foreign_key: true
      t.references :test_case, foreign_key: true
      t.text :answer, null: false
      t.text :code
      t.integer :language_id
      t.integer :judge_status_id, null: false

      t.timestamps null: false
    end
  end
end
