function changeTransferType(){console.log("begin changeTransferType");var e=0;if($(".sublimation_only").size()>0&&"plas"==$("#transfer_type_id option:selected").val())console.log("selected type value is plas, and sublimation_only design"),$("#purchases_entries_QuantityOnOrder").val()<300?(console.log("quantity entered is less than 300, give warning, hide choose button"),$("#minimum_quantity_message").show(),$(".choose_button").button("disable")):($("#minimum_quantity_message").hide(),$(".choose_button").button("enable"));else{console.log("selected type value is not plas,or not a sublimation_only design set quantity by  quantity field value");var o=$("#purchases_entries_QuantityOnOrder").val();$("#minimum_quantity_message").hide()}console.log("the_quantity: "+o),12>o||""==o?(console.log("price-1"),e=$("#transfer_type_id option:selected").data("price-1")):o>=12&&99>=o?(console.log("price-2"),e=$("#transfer_type_id option:selected").data("price-2")):o>99&&299>=o?(console.log("price-3"),e=$("#transfer_type_id option:selected").data("price-3")):o>299?(console.log("price-4"),e=$("#transfer_type_id option:selected").data("price-4")):(console.log("quantity not in range. using price-1"),e=$("#transfer_type_id option:selected").data("price-1")),console.log("the_price: "+e),"0.01"==e?console.log("Price is a penny... do not update."):$("#your_unit_price").html(parseFloat(e).toFixed(2)),"plas"==$("#transfer_type_id option:selected").val()?(console.log("selected type value is plas"),$(".sublimation_transfer_message").hide(),$(".plas_transfer_message").show()):(console.log("selected type value is NOT plas"),$(".sublimation_transfer_message").show(),$(".plas_transfer_message").hide()),console.log("end changeTransferType")}function scrollTo(e){$(function(){$("html, body").animate({scrollTop:e})})}function isFootVisible(){console.log($(".foot").is(":visible")?".foot is visible":".foot is not visible")}function expandItemMenu(){console.log(" $.cookie('last_panel'): "+$.cookie("last_panel"));var e=window.location.pathname;e.indexOf("specsheet")>=0?(console.log("current_link a specsheet page. about to look for cookie current_link"),e=$.cookie("current_link")):(console.log("current_link is not a specsheet page, it will be used as current_link"),document.cookie="current_link="+e+"; path=/");var o=$('a[href="'+e+'"]');o.addClass("ui-btn-active");var n=o.closest(".department_collapsible");n.collapsible("expand")}console.log("-----BEGIN file initiate_functions.js"),$(".specsheet_crest_prints_list").on("pageshow",function(){specsheetUrl(),$(".acrest_print").click(function(e){console.log("great"),e.preventDefault();var o=$(this).attr("data-id"),n=addParameter(specsheetUrl(),"crest_id",o);console.log("specsheet_page_url: "+n),window.location=n})}),$(".application").on("pageinit",function(e){console.log("--BEGIN EVENT-------------------------------------------------------------"),console.log("begin .aplication  on pageinit"),console.log("run flashCookie"),flashCookie(),console.log("finished running flashCookie"),$("#items_menu").length>0&&(console.log("items_menu exists"),console.log("run isSymbiontInProgress"),getItemMenu(e)),console.log("end .application on pageinit"),console.log("-- END EVENT-------------------------------------------------------------")}),$(".application").on("pageshow",function(){console.log("--BEGIN EVENT-------------------------------------------------------------"),$.cookie("barber_admin")&&void 0!=$.cookie("barber_admin")?(console.log("#####################################"),console.log("#####################################"),console.log("#####################################"),console.log("#####################################"),console.log("#####################################"),console.log("#####################################"),console.log("load store_administration.js"),console.log("barber_admin cookie found"),loadjscssfile("/assets/non_compiled_assets/store_administration.js","js"),console.log("load store_administration.js")):console.log("no barber_admin cookie found"),console.log("--BEGIN EVENT-------------------------------------------------------------"),console.log("begin .application  on pageshow"),$.mobile.loading("hide"),bindInfiniteScroll(),linkActsAsAjax();var e;$("body").click(function(o){console.log(" $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"),clicked=$(this),console.log("this.target: "+clicked.target),$(o.target).hasClass("breast_prints_link")?breastPrintChoices():console.log("target does not have class breast_prints_link"),$(o.target).hasClass("toggle_item_buttons")?toggleItemButtons():console.log("target does not have class toggle_item_buttons"),"#items_panel"==$(o.target).attr("href")?(console.log("#items_panel clicked.. time"),$("#item_menu_choices").collapsible("expand"),$.mobile.silentScroll($("#item_menu_choices").get(0).offsetTop)):"#designs_panel"==$(o.target).attr("href")&&(console.log("#designs_panel clicked.. time"),$("#design_menu_choices").collapsible("expand"),$.mobile.silentScroll($("#design_menu_choicequantitiess").get(0).offsetTop)),e=clicked;var n=$(o.target).closest(".ui-panel");"pages_panel"==n.attr("id")?(console.log("wrote cookie for pages panel"),document.cookie="last_panel=pages_panel; path=/"):"items_panel"==n.attr("id")?(console.log("wrote cookie for items panel"),document.cookie="last_panel=items_panel; path=/"):(console.log("wrote cookie for designs panel"),document.cookie="last_panel=designs panel; path=/")}),$(".ui-input-btn,   a[href]:not([href*='#'],[href*='tel'],[href*='mailto'] )").click(function(e){console.log("mobile loader open"),$(e.target).hasClass("no_loader")?console.log("class no_loader found on link"):(console.log("no special class found on link, loader shown"),$.mobile.loading("show"))}),$(document).on("submit",function(){console.log("initiate functions.js-application pageshow. on submit"),console.log("mobile loader open due to submit"),console.log("prevent mobile loading show on local events not directing"),$.mobile.loading("show")}),$(".search_button").on("click",function(e){console.log("performSearch"),$.mobile.loading("show"),performSearch(e)}),$("body").on("click",".publish_button",deletePageCache),$(".update_QuantityOnOrder").keyup(function(e){if(console.log("############################"),console.log("begin update_QuantityOnOrder"),console.log("begin update_QuantityOnOrder"),e.handled!==!0){var o="#purchases_entry_id_"+$(e.target).attr("data-purchases_entry_id")+"_message";console.log("pe_message_to_show: "+o),e&&e.target.value<300&&$(e.target).attr("data-transfer_type")&&"sublimation_only"==$(e.target).attr("data-transfer_type")?(console.log("purchases_entry_id: "+$(e.target).attr("data-purchases_entry_id")),console.log("this item requires a minimum of 300 pcs for silkscreen."),$(e.target).css({"background-color":"pink"}),$(o).show(),$("#update_quantities").hide()):(console.log("No quantity minimum rules apply"),$("#update_quantities").show(),$(e.target).css({"background-color":"white"}),$(o).hide()),e.handled=!0}console.log("end update_QuantityOnOrder"),console.log("end update_QuantityOnOrder"),console.log("end update_QuantityOnOrder"),console.log("############################")}).click(function(){}),$("input").focus(function(){}).click(function(){}),console.log("end .application  on pageshow"),console.log("-- END EVENT-------------------------------------------------------------")}),$(".search_scroll").on("pageshow",function(){if(console.log("begin .search_scroll  on pageshow"),1==isSymbiontInProgress()){var e=jQuery.parseJSON($.cookie("barber_preferences"));"master"==e.item_type?(console.log("master"),$(".item_departments").hide(),$(".design_departments").show(),$(".design_choices").show(),$(".item_only_option").show()):(console.log("not master"),$(".item_departments").show(),$(".design_departments").hide(),$(".design_choices").hide())}else $(".item_departments").show(),$(".design_departments").show(),$(".design_choices").hide(),$(".item_choices").hide()}),$("#specsheet_admin_crest_prints_list").on("pageshow",function(){console.log("begin .specsheet_admin_crest_prints_list  on pageshow"),watchAdminCrestPrints(),console.log("end .specsheet_admin_crest_prints_list on pageshow")}),$(".page_show").on("pageshow",function(){console.log("begin .page_show  on pagebeforeshow"),console.log("end .page_show on pagebeforeshow")}),$(".cart_index").on("pageshow",function(){console.log("begin .cart_index pageshow"),$(".navigate_without_url_change").click(function(e){console.log("navigate_without_url_change"),e.preventDefault(),navigate_without_url_change($(this))}),console.log("end .cart_index pageshow")}),$(".specsheet_index").on("pageshow",function(){console.log("begin .specsheet_index pageshowDDDD"),changeTransferType(),$("#purchases_entries_QuantityOnOrder").keyup(function(e){console.log("begin changing purchases_entries_QuantityOnOrder"),e.handled!==!0&&(console.log("###  purchases_entries_QuantityOnOrder"),changeTransferType(),e.handled=!0)}),$("#transfer_type_id").change(function(e){console.log("begin changing transfer_type_id"),e.handled!==!0&&(console.log("###  transfer_type_id"),changeTransferType(),e.handled=!0)}),$(".breast_print").on("click",changeBreastPrint),console.log("watch for changing dimensions"),watchForDimesionChange(),console.log("end .specsheet_index pageinit")});