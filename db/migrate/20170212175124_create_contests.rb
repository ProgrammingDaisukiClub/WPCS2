class CreateContests < ActiveRecord::Migration[5.0]
  def change
    create_table :contests do |t|
      t.string :name_ja,        null: false
      t.string :name_en,        null: false
      t.string :description_ja, null: false
      t.string :description_en, null: false
      t.datetime :start_at,     null: false
      t.datetime :end_at,       null: false
      t.float :score_baseline,  null: false
      t.string :password,       null: false
      t.integer :status,        null: false # 0:outside, 1:inside

      t.timestamps null: false
    end
  end
end
