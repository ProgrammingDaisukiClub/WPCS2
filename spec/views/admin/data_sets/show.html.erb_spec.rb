require 'rails_helper'

RSpec.describe 'admin/data_sets/show', type: :view do
  before(:each) do
    @admin_data_set = assign(:admin_data_set, DataSet.create!)
  end

  it 'renders attributes in <p>' do
    render
  end
end
