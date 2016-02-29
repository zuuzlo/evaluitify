module ItemsHelper

  def item_image(item)
    image_tag("#{item.image_url}", size: "125x125", alt: "#{item.title}")
  end
end
