class PurchasesEntryDetail < ActiveRecord::Base
   belongs_to :purchases_entry
   belongs_to :listing_purchases_entry
   belongs_to :purchase
   belongs_to :machine
   belongs_to :request_type, :foreign_key => "detail_type_id"
   belongs_to :employee, :foreign_key => "artist_customer_id"

   attr_accessible :holding_for_department_id, :reason_for_holding, :detail_description, :detail_type_id   , :art_due_date, :artist_customer_id, :machine_id, :rush_charge, :similar_artwork_done, :film_number   , :listing_purchase_id   , :colors ,:ship_due_date, :per_piece, :ink_changes_charge, :art_charge , :art_supplied  , :layered_art, :see_folder


end
