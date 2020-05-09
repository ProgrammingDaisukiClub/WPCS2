require 'rails_helper'

RSpec.describe "awards/index", type: :view do
  before(:each) do
    assign(:awards, [
      Award.create!(
        index: "Index"
      ),
      Award.create!(
        index: "Index"
      )
    ])
  end

  it "renders a list of awards" do
    render
    assert_select "tr>td", text: "Index".to_s, count: 2
  end
end
