require 'rails_helper'

RSpec.describe Admin::AwardsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:contest) { create(:contest_holding) }

  describe 'GET #index' do
    subject { get :index, params: { contest_id: contest.id } }

    context 'when the user does not login' do
      it 'raise routing error' do
        expect { subject }.to raise_error(ActionController::RoutingError, 'not found')
      end
    end

    context 'when the normal user logins' do
      before { sign_in(user) }
      let(:user) { create(:user) }
      it 'raise routing error' do
        expect { subject }.to raise_error(ActionController::RoutingError, 'not found')
      end
    end

    context 'when the admin user logins' do
      before { sign_in(user) }
      let(:user) { create(:admin_user) }
      it 'return 200' do
        expect(response.status).to eq 200
      end
    end
  end
end
