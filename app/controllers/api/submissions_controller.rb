class Api::SubmissionsController < ApplicationController
  def index
    render json: [
      {
        id: 1,
        correct: true,
        score: 82
      },
      {
        id: 2,
        correct: false
      }
    ]
  end

  def create
    if [true, false].sample
      render json: {
        id: 1,
        correct: true,
        score: 82
      }
    else
      render json: {
        id: 2,
        correct: false
      }
    end
  end
end
