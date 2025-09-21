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
end
