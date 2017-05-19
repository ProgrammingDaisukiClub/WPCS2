require 'rails_helper'

RSpec.describe Admin::ContestsController, type: :controller do
  let(:contest) { create(:contest_holding) }

  describe 'GET #index' do
    context 'when the user does not login' do
      subject { get :index }
      it 'raise routing error' do
        expect { subject }.to raise_error(ActionController::RoutingError, 'not found')
      end
    end
  end

  describe 'GET #show' do
    context 'when the user does not login' do
      subject { get :show, params: { id: contest.id } }
      it 'raise routing error' do
        expect { subject }.to raise_error(ActionController::RoutingError, 'not found')
      end
    end
  end

  describe 'GET #new' do
    context 'when the user does not login' do
      subject { get :new }
      it 'raise routing error' do
        expect { subject }.to raise_error(ActionController::RoutingError, 'not found')
      end
    end
  end

  describe 'GET #edit' do
    context 'when the user does not login' do
      subject { get :edit, params: { id: contest.id } }
      it 'raise routing error' do
        expect { subject }.to raise_error(ActionController::RoutingError, 'not found')
      end
    end
  end
end
