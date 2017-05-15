class AddStudentIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :student_id, :string, null: false, limit: 8, default: ''
  end
end
