Rails.application.routes.draw do
  
  get 'bitpay' => 'main#pay'
  match '/pay' => 'bitpay#pay', via: :post
  match '/pay' => 'bitpay#pay', via: :get
  post 'bitpay/verify' => 'Application'
  get 'bitpay/verify' => 'Application'
end
