require 'rails_helper'

RSpec.describe 'admin/data_sets/show', type: :view do
  let(:contest) { create(:contest_preparing) }

  before(:each) do
    @admin_data_set = assign(:admin_data_set, contest.problems.first.data_sets.first)
  end

  it 'renders attributes in <p>' do
  end
end
