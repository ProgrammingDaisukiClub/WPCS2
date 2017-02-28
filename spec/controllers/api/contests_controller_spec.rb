require 'rails_helper'

RSpec.describe Api::ContestsController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe 'GET #show' do
    let(:params) do
      {
        id: contest.present? ? contest.id : Contest.pluck(:id).push(0).max.next,
        lang: lang
      }
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

    before do
      sign_in(user) if user
    end

    ['ja', 'en'].each do |language|
      let(:lang) { language }

      shared_examples 'return http not found' do
        it 'return http not found' do
          get :show, params: params
          expect(response).to have_http_status(:not_found)
        end
      end
      context 'when the contest does not exist and the user does not login,' do
        let(:contest) { nil }
        let(:user)    { nil }
        it_behaves_like 'return http not found'
      end
      context 'when the contest does not exist and the user logins,' do
        let(:contest) { nil }
        let(:user)    { create(:user) }
        it_behaves_like 'return http not found'
      end

      shared_examples 'return http success and json without problems' do
        it 'return http success' do
          get :show, params: params
          expect(response).to have_http_status(:success)
        end
        it 'return json without problems' do
          get :show, params: params
          expect(JSON.parse(response.body)).to eq json_without_problems
        end
      end
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
        let(:user)    { create(:user) { |user| create(:contest_registration, user_id: user.id, contest_id: contest.id) } }
        it_behaves_like 'return http success and json without problems'
      end

      shared_examples 'return http success and json with problems' do
        it 'return http success' do
          get :show, params: params
          expect(response).to have_http_success(:success)
        end
        it 'return json with problems' do
          get :show, params: params
          expect(JSON.parse(response.body)).to eq json_with_problems
        end
      end
      context 'when the usre joins during the contest' do
        let(:contest) { create(:contest_holding) }
        let(:user)    { create(:user) { |user| create(:contest_registration, user_id: user.id, contest_id: contest.id) } }
        it_behaves_like 'return http success and json with problems'
      end
      context 'when the user does not login after the contest' do
        let(:contest) { create(:contest_ended) }
        let(:user)    { nil }
        it_behaves_like 'return http success and json with problems'
      end
      context 'when the usre does not join after the contest' do
        let(:contest) { create(:contest_ended) }
        let(:user)    { create(:user) }
        it_behaves_like 'return http success and json with problems'
      end
      context 'when the usre joins after the contest' do
        let(:contest) { create(:contest_ended) }
        let(:user)    { create(:user) { |user| create(:contest_registration, user_id: user.id, contest_id: contest.id) } }
        it_behaves_like 'return http success and json with problems'
      end
    end
  end

  describe 'POST #entry' do
  end

  describe 'GET #ranking' do
  end
end
