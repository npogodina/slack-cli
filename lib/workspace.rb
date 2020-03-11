require "httparty"
require "dotenv"

Dotenv.load
# TODO: remove all above?

class Workspace
  attr_reader :users, :channels

  URL = "https://slack.com/api/users.list"
  SLACK_TOKEN = ENV["SLACK_TOKEN"]

  def initialize
    @users = load_users
    @channels = []
  end

  private

  def load_users
    query = {
      token: SLACK_TOKEN
    }

    response = HTTParty.get(URL, query: query)

    users = response["members"].map do |user|
      User.new(
        slack_id: user["id"],
        username: user["name"],
        real_name: user["profile"]["real_name"]
      )
    end
    return users
  end
end