module TransactionHelper
	extend ActiveSupport::Concern

	def params_separator(params)
		response = []
		params.each do |variable, key|
			response << variable+"="+key.to_s+"|"
		end
		length = (response.length - 4)
		response[0..length].join("")
	end

	def hash_generator(string_with_separator)
		digest = Digest::SHA1.hexdigest(string_with_separator.chop)
		string_with_separator+"hash=#{digest}"
	end

	def aes128_cbc_encrypt(data)
	   key = ENV["encrypt_key"]
	   aes = OpenSSL::Cipher::AES128.new(:CBC)
	   aes.key = key
	   aes.encrypt.final
  end

  def base_64_encryption(string_value)
  	Base64.encode64(string_value)
  end

  def base_64_decryption(base_64_encrypted_value)
  	Base64.decrypt64(base_64_encrypted_value)
  end   	

end 	