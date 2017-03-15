require 'rails_helper'

RSpec.describe Api::SubmissionsController do
  describe 'GET /api/contests/:id/submissions' do
    let(:contest) { create(contest_status) }
    let(:problem) { create(:problem, contest: contest) }
    let(:data_set) { create(:data_set, problem: problem) }
    let(:contest_status) { :contest_holding }
    let(:contest_id) { contest.id }
    let(:user) { create(:user) }
    let(:user_signed_in?) { true }
    let(:user_registered?) { true }

    before do
      sign_in(user) if user_signed_in?
      contest.register(user) if user_registered?
      create(:submission, data_set: data_set, user: user, judge_status: :wrong, score: 0)
      create(:submission, data_set: data_set, user: user, judge_status: :accepted, score: 128)
      get :index, params: {
        contest_id: contest_id
      }
    end

    context 'when contest is not found' do
      let(:contest_id) { contest.id + 1 }

      it 'returns 404 Not Found' do
        expect(response).to have_http_status 404
      end
    end

    context 'when user does not logged in' do
      let(:user_signed_in?) { false }

      it 'returns 403 Forbidden' do
        expect(response).to have_http_status 403
      end
    end

    context 'when user not registered' do
      let(:user_registered?) { false }

      it 'returns 403 Forbidden' do
        expect(response).to have_http_status 403
      end
    end

    context 'when user logged in and participated' do
      let(:submission) { Submission.last }
      let(:json_with_submission) do
        contest.submissions.where(user: user).order(id: :asc).map do |submission|
          data = {
            id: submission.id,
            problem_id: submission.problem_id,
            data_set_id: submission.data_set_id,
            judge_status: submission.judge_status_before_type_cast,
            created_at: JSON.parse(submission.created_at.to_json)
          }
          next data unless submission.judge_status_accepted?
          data.merge(score: submission.score)
        end
      end

      it 'returns 200 OK' do
        expect(response).to have_http_status 200
      end

      context 'returns valid JSON' do
        it 'contains JSON of accepted submission' do
          expect(JSON.parse(response.body, symbolize_names: true)).to eq json_with_submission
        end
      end
    end
  end

  describe 'POST /api/contests/:id/submissions' do
    let(:contest) { create(contest_status) }
    let(:problem) { create(:problem, contest: contest) }
    let(:data_set) { create(:data_set, problem: problem) }
    let(:contest_status) { :contest_holding }
    let(:contest_id) { contest.id }
    let(:user) { create(:user) }
    let(:user_signed_in?) { true }
    let(:user_registered?) { true }
    let(:correct_answer?) { false }

    before do
      sign_in(user) if user_signed_in?
      contest.register(user) if user_registered?
      post :create, params: {
        contest_id: contest_id,
        data_set_id: data_set.id,
        answer: correct_answer? ? data_set.output : 'hogehoge'
      }
    end

    context 'when contest is not found' do
      let(:contest_id) { contest.id + 1 }

      it 'returns 404 Not Found' do
        expect(response).to have_http_status 404
      end
    end

    context 'when user does not sign in' do
      let(:user_signed_in?) { false }

      it 'returns 403 Forbidden' do
        expect(response).to have_http_status 403
      end
    end

    context 'before contest starts' do
      let(:contest_status) { :contest_preparing }

      it 'returns 403 Forbidden' do
        expect(response).to have_http_status 403
      end
    end

    context 'when contest starts but user has no registrations' do
      let(:user_registered?) { false }

      it 'returns 403 Forbidden' do
        expect(response).to have_http_status 403
      end
    end

    context 'when contest is being held and user registers' do
      let(:submission) { Submission.last }
      let(:json_submission) do
        {
          id: submission.id,
          problem_id: submission.data_set.problem.id,
          data_set_id: submission.data_set.id,
          judge_status: correct_answer? ? 2 : 1,
          created_at: JSON.parse(submission.created_at.to_json),
          score: submission.score
        }
      end

      it 'returns 201 Created' do
        expect(response).to have_http_status 201
      end

      context 'if submission is correct' do
        let(:correct_answer?) { true }
        it 'contains JSON of accepted submission' do
          expect(JSON.parse(response.body, symbolize_names: true)).to eq json_submission
        end
      end

      context 'if submission is wrong' do
        it 'contains JSON of wrong submission' do
          expect(JSON.parse(response.body, symbolize_names: true)).to eq json_submission
        end
      end
    end
  end
end
