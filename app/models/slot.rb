class Slot < ActiveRecord::Base
  belongs_to :bundle

  mount_uploader :file, FileUploader

  validates :file, :possible_downloads, presence: true

  before_create :set_file_size
  after_destroy :check_for_bundle_destroy
  
  state_machine :state, :initial => :not_encrypted do
    state :not_encrypted
    state :encrypted
    
    event :finish_encrypt do
      transition :not_encrypted => :encrypted
    end
    
    event :finish_decrypt do
      transition :encrypted => :not_encrypted
    end
  end
  
  def encrypt(password)
    tmp_file = AES_crypt(password) { |c| c.encrypt }
    File.unlink self.file.path
    FileUtils.move tmp_file, self.file.path
    finish_encrypt!
  end
  
  def decrypt(password)
    AES_crypt(password) { |c| c.decrypt }
  end

  def downloaded
    self.possible_downloads -= 1
    self.destroy if self.possible_downloads <= 0
  end
  
  private
    
    def AES_crypt(password)
      c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
      yield c
      c.key = Digest::SHA256.digest(password)
      c.iv = Digest::SHA1.digest(password)
      output = Tempfile.new('slot', :external_encoding => Encoding::ASCII_8BIT)
      File.open(self.file.path,'rb') do |file|
        while buf = file.read(4096)
          output.write(c.update(buf))
        end
        file.close
      end
      output.write(c.final)
      output.close
      output.path
    end

    def set_file_size
      if file.present?
        self.size = file.file.size
      end
    end

    def check_for_bundle_destroy
      self.bundle.destroy if self.bundle.slots.blank?
    end
end
