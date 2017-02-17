class CreateContestRegistrations < ActiveRecord::Migration[5.0]
  def change
    create_table :contest_registrations do |t|
      t.references :user, foreign_key: true
      t.references :contest, foreign_key: true

      t.timestamps null: false
    end
  end
end
