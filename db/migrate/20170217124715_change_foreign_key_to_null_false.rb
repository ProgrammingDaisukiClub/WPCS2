class ChangeForeignKeyToNullFalse < ActiveRecord::Migration[5.0]
  def up
    change_column :problems,    :contest_id,  :integer, null: false
    change_column :data_sets,   :problem_id,  :integer, null: false
    change_column :submissions, :user_id,     :integer, null: false
    change_column :submissions, :data_set_id, :integer, null: false
  end

  def down
    change_column :problems,    :contest_id,  :integer, null: true
    change_column :data_sets,   :problem_id,  :integer, null: true
    change_column :submissions, :user_id,     :integer, null: true
    change_column :submissions, :data_set_id, :integer, null: true
  end
end
