class Revision < ActiveRecord::Base


  belongs_to :page
  belongs_to :user
  attr_accessible :content, :redirect_to, :published


def self.search( keywords, website) ## not flexible but works # too slow

if !keywords.to_s.strip.empty?
	      tokens = keywords.split.collect {|c| "%#{c.downcase}%"}	
		if tokens.size == 1
			conditions = ["website_id  = ? and content like ?     or website_id  = ? and name like ?",  website.id , tokens[0] ,      website.id , tokens[0] ]
		elsif tokens.size == 2
			conditions = ["website_id  = ? and content like ?     or website_id  = ? and  name like ?    or website_id  = ? and content like ?    or website_id  = ? and  name like ?",    website.id ,tokens[0] ,     website.id ,tokens[0] ,    website.id ,tokens[1] ,     website.id ,tokens[1]  ]
		elsif tokens.size == 3
			conditions = ["website_id  = ? and content like ?     or website_id  = ? and  name like ?    or website_id  = ? and content like ?    or website_id  = ? and  name like ?    or website_id  = ? and content like ?    or website_id  = ? and name like ?",  website.id ,tokens[0] ,  website.id ,tokens[0] ,  website.id ,tokens[1],  website.id ,tokens[1] ,  website.id ,tokens[2] ,  website.id ,tokens[2]  ]
		elsif tokens.size == 4
			conditions = ["website_id  = ? and content like ?     or website_id  = ? and  name like ?    or website_id  = ? and content like ?    or website_id  = ? and  name like ?    or website_id  = ? and content like ?    or website_id  = ? and name like ?    or website_id  = ? and content like ?    or website_id  = ? and name like ?",   website.id ,tokens[0] ,  website.id ,tokens[0] ,  website.id ,tokens[1] ,  website.id ,tokens[1],  website.id ,tokens[2] ,  website.id ,tokens[2] ,  website.id ,tokens[3] ,  website.id ,tokens[3]  ]
		end		
			if !conditions.nil?
				return find(:all,:conditions => conditions ,:limit => 30  )  
		 	else
		 		[]
		 	end	
  	else
  		[]
  	end
end
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 def self.find_latest_published_revision_ids
          all_pages = Page.find :all
          revision_ids = []
          all_pages.each do |page|
          revision_ids <<
                if page.revisions
                  first_public_revision = page.revisions.find(:first, :conditions => ["published = ?", true], :order => "created_at DESC")
                  first_public_revision.id if first_public_revision
                end
        end
              return revision_ids
 end
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  def page_name
    return "#{self.page.name}"
  end
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
  def revisions
    	@revisions = Revision.find(:all, :conditions => ["page_id = ? ", page_id], :order => "created_at DESC")
  end
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  def author
    if user != nil
      user
    else
      User.new :email => "system"
    #  User.new :username => "system", :name => "System"
    end
  end

  def only?
    if Revision.count(:conditions => ["page_id = ?", page.id]) == 1
      return true
    else
      return false
    end
  end

  def most_recent_published?
    if Revision.find_most_recent(self.page.id) ==  self.id
      return true
    else
      return false
    end
  end


  def self.most_recent?(revision)
    if Revision.find_most_recent(revision.page).id == revision.id
      return true
    else
      return false
    end
  end

    def self.find_most_recent(page)
    Revision.find(:first, :conditions => ["page_id = ? ", page.id   ], :order => "created_at DESC")  if page
    #Revision.find(:first, :conditions => ["page_id = ? and published = ?", page.id  ,  true ], :order => "created_at DESC")
  end

  def self.most_recent_published?(revision)
    if Revision.find_most_recent_published(revision.page).id == revision.id
      return true
    else
      return false
    end
  end



  def self.find_most_recent_published(page)
       return page.revisions.where("published = ?", true).order("created_at DESC").first
    #.find(:first, :conditions => ["page_id = ? AND published = ?", page.id, true  ]
  end
  

  
  def self.website_id_scope_revision_testing 
  with_scope(:find => {:conditions => 'website_id = 1'}) do
    yield
  end
end
  
  #def most_recent_published_BEFORE?
  #  if Revision.find_most_recent(self.page).id ==  self.id
  #    return true
  #  else
  #    return false
  #  end
  #end
  
  
  
end