require 'rails_helper'

RSpec.describe "admin/problems/index", type: :view do
  before(:each) do
    assign(:problems, [
      Problem.create!(),
      Problem.create!()
    ])
  end

  it "renders a list of admin/problems" do
    render
  end
end
