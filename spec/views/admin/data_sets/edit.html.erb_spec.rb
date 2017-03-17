require 'rails_helper'

RSpec.describe 'admin/data_sets/edit', type: :view do
  let(:contest) { create(:contest_preparing) }

  before(:each) do
    @admin_data_set = assign(:admin_data_set, contest.problems.first.data_sets.first)
  end

  it 'renders the edit admin_data_set form' do
    pending
    render

    assert_select 'form[action=?][method=?]', admin_data_set_path(@admin_data_set), 'post' do
    end
  end
end
