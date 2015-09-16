class QuantityDiscount < ActiveRecord::Base
attr_accessible :Description
has_one :item


def Price1_profit_margin 
		cost =  self.item.Cost
		 profit = self.Price1 - cost
		 margin = profit / cost * 100.0
end


def Price1A_profit_margin 
		cost =  self.item.Cost
		 profit = self.Price1A - cost
		 margin = profit / cost * 100.0
end


def Price1B_profit_margin 
		cost =  self.item.Cost
		 profit = self.Price1B - cost
		 margin = profit / cost * 100.0
end


def Price1C_profit_margin 
		cost =  self.item.Cost
		 profit = self.Price1C - cost
		 margin = profit / cost * 100.0
end
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################

def use_pre_tier_price(quantity)
     quantity0 = 0
     quantity1 = self.Quantity1
     if  quantity1 == 0
             quantity1 = 5000
      end
      use_pre_tier_price =  quantity.between?(quantity0,quantity1)
      use_pre_tier_price = false if quantity >= quantity1
      use_pre_tier_price
end

def use_price_1(quantity)
    quantity1 = self.Quantity1
    quantity2 = self.Quantity2
    quantity2 = quantity2 - 1
    if quantity2 == -1
          quantity2 = 5000
    end
      use_price_1 =  quantity.between?(quantity1,quantity2)
      use_price_1 = false if quantity1 == 0
      use_price_1
end

def use_price_2(quantity)
    quantity2 = self.Quantity2
    quantity3 = self.Quantity3
    quantity3 = quantity3 - 1
    if quantity3 == 0 or quantity3 == -1
          quantity3 = 5000
    end
      use_price_2 =  quantity.between?(quantity2,quantity3)
      use_price_2 = false if quantity2 == 0
      use_price_2
end

def use_price_3(quantity)
    quantity3 = self.Quantity3
    quantity4 = self.Quantity4
    quantity4 = quantity4 - 1
    if quantity4 == 0 or quantity4 == -1
          quantity4 = 5000
    end
      use_price_3 =  quantity.between?(quantity3,quantity4)
      use_price_3 = false if quantity3 == 0
      use_price_3
end

def use_price_4(quantity)
    quantity4 = self.Quantity4
    quantity5 = 5000
      use_price_4 =  quantity.between?(quantity4,quantity5)
      use_price_4 = false if quantity4 == 0
      use_price_4
end


end
