# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'factory_bot_rails'
include FactoryBot::Syntax::Methods

create_list(:mission, 30)
create(:mission, name: "Rails 實作測試", state: "pending")
create(:mission, name: "RSpec 功能測試", state: "in_progress")

default_user = User.find_or_create_by!(email: "default@example.com") do |u|
  u.name = "Default User"
end

Mission.where(user_id: nil).update_all(user_id: default_user.id)
