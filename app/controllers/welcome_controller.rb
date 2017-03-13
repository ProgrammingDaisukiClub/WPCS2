class WelcomeController < ApplicationController
  def index
    @top_contest = Contest.limit(2).map do |contest|
      contest.name_and_description(I18n.locale)
    end
    @all_contest = Contest.all.map do |contest|
      contest.name_and_description(I18n.locale)
    end
  end
end
