class RenameTestCasesToDataSets < ActiveRecord::Migration[5.0]
  def change
    rename_table :test_cases, :data_sets
    rename_column :submissions, :test_case_id, :data_set_id
    rename_column :data_sets, :case_name, :label
  end
end
