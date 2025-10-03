require 'spec_helper'
require 'rails_helper'

RSpec.describe Tagging, type: :model do
  let(:mission) { create(:mission) }
  let!(:existing_tag) { create(:tag, name: "緊急") }

  it { should belong_to(:mission) }
  it { should belong_to(:tag).optional }

  describe "before_validation :find_or_create_tag" do
    context "when tag name is present and tag already exists" do
      let(:tagging) { mission.taggings.build(tag_name: "緊急") }

      it "should use the existing Tag and not create a new one" do
        expect { tagging.valid? }.not_to change(Tag, :count)
        expect(tagging.tag).to eq(existing_tag)
        expect(tagging.tag_id).to eq(existing_tag.id)
      end
    end

    context "when tag name is present but tag does not exist" do
      let(:new_tag_name) { "新項目" }
      let(:tagging) { mission.taggings.build(tag_name: new_tag_name) }

      it "should create a new Tag and assign its ID to the tagging" do
        expect { tagging.valid? }.to change(Tag, :count).by(1)
        expect(tagging.tag.name).to eq(new_tag_name)
      end
    end

    context "when tag_id is already set" do
      let(:tagging) { Tagging.new(mission: mission, tag: existing_tag, tag_name: "will_be_ignored") }
      it "should skip the lookup/creation logic and keep the existing tag_id" do
        expect(Tag).not_to receive(:find_or_create_by!)
      end
      it "should valid" do
        tagging.valid?
        expect(tagging.tag_id).to eq(existing_tag.id)
      end
    end

    context "when tag_name is blank or empty" do
      let(:tagging_empty) { mission.taggings.build(tag_name: "") }
      it "should not create any Tag and leave tag_id as nil" do
        expect { tagging_empty.valid? }.not_to change(Tag, :count)
        expect(tagging_empty.tag_id).to be_nil
      end
    end

    context "when tag_name is blank" do
      let(:tagging_blank) { mission.taggings.build(tag_name: "  ") }
      it "should not create any Tag and leave tag_id as nil" do
        expect { tagging_blank.valid? }.not_to change(Tag, :count)
        expect(tagging_blank.tag_id).to be_nil
      end
    end
  end
end
