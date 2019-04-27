class GatewaysController < ApplicationController
	include TransactionHelper

	def message_generator
		value = params_separator(params)
		payload_with_sha = hash_generator(value)
		aes_128_encrypted_value = aes128_cbc_encrypt(payload_with_sha)
		base_64_value = base_64_encryption(aes_128_encrypted_value)
		
		if !(payload_with_sha.blank? || aes_128_encrypted_value.blank? || base_64_value.blank?)
			render json: { status: 200, payload_to_pg: base_64_value }
	  else
	  	render json: { status: 500, error: "Data processing error" }
	  end	
	end

	def transaction
		aes128_encrypted_value = base_64_decryption(params[:msg]).force_encoding('iso-8859-1')
		payload_with_sha = aes128_cbc_decrypt(aes128_encrypted_value)
		render json: { status: 200, value: payload_with_sha }
	end	
end
