OmniAuth.config.logger = Rails.logger

file_contents = YAML.load(File.read("config/google_auth.yml")) rescue Hash.new
GOOGLE_AUTH = (file_contents||Hash.new)[Rails.env] || {}

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, GOOGLE_AUTH["key"], GOOGLE_AUTH["secret"], {
    scope: "glass.timeline,glass.location,userinfo.profile,userinfo.email",
    prompt: "consent select_account",
    access_type: "offline"
  }
end
