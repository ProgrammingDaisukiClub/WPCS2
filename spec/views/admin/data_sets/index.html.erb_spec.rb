require 'rails_helper'

RSpec.describe 'admin/data_sets/index', type: :view do
  before(:each) do
    assign(:data_sets, [
             DataSet.create!,
             DataSet.create!
           ])
  end

  it 'renders a list of admin/data_sets' do
    render
  end
end
