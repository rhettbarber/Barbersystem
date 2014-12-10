class SublimationEntry  < ActiveRecord::Base



def all_over_root_filename
                   return       self.ItemLookupCode.gsub(/[^0-9\-]/, '')
end


 def big_front_root_filename
                 self.PictureName.gsub(".jpg", "").gsub(".png", "").split("_").first
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


def hot_folder_url_front
             return    "W:\\\\SUBLIMATION_HOT_FOLDER_REVIEW\\" +      self.purchase_id.to_s   + "-" + self.id.to_s  + "-" +    self.all_over_root_filename    + "-0.jpg"
end

def hot_folder_url_back
             return     "W:\\\\SUBLIMATION_HOT_FOLDER_REVIEW\\" +      self.purchase_id.to_s   + "-" + self.id.to_s  + "-" +    self.all_over_root_filename     + "-1.jpg"
end













end
