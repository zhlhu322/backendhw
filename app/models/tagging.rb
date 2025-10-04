class Tagging < ApplicationRecord
  belongs_to :mission
  belongs_to :tag, optional: true
end
