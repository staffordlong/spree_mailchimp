require "spree_core"
require "spree_mailchimp/engine"
require "spree_mailchimp/version"

module SpreeMailchimp
  class List    
    require "gibbon"

    # TODO allow configuration of timeout
    def initialize
      return false unless mailchimp_configured?
      @gibbon = Gibbon::Request.new(api_key: Spree::Config[:mailchimp_api_key])
      @gibbon.timeout = 5
    end

    # TODO allow merge tags to be sent
    # TODO do not fail silently
    def subscribe(user)
      begin
        @gibbon.lists(Spree::Config[:mailchimp_list_id]).members.create(body: subscriber_data(user))
      rescue
      end
    end

    # TODO do not fail silently
    def update(user)
      begin
        @gibbon.lists(Spree::Config[:mailchimp_list_id]).members(member_hash(user)).upsert(body: subscriber_data(user))
      rescue
      end
    end


    # TODO do not fail silently
    def unsubscribe(user)
      begin
        @gibbon.lists(Spree::Config[:mailchimp_list_id]).members(member_hash(user)).update(body: { status: "unsubscribed" })
      rescue
      end
    end

    private

    # Check the mailchimp configuration variables are set
    def mailchimp_configured?
      !(Spree::Config[:mailchimp_api_key].nil? ||
        Spree::Config[:mailchimp_api_key].empty? ||
        Spree::Config[:mailchimp_list_id].nil? ||
        Spree::Config[:mailchimp_list_id].empty?
      )
    end

    # Member hash for existing subscribers
    def member_hash(user)
      Digest::MD5.hexdigest(user.email.downcase)
    end

    # Merge fields for a user
    def merge_fields(user)
      unless user.bill_address.nil?
        {FNAME: user.bill_address.firstname, LNAME: user.bill_address.lastname}
      else
        {}
      end
    end

    # The data for a subscriber
    def subscriber_data(user)
      {email_address: user.email, merge_fields: merge_fields(user), status: "subscribed"}
    end

  end
end