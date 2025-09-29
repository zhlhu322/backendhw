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

  # context "when creating a new mission" do
  #   before do
  #     visit "/missions/new"
  #     fill_in I18n.t("missions.name"), with: "Test Mission"
  #     fill_in I18n.t("missions.description"), with: "This is a test mission."
  #     fill_in I18n.t("missions.end_date"), with: (3.days.from_now).strftime("%Y-%m-%dT%H:%M")
  #     click_button I18n.t("missions.create.btn")
  #   end
  #   it { is_expected.to have_content I18n.t("missions.create.success") }
  #   it { is_expected.to have_content "Test Mission" }
  # end

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

  context "when sorting missions by creation date" do
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

  context "when sorting missions by end date" do
    let!(:mission1) { create(:mission, name: "mission1", end_date: 3.days.from_now) }
    let!(:mission2) { create(:mission, name: "mission2", end_date: 1.day.from_now) }
    before do
      visit "/missions"
      select "依到期時間排序", from: "sort"
      click_button I18n.t("missions.index.sort_btn")
    end

    it "shows the mission with the nearest end date as the first item" do
      first_mission = subject.all("ul#missions-list li").first.text
      expect(first_mission).to include(mission2.name)
    end

    it "shows the mission with the farthest end date as the last item" do
      last_mission = subject.all("ul#missions-list li").last.text
      expect(last_mission).to include(mission1.name)
    end
  end

  context "when searching for missions" do
    let!(:mission1) { create(:mission, name: "Learn Rails", state: "pending") }
    let!(:mission2) { create(:mission, name: "Learn RSpec", state: "in_progress") }
    let!(:mission3) { create(:mission, name: "Learn JavaScript", state: "completed") }
    before do
      visit "/missions"
    end

    context "when searching by name" do
      before do
        fill_in I18n.t("missions.index.search_placeholder"), with: "Rails"
        click_button I18n.t("missions.index.search_btn")
      end
      it "finds missions by name" do
        expect(page).to have_content("Learn Rails")
      end
      it "does not show non-matching missions" do
        expect(page).not_to have_content("Learn RSpec")
        expect(page).not_to have_content("Learn JavaScript")
      end
    end

    context "when searching by state" do
      before do
        fill_in I18n.t("missions.index.search_placeholder"), with: "completed"
        click_button I18n.t("missions.index.search_btn")
      end
      it "finds missions by state" do
        expect(page).to have_content("Learn JavaScript")
      end
      it "does not show non-matching missions" do
        expect(page).not_to have_content("Learn Rails")
        expect(page).not_to have_content("Learn RSpec")
      end
    end

    context "when searching with mixed case" do
      before do
        fill_in I18n.t("missions.index.search_placeholder"), with: "rAiLs"
        click_button I18n.t("missions.index.search_btn")
      end
      it "finds missions by name regardless of case" do
        expect(page).to have_content("Learn Rails")
      end
      it "does not show non-matching missions" do
        expect(page).not_to have_content("Learn RSpec")
        expect(page).not_to have_content("Learn JavaScript")
      end
    end

    context "when there are no matching results" do
      before do
        fill_in I18n.t("missions.index.search_placeholder"), with: "Python"
        click_button I18n.t("missions.index.search_btn")
      end
      it "shows no results message" do
        expect(page).to have_content(I18n.t("missions.index.no_results"))
      end
    end
  end

  context "when sorting missions by priority" do
    let!(:low_priority_mission) { create(:mission, name: "Low Priority", priority: 0) }
    let!(:medium_priority_mission) { create(:mission, name: "Medium Priority", priority: 1) }
    let!(:high_priority_mission) { create(:mission, name: "High Priority", priority: 2) }
    before do
      visit "/missions"
      select "依優先順序排序", from: "sort"
      click_button I18n.t("missions.index.sort_btn")
    end

    it { is_expected.to have_css("#missions-list li:first-child", text: "High Priority") }

    it { is_expected.to have_css("#missions-list li:last-child", text: "Low Priority") }
  end
end
