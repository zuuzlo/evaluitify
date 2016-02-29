class ItemsController < ApplicationController

  def index
    @items = Item.most_watched
    @categories = Category.top_categories
    @title = "Top"
    render 'shared/display_items', locals: { title: @title }
  end
end
