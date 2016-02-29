require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "#most_watched" do
    context "no params" do
      before(:example) do
        stub_request(:get, /svcs.ebay.com/).
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'svcs.ebay.com', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => File.read("#{Rails.root}/spec/json_responses/models/item/get_most_watched_items"), :headers => {'Content-Type' => 'application/json'})
      end
      
      let(:items) { Item.most_watched }

      it "creates new items" do
        #items = Item.most_watched
        expect(items.count).to eq(3)
      end

      it "second item has title" do
        #items = Item.most_watched
        expect(items[2].title).to eq("Apple iPhone 5S 16GB \"Factory Unlocked\" 4G LTE iOS Smartphone")
      end

      it "third item has current_price" do
        #items = Item.most_watched
        expect(items[2].buy_now_price).to eq("192.95")
      end
    end

    context "with category id params" do
      before(:example) do
        stub_request(:get, /svcs.ebay.com.*267/).
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'svcs.ebay.com', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => File.read("#{Rails.root}/spec/json_responses/models/item/get_most_watched_items_cat"), :headers => {'Content-Type' => 'application/json'})
      end
      
      let(:items) { Item.most_watched({categoryId: 267}) }

      it "creates new items" do
        #items = Item.most_watched
        expect(items.count).to eq(3)
      end

      it "second item has title" do
        #items = Item.most_watched
        expect(items[2].title).to eq("2400 Gun Manuals Gunsmith Rifle Carbine Pistol Revolver Shotgun Firearm on DVD")
      end

      it "third item has current_price" do
        #items = Item.most_watched
        expect(items[2].buy_now_price).to eq("7.85")
      end
    end
  end
  describe "#item_category_name" do
    let!(:category1) { Fabricate(:category, ebay_id: 100) }
    let(:item1) {Item.new(category_id: 100)}

    it "returns name of category" do
      expect(item1.item_category_name).to eq(category1.name)
    end
  end
end