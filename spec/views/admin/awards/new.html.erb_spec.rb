require 'rails_helper'

RSpec.describe "awards/new", type: :view do
  before(:each) do
    assign(:award, Award.new(
      index: "MyString"
    ))
  end

  it "renders new award form" do
    render

    assert_select "form[action=?][method=?]", awards_path, "post" do

      assert_select "input[name=?]", "award[index]"
    end
  end
end
