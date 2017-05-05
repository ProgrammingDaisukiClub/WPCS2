require 'rails_helper'

RSpec.describe Admin::SubmissionsController, type: :controller do
  let(:contest) { create(:contest_holding) }

  describe 'GET #index' do
    context 'when the user does not login' do
      subject { get :index, params: { contest_id: contest.id } }
      it 'raise routing error' do
        expect { subject }.to raise_error(ActionController::RoutingError, 'not found')
      end
    end
  end
end
