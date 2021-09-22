require "net/http"
require "uri"

class RecruitsController < ApplicationController
  def index
    # Web request
    # Specifically: all ranked recruits for a given year in order of ranking
    uri = URI.parse("https://api.collegefootballdata.com/recruiting/players?year=2021&classification=HighSchool")
    request = Net::HTTP::Get.new(uri)
    request["Accept"] = "application/json"
    request["Authorization"] = "Bearer #{Rails.application.credentials.cfbd_api_key}"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    # Web response
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    # Accessing all recruits
    all_recruits = JSON.parse(response.body)

    render json: all_recruits
  end

  def show
  end
end
