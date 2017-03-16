require 'rails_helper'

RSpec.describe 'admin/data_sets/edit', type: :view do
  before(:each) do
    @admin_data_set = assign(:admin_data_set, DataSet.create!)
  end

  it 'renders the edit admin_data_set form' do
    render

    assert_select 'form[action=?][method=?]', admin_data_set_path(@admin_data_set), 'post' do
    end
  end
end
