class TagsController < ApplicationController
  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      flash[:notice] = "標籤建立成功"
    end
  end

  private
  def tag_params
    params.require(:tag).permit(:name)
  end
end
