require 'rails_helper'

RSpec.describe Api::SubmissionsController do
  describe 'POST /api/contests/:id/submissions' do
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
      post :create, params: {
        contest_id: contest_id,
        data_set_id: data_set.id,
        answer: 'hogehoge'
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
      let(:json_when_wrong_submission) do
        {
          id: submission.id,
          problem_id: submission.data_set.problem.id,
          data_set_id: submission.data_set.id,
          judge_status: 1, # WA
          created_at: submission.created_at.to_s
        }
      end

      let(:json_when_accepted_submission) do
        json_when_wrong_submission.merge(
          judge_status: 2, # AC
          score: submission.score
        )
      end

      it 'returns 201 Created' do
        expect(response).to have_http_status 201
      end

      context 'if submission is correct' do
        it 'contains JSON of accepted submission' do
          pending 'waiting for implementations of judging'
          expect(JSON.parse(response.body, symbolize_names: true)).to eq json_when_accepted_submission
        end
      end

      context 'if submission is wrong' do
        it 'contains JSON of wrong submission' do
          pending 'waiting for implementations of judging'
          expect(JSON.parse(response.body, symbolize_names: true)).to eq json_when_wrong_submission
        end
      end
    end
  end
end
