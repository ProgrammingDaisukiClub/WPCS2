require 'rails_helper'

RSpec.describe ContestsController, type: :controller do
  shared_examples 'render contests#show' do
    let(:contest_id) { contest.present? ? contest.id : Contest.pluck(:id).push(0).max.next }

    context 'when the contest does not exist' do
      let(:contest) { nil }

      it 'return http not found' do
        expect { subject }.to raise_error(ActionController::RoutingError, 'Not Found')
      end
    end

    context 'when the contest exists' do
      let(:contest) { create(:contest_holding) }

      it 'return http success' do
        is_expected.to have_http_status(:success)
      end

      it 'render contests#show' do
        is_expected.to render_template('contests/show')
      end
    end
  end

  describe 'GET #show' do
    subject { get :show, params: { id: contest_id } }
    it_behaves_like 'render contests#show'
  end

  describe 'GET #ranking' do
    subject { get :ranking, params: { id: contest_id } }
    it_behaves_like 'render contests#show'
  end
end
