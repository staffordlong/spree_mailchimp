module SpreeMailchimp
  class Product < Base

    def create_or_update(product)
      begin
        @gibbon.ecommerce.stores(Spree::Config[:mailchimp_store_id]).products("product-#{product.id}").retrieve
        update(product)
      rescue
        create(product)
      end
    end

    def create(product)
      begin
        @gibbon.ecommerce.stores(Spree::Config[:mailchimp_store_id]).products.create(body: product_data(product))
      rescue
      end
    end

    def update(product)
      begin
        @gibbon.ecommerce.stores(Spree::Config[:mailchimp_store_id]).products("product-#{product.id}").update(body: product_data(product))
      rescue
      end
    end

    private

    def product_data(product)
      product_image = product.images.count > 1 ? product.images.second.attachment.url(:large) : nil
      {
        id: "product-#{product.id}",
        title: product.name,
        handle: product.slug,
        url: "https://www.aphidlondon.com/products/#{product.slug}",
        description: product.description,
        image_url: product_image,
        variants: product.variants.collect do |variant|
          variant_data(variant)
        end
      }
    end

    def variant_data(variant)
      {
        id: "variant-#{variant.id}",
        title: variant.option_values.collect{|ov| "#{ov.option_type.name}: #{ov.name}"}.join(', '),
        sku: variant.sku,
        price: variant.price
      }
    end
  end
end
