# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper


#  alias_method :rails_javascript_include_tag, :javascript_include_tag
#
#  #  <%= javascript_include_tag :defaults, :fckeditor %>
#  def javascript_include_tag(*sources)
#    main_sources, application_source = [], []
#    if sources.include?(:fckeditor)
#      sources.delete(:fckeditor)
#      sources.push('fckeditor/fckeditor')
#    end
#    unless sources.empty?
#      main_sources = rails_javascript_include_tag(*sources).split("\n")
#      application_source = main_sources.pop if main_sources.last.include?('application.js')
#    end
#    [main_sources.join("\n"), application_source].join("\n")
#  end
  ######################################## BEGIN EXTRACT FROM FCKEDITOR
  def fckeditor_textarea(object, field, options = {})
      var = instance_variable_get("@#{object}")
      if var
        value = var.send(field.to_sym)
        value = value.nil? ? "" : value
      else
        value = ""
        klass = "#{object}".camelcase.constantize
        instance_variable_set("@#{object}", eval("#{klass}.new()"))
      end
      id = fckeditor_element_id(object, field)

      cols = options[:cols].nil? ? '' : "cols='"+options[:cols]+"'"
      rows = options[:rows].nil? ? '' : "rows='"+options[:rows]+"'"

      width = options[:width].nil? ? '100%' : options[:width]
      height = options[:height].nil? ? '100%' : options[:height]

      toolbarSet = options[:toolbarSet].nil? ? 'Default' : options[:toolbarSet]

      if options[:ajax]
        inputs = "<input type='hidden' id='#{id}_hidden' name='#{object}[#{field}]'>\n" <<
                 "<textarea id='#{id}' #{cols} #{rows} name='#{id}'>#{value}</textarea>\n"
      else
        inputs = "<textarea id='#{id}' #{cols} #{rows} name='#{object}[#{field}]'>#{value}</textarea>\n"
      end


#       js_path = "#{ActionController::Base.relative_url_root}/javascripts"

       js_path = "/javascripts"

    #  js_path = "#{request.relative_url_root}/javascripts"


      base_path = "#{js_path}/fckeditor/"
      return inputs <<
        javascript_tag("var oFCKeditor = new FCKeditor('#{id}', '#{width}', '#{height}', '#{toolbarSet}');\n" <<
                       "oFCKeditor.BasePath = \"#{base_path}\"\n" <<
                       "oFCKeditor.Config['CustomConfigurationsPath'] = '#{js_path}/fckcustom.js';\n" <<
                       "oFCKeditor.ReplaceTextarea();\n")
    end

    def fckeditor_form_remote_tag(options = {})
      editors = options[:editors]
      before = ""
      editors.keys.each do |e|
        editors[e].each do |f|
          before += fckeditor_before_js(e, f)
        end
      end
      options[:before] = options[:before].nil? ? before : before + options[:before]
      form_remote_tag(options)
    end

    def fckeditor_remote_form_for(object_name, *args, &proc)
      options = args.last.is_a?(Hash) ? args.pop : {}
      concat(fckeditor_form_remote_tag(options), proc.binding)
      fields_for(object_name, *(args << options), &proc)
      concat('</form>', proc.binding)
    end
    alias_method :fckeditor_form_remote_for, :fckeditor_remote_form_for

    def fckeditor_element_id(object, field)
      id = eval("@#{object}.id")
      "#{object}_#{id}_#{field}_editor"
    end

    def fckeditor_div_id(object, field)
      id = eval("@#{object}.id")
      "div-#{object}-#{id}-#{field}-editor"
    end

    def fckeditor_before_js(object, field)
      id = fckeditor_element_id(object, field)
      "var oEditor = FCKeditorAPI.GetInstance('"+id+"'); document.getElementById('"+id+"_hidden').value = oEditor.GetXHTML();"
    end

  ######################################## END EXTRACT FROM FCKEDITOR

def js_extract_messages_from_flash
  if (flash.length > 0)
    result = "<script type='text/javascript'>
      Messages.extractMessages( #{flash.to_json} );
    </script>"

    flash.discard

    result
  end
end

  def errors_for(object, message=nil)
    html = ""
    unless object.errors.blank?
      html << "<div class='formErrors #{object.class.name.humanize.downcase}Errors'>\n"
      if message.blank?
        if object.new_record?
          html << "\t\t<h5>There was a problem creating the #{object.class.name.humanize.downcase}</h5>\n"
        else
          html << "\t\t<h5>There was a problem updating the #{object.class.name.humanize.downcase}</h5>\n"
        end
      else
        html << "<h5>#{message}</h5>"
      end
      html << "\t\t<ul>\n"
      object.errors.full_messages.each do |error|
        html << "\t\t\t<li>#{error}</li>\n"
      end
      html << "\t\t</ul>\n"
      html << "\t</div>\n"
    end
    html
  end


 def numeric_day_of_the_week
		Time.now.to_date.cwday.to_s
end



def convert_spaces_to_commas(string_to_convert)
	string_to_convert.split.collect{|c| "#{c + ','}"}
end


    def display_categorical_navigation_tree(selected_node, customer_viewable_page_types)
    html = '<ul>'
    ancestors = selected_node.ancestors
    root = selected_node.root
    for child in root.children
      if child.has_published_revision? || user_can?('modify')  or user_can?('view_unpublished')
        html += display_categorical_subtree(child, selected_node, ancestors, customer_viewable_page_types)
      end
    end
    if root.slug == selected_node.slug && user_can?('modify')
      html += '<li>&nbsp;&nbsp;'
      html += actions(root)
      html += '</li>'
    end
    return html += '</ul>'
  end


  def display_categorical_subtree(node, selected_node, ancestors,customer_viewable_page_types)
    html = '<li>'
    if node.slug == selected_node.slug
      html += '&raquo; ' + link_to(node.name, {:action => "show_page", :id => node.slug}, :class => "selected")
    else
     	if customer_viewable_page_types.include?( node.page_type_id )
    	 html += '&raquo; ' + link_to(node.name, :action => "show_page", :id => node.slug)
		end
    end
    if ancestors.include?(node) || node.slug == selected_node.slug
      html += '<ul>'
      for child in node.children
        if child.has_published_revision? || user_can?('modify')
          html += '<li>'
          html += display_categorical_subtree(child, selected_node, ancestors , customer_viewable_page_types)
          html += '</li>'
        end
      end
      if node.slug == selected_node.slug && user_can?('modify')
        html += '<li>'
        html += actions(node)
        html += '</li>'
      end
      html += '</ul>'
    end
    return html + '</li>'
  end


  ###########################################################################################################################################################
def prepare_combination_variables(item,design)
	@breast_print = false
	if design.category.breast_print == '1' && item.category.breast_print == '1'
		@breast_print = true
		@breast_print_suffix = []
		 if design.category.category_specific_breast_print == '1'
		    @breast_print_suffix = '-' + Util::Slug.generate(design.category.Name)
	     end
	     @breast_print_suffix << '.png'
		 @breast_print_name = Util::Slug.generate(design.department.Name) +  @breast_print_suffix.to_s if design
	end
          @combination = Combination.find_combo(item, design)
           if @combination
               @combination_height     =  @combination.height
                @combination_left      =  @combination.left
                @combination_top       =  @combination.top
                @combination_bp_height =  @combination.bp_height
                @combination_bp_left   =  @combination.bp_left
                @combination_bp_top    =  @combination.bp_top
                @item_prefix_override  =  @combination.item_prefix_override
           end
 #     end
end

  ###########################################################################################################################################################
def mouseover_image_link( source, link, options = {},html_options = nil, *parameters_for_method_reference)   ##this assumes 0 border
                    rio_source = rio(source)
                    rio_dirname = rio_source.dirname.to_s
                     rio_basename = rio_source.basename.to_s
                    rio_ext = rio_source.ext?.to_s
                    rio_down_path =    rio_dirname + '/'  + rio_basename + '_down'  +  rio_ext
          if html_options
           html_options = html_options.stringify_keys
           convert_options_to_javascript!(html_options)
           tag_options = tag_options(html_options)
         else
           tag_options = nil
         end
      #      url = options.is_a?(String) ? options : self.url_for(options, *parameters_for_method_reference)
              url = link.is_a?(String) ? options : self.url_for(link, *parameters_for_method_reference)

         options.symbolize_keys!
         options[:src] = image_path(source)
         options[:alt] ||= File.basename(options[:src], '.*').split('.').first.capitalize
         options[:id] = options[:alt]
          options[:border] = 0

         if options[:size]
           options[:width], options[:height] = options[:size].split("x") if options[:size] =~ %r{^\d+x\d+$}
           options.delete(:size)
         end
        this_images_tag = tag("img", options)
 #        "<a href=\"#{url}\"    #{tag_options} onmouseout=\"MM_swapImgRestore()\" onmouseover=\"MM_swapImage(\' + #{ options[:id]} +   \','','http://www.dixieoutfitters.com/classic/images/vol11_03.jpg',1)\"          >   #{this_images_tag}                                                      </a>"
 #        "<a href=\"#{url}\"#{tag_options}>#{this_images_tag}</a>"
#        "<a href=\"#{url}\"    #{tag_options} onmouseout=\"MM_swapImgRestore()\" onmouseover=\"MM_swapImage('Image1','','http://www.dixieoutfitters.com/classic/images/vol11_03.jpg',1)\"          >   #{this_images_tag}                                                      </a>"
#                  "<a href=\"#{url}\"    #{tag_options} onmouseout=\"MM_swapImgRestore()\" onmouseover=\"MM_swapImage('Image1','','http://192.168.0.116:2001/images/homepage/index_fishing/index_fishing_10_down.jpg',1)\"          >   #{this_images_tag}                                                      </a>"
#debugger
                  "<a href=\"#{url}\"    #{tag_options} onmouseout=\"MM_swapImgRestore()\" onmouseover=\"MM_swapImage('#{ options[:id]}','','#{ rio_down_path}',1)\">   #{this_images_tag}   </a>"
end
 ###########################################################################################################################################################




  def customer_retail(&block)
         if customer_retail?
          content = with_output_buffer(&block)
          content_tag(:div, content, :class => "customer_retail")
         end
    end




  def customer_wholesale(&block)
      if customer_wholesale?
        content = with_output_buffer(&block)
        content_tag(:div, content, :class => "customer_wholesale")
      end
end

  def customer_preprint(&block)
      if customer_preprint?
        content = with_output_buffer(&block)
        content_tag(:div, content, :class => "customer_preprint")
      end
end

  def customer_transfer(&block)
      if customer_transfer?
        content = with_output_buffer(&block)
        content_tag(:div, content, :class => "customer_transfer")
      end
end

  def customer_franchise(&block)
    if customer_franchise?
      content = with_output_buffer(&block)
        content_tag(:div, content, :class => "customer_franchise")
    end
end

##################################################################################



  def production_only(&block)
     if Rails.env?('production')
        yield
    end
  end


  def checkout_receipt_only(&block)
     if controller.action_name == 'checkout_receipt'
        yield
    end
  end


  def hide_from_receipt_page(&block)
     unless controller.action_name == 'customer_receipt'
        yield
    end
  end


  def development_div(&block)
    if developer?
     content = with_output_buffer(&block)
        content_tag(:div, content, :class => "development_div")
    end
end


	def small_blue_menu(&block)
      content = with_output_buffer(&block)
      content_tag(:div, content, :class => "small_blue_menu_div")
	end

	def light_gold_box(&block)
    content = with_output_buffer(&block)
	  content_tag(:div, content, :class => "light_gold_div")
	end

  
  def cancel_button(page)
    html = "<input type=\"button\" value=\"Cancel\" onclick=\"javascript: window.location = '/page/"
    if page.id != nil
      html += "show/#{page.slug}"
    elsif page.parent_id
      html += "show/#{Page.find(page.parent_id).slug}"
    end
    html += "';\"/>"
    hmml = html.html_safe
  end

	# Page.find_by_sql(["SELECT DISTINCT(p.name), p.slug, p.position from pages p LEFT JOIN revisions r ON p.id = r.page_id WHERE p.parent_id is null AND r.published = ? ORDER BY p.position", true])


    def visible_root_pages
    if user_can?('modify')
      	Page.all(:conditions => ["parent_id is null and website_id = ?" ,@website.id ], :order => "position")
    elsif user_can?('view_unpublished')
        Page.find_by_sql(["SELECT DISTINCT(p.name), p.parent_id,  p.slug, p.page_type_id, p.position from pages p LEFT JOIN revisions r ON p.id = r.page_id WHERE p.parent_id is null AND p.website_id = ? AND p.page_type_id = ?  ORDER BY p.position", @website.id , true  ])
    else
      	Page.find_by_sql(["SELECT DISTINCT(p.name), p.parent_id, p.slug, p.page_type_id, p.position from pages p LEFT JOIN revisions r ON p.id = r.page_id WHERE p.parent_id is null AND p.website_id = ? AND p.page_type_id = ? AND r.published = ? ORDER BY p.position",@website.id , 1, true   ])
    end
  end

    def display_contextual_navigation_tree(selected_node, customer_viewable_page_types)
    html = '<ul>'
    ancestors = selected_node.ancestors
    root = selected_node.root
    for child in root.children
      if child.has_published_revision? || user_can?('modify')  or user_can?('view_unpublished')
        html += display_subtree(child, selected_node, ancestors, customer_viewable_page_types)
      end
    end
    if root.slug == selected_node.slug && user_can?('modify')
      html += '<li>&nbsp;&nbsp;'
      html += actions(root)
      html += '</li>'
    end
    return html += '</ul>'
  end


  def display_subtree(node, selected_node, ancestors,customer_viewable_page_types)
    html = '<li>'
    if node.slug == selected_node.slug
      html += '&raquo; ' + link_to(node.name, {:action => "show_page", :id => node.slug}, :class => "selected")
    else
     	if customer_viewable_page_types.include?( node.page_type_id )
    	 html += '&raquo; ' + link_to(node.name, :action => "show_page", :id => node.slug)
		end
    end
    if ancestors.include?(node) || node.slug == selected_node.slug
      html += '<ul>'
      for child in node.children
        if child.has_published_revision? || user_can?('modify')
          html += '<li>'
          html += display_subtree(child, selected_node, ancestors , customer_viewable_page_types)
          html += '</li>'
        end
      end
      if node.slug == selected_node.slug && user_can?('modify')
        html += '<li>'
        html += actions(node)
        html += '</li>'
      end
      html += '</ul>'
    end
    return html + '</li>'
  end


  def display_subtree_original(node, selected_node, ancestors)
    html = '<li>'
    if node.slug == selected_node.slug
      html += '&raquo; ' + link_to(node.name, {:action => "show", :id => node.slug}, :class => "selected")
    else
      html += '&raquo; ' + link_to(node.name, :action => "show", :id => node.slug)
    end
    if ancestors.include?(node) || node.slug == selected_node.slug
      html += '<ul>'
      for child in node.children
        if child.has_published_revision? || user_can?('modify')
          html += '<li>'
          html += display_subtree(child, selected_node, ancestors)
          html += '</li>'
        end
      end
      if node.slug == selected_node.slug && user_can?('modify')
        html += '<li>'
        html += actions(node)
        html += '</li>'
      end
      html += '</ul>'
    end
    return html + '</li>'
  end

    def display_contextual_navigation_tree_original(selected_node)
    html = '<ul>'
    ancestors = selected_node.ancestors
    root = selected_node.root
    for child in root.children
      if child.has_published_revision? || user_can?('modify')  or user_can?('view_unpublished')
        html += display_subtree(child, selected_node, ancestors)
      end
    end
    if root.slug == selected_node.slug && user_can?('modify')
      html += '<li>&nbsp;&nbsp;'
      html += actions(root)
      html += '</li>'
    end
    return html += '</ul>'
  end

def display_standard_flashes(message = 'There were some problems with your submission:')
			    if flash[:notice]
			      flash_to_display, level = flash[:notice], 'notice'
			    elsif flash[:warning]
			      flash_to_display, level = flash[:warning], 'warning'
			    elsif flash[:error]
			      level = 'error'
			      if flash[:error].instance_of? ActiveRecord::Errors
			        flash_to_display = message
			        flash_to_display << activerecord_error_list(flash[:error])
			      else
			        flash_to_display = flash[:error]
			      end
			    else
			      return
			    end
			    div_name = level.to_s + '_div'
			    div_name = 'notice_div' if div_name.nil?
			    content_tag 'div class="' + div_name + '"', flash_to_display, :class => "flash #{level}"
		   #    content_tag 'div class="' + level + '_div"', flash_to_display, :class => "flash #{level}"
end



    def activerecord_error_list(errors)
    error_list = '<ul class="error_list">'
    error_list << errors.collect do |e, m|
      "<li>#{e.humanize unless e == "base"} #{m}</li>"
    end.to_s << '</ul>'
    error_list
    end


  def hide_card_number(card_number)
  card_number.sub((part = card_number[0..-5]), '*' * part.length)
  end


    private
  def actions(node)
    html = ""
    html += "<select onchange=\"javascript:go_for_#{node.id}(this);\" style=\"font-size:8pt;\">"
    html += "<option>Actions...</option>"
    html += "<option value=\"add_action\" >Add a page</option>"
    html += "<option value=\"reorder_action\">Reorder pages</option>" if user_can?('publish')
    html += "<script type=\"text/javascript\" charset=\"utf-8\">"
    html += "function go_for_#{node.id}(actions) {"
    html += "var action = actions.options[actions.selectedIndex].value;"
    html += "if(action == 'add_action') window.location = '/page/add/?parent=#{node.id}';"
    html += "else if(action == 'reorder_action') window.location = '/page/reorder/#{node.id}';" if user_can?('publish')
    html += "}"
    html += "</script>"
    html += "</select>"
    return html.html_safe
  end


  ##############################################  DEPRECATE


    def visible_dealer_only_root_pages_deprecate
    if user_can?('modify')
      Page.find(:all, :conditions =>[ "parent_id = ? AND page_type_id  != ?" ,nil, 1] , :order => "position")
    elsif @customer
     		 Page.find_by_sql(["SELECT DISTINCT(p.name), p.slug, p.page_type_id, p.position from pages p LEFT JOIN revisions r ON p.id = r.page_id WHERE p.parent_id is null AND p.website_id in (?) AND p.page_type_id != ? AND r.published = ? ORDER BY p.position",[@website.id, '777' ] , 1 , true])
	end

  end





end
