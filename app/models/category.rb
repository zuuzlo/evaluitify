class Category < ActiveRecord::Base
  require 'roo'
  require 'roo-xls'

  has_many :subcategories, :class_name => "Category", :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent_category, :class_name => "Category", :foreign_key=>"parent_id", :dependent => :destroy

  validates :name, presence: true
  validates :ebay_id, presence: true

  def self.load_categories
    xls = Roo::Excel.new("#{Rails.root}/ebayCategories.xls")
    xls.default_sheet = xls.sheets.first
    2.upto(xls.last_row.to_i) do | line |
      category_hash = {}
      %w(H G F E D C B).each do | col |
        unless xls.cell(line, col).nil?
          category_hash[:name] = xls.cell(line, col)
          category_hash[:ebay_id] = xls.cell(line, 'I').to_i
          new_category = Category.new(category_hash)
          new_category.parent_id = Category.find_by_ebay_id(xls.cell(line, 'J').to_i).id unless xls.cell(line, 'I').to_i == xls.cell(line, 'J').to_i
          new_category.save
          break
        end
      end
    end
  end

  def self.top_categories
    Category.where(parent_id: nil)
  end

  def has_subcat?
    self.subcategories.exists?
  end

  def level
    return 0 if self.parent_id.nil?

    parent = Category.find(self.parent_id)
    i = 1
    
    until parent.parent_id.nil? || i > 5
      i +=1 
      parent = Category.find(parent.parent_id)
    end 
    return i
  end
end
