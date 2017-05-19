class Admin::DataSetsController < Admin::ControllerBase
  before_action :set_data_set, only: [:show, :edit, :update, :destroy]

  # GET /data_sets/1
  # GET /data_sets/1.json
  def show; end

  # GET /data_sets/new
  def new
    @data_set = DataSet.new(params.permit(:problem_id))
  end

  # GET /data_sets/1/edit
  def edit; end

  # POST /data_sets
  # POST /data_sets.json
  def create
    @data_set = DataSet.new(data_set_params)

    respond_to do |format|
      if @data_set.save
        format.html { redirect_to [:admin, @data_set], notice: 'Data set was successfully created.' }
        format.json { render :show, status: :created, location: [:admin, @data_set] }
      else
        format.html { render :new }
        format.json { render json: @data_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data_sets/1
  # PATCH/PUT /data_sets/1.json
  def update
    respond_to do |format|
      if @data_set.update(data_set_params)
        format.html { redirect_to [:admin, @data_set], notice: 'Data set was successfully updated.' }
        format.json { render :show, status: :ok, location: [:admin, @data_set] }
      else
        format.html { render :edit }
        format.json { render json: @data_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_sets/1
  # DELETE /data_sets/1.json
  def destroy
    contest = @data_set.contest
    @data_set.destroy
    respond_to do |format|
      format.html { redirect_to admin_contest_url(contest), notice: 'Data set was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_data_set
    @data_set = DataSet.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def data_set_params
    params.require(:data_set).permit(
      :problem_id, :label, :input, :output, :score, :accuracy, :order
    )
  end
end
