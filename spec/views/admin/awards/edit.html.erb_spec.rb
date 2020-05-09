require 'rails_helper'

RSpec.describe "awards/edit", type: :view do
  before(:each) do
    @award = assign(:award, Award.create!(
      index: "MyString"
    ))
  end

  it "renders the edit award form" do
    render

    assert_select "form[action=?][method=?]", award_path(@award), "post" do

      assert_select "input[name=?]", "award[index]"
    end
  end
end
