class CategorySweeper < ActionController::Caching::Sweeper
  observe Category
  
  def after_save(category)
    clean_popular_categories(category)
  end
  
  def after_destroy(category)
    clean_popular_categories(category)
  end
  
  private
  
  def clean_popular_categories(category)
    if category.territory.blank?
      Territory.all.each { |t| expire_fragment("#{t.id}_popular_categories") }
    else
      expire_fragment("#{category.territory.id}_popular_categories")
    end
  end
end