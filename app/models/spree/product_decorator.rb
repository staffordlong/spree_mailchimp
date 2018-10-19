module Spree
  Product.class_eval do
    after_save :sync_mailchimp_product

    private

    def sync_mailchimp_product
      mailchimp_product.create_or_update(self) if mailchimp_product
    end


    def mailchimp_product
      @mc_product ||= SpreeMailchimp::Product.new
    end
  end
end
