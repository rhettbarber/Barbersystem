class SublimationEntry  < ActiveRecord::Base


 @@SOURCE_FOLDER =   "Z:\\\\"

 @@SOURCE_FILE_EXTENSION   = ".jpg"

 @@sublimation_standard_category_class_ids = ["26", "27","15"]

 @@OUTPUT_LOCATION  = "Z:\\\\PRODUCTION_SYSTEM\\REVIEW\\"

 @@OUTPUT_EXTENSION  = ".jpg"

 @@ALL_OVER_SOURCE_LOCATION  = "Z:\\\\PRODUCTION_SYSTEM\\ALL-OVER-T-JPG\\"

def is_custom_sublimation?
          if self.name == "sublimation_shirts"
                    if self.Comment.to_s.include? 'sublim'
                                   true
                    else
                                  false
                     end
          else
                               false
            end
end



def transfer_type_name
  if self.Comment.to_s.include? 'sublim9'
    return    "sublim9"
  elsif self.Comment.to_s.include? "sublim12"
    return    "sublim12"
  elsif self.Comment.to_s.include?  "sublim14"
    return    "sublim14"
  elsif self.Comment.to_s.include?  "sublimfull"
    return    "sublimfull"
  elsif self.Comment.to_s.include?  "sublimaot"
    return    "sublimaot"
  else
    return    ""
  end
end



def sublimation_transfer_width
             return  '1000'
end




  def regular_transfer_width
              logger.debug "##################################"
              logger.debug "begin sublimation_entry.regular_transfer_width"
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
                          sublimation_width_string  =    self.SubDescription3
                          logger.debug "##################################"
                          logger.debug "sublimation_entry.id: " + self.id.to_s
                          logger.debug "sublimation_width_string: " + sublimation_width_string

                           if self.Comment.to_s.include? 'sublim9'
                                          sublimation_width   =       "1800"
                           elsif self.Comment.to_s.include? "sublim12"
                                        sublimation_width   =       "2400"

                           elsif self.Comment.to_s.include?  "sublim14"
                                        sublimation_width   =       "2800"
                           elsif self.Comment.to_s.include?  "sublimfull"
                                        sublimation_width   =       "3000"
                           else
                                        sublimation_width   =       "error"
                           end
              end
              return sublimation_width

              logger.debug "end sublimation_entry.big_front_width"
              logger.debug "##################################"
  end


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
             logger.debug "self.PriceLevel.to_s: " +  self.PriceLevel.to_s
              if    ["0", "1", ""].include?   self.PriceLevel.to_s
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
                            label_string  =    Slug.generate_keep_zero(  the_master_pe.purchase_id.to_s  + "_"  + type_of_shirt + "_" +  the_master_pe.ItemLookupCode + "_" +  the_master_pe.Description  )
              else
                            logger.debug " NOT the_master_pe ##################################"
                            label_string  =  Slug.generate_keep_zero( self.purchase_id.to_s  + "_"  + type_of_shirt + "_" + self.ItemLookupCode + "_" +  self.Description )
                            logger.debug "##################################"
                            logger.debug "sublimation_entry.id: " + self.id.to_s
                            logger.debug "label_string: " + label_string.to_s
              end
              logger.debug "label_string: " + label_string.to_s
              return label_string

  end





def all_over_root_filename
                   return       self.ItemLookupCode.gsub(/[^0-9\-]/, '')
end



 def itemlookupcode_root_filename
                    return       self.ItemLookupCode
 end




def comment_custom_filename
                  sublimation_width_string  =    self.Comment.split("_").second.gsub(".jpg","").gsub(".png", "")
                  # if sublimation_width_string and sublimation_width_string.is_number?
                  #             sublimation_width   =       sublimation_width_string
                  # else
                  #             sublimation_width     = 'no_comment_size'
                  # end
                  return sublimation_width_string
end


 def complete_filename
   Slug.generate_keep_zero self.ItemLookupCode
 end

 def type_of_shirt
    new_line = self.ItemLookupCode.slice(self.ItemLookupCode.length - 1).downcase
     g = "g"
     if new_line == "p"
          return "POLYESTER"
     elsif new_line == 'c'
          return "COTTON"
     else
          return 'UNKNOWN'
     end
 end




 def file_url_front
             if self.name == "all_over_item"
                                       return       @@ALL_OVER_SOURCE_LOCATION  +  self.all_over_root_filename       + "-0" + @@SOURCE_FILE_EXTENSION
             elsif  self.name == "sublimation_shirts"
                                      return       "Z:\\\\ALL-OVER-T-CUSTOM-AUTOMATED\\"  +  self.comment_custom_filename + "-0" + @@SOURCE_FILE_EXTENSION
             else
                                       return      "W:\\\\AUTOMATION_DATABASE\\ORIGINAL_JPG\\"  + self.itemlookupcode_root_filename   + "" + @@SOURCE_FILE_EXTENSION
             end
end

def file_url_back
              if self.name == "all_over_item"
                         return         @@ALL_OVER_SOURCE_LOCATION  +  self.all_over_root_filename   + "-1" + @@SOURCE_FILE_EXTENSION
              elsif  self.name == "sublimation_shirts"
                          return       "Z:\\\\ALL-OVER-T-CUSTOM-AUTOMATED\\"  +  self.comment_custom_filename  + "-1" + @@SOURCE_FILE_EXTENSION
              else
                           return      "W:\\\\AUTOMATION_DATABASE\\ORIGINAL_JPG\\"  +  self.itemlookupcode_root_filename + "" + @@SOURCE_FILE_EXTENSION
              end
end


def hot_folder_url_front(iteration_number=1)
             return    @@OUTPUT_LOCATION +       self.purchase_id.to_s   + "__" + self.id.to_s  + "__" + type_of_shirt + "__" +   self.ItemLookupCode      + "-FRONT-file#" + iteration_number.to_i.to_s + @@OUTPUT_EXTENSION
end

def hot_folder_url_back(iteration_number=1)
             return    @@OUTPUT_LOCATION +      self.purchase_id.to_s   + "__" + self.id.to_s  + "__" + type_of_shirt + "__" +  self.ItemLookupCode     + "-BACK-file#" + iteration_number.to_i.to_s  + @@OUTPUT_EXTENSION
end













end
