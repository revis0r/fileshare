class Workers::ZipJob < Struct.new(:bundle_id)
  def perform
    bundle = Bundle.find(bundle_id)
    begin
      bundle.start_process!
      bundle.make_zip_archive
      bundle.finish_process!
    rescue OpenSSL::Cipher::CipherError
      bundle.finish_process!
    end
  end
end
