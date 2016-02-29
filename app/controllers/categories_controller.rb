class CategoriesController < ApplicationController

  respond_to :js, :html

  def most_watched
    @category = Category.find(params[:id])
    item_params = { 'categoryId' => "#{@category.ebay_id}"}
    @items = Item.most_watched(item_params)
    #render 'shared/display_items', locals: { title: @category.name }
  end

  def show_subcategories
    @category = Category.find(params[:id])
    @categories = @category.subcategories
    @level = @category.level
  end

  def hide_subcategories
    @category = Category.find(params[:id])
    @level = @category.level
  end
end
