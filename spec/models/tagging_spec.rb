require 'spec_helper'
require 'rails_helper'

RSpec.describe Tagging, type: :model do
  it { should belong_to(:mission) }
  it { should belong_to(:tag).optional }
end
