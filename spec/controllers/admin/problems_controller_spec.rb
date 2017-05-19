require 'rails_helper'

RSpec.describe Admin::ProblemsController, type: :controller do
  let(:contest) { create(:contest_holding) }
  let(:problem) { contest.problems.first }

  describe 'GET #show' do
    context 'when the user does not login' do
      subject { get :show, params: { id: problem.id } }
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
      subject { get :edit, params: { id: problem.id } }
      it 'raise routing error' do
        expect { subject }.to raise_error(ActionController::RoutingError, 'not found')
      end
    end
  end
end
