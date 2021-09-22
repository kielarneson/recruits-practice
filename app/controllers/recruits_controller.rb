require "net/http"
require "uri"

class RecruitsController < ApplicationController
  def cfbd_api_response
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

    cfbd_api_response = JSON.parse(response.body)
    return cfbd_api_response
  end

  def index
    # Accessing all recruits
    all_recruits = cfbd_api_response()

    render json: all_recruits
  end

  def show
    # Accessing specific recruit
    specific_recruit = cfbd_api_response().select { |player| player["name"].downcase == params[:name].downcase }
    render json: specific_recruit
  end
end
