require 'rails_helper'

RSpec.describe "admin/problems/new", type: :view do
  before(:each) do
    assign(:admin_problem, Problem.new())
  end

  it "renders new admin_problem form" do
    render

    assert_select "form[action=?][method=?]", problems_path, "post" do
    end
  end
end
