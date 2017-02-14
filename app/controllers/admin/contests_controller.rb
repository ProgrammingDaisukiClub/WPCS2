class Admin::ContestsController < ApplicationController
  before_action :set_admin_contest, only: [:show, :edit, :update, :destroy]

  # GET /admin/contests
  # GET /admin/contests.json
  def index
    @admin_contests = Admin::Contest.all
  end

  # GET /admin/contests/1
  # GET /admin/contests/1.json
  def show
  end

  # GET /admin/contests/new
  def new
    @admin_contest = Admin::Contest.new
  end

  # GET /admin/contests/1/edit
  def edit
  end

  # POST /admin/contests
  # POST /admin/contests.json
  def create
    @admin_contest = Admin::Contest.new(admin_contest_params)

    respond_to do |format|
      if @admin_contest.save
        format.html { redirect_to @admin_contest, notice: 'Contest was successfully created.' }
        format.json { render :show, status: :created, location: @admin_contest }
      else
        format.html { render :new }
        format.json { render json: @admin_contest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/contests/1
  # PATCH/PUT /admin/contests/1.json
  def update
    respond_to do |format|
      if @admin_contest.update(admin_contest_params)
        format.html { redirect_to @admin_contest, notice: 'Contest was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_contest }
      else
        format.html { render :edit }
        format.json { render json: @admin_contest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/contests/1
  # DELETE /admin/contests/1.json
  def destroy
    @admin_contest.destroy
    respond_to do |format|
      format.html { redirect_to admin_contests_url, notice: 'Contest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_contest
      @admin_contest = Admin::Contest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_contest_params
      params.require(:admin_contest).permit(:description_en, :description_ja, :end_at, :name_en, :name_ja, :score_baseline, :start_at)
    end
end
