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
end
