class ViewablePurchase < ActiveRecord::Base
  belongs_to :customer
 belongs_to :user
 has_many :ups_ins
  has_many :purchases_entries, :foreign_key => "purchase_id"
  belongs_to :ship_to
  has_one :quote_tender_entry, :foreign_key => "purchase_id"
	belongs_to :shipping_service
  
end
