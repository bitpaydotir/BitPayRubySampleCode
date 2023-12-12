class BitpayController < ApplicationController
	protect_from_forgery with: :null_session
	def pay
		if !params['amount'].blank?
			if params['amount'].to_i > 999
				
				amount = params['amount']
				
				require 'open-uri'
				require 'net/http'
				params = {'api' => 'YOUR-API-CODE', 'amount' => amount, 
						  'redirect'=> 'http://localhost:3000/bitpay/verify', 'name'=> '', 'email'=>'', 'description'=>'', 'factorId'=> 0}
				url = URI.parse('http://bitpay.ir/payment/gateway-send')
				resp = Net::HTTP.post_form(url, params)
				
				puts resp.body
				
				
				gateResult	= resp.body.to_i
				
				if gateResult > 0
				
					redirect_to "http://bitpay.ir/payment/gateway-"+resp.body
					
				else
				
					@result = "خطا در اتصال به درگاه ، شناسه خطا :"+resp.body
					
				end
				
				
			else
				@result = "مبلغ نا معتبر است"
			end
		else
			@result = "مبلغ را وارد کنید"
		end
	end
	
	def verify
		if !params['trans_id'].blank?
			if !params['id_get'].blank?
				
				id_get 		= params['id_get']
				trans_id	= params['trans_id']
				factorId	= params['factorId']
				
				require 'open-uri'
				require 'net/http'
				
				
				#'amount'=>1 #add to params result equiv to get amount 
				params = {'api' => 'YOUR-API-CODE', 'id_get'=>id_get, 'trans_id'=>trans_id}
				url = URI.parse('http://bitpay.ir/payment/gateway-result-second')
				resp = Net::HTTP.post_form(url, params)
				
				puts resp.body
				
				
				gateResult	= resp.body.to_i
				
				if gateResult == 1
				
					render :plain => "تراکنش با موفقیت انجام شد"
					
				else
				
					render :plain => "تراکنش با خطا مواجه شد، شناسه خطا :"+resp.body
					
				end
				
				
			else
				redirect_to "http://localhost:3000/pay/"
			end
		else
			redirect_to "http://localhost:3000/pay/"
		end
	end
end
