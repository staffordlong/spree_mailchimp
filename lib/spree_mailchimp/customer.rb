module SpreeMailchimp
  class Customer < Base

    def create_or_update(user)
      begin
        @gibbon.ecommerce.stores(Spree::Config[:mailchimp_store_id]).customers("customer-#{user.id}").retrieve
        update(user)
      rescue
        create(user)
      end
    end

    def create(user)
      begin
        @gibbon.ecommerce.stores(Spree::Config[:mailchimp_store_id]).customers.create(body: customer_data(user))
      rescue
      end
    end

    def update(user)
      begin
        @gibbon.ecommerce.stores(Spree::Config[:mailchimp_store_id]).customers("customer-#{user.id}").update(body: subscriber_data(user))
      rescue
      end
    end

    private

    def customer_data(user)
      {
        id: "customer-#{user.id}",
        email_address: user.email,
        opt_in_status: user.mailchimp_opt_in,
      }.tap do |data|
        data.merge({
          firstname: user.ship_address.firstname,
          lastname: user.ship_address.lastname,
          address: address_data(user)
        }) if user.ship_address.present?
      end
    end

    def address_data(user)
      return nil unless user.ship_address
      {
        address1: user.ship_address.address1,
        address2: user.ship_address.address2,
        city: user.ship_address.city,
        province: user.ship_address.state_name,
        postal_code: user.ship_address.zipcode,
        country: user.ship_address.country,
        country_code: user.ship_address.country.iso
      }
    end
  end
end
