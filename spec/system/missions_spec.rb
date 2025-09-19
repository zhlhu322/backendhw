require 'spec_helper'
require 'rails_helper'

RSpec.describe "Missions", type: :system do
  def create_mission(name:, description:)
    let!(:mission) { Mission.create!(name: name, description: description) }
  end

  before do
    driven_by(:rack_test)
  end

  subject { page }

  context "when viewing the mission list" do
    before do
      visit "/missions"
    end
    it { is_expected.to have_content "Missions" }
  end

  context "when creating a new mission" do
    before do
      visit "/missions/new"
      fill_in "Name", with: "Test Mission"
      fill_in "Description", with: "This is a test mission."
      click_button "Create a mission"
    end
    it { is_expected.to have_content "Mission created successfully!" }
    it { is_expected.to have_content "Test Mission" }
  end

  context "when editing an existing mission" do
    create_mission(name: "Test Mission", description: "Old description")
    before do
      visit "/missions"
      click_link "Test Mission"
      click_button "Edit Mission"
      fill_in "Name", with: "Updated Mission"
      fill_in "Description", with: "This is an updated description."
      click_button "Update Mission"
    end

    it { is_expected.to have_content "Mission updated successfully!" }
    it { is_expected.to have_content "Updated Mission" }
  end

  context "when deleting a mission" do
    create_mission(name: "Test Mission", description: "To be deleted")
    before do
      visit "/missions"
      click_link "Test Mission"
      click_button "Delete Mission"
    end

    it { is_expected.to have_content "Mission deleted." }
    it { is_expected.to have_content "Missions" } # Back to missions list
  end
end
