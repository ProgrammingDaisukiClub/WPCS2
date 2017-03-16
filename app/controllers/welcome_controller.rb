class WelcomeController < ApplicationController
  def index
    now = DateTime.now
    @top_contest = Contest.where('end_at >= ?', now)
    @all_contest = Contest.where('end_at < ?', now)
  end
end
