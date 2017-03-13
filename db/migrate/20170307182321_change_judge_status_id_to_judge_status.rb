class ChangeJudgeStatusIdToJudgeStatus < ActiveRecord::Migration[5.0]
  def change
    rename_column :submissions, :judge_status_id, :judge_status
  end
end
