class Admin::EditorialsController < Admin::ControllerBase
  before_action :set_editorial, only: %i[show edit update destroy]
  before_action :set_contest, only: %i[update create]

  # GET /editorials/1
  # GET /editorials/1.json
  def show; end

  # GET /editorials/new
  def new
    @editorial = Editorial.new(params.permit(:contest_id))
  end

  # GET /editorials/1/edit
  def edit; end

  # POST /editorials
  # POST /editorials.json
  def create
    @editorial = Editorial.new(editorial_params)

    respond_to do |format|
      if @editorial.save
        format.html { redirect_to admin_contest_path(@contest), notice: 'Editorial was successfully created.' }
        format.json { render :show, status: :created, location: admin_contest_path(@contest) }
      else
        format.html { render :new }
        format.json { render json: @editorial.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /editorials/1
  # PATCH/PUT /editorials/1.json
  def update
    @contest = Contest.find(params[:contest_id])

    respond_to do |format|
      if @editorial.update(editorial_params)
        format.html { redirect_to admin_contest_path(@contest), notice: 'Editorial was successfully updated.' }
        format.json { render :show, status: :ok, location: admin_contest_path(@contest) }
      else
        format.html { render :edit }
        format.json { render json: @editorial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /editorials/1
  # DELETE /editorials/1.json
  def destroy
    contest = @editorial.contest
    @editorial.destroy
    respond_to do |format|
      format.html { redirect_to admin_contest_url(contest), notice: 'Editorial was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_editorial
    @editorial = Editorial.find(params[:id])
  end

  def set_contest
    @contest = Contest.find(params[:contest_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def editorial_params
    params.require(:editorial).permit(
      :contest_id, :content
    )
  end
end
