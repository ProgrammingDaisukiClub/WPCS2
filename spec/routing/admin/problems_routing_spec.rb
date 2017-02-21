require "rails_helper"

RSpec.describe Admin::ProblemsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/problems").to route_to("admin/problems#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/problems/new").to route_to("admin/problems#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/problems/1").to route_to("admin/problems#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/problems/1/edit").to route_to("admin/problems#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/problems").to route_to("admin/problems#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/problems/1").to route_to("admin/problems#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/problems/1").to route_to("admin/problems#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/problems/1").to route_to("admin/problems#destroy", :id => "1")
    end

  end
end
