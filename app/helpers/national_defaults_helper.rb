module NationalDefaultsHelper
  def decode_defaults(content)
    return content.gsub("NEW_show_your_support_page",territory_show_your_support_path(@territory)).
                  gsub("NEW_promote_your_business_page",territory_promote_your_business_path(@territory)).
                  gsub("NEW_apply_today_page",territory_advertise_with_us_path(@territory)).
                  gsub("(territory_name)","#{@territory.name}").
                  gsub("/business_listings",territory_categories_path(@territory)).
                  gsub("/coupons",territory_coupons_path(@territory)).
                  gsub("/jobs",territory_jobs_path(@territory)).
                  gsub("contact_us","contact-us").
                  gsub("/contact_us",territory_contact_us_path(@territory)).
                  gsub("/contact-us",territory_contact_us_path(@territory)).
                  gsub("../../../contact-us",territory_contact_us_path(@territory))
  end
end