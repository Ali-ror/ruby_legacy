require 'spec_helper'

describe CategoriesHelper do
  before(:each) do
    @category = Factory.create(:category, :name => "Toys")
  end
  
  describe "#full_category_name" do
    it "should display a full inheritance to category" do
      @category2 = Factory.create(:category, :name => "Cars", :parent => @category)
      @category3 = Factory.create(:category, :name => "Porsche", :parent => @category2)
      
      full_category_name(@category3).should == "Toys&nbsp;&rsaquo;&nbsp;Cars&nbsp;&rsaquo;&nbsp;Porsche"
    end
    
    it "should display a short inheritance of category" do
      @category2 = Factory.create(:category, :name => "Cars", :parent => @category)
      @category3 = Factory.create(:category, :name => "Porsche", :parent => @category2)
      
      full_category_name(@category2).should == "Toys&nbsp;&rsaquo;&nbsp;Cars"
    end
  end
end