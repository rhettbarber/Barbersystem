class Tender < ActiveRecord::Base

has_many :quote_tender_entries


def self.for_credit_card(purchase,form_parameters)
                                              quote_tender_entry =  QuoteTenderEntry.new
                                               quote_tender_entry.AdditionalDetailType =  0                                            
                                                quote_tender_entry.AllowMultipleEntries =  0        
                                               quote_tender_entry.CashBackFee =  0                                                                                              
                                                quote_tender_entry.CashBackLimit =  0        
                                                quote_tender_entry.Code =  0                                                       
                                                quote_tender_entry.CurrencyID =  0                                                       
                                               quote_tender_entry.DebitSurcharge =  0                                                        
                                                quote_tender_entry.Description =  0                                                       
                                                quote_tender_entry.DisplayOrder =  0                                                       
                                                quote_tender_entry.DoNotPopCashDrawer =  0                                                       
                                                quote_tender_entry.GLAccount =  0                                                       
                                               quote_tender_entry.HQID =  0                                                        
                                               quote_tender_entry.MaximumAmount =  0                                                        
                                               quote_tender_entry.PreventOverTendering =  0                                                        
                                               quote_tender_entry.PrinterValidation =  0                                                        
                                               quote_tender_entry.RoundToValue =  0                                                        
                                               quote_tender_entry.ScanCode =  0                                                        
                                               quote_tender_entry.SignatureRequired =  0                                                        
                                                quote_tender_entry.SupportCashBack =  0                                                       
                                               quote_tender_entry.ValidationLine1 =  0                                                        
                                               quote_tender_entry.ValidationLine2 =  0     
                                                quote_tender_entry.ValidationLine3 =  0                                                                                                 
                                               quote_tender_entry.ValidationMask =  0      
                                               quote_tender_entry.VerificationType =  0      
                                                quote_tender_entry.VerifyViaEDC =  0     
                                              quote_tender_entry.save
                                              quote_tender_entry
end






end


