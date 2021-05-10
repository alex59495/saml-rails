SAML_SETTINGS = {
  'example': {
    issuer: "my-single-tenant",
    idp_sso_target_url: "https://idp.ossoapp.com/saml-login",
    idp_cert: Rails.application.credentials.idp_cert,
  }
}

Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth::MultiProvider.register(
    self,
    provider_name: :saml,
    identity_provider_id_regex: /[a-z]*/,
    path_prefix: '/auth/saml',
    callback_suffix: 'callback',
  ) do |identity_provider_id, rack_env|
    request = Rack::Request.new(rack_env)
    SAML_SETTINGS[identity_provider_id.chomp('/callback').to_sym].merge({
      assertion_consumer_service_url: acs_url(request.url)
    })
  end

  def acs_url(request_url)
    url = request_url.chomp('/callback')
    url + '/callback'
  end
end