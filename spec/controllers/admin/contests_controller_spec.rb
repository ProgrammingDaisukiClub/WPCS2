require 'rails_helper'

RSpec.describe Admin::ContestsController, type: :controller do
  describe 'GET #show' do
    context 'when the user does not login' do
      it 'redirects to another page' do
        get :index
        expect(response).to have_http_status(302)
      end
    end
  end
end
