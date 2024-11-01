class CategoriesController < ApplicationController
  def index
    @categories = Category.active_root_categories_for( @territory )
    @categories = chunk_array( @categories, 3 )
  end
end