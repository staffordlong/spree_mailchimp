module Spree
  Order.class_eval do

    after_save :sync_mailchimp_cart

    private

    def sync_mailchimp_cart
      if mailchimp_order
        if self.complete?
          mailchimp_order.delete_cart(self)
          mailchimp_order.create_or_update_order(self)
        else
          mailchimp_order.create_or_update_cart(self)
        end
      end
    end


    def mailchimp_order
      @mc_order ||= SpreeMailchimp::Order.new
    end
  end
end
