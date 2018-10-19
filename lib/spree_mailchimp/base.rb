module SpreeMailchimp
  class Base
    require "gibbon"

    # TODO allow configuration of timeout
    def initialize
      return false unless mailchimp_configured?
      @gibbon = Gibbon::Request.new(api_key: Spree::Config[:mailchimp_api_key])
      @gibbon.timeout = 5
    end

    private

    # Check the mailchimp configuration variables are set
    def mailchimp_configured?
      !(Spree::Config[:mailchimp_api_key].nil? ||
        Spree::Config[:mailchimp_api_key].empty? ||
        Spree::Config[:mailchimp_list_id].nil? ||
        Spree::Config[:mailchimp_list_id].empty? ||
        Spree::Config[:mailchimp_store_id].nil? ||
        Spree::Config[:mailchimp_store_id].empty?
      )
    end
  end
end
