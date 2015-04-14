class CloneItemType < ActiveRecord::Base


has_one :category

has_many :clone_item_requests
has_many :clone_items
validates_uniqueness_of :name, :message => " - This Clone Item Type has already been created."

 @@TEMPLATE_PATH =  'W://AUTOMATION_DATABASE/TEMPLATES/'

  default_scope order("Name ASC")


  def unfinished_rms_requests
          ur  = []
          self.clone_item_requests.each do | cir |
                      unless Item.exists?([ "ItemLookupCode = ?", cir.clone_item_type.prefix_code + '-'  +  cir.item.ItemLookupCode.gsub('L', '')  ] ) or ItemClass.exists?([ "ItemLookupCode = ?", cir.clone_item_type.prefix_code + '-'  +  cir.item.ItemLookupCode.gsub('L', '')  ] )
                        ur << cir
                      end
          end
            return ur
  end

  def unfinished_rms_requests_count
        return unfinished_rms_requests.size
  end

  def unfinished_file_requests
          ur  = []
          self.clone_item_requests.each do | cir |
                      unless File.file?( 'W:\\AUTOMATION_DATABASE\\PRODUCTION_FILES\\' + cir.clone_item_type.name + '\\' + cir.clone_item_type.prefix_code + '-' +   cir.item.ItemLookupCode.gsub('L', '')  + cir.clone_item_type.production_extension )
                        ur << cir
                      end
          end
            return ur
  end

  def unfinished_file_requests_count
            return unfinished_file_requests.size
  end


def template_file_name_with_path
      return  @@TEMPLATE_PATH +  self.slug_name   +  '.psd'
end


def template_file_exists?
      return File.exists?(   self.template_file_name_with_path )
end

def self.names
    @names = []
    self.all.each do |the_type|
      @names << the_type.name
    end
    return @names
  end


def original_item_location
    '/images/item_specsheets/' +  self.original_item.PictureName + '/'
end


def location
       '/AUTOMATION_DATABASE/PRODUCTION_JPG/' +  self.folder_name + '/'
end

  def slug_name
    trim( self.name.gsub(/[^a-z1-9]+/i, '-'))
  end

  def folder_name
        slug_name
  end

  def trim(string)
    while string[string.length - 1, string.length] == '-'
      string = string.chop
    end
    string
  end



end

