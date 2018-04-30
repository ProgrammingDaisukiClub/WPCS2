require 'rails_helper'

RSpec.describe Api::ContestsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before do
    sign_in(user) if user
  end

  let(:params) do
    {
      id: contest.present? ? contest.id : Contest.pluck(:id).push(0).max.next
    }.tap do |params|
      params.merge(lang: lang) if lang != 'ja'
    end
  end

  describe 'GET /api/contests/:id/status' do
    before do
      get :status, params: params
    end

    let(:user) { create(:user) }

    %w[ja en].each do |language|
      let(:lang) { language }

      context '開催していないコンテスト' do
        context 'コンテストがオープンの時' do
          let(:contest) do
            create(:contest_preparing_open)
          end

          it '200を返却する' do
            expect(response.status).to eq 200
          end

          context 'パラメーターが妥当である時' do
            let(:expect_response) do
              {
                'status' => 'outside'
              }
            end

            it '妥当なレスポンスを返却する' do
              expect(JSON.parse(response.body)).to eq expect_response
            end
          end
        end

        context 'コンテストがクローズドの時' do
          let(:contest) do
            create(:contest_preparing_closed)
          end

          it '200を返却する' do
            expect(response.status).to eq 200
          end

          context 'パラメーターが妥当である時' do
            let(:expect_response) do
              {
                'status' => 'inside'
              }
            end

            it '妥当なレスポンスを返却する' do
              expect(JSON.parse(response.body)).to eq expect_response
            end
          end
        end
      end

      context '開催中のコンテスト' do
        context 'コンテストがオープンの時' do
          let(:contest) do
            create(:contest_preparing_open)
          end

          it '200を返却する' do
            expect(response.status).to eq 200
          end

          context 'パラメーターが妥当である時' do
            let(:expect_response) do
              {
                'status' => 'outside'
              }
            end

            it '妥当なレスポンスを返却する' do
              expect(JSON.parse(response.body)).to eq expect_response
            end
          end
        end

        context 'コンテストがクローズドの時' do
          let(:contest) do
            create(:contest_preparing_closed)
          end

          it '200を返却する' do
            expect(response.status).to eq 200
          end

          context 'パラメーターが妥当である時' do
            let(:expect_response) do
              {
                'status' => 'inside'
              }
            end

            it '妥当なレスポンスを返却する' do
              expect(JSON.parse(response.body)).to eq expect_response
            end
          end
        end
      end

      context '終了したコンテスト' do
        context 'コンテストがオープンの時' do
          let(:contest) do
            create(:contest_preparing_open)
          end

          it '200を返却する' do
            expect(response.status).to eq 200
          end

          context 'パラメーターが妥当である時' do
            let(:expect_response) do
              {
                'status' => 'outside'
              }
            end

            it '妥当なレスポンスを返却する' do
              expect(JSON.parse(response.body)).to eq expect_response
            end
          end
        end

        context 'コンテストがクローズドの時' do
          let(:contest) do
            create(:contest_preparing_closed)
          end

          it '200を返却する' do
            expect(response.status).to eq 200
          end

          context 'パラメーターが妥当である時' do
            let(:expect_response) do
              {
                'status' => 'inside'
              }
            end

            it '妥当なレスポンスを返却する' do
              expect(JSON.parse(response.body)).to eq expect_response
            end
          end
        end
      end
    end
  end

  describe 'POST /api/contests/:id/validation' do
    before do
      params[:password] = 'password'
      post :validation, params: params
    end

    let(:user) { create(:user) }

    %w[ja en].each do |language|
      let(:lang) { language }

      context '開催していないコンテスト' do
        context 'コンテストがオープンの時' do
          let(:contest) do
            create(:contest_preparing_open)
          end

          it '200を返却する' do
            expect(response.status).to eq 200
          end

          context '妥当なパスワードを入力した時' do
            let(:expect_response) do
              {
                'result' => 'failed',
                'message' => 'this api is not supported when status == 0 contest'
              }
            end

            it '妥当なレスポンスである' do
              expect(JSON.parse(response.body)).to eq expect_response
            end
          end
        end

        context 'コンテストがクローズドの時' do
          let(:contest) do
            create(:contest_preparing_closed)
          end

          it '200を返却する' do
            expect(response.status).to eq 200
          end

          context '妥当なパスワードを入力した時' do
            let(:expect_response) do
              {
                'result' => 'ok'
              }
            end

            it '妥当なレスポンスである' do
              expect(JSON.parse(response.body)).to eq expect_response
            end
          end
        end
      end

      context '開催中のコンテスト' do
        context 'コンテストがオープンの時' do
          let(:contest) do
            create(:contest_preparing_open)
          end

          it '200を返却する' do
            expect(response.status).to eq 200
          end
        end

        context 'コンテストがクローズドの時' do
          let(:contest) do
            create(:contest_preparing_closed)
          end

          it '200を返却する' do
            expect(response.status).to eq 200
          end
        end
      end

      context '終了したコンテスト' do
        context 'コンテストがオープンの時' do
          let(:contest) do
            create(:contest_preparing_open)
          end

          it '200を返却する' do
            post :validation, params: params
            expect(response.status).to eq 200
          end

          context '妥当なパスワードを入力した時' do
            let(:expect_response) do
              {
                'result' => 'failed',
                'message' => 'this api is not supported when status == 0 contest'
              }
            end

            it '妥当なレスポンスである' do
              expect(JSON.parse(response.body)).to eq expect_response
            end
          end
        end

        context 'コンテストがクローズドの時' do
          let(:contest) do
            create(:contest_preparing_closed)
          end

          it '200を返却する' do
            expect(response.status).to eq 200
          end

          context '妥当なパスワードを入力した時' do
            let(:expect_response) do
              {
                'result' => 'ok'
              }
            end

            it '妥当なレスポンスである' do
              expect(JSON.parse(response.body)).to eq expect_response
            end
          end
        end
      end
    end
  end

  describe 'GET /api/contents/:id' do
    before do
      get :show, params: params
    end

    let(:json_without_problems) do
      {
        id: contest.id,
        name: params[:lang] == 'en' ? contest.name_en : contest.name_ja,
        description: params[:lang] == 'en' ? contest.description_en : contest.description_ja,
        start_at: JSON.parse(contest.start_at.to_json),
        end_at: JSON.parse(contest.end_at.to_json),
        baseline: contest.score_baseline,
        current_user_id: user.try(:id),
        admin_role: user.try(:admin_role).present?,
        joined: user.present? && ContestRegistration.find_by(user_id: user.id).present?
      }
    end

    let(:json_with_problems) do
      json_without_problems.merge(
        problems: contest.problems.order(order: :asc).map do |problem|
          {
            id: problem.id,
            name: params[:lang] == 'en' ? problem.name_en : problem.name_ja,
            description: params[:lang] == 'en' ? problem.description_en : problem.description_ja,
            data_sets: problem.data_sets.order(order: :asc).map do |data_set|
              {
                id: data_set.id,
                label: data_set.label,
                max_score: data_set.score,
                correct: data_set.solved_by?(user),
                score: data_set.user_score(user)
              }
            end
          }
        end
      )
    end

    let(:json_with_problems_and_editorial) do
      json_with_problems.merge(
        editorial: contest.editorial
      )
    end

    shared_examples 'json without problems' do
      it 'return json without problems' do
        get :show, params: params
        expect(JSON.parse(response.body, symbolize_names: true)).to eq json_without_problems
      end
    end

    shared_examples 'json with problems' do
      it 'return json with problems' do
        get :show, params: params
        expect(JSON.parse(response.body, symbolize_names: true)).to eq json_with_problems
      end
    end

    shared_examples 'json with problems and editorial' do
      it 'return json with problems and editorial' do
        get :show, params: params
        expect(JSON.parse(response.body, symbolize_names: true)).to eq json_with_problems_and_editorial
      end
    end

    %w[ja en].each do |language|
      let(:lang) { language }

      describe 'Case 1: contest NOT found' do
        context 'contest NOT existed' do
          let(:contest) { nil }

          context 'NOT logged in' do
            let(:user) { nil }
            it 'returns 404 Not Found' do
              expect(response).to have_http_status 404
            end
          end

          context 'logged in' do
            let(:user)    { create(:user) }
            it 'returns 404 Not Found' do
              expect(response).to have_http_status 404
            end
          end
        end
      end

      describe 'Case 2: contest existed but problems are hidden' do
        context 'when the user does not login before the contest starts,' do
          let(:contest) { create(:contest_preparing) }
          let(:user)    { nil }

          it 'returns 200 OK' do
            expect(response).to have_http_status 200
          end
          it_behaves_like 'json without problems'
        end

        context 'when the user does not login during the contest,' do
          let(:contest) { create(:contest_holding) }
          let(:user)    { nil }

          it 'returns 200 OK' do
            expect(response).to have_http_status 200
          end
          it_behaves_like 'json without problems'
        end

        context 'when the user does not joined before the contest starts,' do
          let(:contest) { create(:contest_preparing) }
          let(:user)    { create(:user) }

          it 'returns 200 OK' do
            expect(response).to have_http_status 200
          end
          it_behaves_like 'json without problems'
        end

        context 'when the user does not joined during the contest,' do
          let(:contest) { create(:contest_holding) }
          let(:user)    { create(:user) }

          it 'returns 200 OK' do
            expect(response).to have_http_status 200
          end
          it_behaves_like 'json without problems'
        end

        context 'when the user joins before the contest start,' do
          let(:contest) { create(:contest_preparing) }
          let(:user) do
            create(:user) { |user| create(:contest_registration, user_id: user.id, contest_id: contest.id) }
          end

          it 'returns 200 OK' do
            expect(response).to have_http_status 200
          end
          it_behaves_like 'json without problems'
        end
      end

      describe 'Case 3' do
        context 'when the user joins during the contest' do
          let(:contest) { create(:contest_holding) }
          let(:user) do
            create(:user) { |user| create(:contest_registration, user_id: user.id, contest_id: contest.id) }
          end

          it 'returns 200 OK' do
            expect(response).to have_http_status 200
          end
          it_behaves_like 'json with problems'
        end

        context 'when the user does not login after the contest' do
          let(:contest) { create(:contest_ended) }
          let(:user)    { nil }

          it 'returns 200 OK' do
            expect(response).to have_http_status 200
          end
          it_behaves_like 'json with problems and editorial'
        end

        context 'when the user does not join after the contest' do
          let(:contest) { create(:contest_ended) }
          let(:user)    { create(:user) }

          it 'returns 200 OK' do
            expect(response).to have_http_status 200
          end
          it_behaves_like 'json with problems and editorial'
        end

        context 'when the user joins after the contest' do
          let(:contest) { create(:contest_ended) }
          let(:user) do
            create(:user) do |user|
              create(:contest_registration,
                     user_id: user.id, contest_id: contest.id)
            end
          end

          it 'returns 200 OK' do
            expect(response).to have_http_status 200
          end
          it_behaves_like 'json with problems and editorial'
        end
      end
    end
  end

  describe 'POST /api/contests/:id/entry' do
    before do
      post :entry, params: params
    end

    %w[ja en].each do |language|
      let(:lang) { language }

      describe 'Case 1: contest NOT found' do
        context 'contest NOT existed' do
          let(:contest) { nil }

          context 'NOT logged in' do
            let(:user) { nil }
            it 'returns 404 Not Found' do
              expect(response).to have_http_status 404
            end
          end

          context 'logged in' do
            let(:user)    { create(:user) }
            it 'returns 404 Not Found' do
              expect(response).to have_http_status 404
            end
          end
        end
      end

      describe 'Case 2: NOT logged in or AFTER contest period' do
        context 'NOT logged in' do
          let(:user) { nil }

          context 'BEFORE contest period' do
            let(:contest) { create(:contest_preparing) }

            it 'returns 403 Forbidden' do
              expect(response).to have_http_status 403
            end
          end

          context 'IN contest period' do
            let(:contest) { create(:contest_holding) }

            it 'returns 403 Forbidden' do
              expect(response).to have_http_status 403
            end
          end

          context 'AFTER contest period' do
            let(:contest) { create(:contest_ended) }

            it 'returns 403 Forbidden' do
              expect(response).to have_http_status 403
            end
          end
        end
        context 'logged in' do
          let(:user)    { create(:user) }

          context 'AFTER contest period' do
            let(:contest) { create(:contest_ended) }

            it 'returns 403 Forbidden' do
              expect(response).to have_http_status 403
            end
          end
        end
      end

      describe 'Case 3: Already participated' do
        context 'logged in' do
          let(:user)    { create(:user) }

          context 'participated' do
            before do
              create(:contest_registration, user: user, contest_id: contest.id)
            end

            context 'BEFORE contest period' do
              let(:contest) { create(:contest_preparing) }

              it 'returns 409 Conflict' do
                pending 'implementing now'
                expect(response).to have_http_status 409
              end
            end

            context 'logged in, participated,  IN contest period' do
              let(:contest) { create(:contest_holding) }

              it 'returns 409 Conflict' do
                pending 'implementing now'
                expect(response).to have_http_status 409
              end
            end

            context 'logged in, participated,  AFTER contest period' do
              let(:contest) { create(:contest_ended) }

              it 'returns 409 Conflict' do
                pending 'implementing now'
                expect(response).to have_http_status 409
              end
            end
          end
        end
      end

      describe 'Case 4: Success' do
        context 'logged in' do
          let(:user)    { create(:user) }

          context 'NOT participated' do
            context 'BEFORE contest period' do
              let(:contest) { create(:contest_preparing) }

              it 'returns 201 Created' do
                expect(response).to have_http_status 201
              end
            end

            context 'IN contest period' do
              let(:contest) { create(:contest_holding) }

              it 'returns 201 Created' do
                expect(response).to have_http_status 201
              end
            end
          end
        end
      end
    end
  end

  describe 'GET /api/contests/:id/ranking' do
    before do
      unless contest.nil?
        5.times do |k|
          user = create(:user)
          create(:contest_registration, contest: contest, user: user)
          contest.problems.each do |problem|
            problem.data_sets.each do |data_set|
              create(:submission,
                     data_set: data_set, user: user, judge_status: :wrong, score: nil)
              create(:submission,
                     data_set: data_set, user: user, judge_status: :accepted, score: 123 * k)
              create(:submission,
                     data_set: data_set, user: user, judge_status: :waiting, score: nil)
            end
          end
        end
      end
    end

    before do
      create(:contest_registration, user: user, contest_id: contest.id) if (defined? participated) && participated
      get :ranking, params: params
    end

    %w[ja en].each do |language|
      let(:lang) { language }

      describe 'Case 1: contest NOT found' do
        context 'contest NOT existed' do
          let(:contest) { nil }

          context 'NOT logged in' do
            let(:user) { nil }
            it 'returns 404 Not Found' do
              expect(response).to have_http_status 404
            end
          end

          context 'logged in' do
            let(:user) { create(:user) }
            it 'returns 404 Not Found' do
              expect(response).to have_http_status 404
            end
          end
        end
      end

      describe 'Case 2: access not allowed' do
        context 'BEFORE contest period' do
          let(:contest) { create(:contest_preparing) }

          context 'NOT logged in' do
            let(:user) { nil }

            it 'returns 403' do
              expect(response).to have_http_status 403
            end
          end

          context 'logged in' do
            let(:user) { create(:user) }

            context 'NOT participated' do
              it 'returns 403' do
                expect(response).to have_http_status 403
              end
            end
            context 'participated' do
              before do
                create(:contest_registration, user: user, contest_id: contest.id)
              end
              it 'returns 403' do
                expect(response).to have_http_status 403
              end
            end
          end
        end

        context 'IN contest period' do
          let(:contest) { create(:contest_holding) }

          context 'NOT logged in' do
            let(:user) { nil }
            it 'returns 404 Not Found' do
              expect(response).to have_http_status 403
            end
          end

          context 'logged in' do
            let(:user) { create(:user) }

            context 'NOT participated' do
              it 'returns 403' do
                expect(response).to have_http_status 403
              end
            end
          end
        end

        context 'AFTER contest period' do
          let(:contest) { create(:contest_ended) }

          context 'NOT logged in' do
            let(:user) { nil }
            it 'returns 200 Success' do
              expect(response).to have_http_status 200
            end
          end
        end
      end
      describe 'Case 3: return json' do
        let(:json_ranking) do
          sorted_users = contest.users.sort do |a, b|
            contest.user_score(b) <=> contest.user_score(a)
          end
          {
            users: sorted_users.map do |user|
              {
                id: user.id,
                name: user.name,
                total_score: contest.user_score(user),
                problems: contest.problems.order(order: :asc).map do |problem|
                  {
                    id: problem.id,
                    data_sets: problem.data_sets.order(order: :asc).map do |data_set|
                      {
                        id: data_set.id,
                        label: data_set.label,
                        correct: data_set.solved_by_during_contest?(user),
                        score: data_set.user_score(user),
                        solved_at: JSON.parse(data_set.user_solved_at(user).to_json),
                        wrong_answers: data_set.user_wrong_answers(user)
                      }
                    end
                  }
                end
              }
            end
          }
        end
        context 'logged in' do
          let(:user) { create(:user, name: 'rspec test user') }

          context 'IN contest period' do
            let(:contest) { create(:contest_holding) }

            context 'participted' do
              let(:participated) { true }

              it 'returns 200' do
                expect(response).to have_http_status 200
              end
              it 'has valid JSON' do
                expect(JSON.parse(response.body, symbolize_names: true)).to eq json_ranking
              end
            end
          end

          context 'AFTER contest period' do
            let(:contest) { create(:contest_ended) }

            it 'returns 200' do
              expect(response).to have_http_status 200
            end
            it 'has valid JSON' do
              expect(JSON.parse(response.body, symbolize_names: true)).to eq json_ranking
            end
          end
        end
      end
    end
  end
end
