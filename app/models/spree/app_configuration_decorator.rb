module Spree
  AppConfiguration.class_eval do
    preference :mailchimp_api_key, :string
    preference :mailchimp_list_id, :string
    preference :mailchimp_store_id, :string
    preference :mailchimp_checkbox_during_registration, :boolean, default: false
    preference :mailchimp_user_must_opt_in, :boolean, default: true
  end
end
