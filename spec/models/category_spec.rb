require 'rails_helper'

RSpec.describe Category, type: :model do
  it { should have_many(:subcategories).class_name('Category').with_foreign_key('parent_id').dependent(:destroy) }
  it { should belong_to(:parent_category).class_name('Category').with_foreign_key('parent_id').dependent(:destroy)  }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:ebay_id) }

  before do
    test_xls = Roo::Excel.new("#{Rails.root}/spec/support/test_files/models/ebayCategories.xls")
    #Roo::Excel.stub_chain(:new).and_return( test_xls )
    allow(Roo::Excel).to receive(:new).and_return( test_xls )
    Category.load_categories
  end

  describe "load_categories" do

    it "has 10 categories" do
      expect(Category.count).to eq(20)
    end

    it "Contractor Guides has 9 subcategories" do
      expect(Category.find_by_name('Contractor Guides').subcategories.count).to eq(10)
    end

    it "has right Ebay_id" do
      expect(Category.first.ebay_id).to eq(12576)
    end

    it "has right name" do
      expect(Category.last.name).to eq('Other')
    end
  end

  describe "#top_categories" do
    it "get top categories" do
      expect(Category.top_categories.count).to eq(1)
    end

    it "top categories don't have parents" do
      expect(Category.top_categories.first.parent_id).to be_nil
    end

  end

  describe "#has_subcategories?" do
    let(:cat1) { Fabricate(:category) }
    let(:cat2) { Fabricate(:category, parent_id: cat1.id) }

    it "return false for no subcategories" do
      expect(cat2.has_subcat?).to be false
    end

    it "returns true for subcategories" do
      expect(cat1.has_subcat?).to be true
    end
  end

  describe "#level" do
    let(:cat4) { Category.find_by_ebay_id(66944) }
    let(:cat3) { Category.find_by_ebay_id(42300) }
    let(:cat2) { Category.find_by_ebay_id(41498) }
    let(:cat1) { Category.find_by_ebay_id(11765) }

    it "has level 4" do
      expect(cat4.level).to eq(4)
    end

     it "has level 3" do
      expect(cat3.level).to eq(3)
    end

     it "has level 2" do
      expect(cat2.level).to eq(2)
    end

     it "has level 1" do
      expect(cat1.level).to eq(1)
    end

    it "level 0 for top category" do
      expect(Category.first.level).to eq(0)
    end
  end
end
