require 'rails_helper'

RSpec.describe "Admin::Problems", type: :request do
  describe "GET /admin_problems" do
    it "works! (now write some real specs)" do
      get admin_problems_index_path
      expect(response).to have_http_status(200)
    end
  end
end
