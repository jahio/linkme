require 'rails_helper'

RSpec.describe "Links", type: :request do
  describe "GET /shortpath" do
    context "with an existing valid shortpath" do
      context "that does NOT have a token" do
        before :all do
          # Set some things up to ensure we have an existing link object
          # to work with going forward
          @link = create(:link)

          # And all requests will need the following headers
          @headers = { "CONTENT_TYPE" => "application/json" }
        end
        it "retrieves an existing shortened url object" do
          # Get the encoded URL from the public-facing hash and discard trailing slashes, if any
          pth = @link.public_facing[:short_link].gsub(ENV['RUNTIME_URI_BASE'], '').gsub(/\//, '')
          get "/#{pth}", headers: @headers
          r = JSON.parse(response.body)
          expect(response.status).to be 200
          expect(r["original_url"]).to eq @link[:url]
          expect(r["short_link"]).to eq @link.public_facing[:short_link]
          # TODO: check for visit count increase
        end
      end
      context "that DOES have a token" do
        before :all do
          @link = create(:link_with_token)
          @headers = { "CONTENT_TYPE" => "application/json" }
        end
        it "retrieves an existing shortened URL object" do
          pth = @link.public_facing[:short_link].gsub(ENV['RUNTIME_URI_BASE'], '').gsub(/\//, '')
          get "/#{pth}", headers: @headers
          r = JSON.parse(response.body)
          expect(response.status).to be 200
          expect(r["original_url"]).to eq @link[:url]
          expect(r["short_link"]).to eq @link.public_facing[:short_link]
          # TODO: check for visit count increase
        end
      end
    end
  end
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
