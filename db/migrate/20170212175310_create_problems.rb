class CreateProblems < ActiveRecord::Migration[5.0]
  def change
    create_table :problems do |t|
      t.references :contest, foreign_key: true
      t.string :name_ja,        null: false
      t.string :name_en,        null: false
      t.string :description_ja, null: false
      t.string :description_en, null: false
      t.integer :order,         null: false

      t.timestamps null: false
    end
  end
end
