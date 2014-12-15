class SublimationEntry  < ActiveRecord::Base



 def big_front_width
        logger.debug "##################################"
        logger.debug "  the_pe.PriceLevel: " +   self.PriceLevel.to_s
        if    ["0", "1"].include?   self.PriceLevel.to_s
                  logger.debug "##################################"
                  logger.debug "Customer has 0,1 PriceLevel. Check Opposite for dimension"
                  the_real_pe = PurchasesEntry.find(self.id)
                  the_master_pe = the_real_pe.master_of_symbiont_pair
        else
                  logger.debug "##################################"
                  logger.debug "Customer has singular type PriceLevel. Do not  Check Opposite for dimension"

        end
        if the_master_pe
                    logger.debug "##################################"
                    logger.debug "the_master_pe.id: " + the_master_pe.id.to_s
                    sublimation_width_string  =    the_master_pe.item.SubDescription3     #.split("_").second
                    if sublimation_width_string and sublimation_width_string.is_number?
                               sublimation_width   =       sublimation_width_string
                    end
        else
                    sublimation_width_string  =    self.SubDescription3.split("_").first
                    if sublimation_width_string and sublimation_width_string.is_number?
                                sublimation_width   =       sublimation_width_string
                    end
        end
  end






def all_over_root_filename
                   return       self.ItemLookupCode.gsub(/[^0-9\-]/, '')
end


 def big_front_root_filename
                 # self.PictureName.gsub(".jpg", "").gsub(".png", "").split("_").first
                    return       self.ItemLookupCode
 end



 def file_url_back
               if self.name == "all_over_item"
                          return         "W:\\\\AUTOMATION_DATABASE\\PRODUCTION_FILES\\ALL-OVER-T\\"  +  self.all_over_root_filename   + "-1.jpg"
               else
                             return      "W:\\\\AUTOMATION_DATABASE\\ORIGINAL_JPG\\"  +  self.big_front_root_filename + ".jpg"
                 end
 end

 def file_url_front
   if self.name == "all_over_item"
                    return       "W:\\\\AUTOMATION_DATABASE\\PRODUCTION_FILES\\ALL-OVER-T\\"  +  self.all_over_root_filename       + "-0.jpg"
   else
                     return      "W:\\\\AUTOMATION_DATABASE\\ORIGINAL_JPG\\"  + self.big_front_root_filename   + ".jpg"
   end
end


def hot_folder_url_front(iteration_number=1)
             return    "W:\\\\SUBLIMATION_HOT_FOLDER_REVIEW\\" +      self.purchase_id.to_s   + "-" + self.id.to_s  + "-" +    self.all_over_root_filename      + "-0.jpg"
end

def hot_folder_url_back
             return     "W:\\\\SUBLIMATION_HOT_FOLDER_REVIEW\\" +      self.purchase_id.to_s   + "-" + self.id.to_s  + "-" +    self.all_over_root_filename     + "-1.jpg"
end













end
