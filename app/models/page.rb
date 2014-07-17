class Page < ActiveRecord::Base

  attr_accessible :name, :slug



  Page.partial_updates = true

#default_scope  :conditions => { :website_id =>  Website.current_website_id }

#default_scope lambda do
#    { :conditions => [ "website_id = ?", Website.current_website_id.to_s ] }
#end

#default_scope  where( :website_id => 1 )
#default_scope  lambda { | current_website_id |  where("website_id = ?",   Website.current_website_id ) }

default_scope lambda { where(:website_id => Website.current_website_id ) }


belongs_to :website
has_many :revisions # , :dependent => :delete_all # do
belongs_to :page_type
#belongs_to    :parent, :class_name => "Page"
#has_many      :children, :class_name => "Page", :foreign_key => "parent_id", :order => "position", :dependent => :destroy
#	has_many :revisions, :dependent => :delete_all do
#		def latest_published
#			find(:first,:conditions =>  { 'published' => true }  , :order => 'created_at DESC')
#		end
#	end

	validates_presence_of :name, :on => :create, :message => "can't be blank"
	validates_uniqueness_of :name , :scope => :website_id                        #, :on => :save, :message => "must be unique"
	validates_uniqueness_of :slug  , :scope => :website_id    #, :on => :save, :message => "must be unique"

	#acts_as_tree  :order => "position"
  acts_as_tree_with_dotted_ids #:order => "position"

  #acts_as_list  :scope => :parent_id
	#attr_accessible :name,:slug, :parent_id


#	named_scope :latest_published_revision, :include => :revisions, :conditions => { 'revisions.published' => true }, :order => "revisions.created_at DESC"

#	named_scope :latest_published_revision,  :conditions => { :website_id => 1 }


  before_save :slug_name



  def delete_page_cache
    #C:\Users\RubyMine4\RubymineProjects\ThreeTwoThreeDevelopment\public\apache_root\christianoutfitters_us
    logger.warn( '##############################')
    logger.warn( '##############################')
    logger.warn( '##############################')
    logger.warn( '##############################')
    logger.warn( '#{Rails.root}/public/apache_root/*/' + self.slug.to_s )

    glob_cache_expire( '#{Rails.root}/public/apache_root/*/' + self.slug.to_s )

    logger.warn( '##############################')
    logger.warn( '##############################')
    logger.warn( '##############################')
    logger.warn( '##############################')

  end



  def all_decendants
          all = []
          self.children.each do |category|
                  all << category
                  root_children = category.all_decendants.flatten
                  all << root_children unless root_children.empty?
          end
    return all.flatten
  end



  def all_children_latest_published_revision_ids
          latest_published_revision_ids  = Set.new
          self.all_decendants.each do |the_child|
                    if the_child.revisions
                            first_public_revision = the_child.revisions.order( "created_at DESC").where("published = ?", true).first
                            latest_published_revision_ids.add(   first_public_revision.id  )        if first_public_revision
                    end
          end
          return latest_published_revision_ids.to_a.join(",")
  end





  def page_cache_expire
    #logger.debug "page_cache_expire cachepath: " + cachepath.inspect
    #glob_directories_to_expire = Dir.glob( cachepath )
    #logger.debug "glob_directories_to_expire: " + glob_directories_to_expire.inspect
    #FileUtils.rm_rf(Dir.glob( glob_directories_to_expire ))
    cachepath =  Rails.root.to_s + '/public/apache_root/*/page/' + self.slug.to_s + '.html'
    logger.debug "cachepath: " + cachepath.to_s

    cachepath_filenames_array = Dir.glob(cachepath )
    FileUtils.rm cachepath_filenames_array


  end



  def  most_recent_published_revision
    return self.revisions.where("published = ?", 1   ).order("created_at DESC").first
    #.find(:first, :conditions => ["page_id = ? AND published = ?", page.id, true  ]
  end

  def  most_recent_revision
            logger.warn "begin most_recent_xpublished_revision"
             Revision.unscoped do
                        return self.revisions.order("created_at DESC").first
                        #.find(:first, :conditions => ["page_id = ? AND published = ?", page.id, true  ]
            end
  end

  def  most_recent_xpublished_revision
            logger.warn "begin most_recent_xpublished_revision"
             Revision.unscoped do
                        return self.revisions.order("created_at DESC").first
                        #.find(:first, :conditions => ["page_id = ? AND published = ?", page.id, true  ]
            end
  end


 def ancestors_trail_string
               ancestors_trail_string = []
        for ancestor in self.ancestors
             ancestors_trail_string <<   ' -  ' + ancestor.name
      end
     ancestors_trail_string.to_s
 end
 
 
  
  def slug_name
    self.slug = Slug.generate(self.name)
  end
  
  def has_published_revision?
  #ORIGINAL..DIDNT WORK..  if Page.find_by_sql(["SELECT p.* from pages p LEFT JOIN revisions r ON p.id = r.page_id WHERE p.id = ? AND r.published = true", id]).size > 0

    revisions = Revision.find(:all, :conditions => ["page_id = ? and published = ?", id , -1  ])

    if  revisions.size > 0
      return true
    else
      return false
    end
  end
  
  def self.reset_child_positions(page)
    position = 1
    for child in page.children
      child.update_attribute('position', position)
      reset_child_positions(child)
      position = position + 1
    end
  end
  
  def self.find_testing(*args)
         options = extract_options_from_args!(args)
         validate_find_options(options)
         set_readonly_option!(options)
 
         case args.first
               when :first then
                website_id_scope_page do
                 find_initial(options)
                end
           
                  when :all   then 
                    website_id_scope_page  do
                         find_every(options)
                 end
           else             find_from_ids(args, options)
         end
end
  
  
end
