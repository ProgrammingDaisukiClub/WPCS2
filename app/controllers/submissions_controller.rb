class SubmissionsController < ApplicationController
  def index
    render template: 'contests/show'
  end
end
