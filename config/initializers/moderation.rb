# This is use to simplify adding moderation (rejecting and accepting) by adding methods to a model
# and then pointing to a controller to add accept and reject methods
#
# Example:
#
# class MyModel
#   include Moderation
#   moderate_controller MyController
# end

module Moderation
  extend ActiveSupport::Concern
  
  def accept!
    self.update_attribute(:state, BusinessListing::APPROVED)
  end
  
  def reject!
    self.update_attribute(:state, BusinessListing::REJECTED)
  end
  
  
  module ClassMethods
    def moderate_controller(controller)
      controller.class_eval { include ControllerActions }
    end
  end
   
  module ControllerActions
    def accept
      @obj = resource.class.find(resource.id)
      @obj.accept!
      
      default_url = url_for(params).split("/")
      default_url.delete_at(-1)
      default_url.delete_at(-1)
      default_url = default_url.join("/")
      
      respond_to do |format|
        format.html { redirect_to default_url }
        format.js   { render :template => "admin/common/moderate" }
      end
    end
    
    def reject 
      @obj = resource.class.find(resource.id)
      @obj.reject!

      default_url = url_for(params).split("/")
      default_url.delete_at(-1)
      default_url.delete_at(-1)
      default_url = default_url.join("/")

      respond_to do |format|
        format.html { redirect_to default_url }
        format.js   { render :template => "admin/common/moderate" }
      end
    end
  end  
end