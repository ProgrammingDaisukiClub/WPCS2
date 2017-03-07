require 'rails_helper'

RSpec.describe Api::ContestsController, type: :controller do
  include Devise::Test::ControllerHelpers
  before do
    sign_in(user) if user
  end

  let(:params) do
    {
      id: contest.present? ? contest.id : Contest.pluck(:id).push(0).max.next,
      lang: lang
    }
  end

  describe 'GET /api/contents/:id' do
    before do
      get :show, params: params
    end

    let(:json_without_problems) do
      {
        id: contest.id,
        name: params[:lang] == 'ja' ? contest.name_ja : contest.name_en,
        description: params[:lang] == 'ja' ? contest.description_ja : contest.description_en,
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
                score: data_set.score
              }
            end
          }
        end
      )
    end

    shared_examples 'json without problems' do
      it 'return json without problems' do
        pending 'implementing now'
        get :show, params: params
        expect(JSON.parse(response.body)).to eq json_without_problems
      end
    end

    shared_examples 'json with problems' do
      it 'return json with problems' do
        pending 'implementing now'
        get :show, params: params
        expect(JSON.parse(response.body)).to eq json_with_problems
      end
    end

    %w(ja en).each do |language|
      let(:lang) { language }

      describe 'Case 1: contest NOT found' do
        context 'contest NOT existed' do
          let(:contest) { nil }

          context 'NOT logged in' do
            let(:user) { nil }
            it 'returns 404 Not Found' do
              pending 'implementing now'
              expect(response).to have_http_status 404
            end
          end

          context 'logged in' do
            let(:user)    { create(:user) }
            it 'returns 404 Not Found' do
              pending 'implementing now'
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
          it_behaves_like 'json with problems'
        end

        context 'when the user does not join after the contest' do
          let(:contest) { create(:contest_ended) }
          let(:user)    { create(:user) }

          it 'returns 200 OK' do
            expect(response).to have_http_status 200
          end
          it_behaves_like 'json with problems'
        end

        context 'when the user joins after the contest' do
          let(:contest) { create(:contest_ended) }
          let(:user) do
            create(:user) { |user| create(:contest_registration, user_id: user.id, contest_id: contest.id) }
          end

          it 'returns 200 OK' do
            expect(response).to have_http_status 200
          end
          it_behaves_like 'json with problems'
        end
      end
    end
  end

  describe 'POST /api/contests/:id/entry' do
    before do
      post :entry, params: params
    end

    %w(ja en).each do |language|
      let(:lang) { language }

      describe 'Case 1: contest NOT found' do
        context 'contest NOT existed' do
          let(:contest) { nil }

          context 'NOT logged in' do
            let(:user) { nil }
            it 'returns 404 Not Found' do
              pending 'implementing now'
              expect(response).to have_http_status 404
            end
          end

          context 'logged in' do
            let(:user)    { create(:user) }
            it 'returns 404 Not Found' do
              pending 'implementing now'
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
              pending 'implementing now'
              expect(response).to have_http_status 403
            end
          end

          context 'IN contest period' do
            let(:contest) { create(:contest_holding) }

            it 'returns 403 Forbidden' do
              pending 'implementing now'
              expect(response).to have_http_status 403
            end
          end

          context 'AFTER contest period' do
            let(:contest) { create(:contest_ended) }

            it 'returns 403 Forbidden' do
              pending 'implementing now'
              expect(response).to have_http_status 403
            end
          end
        end
        context 'logged in' do
          let(:user)    { create(:user) }

          context 'AFTER contest period' do
            let(:contest) { create(:contest_ended) }

            it 'returns 403 Forbidden' do
              pending 'implementing now'
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
                pending 'implementing now'
                expect(response).to have_http_status 201
              end
            end

            context 'IN contest period' do
              let(:contest) { create(:contest_holding) }

              it 'returns 201 Created' do
                pending 'implementing now'
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
      get :ranking, params: params
    end

    %w(ja en).each do |language|
      let(:lang) { language }

      describe 'Case 1: contest NOT found' do
        context 'contest NOT existed' do
          let(:contest) { nil }

          context 'NOT logged in' do
            pending 'implementing now'
            let(:user) { nil }
            it 'returns 404 Not Found' do
              pending 'implementing now'
              expect(response).to have_http_status 404
            end
          end

          context 'logged in' do
            pending 'implementing now'
            let(:user) { create(:user) }
            it 'returns 404 Not Found' do
              pending 'implementing now'
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
              pending 'implementing now'
              expect(response).to have_http_status 403
            end
          end

          context 'logged in' do
            let(:user) { create(:user) }

            context 'NOT participated' do
              it 'returns 403' do
                pending 'implementing now'
                expect(response).to have_http_status 403
              end
            end
            context 'participated' do
              before do
                create(:contest_registration, user: user, contest_id: contest.id)
              end
              it 'returns 403' do
                pending 'implementing now'
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
              pending 'implementing now'
              expect(response).to have_http_status 403
            end
          end

          context 'logged in' do
            let(:user) { create(:user) }

            context 'NOT participated' do
              it 'returns 403' do
                pending 'implementing now'
                expect(response).to have_http_status 403
              end
            end
          end
        end

        context 'AFTER contest period' do
          let(:contest) { create(:contest_ended) }

          context 'NOT logged in' do
            let(:user) { nil }
            it 'returns 404 Not Found' do
              pending 'implementing now'
              expect(response).to have_http_status 403
            end
          end
        end
      end
=begin
      describe 'Case 3: return json' do
        let(:json_ranking) do
          {
            problems: contest.users.map do |user|
              {
                id: user.id,
                name: user.name,
                problems: contest.problems.map do |prob|
                  {
                    id: prob.id,
                  }
                end
              }
            end
          }
        end
        context 'logged in' do
          let(:user) { create(:user) }

          context 'IN contest period' do
            let(:contest) { create(:contest_holding) }

            context 'participted' do
              before do
                create(:contest_registration, user: user, contest_id: contest.id)
              end

              it 'returns 200' do
                # pending 'implementing now'
                expect(response).to have_http_status 200
              end            
              it 'has valid JSON' do
                expect(JSON.parse(response.body)).to eq json_ranking
              end
            end
          end

          context 'AFTER contest period' do
            let(:contest) { create(:contest_ended) }

            it 'returns 200' do
              # pending 'implementing now'
              expect(response).to have_http_status 200
            end
          end
        end
      end
=end
    end
  end
end
