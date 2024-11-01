module CategoriesHelper  
  def parent_category_options
    category_options
  end
  
  def category_options
    cats = Category.roots_and_territory_categories( @territory )
    results = cats.collect { |cat| [ cat.path_name_cache.html_safe, cat.id ] }
    results.sort_by { |c| c[0] }
  end

  def simple_full_category_name(category)
    category.path_name_cache
  end

  def full_category_name(category,options={})
    categories, name = category.self_and_ancestors.sort_by { |x| x.lft }, ""
    categories.each do |cat|
      if options[:links]
        unless cat == category
          html_link = content_tag(:li, link_to(cat.name, territory_category_path(@territory, cat.slugger)))
          name += html_link
        else
          name += content_tag(:li, cat.name)
        end
      else
        name += cat == categories[-1] ? cat.name : "#{cat.name}&nbsp;&rsaquo;&nbsp;"
      end
    end
    name.html_safe
  end

  def popular_categories_for(territory)
    categories = Category.popular_categories_for(territory)
    chunk_array( categories, 2 )
  end

end