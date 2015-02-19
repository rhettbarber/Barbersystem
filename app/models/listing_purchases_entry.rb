class ListingPurchasesEntry < ActiveRecord::Base
  belongs_to :clone_item_type   , :foreign_key => "detail_type_id"
belongs_to :purchase
belongs_to :item
has_one :layout
has_one :purchases_entry_detail



# SQL SCHEMA BINDING CAUSED A LOT OF BAD NAMING TO CONTINUE FOR AWHILE.
belongs_to :machine
belongs_to :request_type, :foreign_key => "detail_type_id"
belongs_to :artist, :foreign_key => "artist_customer_id"
attr_accessible :QuantityOnOrder, :Comment   , :QuantityRTD

attr_accessor :see_folder

def see_folder
              if   self[:see_folder] == 0
                              false
              else
                           true
                end
end





def art_overdue?
             if  self.art_due_date and   self.art_due_date   < Time.now
                        if   self.production_file_exists?
                                          if  layered_art == 1 and  layered_art_exists?
                                                             false
                                          else
                                                          true
                                            end
                        else
                                  true
                         end
             else
                    false
             end
end


def supplied_art_filename
                  if see_folder
                                return "Z://STORAGE_DISK_1/MAIN_FILES_STORAGE/CUSTOMER_SUPPLIED_DATABASE/" +  self.purchase_id.to_s  +  "-"  +   self.id.to_s   + "-" +   self.purchase.customer_slug  + '/'
                  else
                               return "Z://STORAGE_DISK_1/MAIN_FILES_STORAGE/CUSTOMER_SUPPLIED_DATABASE/" +  self.purchase_id.to_s  +  "-"  +   self.id.to_s   + "-" +   self.purchase.customer_slug  +  "-"  +   Util::Slug.generate(  self.purchases_entries_Description   )
                    end
 end

def layered_art_filename
                      if see_folder
                               return "Z://STORAGE_DISK_1/MAIN_FILES_STORAGE/CUSTOM_DATABASE/" +  self.purchase_id.to_s  +  "-"  +   self.id.to_s   + "-" +   self.purchase.customer_slug        + '/'
                      else
                              return "Z://STORAGE_DISK_1/MAIN_FILES_STORAGE/CUSTOM_DATABASE/" +  self.purchase_id.to_s  +  "-"  +   self.id.to_s   + "-" +   self.purchase.customer_slug  +  "-"  +   Util::Slug.generate(  self.purchases_entries_Description   )
                        end
end


def production_filename
                              if clone_item_type
                                              if  see_folder
                                                             return  'Y://AUTOMATION_DATABASE/CUSTOM_PRODUCTION_FILES/' + self.clone_item_type.name + '/'  +  self.purchase_id.to_s  +  "-"  +   self.id.to_s   + "-" +   self.purchase.customer_slug    + '/'
                                              else
                                                             return  'Y://AUTOMATION_DATABASE/CUSTOM_PRODUCTION_FILES/' + self.clone_item_type.name + '/'  +  self.purchase_id.to_s  +  "-"  +   self.id.to_s   + "-" +   self.purchase.customer_slug  +  "-"  +   Util::Slug.generate(  self.purchases_entries_Description   )
                                                end
                              else
                                      return "NO TYPE"
                                end
end


def supplied_art_exists?
                  ss = self.supplied_art_filename
                  tt = "tt"
                  if  see_folder
                                     if File.directory?(  self.supplied_art_filename    )
                                                true
                                     end
                  else
                                    if File.file?(  self.supplied_art_filename + ".psd"  ) or  File.file?(  self.supplied_art_filename + ".tif"  )    or  File.file?(  self.supplied_art_filename + ".eps"  )   or  File.file?(  self.supplied_art_filename + ".ai"  )  or  File.file?(  self.supplied_art_filename + ".jpg"  )       or  File.file?(  self.supplied_art_filename + ".jpeg"  )      or  File.file?(  self.supplied_art_filename + ".gif"  )       or  File.file?(  self.supplied_art_filename + ".pdf"  )
                                               true
                                    end
                    end
 end

def  layered_art_exists?
              if see_folder
                                if File.directory?(  self.layered_art_filename   )
                                           true
                                end
              else
                              if File.file?(  self.layered_art_filename + ".psd"  ) or  File.file?(  self.layered_art_filename + ".tif"  )    or  File.file?(  self.layered_art_filename + ".eps"  )   or  File.file?(  self.layered_art_filename + ".ai"  )
                                          true
                               end
                end
end


def production_file_exists?
                if see_folder
                            if File.directory?(  self.production_filename  )
                                       true
                            end
                else
                           if File.file?(  self.production_filename + ".psd"  ) or  File.file?(  self.production_filename + ".tif"  )    or  File.file?(  self.production_filename + ".eps"  )   or  File.file?(  self.production_filename + ".ai"  )     or  File.file?(  self.production_filename + ".jpg"  ) or  File.file?(  self.production_filename + ".jpeg"  )
                                      true
                           end
                  end
 end



def combined_name
          if self.Company != " "
                  self.FirstName.to_s  + " " +  self.LastName.to_s + " - " + self.Company.to_s
          else
                 self.FirstName.to_s + " " +  self.LastName.to_s  + " " + self.Company.to_s
          end

end


#ALTER VIEW [dbo].[listing_items] WITH SCHEMABINDING AS
#SELECT     Notes, Description, ID AS id, ItemLookupCode, DepartmentID AS department_id, CategoryID AS category_id, PictureName, ExtendedDescription, SubDescription1,
#                      SubDescription2, SubDescription3, WebItem, Inactive, COALESCE (CAST( id AS varchar(MAX)), '')  + ' ' +  ItemLookupCode  + ' ' +  COALESCE (CAST( Notes AS varchar(MAX)), '')  + ' ' +  COALESCE (CAST( Description AS varchar(MAX)), '')   + ' ' +  COALESCE (CAST( ExtendedDescription AS varchar(MAX)), '')  AS items_combined
#FROM         dbo.Item


# PERFECT-READY-BEWARE-NEW-COLUMNS
  #ALTER VIEW [dbo].[items] WITH SCHEMABINDING AS
  #SELECT     ID AS id, DepartmentID AS department_id, CategoryID AS category_id, DateCreated, SubDescription3, SupplierID AS supplier_id, PictureName, Description,
  #                      ItemLookupCode, Price, PriceA, PriceB, PriceC, Cost, Quantity, Weight, Inactive, WebItem, SubCategoryID, ItemNotDiscountable,
  #                      QuantityDiscountID AS quantity_discount_id, SubDescription1, SubDescription2, ExtendedDescription, CommissionAmount, CommissionMaximum, CommissionMode,
  #                      CommissionPercentProfit, CommissionPercentSale, LastReceived, LastUpdated, QuantityCommitted, MessageID AS message_id, SalePrice, SaleStartDate,
  #                      SaleEndDate, ItemType, LastSold, BlockSalesReason, BlockSalesAfterDate, BlockSalesBeforeDate, BlockSalesType,
  #                      BlockSalesScheduleID AS block_sales_schedule_id, SaleScheduleID AS sale_schedule_id, SaleType, Consignment, DoNotOrder, MSRP, shipcost, imagecost,
  #                      laborcost, exclude_from_website_in_ids, Notes, CostLastUpdated
  #FROM         dbo.Item

  # PERFECT-READY-BEWARE-NEW-COLUMNS
  #ALTER VIEW [dbo].[purchases_entries] WITH SCHEMABINDING AS
  #SELECT     OrderID AS purchase_id, ItemID AS item_id, ID AS id, Cost, StoreID AS store_id, FullPrice, PriceSource, Price, QuantityOnOrder, SalesRepID, Taxable, DetailID,
  #                      Description, DiscountReasonCodeID AS discount_reason_code_id, ReturnReasonCodeID AS return_reason_code_id, QuantityRTD, LastUpdated, Comment,
  #                      ItemLookupCode, symbiote_purchases_entry_id, master_department_id, on_hold, commission_paid
  #FROM         dbo.OrderEntry

#ALTER VIEW [dbo].[purchases] WITH SCHEMABINDING AS
#SELECT     ID AS id, StoreID AS store_id, Time, Closed, Type, Comment, CustomerID AS customer_id, ShipToID AS ship_to_id, DepositOverride, Deposit, Tax, Total, LastUpdated,
#                       Taxable, SalesRepID, ReferenceNumber, ShippingChargeOnOrder, ShippingChargeOverride, ShippingServiceID AS shipping_service_id, ShippingTrackingNumber,
#                       ShippingNotes, website_id, a_id, recruiter_a_id, affiliate_paid, recruiter_paid
# FROM         dbo.[Order]

#
#  ALTER VIEW [dbo].[listing_purchases_entries] WITH SCHEMABINDING AS
#SELECT     dbo.layouts.id AS layout_id, dbo.layouts.purchases_entry_id, dbo.layouts.number, dbo.layouts.created_at, dbo.layouts.updated_at, dbo.layouts.description,
#                       dbo.purchases_entries.purchase_id, dbo.purchases_entries.id, dbo.purchases_entries.Cost, dbo.purchases_entries.store_id, dbo.purchases_entries.FullPrice,
#                       dbo.purchases_entries.PriceSource, dbo.purchases_entries.Price, dbo.purchases_entries.QuantityOnOrder, dbo.purchases_entries.SalesRepID,
#                       dbo.purchases_entries.Taxable, dbo.purchases_entries.DetailID, dbo.purchases_entries.discount_reason_code_id, dbo.purchases_entries.return_reason_code_id,
#                       dbo.purchases_entries.QuantityRTD, dbo.purchases_entries.LastUpdated, dbo.purchases_entries.Comment, dbo.purchases_entries.symbiote_purchases_entry_id,
#                       dbo.purchases_entries.master_department_id, dbo.purchases_entries.on_hold, dbo.purchases_entries.commission_paid, dbo.purchases.Time,
#                       dbo.purchases.Closed, dbo.purchases.Type, dbo.purchases.Comment AS purchases_Comment, dbo.purchases.customer_id, dbo.purchases.ship_to_id,
#                       dbo.purchases.DepositOverride, dbo.purchases.Deposit, dbo.purchases.Tax, dbo.purchases.Total, dbo.purchases.LastUpdated AS Expr6,
#                       dbo.purchases.Taxable AS Expr7, dbo.purchases.SalesRepID AS Expr8, dbo.purchases.ReferenceNumber, dbo.purchases.ShippingChargeOnOrder,
#                       dbo.purchases.ShippingChargeOverride, dbo.purchases.shipping_service_id, dbo.purchases.ShippingTrackingNumber, dbo.purchases.ShippingNotes,
#                       dbo.purchases.website_id, dbo.purchases.a_id, dbo.purchases.recruiter_a_id, dbo.purchases.affiliate_paid, dbo.purchases.recruiter_paid, dbo.items.department_id,
#                       dbo.items.category_id, dbo.items.DateCreated, dbo.items.SubDescription3, dbo.items.supplier_id, dbo.items.PictureName, dbo.items.Price AS items_price,
#                       dbo.items.PriceA, dbo.items.PriceB, dbo.items.PriceC, dbo.items.Cost AS items_Cost, dbo.items.Quantity, dbo.items.Weight, dbo.items.Inactive, dbo.items.WebItem,
#                       dbo.items.SubCategoryID, dbo.items.ItemNotDiscountable, dbo.items.quantity_discount_id, dbo.items.SubDescription1, dbo.items.SubDescription2,
#                       dbo.items.ExtendedDescription, dbo.items.CommissionAmount, dbo.items.CommissionMaximum, dbo.items.CommissionMode, dbo.items.CommissionPercentProfit,
#                       dbo.items.CommissionPercentSale, dbo.items.LastReceived, dbo.items.LastUpdated AS items_LastUpdated, dbo.items.QuantityCommitted, dbo.items.message_id,
#                       dbo.items.SalePrice, dbo.items.SaleStartDate, dbo.items.SaleEndDate, dbo.items.ItemType, dbo.items.LastSold, dbo.items.BlockSalesReason,
#                       dbo.items.BlockSalesAfterDate, dbo.items.BlockSalesBeforeDate, dbo.items.BlockSalesType, dbo.items.block_sales_schedule_id, dbo.items.sale_schedule_id,
#                       dbo.items.SaleType, dbo.items.Consignment, dbo.items.DoNotOrder, dbo.items.MSRP, dbo.items.shipcost, dbo.items.imagecost, dbo.items.laborcost,
#                       dbo.items.exclude_from_website_in_ids, dbo.items.Notes, dbo.items.CostLastUpdated, dbo.items.id AS item_id, dbo.items.Description AS items_Description,
#                       dbo.items.ItemLookupCode,
#                       COALESCE (CAST(dbo.layouts.number AS varchar(MAX)), '') +
#                        COALESCE (CAST(dbo.layouts.description AS varchar(MAX)), '')  + ' ' +
#
#                        COALESCE (CAST(dbo.purchases.Comment AS varchar(MAX)), '') + ' ' +
#                        COALESCE (CAST(dbo.purchases.ReferenceNumber AS varchar(MAX)), '') + ' ' +
#                        COALESCE (CAST(dbo.purchases_entries.purchase_id AS varchar(MAX)), '') + ' ' +
#                        COALESCE (CAST(dbo.purchases_entries.Comment AS varchar(MAX)), '') + ' ' +
#                        COALESCE (CAST(dbo.purchases_entries.ItemLookupCode AS varchar(MAX)), '') + ' ' +
#                        COALESCE (CAST(dbo.purchases_entries.Description AS varchar(MAX)), '')  + ' ' +
#                       COALESCE (CAST(dbo.purchases_entries.Comment AS varchar(MAX)), '')
#                       + ' ' +  dbo.items.ItemLookupCode + ' ' + ' ' +
#                       COALESCE (CAST(dbo.items.Notes AS varchar(MAX)), '') + ' ' +
#                        COALESCE (CAST(dbo.items.Description AS varchar(MAX)),  '') + ' ' +
#                        COALESCE (CAST(dbo.Customer.AccountNumber AS varchar(MAX)),  '') + ' ' +
#                        COALESCE (CAST(dbo.Customer.Company AS varchar(MAX)),  '') + ' ' +
#                        COALESCE (CAST(dbo.Customer.FirstName AS varchar(MAX)),  '') + ' ' +
#                        COALESCE (CAST(dbo.Customer.LastName  AS varchar(MAX)),  '') + ' ' +
#                        COALESCE (CAST(dbo.Customer.EmailAddress AS varchar(MAX)),  '') + ' ' +
#                        COALESCE (CAST(dbo.users.email AS varchar(MAX)),  '') + ' ' +
#
#                        COALESCE (CAST(dbo.items.ExtendedDescription AS varchar(MAX)), '') AS purchases_entry_combined,
#                       dbo.purchases_entries.Description AS purchases_entries_Description, dbo.purchases_entries.ItemLookupCode AS purchases_entries_ItemLookupCode,
#                       dbo.Customer.AccountNumber, dbo.Customer.FirstName, dbo.Customer.LastName, dbo.Customer.EmailAddress, dbo.Customer.Company, dbo.users.email
# FROM         dbo.Customer LEFT OUTER JOIN
#                       dbo.users ON dbo.Customer.ID = dbo.users.customer_id RIGHT OUTER JOIN
#                       dbo.purchases ON dbo.Customer.ID = dbo.purchases.customer_id RIGHT OUTER JOIN
#                       dbo.items RIGHT OUTER JOIN
#                       dbo.purchases_entries ON dbo.items.id = dbo.purchases_entries.item_id ON dbo.purchases.id = dbo.purchases_entries.purchase_id LEFT OUTER JOIN
#                       dbo.layouts ON dbo.purchases_entries.id = dbo.layouts.purchases_entry_id
# WHERE     (dbo.purchases.Type = 2)



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

    def self.find_with_msfte_works (*args)
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


                search_string =   "EXEC sp_executesql N'SELECT TOP (150) [listing_items].* FROM [listing_items] JOIN CONTAINSTABLE([listing_items], (*), #{search_terms} ) as msfte_ctbl_0 ON [listing_items].[id] = msfte_ctbl_0.[key] ORDER BY msfte_ctbl_0.rank DESC'"

                #search_string =   "SELECT TOP (100) [listing_items].* FROM [listing_items]"
                $stdout.puts "search_string: " + search_string

                ListingItem.transaction do
                     self.find_by_sql( search_string  )
                end

end


                #full_working_search_string =   "EXEC sp_executesql N'SELECT TOP (100) [listing_items].* FROM [listing_items] JOIN CONTAINSTABLE([listing_items], (*), #{search_terms} ) as msfte_ctbl_0 ON [listing_items].[id] = msfte_ctbl_0.[key] ORDER BY msfte_ctbl_0.rank DESC'"
                #search_string =   "sp_executesql N'SELECT TOP (100) [listing_items].* FROM [listing_items] JOIN CONTAINSTABLE([listing_items], (*), #{search_terms} ) as msfte_ctbl_0 ON [listing_items].[id] = msfte_ctbl_0.[key] ORDER BY msfte_ctbl_0.rank DESC'"
                #search_string =   "SELECT TOP (100) [listing_items].* FROM [listing_items]"


#logger=$stdout

# www.mssqltips.com/tip.asp?tip=1610
#I had to create a view with combined fields so microsoft full text search would treat the columns equal
#
#Views have to have a special index created for schema binding
#
#ALTER VIEW [dbo].[listing_items] WITH SCHEMABINDING AS
#SELECT     id, Description, ItemLookupCode,  COALESCE (CAST( id AS varchar(MAX)), '')  + ' ' +  ItemLookupCode  + ' ' +  COALESCE (CAST( Notes AS varchar(MAX)), '')  + ' ' +  COALESCE (CAST( Description AS varchar(MAX)), '')   + ' ' +  COALESCE (CAST( ExtendedDescription AS varchar(MAX)), '')  AS items_combined
#FROM         dbo.item

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
      klass.transaction do
           klass.find(:all, options, :limit => 100)
      end

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




    def self.find_with_msfte(*args)
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







     def created_date
               begin
                          date =   self.created_at
                        s = "s"
                            if date
                                      year            =      date.year
                                      month        =      date.month
                                      day              =      date.day

                                     g = "g"

                                    return Date.civil( year, month, day)
                            else
                              "No Date"
                            end

               rescue
                         "No Date"
                 end
     end



        def overdue
                  #logger.debug "due_date: " + self.due_date.to_s
                  #logger.debug "Date.civil: " + Date.civil.to_s
                  if   self.due_date <=   Date.today
                              true
                  else
                              false
                  end
        end


        def balance
                    self.QuantityRTD.to_i  -   self.QuantityOnOrder.to_i
        end

        def balance_operator
                    if  self.balance > 0
                     return "+"
                    end
        end


          def due_date
                    begin
                               date =   self.Comment.gsub(']','').gsub('[','')
                               date_split  =     date.split("-")
                               year            =      date_split[0].to_i
                               month        =      date_split[1].to_i
                               day              =      date_split[2].to_i
                               logger.debug "self.Comment: " + self.Comment
                              g = "g"

                             return Date.civil( year, month, day)
                    rescue
                              "No Date"
                      end


          end



        def extended_total_at_commissioned_price
        			self.QuantityRTD * self.commissioned_price
        end


        def commissioned_price
        		@special_price_levels = ['0','1']
        		if self.purchase.customer
        					if   @special_price_levels. include?(self.purchase.customer.PriceLevel.to_s)
        							return self.item.lowest_quantity_discount_price_b
        					else
        							return self.Price
        					end
        		else
        					return 0.0
        		end
        end


        def commission_percent_sale

          #use @commissioned_customer instead

                        logger.warn "######### item.ItemLookupCode: "  +   item.ItemLookupCode
                        logger.warn "self.purchase.customer.CustomNumber1: " + self.purchase.customer.CustomNumber1.to_s
                        if 	self.item.CommissionPercentSale > 0
                                           logger.warn "######### self.item.ItemLookupCode: "  +  self. item.ItemLookupCode
                                           logger.warn "self.item.CommissionPercentSale"
                                          self.item.CommissionPercentSale * 0.01
                        elsif self.item.customer_item.customer.CustomNumber1 > 0
                                           logger.warn "######### self.item.ItemLookupCode: "  +  self. item.ItemLookupCode
                                            logger.warn "self.item.customer_item.customer.CustomNumber1: " + self.item.customer_item.customer.CustomNumber1.to_s
                                           self.item.customer_item.customer.CustomNumber1  * 0.01
                        else
                                          0.0
                        end
        end



        def fixed_total
        	return item.CommissionAmount * self.QuantityRTD
        end

        def percent_total
        	return  self.extended_total_at_commissioned_price *  self.commission_percent_sale
        end

        def combined_total
        			return self.percent_total  +   self.fixed_total
        end







































         def  symbiont_your_unit_price
            if self.complete_symbiont
            		quantity = self.QuantityOnOrder
        	 		if self.purchase.customer
        	 			customer = self.purchase.customer
        	       		return self.item.your_unit_price( customer, quantity ) + self.opposite_entry.item.your_unit_price( customer, quantity )
        	 		else
        	 			return self.item.full_unit_price(0,quantity)
        	 		end
         	else
         		0
         	end
         end

         def  symbiont_your_extended_price
                 begin
                        return self.symbiont_your_unit_price * self.QuantityOnOrder
                   rescue
                               0
                    end
         end





         def  symbiont_full_unit_price
                self.item.full_unit_price + self.opposite_entry.item.full_unit_price
         end

         def  symbiont_full_extended_price
                 begin
                               self.full_extended_price(0,self.item)  +  self.opposite_entry.full_extended_price(0,self.opposite_entry.item)
                   rescue
                               0
                    end
         end



        ########################################################################################################
        ####### SYMBIONT AREA


         def potential_slave_decides_masters_department(potential_slave)
                  if self.master_department_id =='0'
                             potential_slave.category.category_class.opposite_default_department_id
                    else
                            if self.item.category.use_generic_department == '1'
                                self.item.department_id
                            else
                                      if  potential_slave.category.category_class.appearing_sections.include?(self.masters_department_letter_section_code)
                                                    self.master_department_id
                                        else
                                                    potential_slave.category.category_class.slaves_opposite_master_default_department_id
                                       end
                             end
                      end
        end

         def design_decides_potential_masters_department(parameter_department) ##here self is the slave items purchases entry.
                 if self.item.category.category_class.appearing_sections.include?(parameter_department.letter_section_code)

                            potential_dept =      parameter_department.id
                  else

                #          potential_dept =    self.item.category.category_class.slaves_opposite_master_default_department_id
                          potential_dept =    self.item.design_decides_opposites_department
                 end
         end

        def complete_symbiote(item,master_department, pe_comment)
                                                      self.ItemLookupCode  = item.ItemLookupCode
                                                      self.master_department_id =  master_department
                                                      self.QuantityOnOrder =  self.opposite_entry.QuantityOnOrder  ##be sure to update with param the opposite before this.
                                                      self.FullPrice =  item.full_unit_price
                                                      self.item_id =  item.id
                                                      self.Cost = item.Cost
                                                      self.Comment = pe_comment
                                                      self.Description =  Util::Slug.generate(item.Description)
                                                      self.Price = item.Price
                                                      self.LastUpdated = Time.now
                                                      self.save
                                                      opposite = self.opposite_entry
                                                      opposite.master_department_id = master_department
                                                      opposite.save
        end

         def masters_department_letter_section_code
                dep = Department.find(self.master_department_id)
                dep.letter_section_code
         end

          def potential_slave_decides_item_class_components(design)
        #@item_class_components  = @item_entry.potential_slave_decides_item_class_components(@design)
                if  design.opacity_letter == 'o'
                         self.item.item_class_component.item_class.item_class_components
                else
                           self.item.item_class_component.item_class.light_components_only
                end
         end

          def slaves_item_class_components_decision
                if  self.item.opacity_letter == 'o'
                         self.opposite_entry.item.item_class_component.item_class.item_class_components
                else
                           self.opposite_entry.item.item_class_component.item_class.light_components_only
                end
         end

         def slaves_department_decision
                 if self.slave_of_symbiont_pair.item.category.category_class.exclude_from_sections.include?(self.slave_of_symbiont_pair.master_department_letter_section_code)
                              self.slave_of_symbiont_pair.category.category_class.opposite_default_department_id
                  else
                              self.master_of_symbiont_pair.master_department_id
                 end
         end

         def symbiotic_item
              if self.item.category.category_class.item_type == 'master' or  self.item.category.category_class.item_type == 'slave'
                     true
              else
                      false
              end
         end

         def master_of_symbiont_pair
                if self.item.category.category_class.item_type == 'master'
                    self
                else
                    self.opposite_entry
                end
         end

         def slave_of_symbiont_pair
                if self.item.category.category_class.item_type == 'slave'
                    self
                else
                    self.opposite_entry
                end
         end

        def master_department_letter_section_code
                    master_dept  = Department.find( self.master_department_id )
                   return  master_dept.letter_section_code
        end

         def complete_symbiont
                  if self.item && self.opposite_entry.item
                           true
                  else
                           false
                  end
         end


        def self.add_singular_item(purchase,item,quantity,department)
        											  department = department || 0
                                                      purchases_entry =  PurchasesEntry.new
                                                      purchases_entry.on_hold = 0
                                                      purchases_entry.ItemLookupCode  = item.ItemLookupCode
                                                      purchases_entry.master_department_id  = department
                                                      purchases_entry.QuantityOnOrder = quantity
                                                      purchases_entry.QuantityRTD = 0
                                                      purchases_entry.DetailID = 0
                                                      purchases_entry.SalesRepID = 0
                                                      purchases_entry.PriceSource = 1
                                                      purchases_entry.discount_reason_code_id = 0
                                                      purchases_entry.return_reason_code_id = 0
                                                      purchases_entry.FullPrice = item.full_unit_price
                                                      purchases_entry.item_id =  item.id
                                                      purchases_entry.purchase_id = purchase.id
                                                      purchases_entry.store_id = 7
                                                      purchases_entry.Cost = item.Cost
                                                      purchases_entry.Comment = 0
                                                      purchases_entry.commission_paid = 0
                                                      purchases_entry.Description = Util::Slug.generate(item.Description)
                                                      purchases_entry.Price = item.Price
                                                      purchases_entry.Taxable = 1
                                                      purchases_entry.LastUpdated = Time.now
                                                      purchases_entry.symbiote_purchases_entry_id = 0
                                                      purchases_entry.save
                                                      purchases_entry
        end

        def master_entry
                     if self.item
                                  if self.item.category.category_class.item_type == 'master'
                                             true
                                  else
                                            false
                                  end
                      else
                                false
                      end
        end

        def opposite_entry
                if self.symbiote_purchases_entry_id != '0' and  self.symbiote_purchases_entry_id != 0
                             PurchasesEntry.find(:first,:conditions => [ "symbiote_purchases_entry_id = ?", self.id  ])
                  else
                           false
                end
        end

        ########################################################################################################
        ####### TOTALS AREA
        def full_extended_price(customer=0,item=0)
              if item.class != Item
                  item = Item.find(item)
              end
                     item.full_unit_price(customer) *  self.QuantityOnOrder
        end

        def your_extended_price(customer=0,quantity=0,item=0)
        	begin
              yep = item.unit_quantity_tier_discount_price(customer,quantity)  *  self.QuantityOnOrder
              return yep.to_f
         	rescue
         		return 0
         	end
        end


        def your_extended_price_savings(customer=0,quantity=0,item=0)
              yeps = self.full_extended_price(customer,item)   -   self.your_extended_price(customer,quantity,item)
              return yeps.to_f
        end

        def extended_tax
              self.Price *    0.06
        end






end
