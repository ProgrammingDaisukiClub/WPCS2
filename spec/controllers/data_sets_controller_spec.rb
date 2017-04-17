require 'rails_helper'

RSpec.describe DataSetsController, type: :controller do
  shared_examples 'data_sets#show' do
    let(:contest_id) { contest.present? ? contest.id : Contest.pluck(:id).push(0).max.next }
    let(:problem_id) { problem.present? ? problem.id : Problem.pluck(:id).push(0).max.next }
    let(:data_set_id) { data_set.present? ? data_set.id : DataSet.pluck(:id).push(0).max.next }

    shared_examples 'raise ActionController::RoutingError' do
      it 'raise ActionController::RoutingError' do
        expect { subject }.to raise_error(ActionController::RoutingError, 'Not Found')
      end
    end

    context 'when the contest does not exist' do
      let(:contest) { nil }
      let(:problem) { nil }
      let(:data_set) { nil }
      it_behaves_like 'raise ActionController::RoutingError'
    end

    context 'when the contest exists and the problem does not exists' do
      let(:contest) { create(:contest_holding) }
      let(:problem) { nil }
      let(:data_set) { nil }
      it_behaves_like 'raise ActionController::RoutingError'
    end

    context 'when the contest exists and the problem exists and the data_set does not exists' do
      let(:contest) { create(:contest_holding) }
      let(:problem) { nil }
      let(:data_set) { nil }
      it_behaves_like 'raise ActionController::RoutingError'
    end

    context 'when the contest exists' do
      let(:contest) { create(:contest_holding) }
      let(:problem) { contest.problems.first }
      let(:data_set) { problem.data_sets.first }
      let(:send_data_options) do
        { filename: "input_#{contest_id}_#{problem_id}_#{data_set_id}.in",
        disposition: 'attachment', type: 'text/txt', status: 200 }
      end
      it 'return http ' do
        expect(subject).to have_http_status(:success)
      end

      it 'should return a txt attachment' do
        expect(@controller).to receive(:send_data).with(dataset.input, send_data_options) {
          @controller.render nothing: true
        }
        get :show, id: data_set_id, problem_id: problem_id, contest_id: contest_id, format: 'text'
      end
    end
  end

  describe 'GET #show' do
    subject { get :show, params: { contest_id: contest_id, problem_id: problem_id, id: data_set_id, type: 'text' } }

  end
end
