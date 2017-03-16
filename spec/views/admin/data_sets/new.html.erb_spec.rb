require 'rails_helper'

RSpec.describe 'admin/data_sets/new', type: :view do
  before(:each) do
    assign(:admin_data_set, DataSet.new)
  end

  it 'renders new admin_data_set form' do
    render

    assert_select 'form[action=?][method=?]', data_sets_path, 'post' do
    end
  end
end
