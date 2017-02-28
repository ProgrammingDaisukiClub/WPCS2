require 'rails_helper'

RSpec.describe ProblemsController, type: :controller do
  shared_examples 'render contests#show' do
    let(:contest_id) { contest.present? ? contest.id : Contest.pluck(:id).push(0).max.next }
    let(:problem_id) { problem.present? ? problem.id : Problem.pluck(:id).push(0).max.next }

    shared_examples 'raise ActionController::RoutingError' do
      it 'raise ActionController::RoutingError' do
        expect{ subject }.to raise_error(ActionController::RoutingError, 'Not Found')
      end
    end

    context 'when the contest does not exist' do
      let(:contest) { nil }
      let(:problem) { nil }

      it_behaves_like 'raise ActionController::RoutingError'
    end

    context 'when the contest exists and the problem does not exists' do
      let(:contest) { create(:contest_holding) }
      let(:problem) { nil }

      it_behaves_like 'raise ActionController::RoutingError'
    end

    context 'when the contest exists' do
      let(:contest) { create(:contest_holding) }
      let(:problem) { contest.problems.first }

      it 'return http success' do
        expect(subject).to have_http_status(:success)
      end

      it 'render contests#show' do
        expect(subject).to render_template('contests/show')
      end
    end
  end

  describe 'GET #show' do
    let(:subject) { get :show, params: { contest_id: contest_id, id: problem_id } }
    it_behaves_like 'render contests#show'
  end
end
