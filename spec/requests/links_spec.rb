require 'rails_helper'

RSpec.describe "Links", type: :request do
  describe "POST /" do
    context "with invalid data consisting of" do
      context "...incomplete link specification" do
      end
      context "...a link not having a valid http/s prefix" do
      end
      context "...an attempted overridden timestamp in the past" do
      end
    end
    context "with a valid link specification" do
      it "creates the link object then renders JSON back for the link object created" do
        link = { url: Faker::Internet.url }
        headers = { "CONTENT_TYPE" => "application/json" }
        post "/", params: link.to_json, headers: headers
        r = JSON.parse(response.body)
        expect(response.status).to be 200
        expect(r["original_url"]).to eq link[:url]
        expect(r["short_link"]).to_not be nil
      end
    end
  end
end