class Api::ContestsController < ApplicationController
  def show
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
