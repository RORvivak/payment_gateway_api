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
		input_flag = valid_input(payload_with_sha)
		
		if (input_flag)
			transaction_response = transaction_response_generator(payload_with_sha)
			response_parameters = response_parameter_generator(transaction_response)  
			render json: { status: 200, gateway_response: transaction_response, output_parameters: response_parameters }
		else
			render json: { status: 500, txn_status: "failure" }
		end		
	end	
end
