require 'digest/sha2'

class Bundle < ActiveRecord::Base
  attr_accessor :password

  validates :url_id, :destroy_code, :possible_downloads, presence: true
  validates :password, presence: true, if: -> { self.new_record? }
  validates_uniqueness_of :id
  validates :slots, presence: true, if: -> { self.text.blank? }
  validates :text, presence: true, if: -> { self.slots.blank? && self.text.present? }

  has_many :slots, dependent: :destroy

  accepts_nested_attributes_for :slots, reject_if: ->(a) { a[:file].blank? }

  before_validation :generate_ids
  before_validation :set_possible_downloads
  before_create :encrypt_text, if: ->{ self.text.present? }
  after_create :add_crypt_job
  
  def self.attributes_protected_by_default
    ["type"]
  end
  
  state_machine :state, :initial => :pending do
    state :pending
    state :processing
    state :ready
    after_transition :pending => :processing, :do => :crypt_slots_and_text
    
    event :start_encrypting do
      transition :pending => :processing
    end
    
    event :finish_encrypting do
      transition all => :ready
    end
  end
  
  def encrypt_slots
    slots.each { |slot| slot.encrypt @password }
  end
  
  def decrypt_text(for_owner=false)
    text = AES_crypt_text(self.text, @password){ |c| c.decrypt }
    if self.slots.blank? && !for_owner.eql?(true)
      self.possible_downloads -= 1
      if self.possible_downloads <= 0
        self.destroy
      else
        self.update_column(:possible_downloads, self.possible_downloads)
      end
    end
    text.force_encoding(Encoding::UTF_8)
  end

  def check_password(password)
    @password = password
    begin
      if self.text.present?
        decrypt_text
      else
        slots.first.decrypt password
      end
      true
    rescue
      false
    end
  end

  def to_param
    self.url_id
  end

  private

    def encrypt_text
      self.text = AES_crypt_text(self.text, @password){ |c| c.encrypt }.force_encoding(Encoding::ASCII_8BIT)
    end

    def crypt_slots_and_text
      encrypt_slots
      finish_encrypting!
    end

    def add_crypt_job
      Delayed::Job.enqueue Workers::EncryptJob.new(self.id.to_s, @password)
    end

    def generate_ids
      self.url_id = SecureRandom.hex if self.url_id.blank?
      self.destroy_code = SecureRandom.hex if self.destroy_code.blank?
    end

    def AES_crypt_text(text, password)
      c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
      yield c
      c.key = Digest::SHA256.digest(password)
      c.iv = Digest::SHA1.digest(password)
      c.update(text) << c.final
    end

    def set_possible_downloads
      self.slots.each do |slot|
        slot.possible_downloads = self.possible_downloads
      end
    end
end
