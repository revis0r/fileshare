class Workers::DecryptJob < Struct.new(:bundle_id, :password)
  def perform
    bundle = Bundle.find(bundle_id)
    begin
      bundle.decrypt_slots(password)
      bundle.finish_process
      bundle.remove_slot_after_download = true
      bundle.save
    rescue OpenSSL::Cipher::CipherError
      bundle.finish_process!
    end
  end
end
