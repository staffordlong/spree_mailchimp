module SpreeMailchimp
  class Order < Base

    def create_or_update_cart(order)
      begin
        @gibbon.ecommerce.stores(Spree::Config[:mailchimp_store_id]).carts(order.number).retrieve
        update_cart(order)
      rescue
        create_cart(order)
      end
    end

    def create_or_update_order(order)
      begin
        @gibbon.ecommerce.stores(Spree::Config[:mailchimp_store_id]).orders(order.number).retrieve
        update_order(order)
      rescue
        create_order(order)
      end
    end

    def create_order(order)
      begin
        @gibbon.ecommerce.stores(Spree::Config[:mailchimp_store_id]).orders.create(body: order_data(order))
      rescue
      end
    end

    def update_order(order)
      begin
        @gibbon.ecommerce.stores(Spree::Config[:mailchimp_store_id]).orders(order.number).update(body: order_data(order))
      rescue
      end
    end

    def create_cart(order)
      begin
        @gibbon.ecommerce.stores(Spree::Config[:mailchimp_store_id]).carts.create(body: cart_data(order))
      rescue
      end
    end

    def update_cart(order)
      begin
        @gibbon.ecommerce.stores(Spree::Config[:mailchimp_store_id]).carts(order.number).update(body: cart_data(order))
      rescue
      end
    end

    def delete_cart(order)
      begin
        @gibbon.ecommerce.stores(Spree::Config[:mailchimp_store_id]).carts(order.number).delete
      rescue
      end
    end


    private

    def cart_data(order)
      {
        id: order.number,
        customer: customer_data(order),
        checkout_url: "https://www.aphidlondon.com/cart",
        currency_code: order.currency,
        order_total: order.total.to_f,
        lines: line_data(order)
      }
    end

    def order_data(order)
      {
        id: order.number,
        customer: customer_data(order),
        currency_code: order.currency,
        order_total: order.total.to_f,
        lines: line_data(order)
      }
    end

    def customer_data(order)
      if order.user.present?
        SpreeMailchimp::Customer.new.create_or_update(order.user)
        { id: "customer-#{order.user_id}" }
      else
        {
          id: "guest-#{order.id}",
          email_address: order.email,
          opt_in_status: order.guest_mailchimp_opt_in
        }.tap do |data|
          data.merge({
            first_name: order.ship_address.firstname,
            last_name: order.ship_address.lastname,
            address: address_data(order.ship_address)
          }) if order.ship_address.present?
        end
      end
    end

    def address_data(address)
      {
        address1: address.address1,
        address2: address.address2,
        city: address.city,
        province: address.state_name,
        postal_code: address.zipcode,
        country: address.country,
        country_code: address.country.iso
      }
    end

    def line_data(order)
      [].tap do |lines|
        order.line_items.each do |item|
          lines << {
            id: "line_item-#{item.id}",
            product_id: "product-#{item.product.id}",
            product_variant_id: "variant-#{item.variant_id}",
            quantity: item.quantity,
            price: item.price.to_f
          }
        end
      end
    end
  end
end
