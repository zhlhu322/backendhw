require 'spec_helper'
require 'rails_helper'

RSpec.describe "Missions", type: :system do
  before do
    driven_by(:rack_test)
  end

  subject { page }

  context "when viewing the mission list" do
    before do
      visit "/missions"
    end
    it { is_expected.to have_content I18n.t("missions.index.title") }
  end

  context "when creating a new mission" do
    before do
      visit "/missions/new"
      fill_in I18n.t("missions.name"), with: "Test Mission"
      fill_in I18n.t("missions.description"), with: "This is a test mission."
      click_button I18n.t("missions.create.btn")
    end
    it { is_expected.to have_content I18n.t("missions.create.success") }
    it { is_expected.to have_content "Test Mission" }
  end

  context "when editing an existing mission" do
    let!(:mission) { create(:mission) }
    before do
      visit "/missions"
      click_link mission.name
      click_button I18n.t("missions.show.btn")
      fill_in I18n.t("missions.name"), with: "Updated Mission"
      fill_in I18n.t("missions.description"), with: "This is an updated description."
      click_button I18n.t("missions.edit.btn")
    end

    it { is_expected.to have_content I18n.t("missions.edit.success") }
    it { is_expected.to have_content "Updated Mission" }
  end

  context "when deleting a mission" do
    let!(:mission) { create(:mission, :to_be_deleted) }
    before do
      visit "/missions"
      click_link mission.name
      click_button I18n.t("missions.delete.btn")
    end

    it { is_expected.to have_content I18n.t("missions.delete.success") }
    it { is_expected.to have_content I18n.t("missions.index.title") } # Back to missions list
  end

  context "when sorting missions" do
    let!(:old_mission) { create(:mission, name: "old_mission", created_at: 3.weeks.ago) }
    let!(:new_mission) { create(:mission, name: "new_mission", created_at: 1.day.ago) }
    before do
      visit "/missions"
      select "依建立時間排序", from: "sort"
      click_button I18n.t("missions.index.sort_btn")
    end

    it "shows the newest mission as the first item" do
      first_mission = subject.all("ul#missions-list li").first.text
      expect(first_mission).to include(new_mission.name)
    end

    it "shows the oldest mission as the last item" do
      last_mission = subject.all("ul#missions-list li").last.text
      expect(last_mission).to include(old_mission.name)
    end
  end
end
