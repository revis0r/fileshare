class Workers::EncryptJob < Struct.new(:bundle_id, :password)
  def perform
    bundle = Bundle.find(bundle_id)
    bundle.password = password
    bundle.start_encrypting!
  end
end
