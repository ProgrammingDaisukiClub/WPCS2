class ContestsController < ApplicationController
  def show; end

  def ranking;
    render action: :show
  end
end
