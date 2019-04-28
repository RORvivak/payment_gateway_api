module TransactionHelper
	extend ActiveSupport::Concern

	def params_separator(params)
		response = []
		params.each { |variable, key| response << variable+"="+key.to_s+"|" }
		length = (response.length - 3)
		response[0..length].join("")
	end

	def hash_generator(string_with_separator)
		digest = Digest::SHA1.hexdigest(string_with_separator.chop)
		string_with_separator+"hash=#{digest}"
	end

	def aes128_cbc_encrypt(data)
	  aes = OpenSSL::Cipher::AES128.new(:CBC)
	  aes.encrypt
	  aes.key =  ENV["encrypt_key"]
	  aes.update(data) + aes.final
  end

  def aes128_cbc_decrypt(data)
	  aes = OpenSSL::Cipher::AES128.new(:CBC)
	  aes.decrypt
	  aes.key =  ENV["encrypt_key"]
	  aes.update(data) + aes.final
  end	

  def base_64_encryption(string_value)
  	Base64.encode64(string_value)
  end

  def base_64_decryption(base_64_encrypted_value)
  	Base64.decode64(base_64_encrypted_value)
  end

  def valid_input(input)
  	splitted_input = input.split("|hash=")
  	sha_digest_value = Digest::SHA1.hexdigest(splitted_input[0])
  	(sha_digest_value == splitted_input[1]) ? true : false 	
  end

  def transaction_response_generator(intermediate_output)
  	intermediate_output_array = intermediate_output.split("|")
  	intermediate_output_array.pop
  	intermediate_output_array.shift(2)
    response = intermediate_output_array.join("|")

  	transaction_reference_no = ("pg_txn_" + DateTime.now.to_i.to_s)
  	final_response = ("txn_status=success|" + response +	"|payment_gateway_transaction_reference=" + transaction_reference_no)
    (final_response + "|hash=" +  Digest::SHA1.hexdigest(final_response)).gsub("|", "\"") 	
  end   	
end 	