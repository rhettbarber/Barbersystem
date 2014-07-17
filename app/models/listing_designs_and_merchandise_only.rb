class ListingDesignsAndMerchandiseOnly  < ActiveRecord::Base
has_many :aliasings      ,  :foreign_key => "item_id"
belongs_to      :category
has_one :item_class_component , :foreign_key => "item_id"
has_one :item_class, :through => :item_class_component

#ALTER VIEW [dbo].[listing_designs_and_merchandise_only] WITH SCHEMABINDING AS
#SELECT     Notes, Description, ID AS id, ItemLookupCode, DepartmentID AS department_id, CategoryID AS category_id, PictureName, ExtendedDescription, SubDescription1,
#                      SubDescription2, SubDescription3, WebItem, Inactive, COALESCE (CAST( id AS varchar(MAX)), '')  + ' ' +  ItemLookupCode  + ' ' +  COALESCE (CAST( Notes AS varchar(MAX)), '')  + ' ' +  COALESCE (CAST( Description AS varchar(MAX)), '')   + ' ' +  COALESCE (CAST( ExtendedDescription AS varchar(MAX)), '')  AS items_combined
#FROM         dbo.Item
#WHERE     (CategoryID IN (10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 24, 27, 43, 22, 28, 26))






  def self.find_with_msfte(*args)
                options = self.options_from(args)
                $stdout.puts "options.inspect: " + options.inspect
                $stdout.puts "args.class: " + args.class.to_s
                $stdout.puts "args.inspect: " + args.inspect
                search_terms = self.my_quote_bound_value(self.query_from_options(args, options))
                $stdout.puts "search_terms.class: " + search_terms.class.to_s
                $stdout.puts "search_terms.inspect: " + search_terms.inspect
                search_string =   "EXEC sp_executesql N'SELECT TOP (100) [listing_designs_and_merchandise_only].* FROM [listing_designs_and_merchandise_only] JOIN CONTAINSTABLE([listing_designs_and_merchandise_only], (*), #{search_terms} ) as msfte_ctbl_0 ON [listing_designs_and_merchandise_only].[id] = msfte_ctbl_0.[key] ORDER BY msfte_ctbl_0.rank DESC'"
                $stdout.puts "search_string: " + search_string
                #@initial_items = ListingDesignsAndMerchandiseOnly.find_with_msfte :matches_any => ['deer', 'hunting' ]
                ListingDesignsAndMerchandiseOnly.transaction do
                     self.find_by_sql( search_string  )
                end
  end







        def self.my_quote_bound_value(value, c = connection) #:nodoc:
          $stdout.puts "value: " + value
          $stdout.puts "value.class: " + value.class.to_s
          #$stdout.puts "c:" + c.inspect
          if value.respond_to?(:map) && !value.acts_like?(:string)
            if value.respond_to?(:empty?) && value.empty?
              prevalue = c.quote(nil)
            else
              prevalue =  value.map { |v| c.quote(v) }.join(',')
            end
          else
            prevalue =  c.quote(value)
          end
           return  "N\'" +  prevalue.gsub("N", "") + "\'"
        end

    def self.find_with_msfte_junk (*args)
                ## options: {:joins=>" JOIN CONTAINSTABLE([listing_items], (*), N'\"deer\" | \"hunting\"') as msfte_ctbl_0 ON [listing_items].[id] = msfte_ctbl_0.[key]", :order=>"msfte_ctbl_0.rank DESC"}
                #  $stdout.puts "include_in_search.nil?"
                #$stdout.puts "############################## self.find_with_msfte (*keywords)"
                ##search_columns = self.safe_to_array(options.delete(:search_attributes) || "*")
                #search_terms = quote_bound_value(self.query_from_options(keywords, options))
                #quoted_search_columns = search_columns.map { |s| s == "*" ? s : "[#{s}]" }.join(",")
                #join = " JOIN CONTAINSTABLE(#{quoted_table_name}, (#{quoted_search_columns}), #{search_terms}) as #{self.ctbl[0]} ON #{quoted_table_name}.[#{primary_key}] = #{self.ctbl[0]}.[key]"
                ##(options[:joins] ||= "") << join
                ##options[:order] ||= "#{self.ctbl[0]}.rank DESC"
                #$stdout.puts "####################### self.find_or_paginate (klass, options): "
                ##$stdout.puts "options: " + options.inspect
                ##$stdout.puts "quoted_search_columns: " + quoted_search_columns
                #$stdout.puts "keywords.inspect" +  keywords.inspect
                #$stdout.puts "search_terms.inspect" +  search_terms.inspect
                #self.find(:all, options, :limit => 100)
                #self.find(:all, :joins => "CONTAINSTABLE([listing_items], (*), N''\"deer\" | \"hunting\"'') as msfte_ctbl_0 ON [listing_items].[id] = msfte_ctbl_0.[key]")

                #self.find_by_sql( "EXEC sp_executesql N'SELECT TOP (100) [listing_items].* FROM [listing_items] JOIN CONTAINSTABLE([listing_items], (*), N''\"deer\" | \"hunting\"'') as msfte_ctbl_0 ON [listing_items].[id] = msfte_ctbl_0.[key] ORDER BY msfte_ctbl_0.rank DESC'"   )
                #self.find_by_sql( "EXEC sp_executesql N'SELECT TOP (100) [listing_items].* FROM [listing_items] JOIN CONTAINSTABLE([listing_items], (*), N''\"deer\" | \"hunting\"'') as msfte_ctbl_0 ON [listing_items].[id] = msfte_ctbl_0.[key] ORDER BY msfte_ctbl_0.rank DESC'"   )

                #args =  :matches_any => ['deer', 'hunting' ]
                options = self.options_from(args)
                $stdout.puts "options.inspect: " + options.inspect
                $stdout.puts "args.class: " + args.class.to_s
                $stdout.puts "args.inspect: " + args.inspect
                search_terms = self.my_quote_bound_value(self.query_from_options(args, options))
                #options: {:matches_any=>["deer", "hunting"]}
                $stdout.puts "search_terms.class: " + search_terms.class.to_s
                $stdout.puts "search_terms.inspect: " + search_terms.inspect
                search_string =   "SELECT TOP (100) [listing_designs_and_merchandise_only].* FROM [listing_designs_and_merchandise_only] JOIN CONTAINSTABLE([listing_designs_and_merchandise_only], (*), #{search_terms} ) as msfte_ctbl_0 ON [listing_designs_and_merchandise_only].[id] = msfte_ctbl_0.[key] ORDER BY msfte_ctbl_0.rank DESC"
                #search_string =   "SELECT TOP (100) [listing_items].* FROM [listing_items]"
                $stdout.puts "search_string: " + search_string
                #@initial_items = ListingDesignsAndMerchandiseOnly.find_with_msfte_works :matches_any => ['deer', 'hunting' ]
                self.find_by_sql( search_string  )
end







#logger=$stdout

# www.mssqltips.com/tip.asp?tip=1610
#I had to create a view with combined fields so microsoft full text search would treat the columns equal
#
#Views have to have a special index created for schema binding
#
#ALTER VIEW [dbo].[listing_items] WITH SCHEMABINDING AS
#SELECT     id, Description, ItemLookupCode,  COALESCE (CAST( id AS varchar(MAX)), '')  + ' ' +  ItemLookupCode  + ' ' +  COALESCE (CAST( Notes AS varchar(MAX)), '')  + ' ' +  COALESCE (CAST( Description AS varchar(MAX)), '')   + ' ' +  COALESCE (CAST( ExtendedDescription AS varchar(MAX)), '')  AS items_combined
#FROM         dbo.item




  def number_without_size
    if self.WebItem == true
      no = self.ItemLookupCode[/\d+-\d+/]
      if no.nil?
        return self.ItemLookupCode[/\d+/]
      else
        return no
      end
    else
      return nil
    end
  end






def number_only
			no = self.ItemLookupCode[/\d+/]
			if no.nil?
					'0'
			else
					no
			end
end


    def self.find_or_paginate (klass, options)
      $stdout.puts "####################### self.find_or_paginate (klass, options): "
      $stdout.puts "options: " + options.inspect
      $stdout.puts "klass.inspect: " + klass.inspect
      klass.find(:all, options, :limit => 100)
    end


  def self.find_or_paginate_original (klass, options)
    if options.has_key?(:per_page) || options.has_key?(:page)
      WillPaginate::Collection.create(options.delete(:page) || 1, options.delete(:per_page) || klass.per_page) do |pager|
        options[:limit] = pager.offset + pager.per_page
        result = klass.find(:all, options)
        pager.replace(result[pager.offset, pager.per_page])
        # :order is only allowed in #count together with :group
        pager.total_entries = klass.count(options.reject {|k,_| k == :order}) unless pager.total_entries
      end
    else
      klass.find(:all, options)
    end
  end

    def self.query_from_options (args, options)
        $stdout.puts "BEGIN self.query_from_options (args, options)"
        #$stdout.puts "q: " + q
        #$stdout.puts "args.first: " +  args.first
        $stdout.puts "options: " + options.inspect
        #$stdout.puts "phrases: " + phrases

    if q = args.first
      q = "\"#{q}\"" unless q.include?('"')
    elsif phrases = options.delete(:matches_all)
      q = self.quote_and_join_phrases(phrases, ' & ')
    elsif phrases = options.delete(:matches_any)
      q = self.quote_and_join_phrases(phrases, ' | ')
    elsif phrases = options.delete(:starts_with_all)
      q = self.quote_and_join_phrases(phrases, ' & ', '*')
    elsif phrases = options.delete(:starts_with_any)
      q = self.quote_and_join_phrases(phrases, ' | ', '*')
    else
      raise ArgumentError, "Missing search term. Please provide a string or one of :matches_all, :matches_any, :starts_with_all, :starts_with_any with array."
    end
    q
  end

  def self.quote_and_join_phrases (phrases, joiner, wild_card = '')
    phrases = phrases.split if phrases.is_a? String
    phrases.map { |w| "\"#{w}#{wild_card}\"" }.join(joiner)
  end

  def self.ctbl
    @ctbl ||= Hash.new { |h,k| "msfte_ctbl_#{k}" }
  end

  def self.order_clause (size)
    inner = (0..size).map {|ix| "ISNULL(#{ctbl[ix]}.[rank], 1)" }.join "*"
    "(#{inner}) DESC"
  end

  def self.scope_for_association_search (size)
    inner = (0..size).map {|ix| "ISNULL(#{ctbl[ix]}.[rank], 0)" }.join "+"
    {:conditions => "(#{inner}) > 0"} #
  end

  def self.options_from(args)
    options = args.extract_options!.dup
  end



        def self.safe_to_array(o)
          case o
          when NilClass
            []
          when Array
            o
          else
            [o]
          end
        end

    # Search a model and optional associations for full-text matches.
    # In the simplest form, just pass the string (word or phrase) that
    # you want to search for:
    #     Post.find_with_msfte "it was a dark and stormy night"
    # Matches will be returned in relevance order (according to the full-text index).
    #
    # The method is implemented using ActiveRecord.find() and any options given not handled by
    # this method will be passed to #find.
    #
    # ==== Options
    # * <tt>:matches_any</tt> - Accepts an array of strings (words and/or phrases) and will return
    #   all objects that match <b>at least one</b> of the words or phrases.
    # * <tt>:matches_all</tt> - Accepts an array of strings (words and/or phrases) and will return
    #   all objects that match <b>all</b> of the words or phrases.
    # * <tt>:starts_with_any</tt> - Accepts an array of strings (words and/or phrases) and will return
    #   all objects that match <b>at least one</b> of the words or phrases using a partial match.
    # * <tt>:starts_with_all</tt> - Accepts an array of strings (words and/or phrases) and will return
    #   all objects that match <b>all</b> of the words or phrases using a partial match.
    # * <tt>:include_in_search</tt> - Symbol or array of symbols for associations that will also be
    #   searched.  If you want to use <tt>:include</tt> at the same time, make sure that the associations
    #   listed in <tt>:include_in_search</tt> are also in <tt>:include</tt>.
    # * <tt>:ignore_self</tt> - set to true to only search the associated models.  Requires <tt>:include_in_search</tt>.
    # * <tt>:search_attributes</tt> - column name(s) to search as a symbol or an array of symbols.  If using
    #   <tt>:include_in_search</tt>, it should be a hash like <tt>{:post => [:title], :comment => [:title, :text]}</tt>.
    #   Default for all searched models is '*' meaning all full-text indexed columns.
    # * <tt>:page</tt> - Page of search results to retrieve.  Optional.
    # * <tt>:per_page</tt> - Number of search results that are displayed per page.  Only used for pagination.
    #   If omitted, calls #per_page on the model just like <tt>will_paginate</tt>.
    #
    # See README for examples.

   #EXEC sp_executesql N'SELECT TOP (100) [listing_items].* FROM [listing_items] JOIN CONTAINSTABLE([listing_items], (*), N''"deer" | "hunting"'') as msfte_ctbl_0 ON [listing_items].[id] = msfte_ctbl_0.[key] ORDER BY msfte_ctbl_0.rank DESC'

    def self.find_with_msfte_test(*args)
          self.find_by_sql( "EXEC sp_executesql N'SELECT TOP (100) [listing_items].* FROM [listing_items] JOIN CONTAINSTABLE([listing_items], (*), N''\"deer\" | \"hunting\"'') as msfte_ctbl_0 ON [listing_items].[id] = msfte_ctbl_0.[key] ORDER BY msfte_ctbl_0.rank DESC'"   )
    end




    def self.find_with_msfte_orig(*args)
          $stdout.puts "############################## self.find_with_msfte (*args)"
           $stdout.puts "{name}.find_with_msfte {args.inspect}" + "#{name}.find_with_msfte #{args.inspect}"
          options = self.options_from(args)
          if include_in_search = options.delete(:include_in_search)
                $stdout.puts "include_in_search = options.delete(:include_in_search)"
                options[:include] ||= include_in_search
                include_in_search = self.safe_to_array(include_in_search)
                raise ArgumentError, ":include_in_search must be a symbol or an array of symbols" unless include_in_search.all? { |s| s.is_a?(Symbol) }
          else
                $stdout.puts "NOT include_in_search = options.delete(:include_in_search)"
          end

          search_terms = my_quote_bound_value(self.query_from_options(args, options))
          if include_in_search.nil?
                $stdout.puts "include_in_search.nil?"
                search_columns = self.safe_to_array(options.delete(:search_attributes) || "*")
                quoted_search_columns = search_columns.map { |s| s == "*" ? s : "[#{s}]" }.join(",")
                join = " JOIN CONTAINSTABLE(#{quoted_table_name}, (#{quoted_search_columns}), #{search_terms}) as #{self.ctbl[0]} ON #{quoted_table_name}.[#{primary_key}] = #{self.ctbl[0]}.[key]"
                (options[:joins] ||= "") << join
                options[:order] ||= "#{self.ctbl[0]}.rank DESC"
                self.find_or_paginate self, options
          else
                $stdout.puts "NOTinclude_in_search.nil?"
                search_columns = options.delete(:search_attributes) || {}
                quoted_search_columns = Hash.new("*")
                search_columns.each_pair do |association, attributes|
                    quoted_search_columns[association] = self.safe_to_array(attributes).map { |s| s == "*" ? s : "[#{s}]" }.join(",")
                end
                options[:joins] ||= ""
                if options.delete(:ignore_self)
                      $stdout.puts "options.delete(:ignore_self)"
                      ctbl_start_index = 0
                else
                      $stdout.puts "NOT options.delete(:ignore_self)"
                      join = " JOIN CONTAINSTABLE(#{quoted_table_name}, (#{quoted_search_columns[:self]}), #{search_terms}) as #{self.ctbl[0]} ON #{quoted_table_name}.[#{primary_key}] = #{self.ctbl[0]}.[key]"
                      options[:joins] << " LEFT OUTER#{join}"
                      ctbl_start_index = 1
                end

                stupid_extra = []
                include_in_search.each_with_index do |association, ix|
                      ix += ctbl_start_index
                      reflection = reflections[association]
                      join =  " LEFT OUTER JOIN CONTAINSTABLE(#{reflection.quoted_table_name}, (#{quoted_search_columns[association]}), #{search_terms}) as #{self.ctbl[ix]}"
                      join << " ON #{reflection.quoted_table_name}.[#{reflection.klass.primary_key}] = #{self.ctbl[ix]}.[key]"
                      options[:joins] << join
                      # stupid_extra << "#{reflection.quoted_table_name}.[#{reflection.klass.primary_key}] = #{reflection.quoted_table_name}.[#{reflection.klass.primary_key}]"
                end

                join_size = include_in_search.size - 1 + ctbl_start_index
                options[:order] ||= self.order_clause(join_size) # stupid_extra.join(" AND ")
                with_scope({:find => self.scope_for_association_search(join_size) }, :merge) do
                      self.find_or_paginate self, options
                end
          end
    end


end
