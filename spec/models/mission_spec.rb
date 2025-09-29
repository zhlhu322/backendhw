require 'spec_helper'
require 'rails_helper'

RSpec.describe Mission, type: :model do
  context "validations" do
    context "when creating a mission with valid attributes" do
      let(:mission) { build(:mission) }
      it "is valid" do
        expect(mission).to be_valid
      end
    end

    context "when creating a mission without a name" do
      let(:mission) { build(:mission, name: nil) }
      it "is not valid without a name" do
        expect(mission).not_to be_valid
      end
      it "has the correct error message" do
        mission.valid? # 要先觸發驗證才會有errors[]
        expect(mission.errors[:name]).to include("can't be blank")
      end
    end

    context "when creating a mission without a description" do
      let(:mission) { build(:mission, description: nil) }
      it "is not valid without a description" do
        expect(mission).not_to be_valid
      end
      it "has the correct error message" do
        mission.valid?
        expect(mission.errors[:description]).to include("can't be blank")
      end
    end
  end

  context ".search" do
    before(:each) { Mission.destroy_all }
    before do
      create(:mission, name: "Learn Rails", state: "pending")
      create(:mission, name: "Learn RSpec", state: "in_progress")
      create(:mission, name: "Learn JavaScript", state: "completed")
    end

    it "returns missions matching the name query" do
      results = Mission.search("Rails")
      expect(results.count).to eq(1)
      expect(results.first.name).to eq("Learn Rails")
    end

    it "returns missions matching the state query" do
      results = Mission.search("completed")
      expect(results.count).to eq(1)
      expect(results.first.name).to eq("Learn JavaScript")
    end

    it "is case insensitive for name search" do
      results = Mission.search("learn rails")
      expect(results.count).to eq(1)
      expect(results.first.name).to eq("Learn Rails")
    end

    it "returns an empty result when no matches are found" do
      results = Mission.search("Python")
      expect(results.count).to eq(0)
    end
  end
end
