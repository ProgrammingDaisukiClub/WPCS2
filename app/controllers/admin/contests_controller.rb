class Admin::ContestsController < Admin::AdminControllerBase
  before_action :set_contest, only: [:show, :edit, :update, :destroy]

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

  # GET /contests/1/submissions
  def submissions
    data_set_ids = Contest.find_by_id(params[:id]).data_sets.pluck(:id)
    @submissions = Submission.where(data_set_id: data_set_ids)
  end

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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contest
    @contest = Contest.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contest_params
    params.require(:contest).permit(:description_en, :description_ja,
                                    :end_at, :name_en, :name_ja, :score_baseline, :start_at)
  end
end
