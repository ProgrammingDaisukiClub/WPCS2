class Admin::AwardsController < Admin::ControllerBase
  include Api::ContestsRankingJson

  before_action :set_contest

  # GET /awards
  # GET /awards.json
  def index
    # @contest = Contest.find_by_id(params[:contest_id])
    con = ActiveRecord::Base.connection
    @ranking_awards = calculate_ranking_awards.take(10)
    @fastac_awards = []
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def award_params
      params.require(:award).permit(:index)
    end

    def set_contest
      @contest = Contest.find_by_id(params[:contest_id])
    end

    def calculate_ranking_awards
      @users = @contest.users
      @problems = @contest.problems.includes(:data_sets).includes(:data_sets)
      @submissions = @contest.submissions
                           .where(created_at: @contest.start_at..@contest.end_at)
                           .order(:created_at).includes(:data_set, :problem, :user)

      table = create_ranking_table
      calculate_ranking_score(table)
      table_to_array(table)
    end

    # def ranking_query(contest_id)
    #   query = <<-QUERY
    #   SELECT
    #   users.id AS user_id,
    #   users.name AS user_name,  
    #   SUM(submissions.score)
    #   FROM submissions
    #   JOIN users ON submissions.user_id = users.id
    #   JOIN data_sets ON submissions.data_set_id = data_sets.id 
    #   JOIN problems ON data_sets.problem_id = problems.id 
    #   JOIN contests ON problems.contest_id = contests.id 
    #   WHERE submissions.created_at >= contests.start_at 
    #       AND submissions.created_at <= contests.end_at
    #       AND submissions.judge_status = 2
    #       AND contests.id = ?
    #       AND submissions.created_at = (
    #           SELECT MIN(created_at) FROM submissions
    #           WHERE users.id = submissions.user_id
    #           AND data_set_id = data_sets.id
    #           AND submissions.judge_status = 2
    #       )
    #   GROUP BY users.id 
    #   ORDER BY SUM(submissions.score) DESC
    #   LIMIT 50;  
    #   QUERY
    #   ActiveRecord::Base.send(
    #     :sanitize_sql_array,
    #     [query, contest_id])
    # end
end
