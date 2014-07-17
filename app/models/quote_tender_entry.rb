class QuoteTenderEntry < ActiveRecord::Base

	belongs_to :purchase
	belongs_to :tender

	validates_presence_of  :CreditCardExpiration, :CreditCardNumber ,:CreditCardApprovalCode
	validates_presence_of :purchase_id, :tender_id, :Amount
	validates_length_of :CreditCardNumber, :maximum => 20
	validates_length_of :CreditCardNumber, :minimum => 7
	validates_length_of :CreditCardApprovalCode, :maximum => 20

	attr_accessible :tender_id, :CreditCardNumber, :CreditCardExpiration, :CreditCardApprovalCode

  def self.months
    [    [1, '1'] ,   [ 2, '2'],   [3, '3'],  [4, '4'],   [5, '5'],   [6, '6'],   [7, '7'],  [8, '8'],   [9, '9'],   [10, '10']  , [11, '11'],   [12, '12']  ]
  end
################################################################################################
  def self.years
	    start_year = Date.today.year
	    years = Array.new
	    #years = years << [" "]
	    10.times do
	      years <<  [ start_year , start_year.to_s ]
	      start_year += 1
	    end
    return years
  end
################################################################################################
	def self.for_credit_card(purchase,form_parameters)
				quote_tender_entry =  QuoteTenderEntry.new
				quote_tender_entry.Amount =  77
				quote_tender_entry.purchase_id =  purchase
				quote_tender_entry.tender_id =  8
				quote_tender_entry.CreditCardExpiration =  form_parameters.CreditCardExpiration
				quote_tender_entry.CreditCardNumber =  form_parameters.CreditCardNumber
				quote_tender_entry.CreditCardApprovalCode = form_parameters.CreditCardApprovalCode
				quote_tender_entry.save
				quote_tender_entry
	end
################################################################################################

# Make sure these are only numbers
#  validates_format_of :CreditCardNumber, :with => /^[\d]*$/,
#                      :message => "Credit Card has wrong format"

#  validates_format_of :CreditCardApprovalCode, :with => /^[\d]*$/,
#                      :message => "Approval Code Invalid"




end
