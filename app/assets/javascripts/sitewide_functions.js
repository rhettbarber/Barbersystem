console.log("-----BEGIN file sitewide_functions.js") ;


function add_to_cart_purchases_entry_change(  thing_to_change  )  {
            if (  thing_to_change == "item") {
                                 console.log("Change submit value to add_to_cart_purchases_entry_change_item_keep_design");
                                  $("#special_submit").val("add_to_cart_purchases_entry_change_item_keep_design");
                                   $( "#change_design_options" ).popup( "close" );
                                    $('#special_submit').trigger('click');
            } else if ( thing_to_change  == "design") {
                                   console.log("Change submit value to add_to_cart_purchases_entry_change_design_keep_item");
                                  $("#special_submit").val("add_to_cart_purchases_entry_change_design_keep_item");
                                  $( "#change_item_options" ).popup( "close" );
                                  $('#special_submit').trigger('click');
            }
            console.log(" $(#special_submit).val(: " +  $("#special_submit").val()  );
}




function displaySaleTags( singular_item_customer_status) {
                if (singular_item_customer_status == "true") {
                                    console.log("customer is  singular type. show sale items");
                                    $(".sale_type_1").addClass("tags");
                                    $(".sale_label_1").show();
                } else {
                                    console.log("customer is not singular type");
                }
                console.log("show sale tags under correct conditions");
}



function breastPrintChoices() {
                    console.log("begin breastPrintChoices()");
                    //    $(".search_buttons").hide();
                    postNonAjax('/specsheet/crest_prints_list/', 'get', {
                                        item_class_component_item_id:  $('#item_class_component_item_id').val() ,
                                        design_id:  $('#design_id').val(),
                                        side:  $('#side').val(),
                                        main_design_id:  $('#back_design_id').val(),
                                        department_id:  $('#department_id').val(),
                                        purchases_entry_id:  $('#purchases_entry_id').val(),
                                        item_id:  $('#item_id').val()
                    });
                    console.log("end breastPrintChoices()");
}





function loadjscssfile(filename, filetype){
                if (filetype=="js"){ //if filename is a external JavaScript file
                                    var fileref=document.createElement('script')
                                    fileref.setAttribute("type","text/javascript")
                                    fileref.setAttribute("src", filename)
                }
                else if (filetype=="css"){ //if filename is an external CSS file
                                    var fileref=document.createElement("link")
                                    fileref.setAttribute("rel", "stylesheet")
                                    fileref.setAttribute("type", "text/css")
                                    fileref.setAttribute("href", filename)
                }
                if (typeof fileref!="undefined") {
                                    document.getElementsByTagName("head")[0].appendChild(fileref)
                }
}



function shareSpecsheet(  ){
    console.log("begin shareSpecsheet");


    var str = $( "form" ).serialize();
   console.log( str );


     if (   $('#share_product').html().length > 10  ) {
                      console.log("share already exists");
                      console.log("share already exists");
     }  else {
                          console.log("share does not exist");
                          console.log("share does not exist");
                        if (window.innerWidth > 450 ) {
                                            console.log("window is full size. share function will be run");

                                          var  the_doc_domain = document.domain  ;


                                            if ( $( "#specsheet_table img").first().attr("src") ) {
                                                            console.log("using src");
                                                            var image_to_share =  'http://' + the_doc_domain   +  $( "#specsheet_table img").first().attr("src").replace("specsheets", "thumbnails").replace("http://cdn.dixieoutfitters.com", "");
                                            }   else {
                                                            console.log("using background-image");
                                                            var image_to_share =  'http://' + the_doc_domain   +  $( "#specsheet_table").first().css("background-image").replace("specsheets", "thumbnails").replace("http://cdn.dixieoutfitters.com", "");
                                            }




                                            var description_to_share = $("#item_description").text().replace("Item Description","");



                                            if  (the_doc_domain == 'dixieoutfitters.net') {
                                                        the_app_id = '120689167949854';
                                            } else if (the_doc_domain == 'barberandcompany.net')  {
                                                         the_app_id = '1445913982325141';
                                            } else {
                                                        the_app_id = "308436462649023" ;
                                            }

                                            console.log("image_to_share: " + image_to_share );

                                            $('#share_product').share({
                                                                networks: ['twitter','facebook','tumblr','pinterest','googleplus','email'],
                                                                title : 'Check this out!',
                                                                pictureUrl :    image_to_share ,     //   'http://dixieoutfitters.net/images/item_thumbnails/11096_lmrp_ash.png',
                                                                pageDesc:description_to_share ,
                                                                orientation: 'vertical',
                                                                urlToShare:  'http://' +  the_doc_domain   + specsheetUrl(),
                                                                redirectUri:   'http://' +  the_doc_domain  + '/store/close_window' ,//     "http://192.168.0.125:2001/" + specsheetUrl(),
                                                                appId: the_app_id ,
                                                                affix: 'right center'
                                            })
                        } else {
                                            console.log("window is mobile size. share function not run");
                        }

     }

    console.log("end shareSpecsheet");
}




function expandCollapsibleDepartment( department_id  ) {
                  console.log("begin expandCollapsibleDepartment");
                 var the_department_to_expand_string  =    "#department_collapsible_" + department_id  ;
                 var the_department_to_expand  =     $( the_department_to_expand_string );
                 var the_main_menu_to_expand  =     $( the_department_to_expand_string ).closest(".main_menu_choices");
                  the_main_menu_to_expand.collapsible("expand")   ;
                  the_department_to_expand.collapsible("expand");
                  var scroll_offset =  the_department_to_expand.get(0).offsetTop;
                 console.log("scroll_offset: " + scroll_offset);
                  the_department_to_expand.addClass("ui-btn-active ui-btn") ;
                  setTimeout(function(){fncAnimate( scroll_offset )},100);
                console.log("end expandCollapsibleDepartment");
}



function fncAnimate( scroll_offset ){
                    $('html, body').animate({scrollTop:scroll_offset });
}



function getUrlParameter(sParam)
{
    var sPageURL = window.location.search.substring(1);
    var sURLVariables = sPageURL.split('&');
    for (var i = 0; i < sURLVariables.length; i++)
            {
                var sParameterName = sURLVariables[i].split('=');
                if (sParameterName[0] == sParam)
                        {
                            return sParameterName[1];
                        }
            }

    }



function getItemMenu(event) {
    console.log( "begin getItemMenu");

    var department_id = getUrlParameter('department_id');



    jQuery.ajax({
        type: "GET",
        dataType: 'script',
        url: "/store/items_menu"  ,
        data: {department_id:department_id }
    });
    console.log( "end getItemMenu");
}











function specsheetUrl() {
                    if ($("#item_class_component_item_id" ).val()  == ""  ||  $("#item_class_component_item_id").val() == undefined ) {
                                                if ($("#parameter_item_id" ).val()  == ""  ||  $("#parameter_item_id").val() == undefined ) {
                                                                       if ($("#item_id" ).val()  == ""  ||  $("#item_id").val() == undefined ) {
                                                                                             var the_item  =  $("#design_id").val() ;
                                                                       } else {

                                                                                             var the_item  =  $("#item_id").val() ;
                                                                       }
                                                } else {
                                                                        var the_item  =  $("#parameter_item_id").val() ;
                                                }
                    }   else {
                                    var the_item  =  $("#item_class_component_item_id").val() ;

                    }

                    var the_url  =   "/specsheet/" + the_item ;


                    if ( $("#department_id").val() == ""   ||  $("#department_id").val() == undefined  ) {
                                        console.log("no department_id");
                    }  else {
                                        var the_url  = addParameter( the_url , 'department_id',  $("#department_id").val()  );
                    }

                    if ( $("#design_id").val() == ""  ||  $("#design_id").val() == undefined ) {
                                        console.log("no design_id");
                    }  else {
                                        var the_url  = addParameter( the_url , 'design_id',  $("#design_id").val()  );
                    }

                    if ( $("#crest_id").val() == ""   ||  $("#crest_id").val() == undefined)  {
                                        console.log("no crest_id");
                    }  else {
                                        var the_url  = addParameter( the_url , 'crest_id',  $("#crest_id").val()  );
                    }

                    if ( $("#side").val() == ""   ||  $("#side").val() == undefined)  {
                                     console.log("no side");
                    }  else {
                                    var the_url  = addParameter( the_url , 'side',  $("#side").val()  );
                    }



                    if ( $("#item_class_component_item_id").val() == "" ||  $("#item_class_component_item_id").val() == undefined ) {
                                        console.log("no item_class_component_item_id");
                    }  else {
                                        var the_url  = addParameter( the_url , 'item_class_component_item_id',  $("#item_class_component_item_id").val()  );
                    }


                    if ( $("#purchases_entry_id").val() == ""  ||  $("#purchases_entry_id").val() == undefined)  {
                                        console.log("no purchases_entry_id");
                    }  else {
                                        var the_url  = addParameter( the_url , 'purchases_entry_id',  $("#purchases_entry_id").val()  );
                    }

               $("#specsheet_url").val( the_url  ) ;

            return the_url ;
}

function flashCookie() {
            Flash.transferFromCookies();
            var total_string  = Flash.data.notice  + Flash.data.error ;
        //           console.log( "total_string: " +  total_string  ) ;
        //           console.log( "total_string.length: " +  total_string.length    ) ;
            if (total_string.length > 9 ) {
                console.log( "application.html.erb inline js:  flash was found in cookie");
                console.log( "flash transferred and element shown");
                Flash.writeDataTo('error', $('#error_div_id'));
                Flash.writeDataTo('notice', $('#notice_div_id'));
                $('#attention_window').show();

            } else {
                console.log( "-----application.html.erb inline js: no flash found in cookie");
            }
}



//function flashCookie() {
//    $("#design_menu_choices").collapsible("expand");
//    $.mobile.silentScroll( $("#design_menu_choices").get(0).offsetTop);
//}



function watchAdminCrestPrints() {
    console.log("begin watchAdminCrestPrints");
    $('#submit_add_crest_prints').click(function(e) {
        console.log("submit_add_crest_prints")
        addCrestPrints();
    });

    $('#submit_remove_crest_prints').click(function(e) {
        console.log("submit_remove_crest_prints")
        removeCrestPrints()
    });

    $('#submit_default_crest_print').click(function(e) {
        console.log("submit_default_crest_print")
        setDefaultCrestPrint();
    });
}

function toggleItemButtons() {
                console.log("begin toggle_item_buttons");
                if ( isSymbiontInProgress() == true  ) {
                                var  cookie_content = jQuery.parseJSON( $.cookie('barber_preferences') ) ;
                                if (  cookie_content.item_type == "master") {
                                                    console.log("master");
                                                    $(".item_only_option").show();
                                                    $("#specsheet_link").attr("href", "/specsheet?purchases_entry_id=" + cookie_content.purchase_symbiote_purchases_entry_id );
                                }    else {
                                                    console.log("not master");
                                 }
                }
                console.log("end toggle_item_buttons");
}




function checkCookie() {
            if (document.cookie.indexOf("barber_email") >= 0) {
                                        if (document.cookie.indexOf("logged_in%3Dyes") >= 0) {
                                                                console.log("logged in is true") ;
                                        }  else {
                                                                console.log("logged in is false") ;
                                                                addLoginHeader();
                                        }
            }   else {
                                        console.log("no barber cookie") ;
                                        addLoginHeader();
            }
}


function addLoginHeader() {
                var hostname =  document.location.hostname;
                var port  =  document.location.port;
                var is_barber   =  hostname.indexOf("barber") ;
                console.log("hostname: " + hostname );
                if ( is_barber  == -1  )  {
                                    if ( port == "2001")  {
                                                         createBarberWholesaleWarning();
                                    }  else  {
                                                        console.log("barber not in hostname  and not in barber development");
                                    }

                }  else {
                                                        console.log("adding barber login header");
                                                        createBarberWholesaleWarning();
                }
}


function createBarberWholesaleWarning() {
                    var dd = document.createElement('div');
                    dd.setAttribute('style', "width:100%;height:94px;" );
                    var t = document.createElement('img');
                    t.setAttribute('src', "http://cdn.dixieoutfitters.com/images/headers/warning-login.jpg"   );
                    t.setAttribute('border', 0);
                    var link = document.createElement('a'); // create the link
                    link.setAttribute('href', '/account/login'); // set link path
                    link.appendChild(t); // append to link
                    dd.appendChild(link); // append to link
                   $(dd).appendTo(  "#attention_window"  );
                   $(  "#attention_window" ).show();
}


function setEmailCookie() {
                     document.cookie = "barber_email=yes,logged_in=no;"
}

function hideEmailCookie() {
                    document.cookie = "barber_email=yes,logged_in=no;"
                    $('signup').hide();
}


function deletePageCache() {
                console.log("begin deletePageCache");
                $.mobile.loading('show');
                $.ajax({
                                    type: "POST",
                                    url: "/p/delete_static_page_cache/" + $("#page_id").val()  ,
                                    dataType: 'script',
                                    data: {  }
                }).done(function( msg ) {
                                    $.mobile.loading('hide');
                                    $("#publish_button").hide();
                  });
                console.log("end deletePageCache");
}


function linkActsAsAjax() {
                console.log("binding linkActsAsAjax  ##############################")
                $(".link_acts_as_ajax").click(function (e) {
                                                              e.preventDefault();
                                                              var url = this.href;
                                                              console.log("linkActsAsAjax "  );
                                                              console.log("url: "  +  url );

                                                            jQuery.ajax({
                                                                    type: "GET",
                                                                    url: url
                                                            })
                });

    }


function performSearch(e) {
    console.log("begin performSearch"   );
   var  e_target = e.target.id
    console.log("e_target: " + e_target  );
    if ( isSymbiontInProgress() == true ) {
                        console.log("#####################################################################");
                        console.log("Please complete or delete your chosen design before searching for another design.");
                        $.mobile.loading('hide');
                        var  cookie_content = jQuery.parseJSON( $.cookie('barber_preferences') ) ;
                        if (  cookie_content.item_type == "master") {
                                             console.log("master");
                                            if  ( e_target  == "search_garments"  ||    e_target  == "search_merchandise" ) {
                                                                    console.log("clicked button search_garments or search_merchandise");
                                                                    $(".design_choices").show();
                                            } else {
                                                            console.log("clicked button which contains applicable opposite.. posting search");
                                                             postSearch(e);
                                            }

                        }    else {
                                        console.log("not master");
                                        if  ( e_target  == "search_designs" ) {
                                                        console.log("clicked button search_designs.. already have a design.. show choices");
                                                        $(".item_choices").show();
                                        } else {
                                                        console.log("clicked button which contains applicable opposite.. posting search");
                                                        postSearch(e);
                                        }
                        }

    } else {
                      console.log("not in progress");
                        postSearch(e);
    }
}



function postSearch(e) {
            console.log("begin postSearch()");
            $(".search_buttons").hide();
            postNonAjax('/search/', 'post', {
                            query:  $('#search_query').val() ,
                            search_type_name:  e.target.id
            });
}


function bindInfiniteScroll() {
    console.log("binding scroll bindInfiniteScroll  ##############################")
    $(document).scroll(function(e){
             if ( $(".revisions div:last").length > 0     ) {
                                if (element_in_scroll(".revisions div:last")) {
                                                 $(".load-more-revisions").hide();
                                                console.log("##############################")
                                                console.log("checking element_in_scroll")
                                                $(document).unbind('scroll');
                                                 if (  $("#page-link").html() != undefined ) {
                                                                    $.mobile.loading('show');
                                                                     var   next_page_url = $("#page-link").attr("href") ;
                                                                     $(".last_item").remove();
                                                                    $.ajax({
                                                                        type: "POST",
                                                                        url: next_page_url ,
                                                                        dataType: 'script',
                                                                        data: {  }
                                                                    }).done(function( msg ) {
                                                                                             $.mobile.loading('hide');
                                                                                            if (msg.count != 0) {
                                                                                                                $(document).scroll(function(e){
                                                                                                                            //                                                                    scroll_element_ajax();
                                                                                                                            console.log("scroll_element_ajax()");
                                                                                                                })
                                                                                            }
                                                                     });
                                                   }
                                 };
             }
    });
}

function element_in_scroll(elem)
{
                var docViewTop = $(window).scrollTop();
                var docViewBottom = docViewTop + $(window).height();

                var elemTop = $(elem).offset().top;
                var elemBottom = elemTop + $(elem).height();

                var status =  ((elemBottom <= docViewBottom) && (elemTop >= docViewTop));
                console.log("status: " + status);
                return status
}



function postNonAjax(action, method, input) {
    "use strict";
    var form;
    form = $('<form />', {
        action: action,
        method: method,
        style: 'display: none;'
    });
    if (typeof input !== 'undefined') {
        $.each(input, function (name, value) {
            $('<input />', {
                type: 'hidden',
                name: name,
                value: value
            }).appendTo(form);
        });
    }
    form.appendTo('body').submit();
}




function addParameter(url, param, value) {
                // Using a positive lookahead (?=\=) to find the
                // given parameter, preceded by a ? or &, and followed
                // by a = with a value after than (using a non-greedy selector)
                // and then followed by a & or the end of the string
                var val = new RegExp('(\\?|\\&)' + param + '=.*?(?=(&|$))'),
                    qstring = /\?.+$/;

                // Check if the parameter exists
                if (val.test(url))
                {
                            // if it does, replace it, using the captured group
                            // to determine & or ? at the beginning
                            return url.replace(val, '$1' + param + '=' + value);
                }
                else if (qstring.test(url))
                {
                            // otherwise, if there is a query string at all
                            // add the param to the end of it
                            return url + '&' + param + '=' + value;
                }
                else
                {
                            // if there's no query string, add one
                            return url + '?' + param + '=' + value;
                 }
}



function watchForDimesionChange() {
      $("#item_class_component_item_id").change(function( event){
          console.log("begin changing dimensions");
          if(event.handled !== true) {
                  console.log("### mobile loading show");
                  $.mobile.loading('show');
                  change_specsheet();
                  event.handled = true;
          }
      });
  }



function leftAlignPanel() {
             $(".yield").css("margin-left", "0");
             $(".yield").css("margin-right", "0");
 }

 function autoAlignPanel() {
             $(".yield").css("margin-left", "auto");
             $(".yield").css("margin-right", "auto");
 }

function filterDepartments(   activePage  ) {
    console.log("begin function filterDepartments");
    if ( isSymbiontInProgress() == true  ) {
                                            var  cookie_content = jQuery.parseJSON( $.cookie('barber_preferences') ) ;
                                            var symbiote_potential_opposite_department_ids =   cookie_content.potential_opposite_department_ids.split(",")   ;
                                             console.log("symbiote_potential_opposite_department_ids: " + symbiote_potential_opposite_department_ids );
                                            $('.department_collapsible').each(function(i, obj) {
                                                            var the_department = $(obj).attr('data-department_id');
                                                            the_department = the_department.toString();
//                                                              console.log("----------------------------------------------");
                                                            if ( jQuery.inArray( the_department  ,  symbiote_potential_opposite_department_ids      )  >  -1  ) {
                                                                                       console.log('this is a potential department: ' +  the_department );
                                                                                        $(obj).show();
                                                            } else {
                                                                                        console.log('this is not a potential department: ' +  the_department );
                                                                                        $(obj).hide();
                                                            }
//                                                             console.log("----------------------------------------------");
                                            } )
    }
    console.log("end function filterDepartments");
}


 function watchLeftPanel() {
        console.log( "begin watchLeftPanel") ;
     $( ".left-panel" ).panel({
         open: function( event, ui ) {
                  console.log("items panel opened");
                    leftAlignPanel();
         },
         close: function( event, ui ) {
                    console.log("items panel closed");
                    autoAlignPanel();
         }
     });

 }



 function filterCategories(   activePage  ) {
    console.log("begin filterCategories");
    if ( isSymbiontInProgress() == true ) {
        var  cookie_content = jQuery.parseJSON( $.cookie('barber_preferences') ) ;
        var opposite_category_ids =   cookie_content.opposite_category_ids.split(",")   ;
         console.log("opposite_category_ids: " + opposite_category_ids );
        $('.category_li').each(function(i, obj) {
                            var the_category =    $(obj).attr('data-category_id');
                             the_category = the_category.toString();
                            if ( jQuery.inArray( the_category  ,  opposite_category_ids   )  >  -1  ) {
//                                            console.log("it is a potential category:" +  the_category );
                                            $(obj).show();
                            } else {
//                                            console.log("it is not a potential category:" +  the_category );
                                            $(obj).hide();
                            }
        } )
    }  else {
        console.log("symbiont is not in progress, filterCategories not  needed");
    }
    console.log("end filterCategories");
}

function isSymbiontInProgress() {
      console.log("begin isSymbiontInProgress");
                      if ( $.cookie('barber_preferences' )  &&   $.cookie('barber_preferences') != undefined   ) {
                //                  console.log("cookie value: " + $.cookie('barber_preferences') );
                                  var  cookie_content = jQuery.parseJSON( $.cookie('barber_preferences') ) ;
                                  if ( cookie_content.ItemLookupCode != 0   ) {
                                                 console.log("cookie found- symbiont in progress");
                                                return true
                                  } else {
                                                 console.log("cookie found- symbiont is not in progress");
                                                return false
                                  }
                      } else {
                                 console.log("COOKIE NOT FOUND!! or undefined!")
                      }
      console.log("end isSymbiontInProgress");
  }


function updatePanelMessages() {
                console.log("begin updatePanelMessages");
                    if ( isSymbiontInProgress() == true  ) {
                                            console.log("cookie already exists!");
                                            console.log("cookie value: " + $.cookie('barber_preferences') );
                                            var  cookie_content = jQuery.parseJSON( $.cookie('barber_preferences') ) ;
                                            //                                    var  cookie_content = $.cookie('barber_preferences')   ;
                                            console.log("cookie_content.ItemLookupCode: " +  cookie_content.ItemLookupCode    );

                                            if (  cookie_content.item_type == "master") {
                                                                console.log("master updatePanelMessages");
                                                                $(".symbiote_items_menu_options").show();
                                            }    else {
                                                                console.log("not master updatePanelMessages");
                                                                $(".symbiote_items_menu_options").hide();
                                            }
                                            if (  cookie_content.item_type == "slave") {
                                                                console.log("slave updatePanelMessages");
                                                                $(".symbiote_designs_menu_options").show();
                                            }    else {
                                                                console.log("not slave updatePanelMessages");
                                                                $(".symbiote_designs_menu_options").hide();
                                            }
                    } else {
                                        console.log("cookie found with no symbiont in progress updatePanelMessages");
                    }
                console.log("end updatePanelMessages");
}



function updatePanelMessagesOriginal() {
                var item_departments_collapsible_set_size  =  $( "#item_departments_collapsible_set > *").filter(":visible").size() ;
                console.log("item_departments_collapsible_set_size: " + item_departments_collapsible_set_size );
                if ( item_departments_collapsible_set_size   == 0) {
                                console.log("item_departments_collapsible_set_size has no visible children");
                                $(".symbiote_items_menu_options").show();
                } else {$(".symbiote_items_menu_options").hide();}
                var design_departments_collapsible_set_size  =  $( "#design_departments_collapsible_set > *").filter(":visible").size() ;
                console.log("design_departments_collapsible_set_size: " + design_departments_collapsible_set_size );
                if ( design_departments_collapsible_set_size   == 0) {
                                console.log("design_departments_collapsible_set_size has no visible children");
                                $(".symbiote_designs_menu_options").show();
                }  else {$(".symbiote_designs_menu_options").hide();}
}

function navigate_without_url_change(obj){
                console.log("navigate_without_url_change");
                window.location = obj.attr('href');
}


function itemDepartmentsListToContainer() {
    if ( $('#item_choices_container').length > 0  )  {
        console.log("append designs_departments_list to design_choices_container");
        $("#items_departments_list").detach().appendTo('#item_choices_container')  ;
    }  else {
        console.log("no item_choices_container") ;
    }
}

function designDepartmentsListToContainer() {
                if ( $('#design_choices_container').length > 0  )  {
                                console.log("append designs_departments_list to designs_choices_container");
                                $("#designs_departments_list").detach().appendTo('#design_choices_container')  ;
                }  else {
                               console.log("no design_choices_container") ;
                }
}



function buildFooterFromCookie(activePage) {
              console.log("begin buildFooterFromCookie");
              if ( activePage)  {
                                if ( isSymbiontInProgress() == true  ) {
                                                console.log("cookie already exists!");
                                                console.log("cookie value: " + $.cookie('barber_preferences') );
                                                var  cookie_content = jQuery.parseJSON( $.cookie('barber_preferences') ) ;
            //                                    var  cookie_content = $.cookie('barber_preferences')   ;
                                                 console.log("cookie_content.ItemLookupCode: " +  cookie_content.ItemLookupCode    );
                                                //    THIS GETS PREVIOUS PAGE - HIDDEN PAGE
                                                //    $(":jqmData(role='page'):last").find("#symbiote_thumbnail_container").html( "<img style='height:85px;' src='" +  cookie_content.image_url  + "'  alt='" +   cookie_content.ItemLookupCode  + "'>" );
                                                //    $(":jqmData(role='page'):last").find( "#symbiote_description_container").html(    cookie_content.ItemLookupCode  + cookie_content.Description  +  cookie_content.Dimensions  );
                                                activePage.find(".symbiote_thumbnail_container_link").html( "<img  src='" +  cookie_content.image_url  + "'  class='toggle_item_buttons'  alt='" +   cookie_content.ItemLookupCode  + "'>" );
//                                                activePage.find( ".symbiote_thumbnail_container_link").append(    cookie_content.ItemLookupCode  +  " " + cookie_content.Description +  " "   +  cookie_content.Dimensions  );
                                                activePage.find( ".symbiote_thumbnail_container_link").append(  " <h2 class='toggle_item_buttons'>" +   cookie_content.ItemLookupCode  + "</h2><p  class='toggle_item_buttons'>"+ cookie_content.Description +  " "   +  cookie_content.Dimensions + "</p>" );

                                              $('.symbiote_container_listview').listview("refresh");

                                                activePage.find( ".symbiote_container").attr("data-potential_opposite_department_ids",cookie_content.potential_opposite_department_ids   ) ;
                                                activePage.find( ".symbiote_container").attr("data-opposite_category_ids",  cookie_content.opposite_category_ids    ) ;
//                                                 activePage.find("#specsheet_choice").html( "<a href='/specsheet/" + cookie_content.item_id +  "'>View Details</a>" );
                                                console.log("THIS THIS THIS THIS THIS THIS");
                                                console.log("THIS THIS THIS THIS THIS THIS");
                                                if (  cookie_content.item_type == "master") {
                                                                            console.log("master,  update .symbiote_message_container");
//                                                                            activePage.find(".symbiote_message_container").html( "Please find a design for your chosen item" );
                                                                             console.log(" add Open designs link to .open choice");
//                                                                            activePage.find(".open_choice").html( "<a href='#designs_panel'>Open designs</a>" );
//
//                                                                            designDepartmentsListToContainer();

//                                                                              $("#design_choices_container").html( $("#designs_departments_list").html() ) ;


                                                                          $("#item_menu_choices").hide() ;


                                                                            activePage.find(".design_options").show();
                                                                            console.log("buildFooterFromCookie designs_panel open");
                                                }    else {
                                                                            console.log("not master");
//                                                                            activePage.find(".symbiote_message_container").html( "Your chosen design" );
//                                                                            activePage.find(".open_choice").html( "<a href='#items_panel'>Open items</a>" );
//

                                                                               $("#design_menu_choices").hide() ;

//                                                                            itemDepartmentsListToContainer();


//                                                                           $("#item_choices_container").html( $("#items_departments_list").html() ) ;
                                                                            activePage.find(".item_options").show();
                                                                             console.log("buildFooterFromCookie items_panel open");
                                                }
                                                console.log("THIS THIS THIS THIS THIS THIS");
                                                console.log("THIS THIS THIS THIS THIS THIS");
//                                                leftAlignPanel();
                                                activePage.find( ".symbiote_menu" ).listview( "refresh" );
                                                activePage.find(".foot").show();
                                                activePage.find(".symbiote_choices").show();
                                } else {
                                                console.log("########################");
                                                console.log("cookie found with no symbiont in progress");
                                                activePage.find(".all_options").show();
//                                                activePage.find(".foot").hide();
                                                activePage.find(".symbiote_choices").hide();
//                                               createInitialCookie();
                                }
              } else {
                            console.log("activePage not defined");
                            $(".foot").hide();
                            $(".symbiote_choices").hide();
              }
            console.log("end buildFooterFromCookie");
}



function openPanel() {
    console.log("begin openPanel");
    if ( isSymbiontInProgress() == true  ) {
                       var  cookie_content = jQuery.parseJSON( $.cookie('barber_preferences') ) ;
                        if (  cookie_content.item_type == "master") {
                                        $.mobile.activePage.find( "#designs_panel" ).panel( "open");
                                        console.log("open designs_panel");
                        } else {
                                        $.mobile.activePage.find( "#items_panel" ).panel( "open");
                                        console.log("open items_panel");
                        }
    }  else { console.log("no symbiont");}
    console.log("end openPanel");
}






//    BEGIN SPECSHEET FUNCTIONS

function toggleSide() {

                 $( "#change_design_options" ).popup( "close" );

                if ( $("#side").val() == "front") {
                                 $("#side").val("back");
                } else {
                                 $("#side").val("front");
                }

                 change_specsheet();
}




function change_specsheet() {
            jQuery.ajax({
                        type: "GET",
                        dataType: 'script',
                        url: "/specsheet/update_specsheet",
                        data: { item_id:  $('#item_class_component_item_id').val()  , side:  $('#side').val()  , design_id:  $('#design_id').val()   , show_wide_specsheet:  $('#show_wide_specsheet').val()  , department_id:  $('#department_id').val() , purchases_entry_id:  $('#purchases_entry_id').val(), crest_id: $('#crest_id').val()  }
            });
}


function changeBreastPrint(e ) {
                    var bp = $(e.target);
                    console.log("bp.src: " + bp.attr("src") );
}



function setDefaultCrestPrint() {
                console.log("test test");
                var allVals = [];
                $('#admin_crest_print_choices_to_remove :checked').each(function() {
                                allVals.push($(this).val());
                });
                if ($('#admin_crest_print_choices_to_remove :checked').size()   > 1  ) {
                                 alert("please choose only one crest print to use as default.");
                } else {


                                console.log("length not greater than 1: "   );
                                $('#item_id_to_default').val(allVals)

                                jQuery.ajax({
                                    type: "GET",
                                    url: "/specsheet/update_crest_prints_list",
                                    data: { item_id_to_default:  $('#item_id_to_default').val()   , category_id:  $('#category_id').val()  , main_design_id:  $('#main_design_id').val() }
                                });
                }
}

function removeCrestPrints() {
    var allVals = [];
    $('#admin_crest_print_choices_to_remove :checked').each(function() {
                 allVals.push($(this).val());
    });
    $('#item_ids_to_remove').val(allVals)

    jQuery.ajax({
                    type: "GET",
                    url: "/specsheet/update_crest_prints_list",
                    data: { item_ids_to_remove:  $('#item_ids_to_remove').val()   , category_id:  $('#category_id').val()  , main_design_id:  $('#main_design_id').val() }
    });
}

function addCrestPrints() {
                var allVals = [];
                $('#admin_crest_print_choices :checked').each(function() {
                                allVals.push($(this).val());
                });
                $('#item_ids').val(allVals)

                jQuery.ajax({
                                type: "GET",
                                url: "/specsheet/update_crest_prints_list",
                                data: { item_ids:  $('#item_ids').val()   , category_id:  $('#category_id').val()  , main_design_id:  $('#main_design_id').val() }
                });
}

