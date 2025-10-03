class Tagging < ApplicationRecord
  belongs_to :mission
  belongs_to :tag, optional: true

  attr_accessor :tag_name
  before_validation :find_or_create_tag

  private

  def find_or_create_tag
    return if self.tag_id.present?
    tag_name_to_use = self.tag_name.to_s.strip
    return if tag_name_to_use.blank?
    self.tag = Tag.find_or_create_by!(name: tag_name_to_use)
  end
end
