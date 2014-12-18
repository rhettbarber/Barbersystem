class SublimationEntry  < ActiveRecord::Base



 def big_front_width
              logger.debug "##################################"
              logger.debug "begin sublimation_entry.big_front_width"
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
                          logger.debug " the_master_pe ##################################"
                          logger.debug "the_master_pe.id: " + the_master_pe.id.to_s
                          sublimation_width_string  =    the_master_pe.item.SubDescription3     #.split("_").second
                          if sublimation_width_string and sublimation_width_string.is_number?
                                     sublimation_width   =       sublimation_width_string
                          else
                                    sublimation_width     = false
                            end
              else
                           logger.debug " NOT the_master_pe ##################################"
                          sublimation_width_string  =    self.SubDescription3.split("_").first
                          logger.debug "##################################"
                          logger.debug "sublimation_entry.id: " + self.id.to_s
                          logger.debug "sublimation_width_string: " + sublimation_width_string.to_s
                          if sublimation_width_string and sublimation_width_string.is_number?
                                        logger.debug "sublimation_width_string and sublimation_width_string.is_number?"
                                      sublimation_width   =       sublimation_width_string
                          else
                                        logger.debug "NOT sublimation_width_string and sublimation_width_string.is_number?"
                                        sublimation_width     = false
                            end
              end
              return sublimation_width

              logger.debug "end sublimation_entry.big_front_width"
              logger.debug "##################################"
  end



  def label
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
                            logger.debug " the_master_pe ##################################"
                            logger.debug "the_master_pe.id: " + the_master_pe.id.to_s
                            label_string  =    Slug.generate(   the_master_pe.ItemLookupCode + "_" +  the_master_pe.Description  )
              else
                            logger.debug " NOT the_master_pe ##################################"
                            label_string  =  Slug.generate(   self.ItemLookupCode + "_" +  self.Description )
                            logger.debug "##################################"
                            logger.debug "sublimation_entry.id: " + self.id.to_s
                            logger.debug "label_string: " + label_string.to_s
              end
              return label_string

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
             return    @@OUTPUT_LOCATION +       self.purchase_id.to_s   + "-" + self.id.to_s  + "-" +    self.all_over_root_filename      + "-0-" + iteration_number.to_i.to_s  + ".jpg"
end

def hot_folder_url_back(iteration_number=1)
             return    @@OUTPUT_LOCATION +      self.purchase_id.to_s   + "-" + self.id.to_s  + "-" +    self.all_over_root_filename     + "-1-" + iteration_number.to_i.to_s  + ".jpg"
end













end
