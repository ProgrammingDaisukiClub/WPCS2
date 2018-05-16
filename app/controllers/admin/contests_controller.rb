class Admin::ContestsController < Admin::ControllerBase
  before_action :set_contest, only: %i[show edit update destroy json_upload update_from_json]

  # GET /contests
  # GET /contests.json
  def index
    @contests = Contest.all
  end

  # GET /contests/1
  # GET /contests/1.json
  def show; end

  # GET /contests/new
  def new
    @contest = Contest.new
  end

  # GET /contests/1/edit
  def edit; end

  # POST /contests
  # POST /contests.json
  def create
    @contest = Contest.new(contest_params)

    respond_to do |format|
      if @contest.save
        format.html { redirect_to [:admin, @contest], notice: 'Contest was successfully created.' }
        format.json { render :show, status: :created, location: [:admin, @contest] }
      else
        format.html { render :new }
        format.json { render json: @contest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contests/1
  # PATCH/PUT /contests/1.json
  def update
    respond_to do |format|
      if @contest.update(contest_params)
        format.html { redirect_to [:admin, @contest], notice: 'Contest was successfully updated.' }
        format.json { render :show, status: :ok, location: [:admin, @contest] }
      else
        format.html { render :edit }
        format.json { render json: @contest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contests/1
  # DELETE /contests/1.json
  def destroy
    @contest.destroy
    respond_to do |format|
      format.html { redirect_to admin_contests_url, notice: 'Contest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /contests/1/json_upload
  def json_upload; end

  # PATCH /contests/1
  def update_from_json
    json_string = params.require(:contest).require(:file).tempfile.read
    json = JSON.parse(json_string, symbolize_names: true)

    Contest.transaction do
      @contest.update(
        name_ja: json[:contest_name] || @contest.name_ja,
        name_en: json[:contest_name] || @contest.name_en
      )
      @contest.problems.destroy_all
      json[:problems].each.with_index do |problem_json, i|
        problem = Problem.create(
          contest_id: @contest.id,
          name_ja: problem_json[:title],
          name_en: problem_json[:title],
          description_ja: problem_json[:statement],
          description_en: problem_json[:statement],
          order: i
        )
        problem_json[:data_sets].each.with_index do |data_set_json, j|
          DataSet.create(
            problem_id: problem.id,
            label: data_set_json[:label],
            input: data_set_json[:input],
            output: data_set_json[:output],
            score: data_set_json[:score],
            order: j
          )
        end
      end
    end

    redirect_to admin_contest_url(@contest), notice: 'Contest was successfully updated.'
  rescue StandardError => e
    @contest.errors[:base] << "Invalid JSON file was uploaded - #{e.message}"
    render :json_upload
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contest
    @contest = Contest.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contest_params
    params.require(:contest).permit(:description_en, :description_ja,
                                    :end_at, :name_en, :name_ja, :score_baseline,
                                    :start_at, :status, :password)
  end
end
