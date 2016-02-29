class Item
  include ActiveModel::Model
  require 'rebay2'
  attr_accessor :title, :url_link, :image_url, :buy_now_price, :current_price, :category_id, :watch_count

  def self.most_watched(params=nil)
    merch = Rebay2::Merchandising.new
    response = merch.get_most_watched_items(params)
    items = []
    response.each do | item |

      new_item = Item.new
      new_item.title = item["title"]
      new_item.category_id = item["primaryCategoryId"]
      new_item.url_link = item["viewItemURL"]
      new_item.image_url = item["imageURL"]
      new_item.buy_now_price = item["buyItNowPrice"]["__value__"]
      new_item.current_price = item["currentPrice"]["__value__"] if item["currentPrice"]
      new_item.watch_count = item["watchCount"]
      items << new_item
    end

    items
  end

  def item_category_name
    Category.find_by_ebay_id(self.category_id.to_i).name
  end
end