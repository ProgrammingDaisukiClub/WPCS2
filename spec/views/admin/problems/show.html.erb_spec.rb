require 'rails_helper'

RSpec.describe "admin/problems/show", type: :view do
  before(:each) do
    @admin_problem = assign(:admin_problem, Problem.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
