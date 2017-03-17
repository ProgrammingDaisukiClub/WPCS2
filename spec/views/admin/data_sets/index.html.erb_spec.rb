require 'rails_helper'

RSpec.describe 'admin/data_sets/index', type: :view do
  let(:contest) { create(:contest_preparing) }
  before(:each) do
    assign(:data_sets, contest.problems.first.data_sets)
  end

  it 'renders a list of admin/data_sets' do
    render
  end
end
