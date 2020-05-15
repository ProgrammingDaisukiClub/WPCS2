class Admin::AwardsController < Admin::ControllerBase
  include Api::ContestsRankingJson

  before_action :set_contest

  # GET /awards
  # GET /awards.json
  def index
    # @contest = Contest.find_by_id(params[:contest_id])
    @ranking_awards = calculate_ranking_awards.take(10)
    @already_awarded_user = @ranking_awards.map{ |item| item[:id] }
    @fastac_awards = calculate_fastac_candidates
    p @fastac_awards
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def award_params
      params.require(:award).permit(:index)
    end

    def set_contest
      @contest = Contest.find_by_id(params[:contest_id])
    end

    def calculate_fastac_candidates
      # @users = @contest.users
      # @problems = @contest.problems.includes(:data_sets).includes(:data_sets)
      # @submissions = @contest.submissions
      #                      .where(created_at: @contest.start_at..@contest.end_at)
      #                      .where(problems: {data_sets: {label: "Large"}})
      #                      .order(:created_at).includes(:data_set, :problem, :user)
      # fastac_awards = {}
      # @problems.map do |problem|
      # end

      response = {}
      con = ActiveRecord::Base.connection
      con.select_all(fastac_query(params[:contest_id])).to_hash.map do |v|
        if not response.has_key?(v["name_ja"]) and @already_awarded_user.exclude?(v["id"])
          response[v["name_ja"]] = {:name => v["name"], :id => v["id"], :min => v["min"]}
          @already_awarded_user.append(v["id"])
        end
      end
      response
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

  def fastac_query(contest_id)
    query = <<-QUERY
      SELECT
        users.id,
        users.name,
        problems.order,
        problems.name_ja,
        MIN(submissions.created_at)
      FROM submissions
      JOIN users ON submissions.user_id = users.id
      JOIN data_sets ON submissions.data_set_id = data_sets.id
      JOIN problems ON data_sets.problem_id = problems.id
      JOIN contests ON problems.contest_id = contests.id
      WHERE submissions.created_at >= contests.start_at
        AND submissions.created_at <= contests.end_at
        AND submissions.judge_status = 2
        AND contests.id = ?
        AND data_sets.label = 'Large'
        AND submissions.created_at = (
            SELECT MIN(created_at) FROM submissions
            WHERE users.id = submissions.user_id
            AND data_set_id = data_sets.id
            AND submissions.judge_status = 2
        )
      GROUP BY (problems.name_ja, problems.id, users.id, users.name)
      ORDER BY problems.order ASC, MIN(submissions.created_at) ASC;
    QUERY
    ActiveRecord::Base.send(
      :sanitize_sql_array,
      [query, contest_id])
  end
end
