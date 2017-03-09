require 'rails_helper'

RSpec.describe Api::ContestsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:params) do
    {
      id: contest.present? ? contest.id : Contest.pluck(:id).push(0).max.next,
      lang: lang
    }
  end

  shared_examples 'return HTTP 201 Created' do
    it 'return HTTP 201 Created' do
      pending 'wait for fixing test code'
      get :show, params: params
      expect(response).to have_http_status 201
    end
  end

  shared_examples 'return HTTP 404 Not Found' do
    it 'return HTTP 404 Not Found' do
      get :show, params: params
      expect(response).to have_http_status 404
    end
  end

  shared_examples 'return HTTP 403 Forbidden' do
    it 'return HTTP 403 Forbidden' do
      pending 'wait for fixing test code'
      get :show, params: params
      expect(response).to have_http_status 403
    end
  end

  shared_examples 'return HTTP 409 Conflict' do
    it 'return HTTP 409 Conflict' do
      pending 'wait for fixing test code'
      get :show, params: params
      expect(response).to have_http_status 409
    end
  end

  describe 'GET /api/contents/:id' do
    let(:json_without_problems) do
      {
        id: contest.id,
        name: params[:lang] == 'ja' ? contest.name_ja : contest.name_en,
        description: params[:lang] == 'ja' ? contest.description_ja : contest.description_en,
        start_at: JSON.parse(contest.start_at.to_json),
        end_at: JSON.parse(contest.end_at.to_json),
        joined: user.present? && ContestRegistration.find_by(user_id: user.id).present?
      }
    end

    let(:json_with_problems) do
      json_without_problems.merge(
        problems: contest.problems.map do |problem|
          {
            id: problem.id,
            name: params[:lang] == 'ja' ? problem.name_ja : problem.name_en,
            description: params[:lang] == 'ja' ? problem.description_ja : problem.description_en,
            data_sets: problem.data_sets.map do |data_set|
              {
                id: data_set.id,
                label: data_set.label,
                max_score: data_set.score,
                correct: false,
                score: 0
              }
            end
          }
        end
      )
    end

    before do
      sign_in(user) if user
    end

    shared_examples 'return http success and json without problems' do
      it 'return http success' do
        get :show, params: params
        expect(response).to have_http_status(:success)
      end
      it 'return json without problems' do
        get :show, params: params
        expect(JSON.parse(response.body, symbolize_names: true)).to eq json_without_problems
      end
    end

    shared_examples 'return http success and json with problems' do
      it 'return http success' do
        get :show, params: params
        expect(response).to have_http_status(:success)
      end
      it 'return json with problems' do
        get :show, params: params
        expect(JSON.parse(response.body, symbolize_names: true)).to eq json_with_problems
      end
    end

    %w(ja en).each do |language|
      let(:lang) { language }

      describe 'Case 1' do
        context 'when the contest does not exist and the user does not login,' do
          let(:contest) { nil }
          let(:user)    { nil }
          it_behaves_like 'return HTTP 404 Not Found'
        end

        context 'when the contest does not exist and the user logins,' do
          let(:contest) { nil }
          let(:user)    { create(:user) }
          it_behaves_like 'return HTTP 404 Not Found'
        end
      end

      describe 'Case 2' do
        context 'when the user does not login before the contest starts,' do
          let(:contest) { create(:contest_preparing) }
          let(:user)    { nil }
          it_behaves_like 'return http success and json without problems'
        end

        context 'when the user does not login during the contest,' do
          let(:contest) { create(:contest_holding) }
          let(:user)    { nil }
          it_behaves_like 'return http success and json without problems'
        end

        context 'when the user does not joined before the contest starts,' do
          let(:contest) { create(:contest_preparing) }
          let(:user)    { create(:user) }
          it_behaves_like 'return http success and json without problems'
        end

        context 'when the user does not joined during the contest,' do
          let(:contest) { create(:contest_holding) }
          let(:user)    { create(:user) }
          it_behaves_like 'return http success and json without problems'
        end

        context 'when the user joins before the contest start,' do
          let(:contest) { create(:contest_preparing) }
          let(:user) do
            create(:user) { |user| create(:contest_registration, user_id: user.id, contest_id: contest.id) }
          end
          it_behaves_like 'return http success and json without problems'
        end
      end

      describe 'Case 3' do
        context 'when the user joins during the contest' do
          let(:contest) { create(:contest_holding) }
          let(:user) do
            create(:user) { |user| create(:contest_registration, user_id: user.id, contest_id: contest.id) }
          end
          it_behaves_like 'return http success and json with problems'
        end

        context 'when the user does not login after the contest' do
          let(:contest) { create(:contest_ended) }
          let(:user)    { nil }
          it_behaves_like 'return http success and json with problems'
        end

        context 'when the user does not join after the contest' do
          let(:contest) { create(:contest_ended) }
          let(:user)    { create(:user) }
          it_behaves_like 'return http success and json with problems'
        end

        context 'when the user joins after the contest' do
          let(:contest) { create(:contest_ended) }
          let(:user) do
            create(:user) { |user| create(:contest_registration, user_id: user.id, contest_id: contest.id) }
          end
          it_behaves_like 'return http success and json with problems'
        end
      end
    end
  end

  describe 'POST /api/contests/:id/entry' do
    %w(ja en).each do |language|
      let(:lang) { language }

      describe 'Case 1: contest NOT found' do
        context 'contest NOT existed' do
          let(:contest) { nil }

          context 'NOT logged in' do
            let(:user) { nil }
            it_behaves_like 'return HTTP 404 Not Found'
          end

          context 'logged in' do
            let(:user)    { create(:user) }
            it_behaves_like 'return HTTP 404 Not Found'
          end
        end
      end

      describe 'Case 2: NOT logged in or AFTER contest period' do
        context 'NOT logged in' do
          let(:user) { nil }

          context 'BEFORE contest period' do
            let(:contest) { create(:contest_preparing) }

            it_behaves_like 'return HTTP 403 Forbidden'
          end

          context 'IN contest period' do
            let(:contest) { create(:contest_holding) }

            it_behaves_like 'return HTTP 403 Forbidden'
          end

          context 'AFTER contest period' do
            let(:contest) { create(:contest_ended) }

            it_behaves_like 'return HTTP 403 Forbidden'
          end
        end
        context 'logged in' do
          let(:user)    { create(:user) }

          context 'AFTER contest period' do
            let(:contest) { create(:contest_ended) }

            it_behaves_like 'return HTTP 403 Forbidden'
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

              it_behaves_like 'return HTTP 409 Conflict'
            end

            context 'logged in, participated,  IN contest period' do
              let(:contest) { create(:contest_holding) }

              it_behaves_like 'return HTTP 409 Conflict'
            end

            context 'logged in, participated,  AFTER contest period' do
              let(:contest) { create(:contest_ended) }

              it_behaves_like 'return HTTP 409 Conflict'
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

              it_behaves_like 'return HTTP 201 Created'
            end

            context 'IN contest period' do
              let(:contest) { create(:contest_holding) }

              it_behaves_like 'return HTTP 201 Created'
            end
          end
        end
      end
    end
  end

  describe 'GET /api/contests/:id/ranking' do
  end
end
