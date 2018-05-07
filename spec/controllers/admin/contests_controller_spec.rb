require 'rails_helper'

RSpec.describe Admin::ContestsController, type: :controller do
  include Devise::Test::ControllerHelpers

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

  describe 'GET #json_upload' do
    context 'when the user does not login' do
      subject { get :json_upload, params: { id: contest.id } }
      it 'raise routing error' do
        expect { subject }.to raise_error(ActionController::RoutingError, 'not found')
      end
    end

    context 'when the user does not login' do
      subject { get :json_upload, params: { id: contest.id } }
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

  describe 'PATCH #update_from_json' do
    before { sign_in(user) }
    let(:user) { create(:admin_user) }
    let(:contest) { create(:contest_preparing) }

    let(:file) do
      tempfile = Tempfile.open do |f|
        f.write(json.to_json)
        f
      end
      fixture_file_upload(tempfile.path)
    end

    context 'when a valid json file is uploaded' do
      let(:json) do
        {
          contest_name: 'Sample Contest',
          problems: [
            {
              title: 'A + B',
              statement: "# Description\n",
              data_sets: [
                {
                  label: 'Small',
                  score: 50,
                  input: "2\n1 2\n3 4\n",
                  output: "3\n7\n"
                }
              ]
            }
          ]
        }
      end
      it 'the contest is updated succesfully' do
        patch :update_from_json, params: { id: contest.id, contest: { file: file } }
        updated_contest = Contest.find_by(id: contest.id)
        expect(response).to redirect_to admin_contest_path(contest)
        expect(updated_contest.name_ja).to eq json[:contest_name]
        expect(updated_contest.problems.size).to eq 1
        expect(updated_contest.problems.first.name_ja).to eq 'A + B'
        expect(updated_contest.problems.first.data_sets.size).to eq 1
        expect(updated_contest.problems.first.data_sets.first.label).to eq 'Small'
      end
    end

    context 'when invalid json file is uploaded' do
      let(:json) { { contest_name: 'Sample Contest' } }
      it 'the contest is updated succesfully' do
        patch :update_from_json, params: { id: contest.id, contest: { file: file } }
        expect(response).to render_template(:json_upload)
      end
    end
  end
end
