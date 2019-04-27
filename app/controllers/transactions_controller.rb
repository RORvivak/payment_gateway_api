class TransactionsController < ApplicationController
	include TransactionHelper

	def information_generator
		value = params_separator(params)
		payload_with_sha = hash_generator(value)
		encrypted_value = aes128_cbc_encrypt(payload_with_sha)
		base_64_value = base_64_encryption(encrypted_value)
		
		if !(payload_with_sha.blank? || encrypted_value.blank? || base_64_value.blank?)
			render json: { status: 200, payload_to_pg: base_64_value }
	  else
	  	render json: { status: 500, error: "Data processing error" }
	  end	
	end

	def transaction
		render json: { status: 200, base_64_value: base_64_decryption(param[:msg]) }
	end	


	
end
