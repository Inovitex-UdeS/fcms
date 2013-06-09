require "spec_helper"

describe Admin::EditionsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/editions").should route_to("admin/editions#index")
    end

    it "routes to #new" do
      get("/admin/editions/new").should route_to("admin/editions#new")
    end

    it "routes to #show" do
      get("/admin/editions/1").should route_to("admin/editions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/editions/1/edit").should route_to("admin/editions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/editions").should route_to("admin/editions#create")
    end

    it "routes to #update" do
      put("/admin/editions/1").should route_to("admin/editions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/editions/1").should route_to("admin/editions#destroy", :id => "1")
    end

  end
end
