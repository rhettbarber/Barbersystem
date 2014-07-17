class Sale < ActiveRecord::Base

  has_one :viewable_purchase
  belongs_to :purchases_entries_for_commission




  has_one :sales_by_affiliate

  belongs_to :purchase
  belongs_to :customer
  has_many :sales_entries
  has_one :shipping_entry


  attr_accessible :cashier_id

  @@link_affiliate_percentage = 0.05
  @@recruited_affiliate_percentage = 0.01







  def association_function
    xxxx
    'purchases_entry_id' + 'purchase_id'
  end












  def shipping_charge
    if  self.shipping_entry
      return self.shipping_entry.shipping_charge
    else
      return 0.0
    end
  end



  def total_before_shipping
    if self.Total > 0
      if self.shipping_entry
        if self.SalesTax > 0
          return  self.Total -   self.shipping_entry.shipping_charge - self.SalesTax
        else
          return  self.Total -   self.shipping_entry.shipping_charge
        end
      else
        return  self.Total
      end
    else
      return 0.0
    end
  end

  def self.recruited_affiliate_percentage
    @@recruited_affiliate_percentage
  end



  def self.link_affiliate_percentage
    @@link_affiliate_percentage
  end


  def total_payable
    if self.Total > 0
      if self.total_returned < 0
        return  total_before_shipping + self.total_returned
      else
        return total_before_shipping
      end
    else
      0
    end
  end



  def total_returned
    conditions = ["recall_id = ? and RecallType = ?", self.id,  '1' ]
    @artfts = Sale.sum("Total", :conditions => conditions)
    if @artfts < 0
      return @artfts
    else
      return 0
    end
  end


  def recruited_affiliate_payable_sale_amount
    return  total_payable * @@recruited_affiliate_percentage
  end




  def link_affiliate_payable_sale_amount
    return  total_payable * @@link_affiliate_percentage
  end


  def  self.qualifying_time
    Time.now - 30.days
  end




  def payable_qualification_information
    self.purchase.affiliate_paid != 1 and  self.sale_time <  Sale.qualifying_time

  end





end
