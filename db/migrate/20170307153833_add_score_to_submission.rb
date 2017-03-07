class AddScoreToSubmission < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :score, :integer
  end
end
