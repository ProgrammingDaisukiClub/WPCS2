require "rails_helper"

RSpec.describe AwardsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/awards").to route_to("awards#index")
    end

    it "routes to #new" do
      expect(get: "/awards/new").to route_to("awards#new")
    end

    it "routes to #show" do
      expect(get: "/awards/1").to route_to("awards#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/awards/1/edit").to route_to("awards#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/awards").to route_to("awards#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/awards/1").to route_to("awards#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/awards/1").to route_to("awards#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/awards/1").to route_to("awards#destroy", id: "1")
    end
  end
end
