require 'net/http'

class CloneItem < ActiveRecord::Base
  belongs_to :clone_item_type
  belongs_to :item


  validates_uniqueness_of :clone_item_type_id, :scope => [:item_id], :message => "This clone item type already exists, you do not need to create it, update it if needed"

@@STOCK_DESIGN_PATH = 'Y://STORAGE_DISK_1/MAIN_FILES_STORAGE/ITEM_MANAGEMENT/STOCK_DESIGNS_BY_NUMBER/'
@@PRODUCTION_FILE_PATH = 'Y://STORAGE_DISK_1/MAIN_FILES_STORAGE/ITEM_MANAGEMENT/PRODUCTION_FILES/'
@@DESIGN_SEPARATION_PATH = 'Y://STORAGE_DISK_1/MAIN_FILES_STORAGE/ITEM_MANAGEMENT/DESIGN_SEPARATIONS/'
@@TEMPLATE_PATH = 'Y://STORAGE_DISK_1/MAIN_FILES_STORAGE/ITEM_MANAGEMENT/TEMPLATES/'
cattr_reader :per_page
@@per_page = 10


  def status_tip( the_status_name )
            the_tip_case = case the_status_name
            when  'stock_design_file_exists?' then   'Stock Design Location: <br>  ' +  self.stock_design_filename +  ' as .psd or .tif'
            when 'production_file_exists?' then  self.production_filename +  ' as .psd or .tif'
            when 'template_file_exists?' then  self.template_filename +  ' as .psd or .tif'
            when 'design_separation_file_exists?' then  'Main design separation location, Clones do not get separated:<br> ' + self.design_separation_filename +  ' as .psd or .tif'
            when 'prefix_is_set?' then 'The prefix is currently: ' +  self.clone.category.prefix
            when 'web_category_is_true?' then 'This items category web_category is to: ' +  self.clone.category.web_category
            when 'category_class_id_is_set?' then  'The category_class_id is currently: ' +  self.clone.category.category_class_id.to_s
            when 'thumbnail_image_exists?' then  self.item_thumbnail_filename
            when 'specsheet_image_exists?' then  self.item_specsheet_filename
            when 'item_is_webitem?' then 'WebItem is currently set to: ' +  self.clone.WebItem.to_s
            end
  end


  def clone
        if Item.exists?(self.clone_id)
                Item.find self.clone_id
        end
  end

  def call_method( method_name)
              method(method_name).call if method_name
  end

############    MULTIPLE CALL METHODS    ##########################
def all_systems_go?
       if production_ready? and web_ready?
             true
       else
             false
       end
end

def production_ready?
        if clone
                   if  self.clone.stock_design_file_exists? and
                        self.clone.production_file_exists? and
                        self.clone.template_file_exists?
                                  true
                    else
                                  false
                    end
        else
                false
        end
end

def web_ready?
                    if prefix_is_set? and
                      web_category_is_true? and
                      category_class_id_is_set? and
                      thumbnail_image_exists? and
                      specsheet_image_exists? and
                      item_is_webitem?
                    true
           else
                      false
           end
 end

def production_ready_status_image_name
      if self.clone
          if self.production_ready?
                      '/images/icons/production_ready.jpg'
                else
                        '/images/icons/production_incomplete.jpg'
                end
      else
                '/images/icons/production_incomplete.jpg'
      end
end

def web_ready_status_image_name
      if self.clone
                if self.web_ready?
                            '/images/icons/web_ready.jpg'
                      else
                              '/images/icons/web_incomplete.jpg'
                      end
      else
                 '/images/icons/web_incomplete.jpg'
      end
end
#############    ONLINE METHODS    #################################
def item_is_webitem?
      self.clone.WebItem?
end

def specsheet_image_exists?
    if Net::HTTP.get_response(URI.parse( self.item_specsheet_filename  )).code == "200"  #other response is message
                true
      else
               false
      end
end

def item_specsheet_filename
       'http://localhost:7000/images/item_specsheets/' + self.clone.PictureName
end

def thumbnail_image_exists?
    if Net::HTTP.get_response(URI.parse( self.item_thumbnail_filename  )).code == "200"
                true
      else
               false
      end
end

def item_thumbnail_filename
         'http://localhost:7000/images/item_thumbnails/' + self.clone.PictureName
end
#############    PRODUCTION METHODS    ############################


  def design_separation_file_exists?
           if File.exists?(   self.design_separation_filename   +  '.psd')  or   File.exists?(  self.design_separation_filename   +  '.tif')
                true
           else
                false
           end
  end

def design_separation_filename
          @@DESIGN_SEPARATION_PATH +  self.item.bare_filename
end


def stock_design_file_exists?
      if File.exists?( self.stock_design_filename   +  '.psd') or  File.exists?( self.stock_design_filename   +  '.tif')
                true
      else
               false
      end
end

def stock_design_filename
           @@STOCK_DESIGN_PATH  +  self.clone.bare_filename
end

def production_file_exists?
      if File.exists?( self.production_filename   +  '.psd') or  File.exists?( self.production_filename   +  '.tif')
                true
      else
               false
      end
end

  def production_filename
           @@PRODUCTION_FILE_PATH + self.clone_item_type.slug_name + '/'   +  self.clone.bare_filename
  end


def template_file_exists?
      if File.exists?( self.template_filename   +  '.psd') or  File.exists?( self.template_filename   +  '.tif')
                true
      else
               false
      end
end

def template_filename
           @@TEMPLATE_PATH  +  self.clone_item_type.slug_name
end
########    CATEGORY SETUP FOR WEB METHODS    #########################

def web_category_is_true?
      self.clone.category.web_category != '0'
end

def category_class_id_is_set?
      self.clone.category.category_class_id != 31
end

 def prefix_is_set?
     self.clone.category.prefix != '0'
end






































  #########################################################################################################


#def production_file_name_with_path( original_item_picturename )
#      return  @@PRODUCTION_FILE_PATH  +  self.clone_item_type.slug_name + '/'  + original_item_picturename
#end
#
#
#def production_file_exists?( original_item_picturename )
#            return File.exists?(   self.production_file_name_with_path( original_item_picturename ) )
#end
#
#








  
end

