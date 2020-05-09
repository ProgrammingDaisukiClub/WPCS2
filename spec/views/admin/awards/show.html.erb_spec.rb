require 'rails_helper'

RSpec.describe "awards/show", type: :view do
  before(:each) do
    @award = assign(:award, Award.create!(
      index: "Index"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Index/)
  end
end
