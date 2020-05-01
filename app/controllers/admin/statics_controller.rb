class Admin::StaticsController < Admin::ControllerBase
  def index
    con = ActiveRecord::Base.connection
    @contest = Contest.find_by_id(params[:contest_id])
    @ranking = Submission.joins("JOIN users ON submissions.user_id = users.id")
        .joins("JOIN data_sets ON submissions.data_set_id = data_sets.id")
        .joins("JOIN problems ON data_sets.problem_id = problems.id")
        .joins("JOIN contests ON problems.contest_id = contests.id")
        .group("users.id")
        .order("SUM(submissions.score) DESC")
        .where(["submissions.created_at >= contests.start_at AND submissions.created_at <= contests.end_at AND submissions.judge_status = 2 AND contests.id = ? AND submissions.created_at = (SELECT MIN(created_at) FROM submissions WHERE users.id = submissions.user_id AND data_set_id = data_sets.id AND submissions.judge_status = 2)", 2])
        .select("users.name, SUM(submissions.score)").limit(10)
    puts @ranking
    p "hogehoge"
  end
end
