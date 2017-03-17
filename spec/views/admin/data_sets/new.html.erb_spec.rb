require 'rails_helper'

RSpec.describe 'admin/data_sets/new', type: :view do
  let(:contest) { create(:contest_preparing) }
  before(:each) do
    assign(:admin_data_set, contest.problems.first.data_sets.first)
  end

  it 'renders new admin_data_set form' do
    pending
    render

    assert_select 'form[action=?][method=?]', data_sets_path, 'post' do
    end
  end
end
