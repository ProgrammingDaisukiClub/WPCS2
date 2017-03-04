class Api::ContestsController < ApplicationController
  def show
    unless (contest = Contest.find_by_id(params[:id]))
      render(json: {}, status: :not_found)
      return
    end

    json_without_problems = contest.get_without_problems(params[:lang])

    unless signed_in?
      json_without_problems = json_without_problems.merge(joined: false)
      if contest.ended?
        json_with_problems = json_without_problems.merge(contest.get_problems(params[:lang]))
        render(json: json_with_problems, status: :ok)
        return
      else
        render(json: json_without_problems, status: :ok)
        return
      end
    end

    is_user_registered = contest.registered_by(current_user)
    json_without_problems = json_without_problems.merge(joined: is_user_registered)

    if (!contest.ended? && !is_user_registered) || (!contest.started? && is_user_registered)
      render(json: json_without_problems, status: :ok)
      return
    end

    if (contest.during? && is_user_registered) || contest.ended?
      json_with_problems = json_without_problems.merge(contest.get_problems(params[:lang]))
      render(json: json_with_problems, status: :ok)
      return
    end

    render json: {
      name: 'コンテスト名',
      description: 'コンテスト詳細説明',
      start_at: DateTime.now,
      end_at: DateTime.now.tomorrow,
      joined: false,
      problems: [
        {
          id: 1,
          name: '問題名1',
          description: '問題詳細2',
          data_sets: [
            {
              id: 1,
              label: 'Small',
              max_score: 100
            },
            {
              id: 2,
              label: 'Large',
              max_score: 200
            }
          ]
        },
        {
          id: 2,
          name: '問題名2',
          description: '問題詳細2',
          data_sets: [
            id: 1,
            label: 'Medium',
            max_score: 150
          ]
        }
      ]
    }
  end

  def entry
    unless contest = Contest.find_by_id(params[:id])
      render(json: {}, status: 404)
      return
    end

    if !signed_in? || contest.ended?
      render(json: {}, status: 403)
      return
    end
    
    if contest.registered_by(current_user)
      render(json: {}, status: 409)
      return
    end

    if contest.register(user)
      render(json: {}, status: 201)
      return 
    end
    
    render json: {}
  end

  def ranking
    render json: {
      users: [
        id: 1,
        name: 'ユーザー名',
        problems: [
          {
            id: 1,
            data_sets: [
              { id: 1, label: 'small', solved_at: DateTime.now, score: 85 },
              { id: 2, label: 'large' }
            ]
          },
          {
            id: 2,
            data_sets: [
              { id: 3, label: 'small', solved_at: DateTime.now.tomorrow, score: 97 },
              { id: 4, label: 'small', solved_at: DateTime.now.yesterday, score: 63 }
            ]
          }
        ]
      ]
    }
  end
end
