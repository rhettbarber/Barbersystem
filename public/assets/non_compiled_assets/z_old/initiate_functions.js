console.log("-----BEGIN file initiate_functions.js");


$(".specsheet_crest_prints_list").on('pageshow', function(event){
                    specsheetUrl();
                    $( ".acrest_print" ).click(function( event ) {
                                                console.log("great");
                                                event.preventDefault();

                                                var crest_item_id  = $(this).attr("data-id");
                                                var specsheet_page_url  = addParameter(  specsheetUrl()  , 'crest_id', crest_item_id );

                                                console.log("specsheet_page_url: " +   specsheet_page_url    )

                                                 window.location =  specsheet_page_url;
                    });
});


$(".application").on('pageinit', function(event){
                console.log("--BEGIN EVENT-------------------------------------------------------------");
                console.log("begin .aplication  on pageinit")
                console.log( "run flashCookie");
                 flashCookie();
                console.log( "finished running flashCookie");
                if (  $("#items_menu").length > 0    ) {
                                    console.log("items_menu exists");
                                     console.log( "run isSymbiontInProgress");
//                                    if ( isSymbiontInProgress() == true  ) {
//                                                    console.log("isSymbiontInProgress.. about to resize for symbiont");
//                                                                    $("#items_menu").css("min-height", "180px");
//
//                                    }  else {
//                                                    console.log("isSymbiontInProgress is false");
//                                                    console.log("about to resize to show item and design choices");
//                                                                        $("#items_menu").css("min-height", "110px");
//                                    }
                                    getItemMenu(event);
                }
                 console.log("end .application on pageinit");
                 console.log("-- END EVENT-------------------------------------------------------------");
});



// MAIN PAGE SHOW FUNCTION LOADED ON EVERY PAGE
// MAIN PAGE SHOW FUNCTION LOADED ON EVERY PAGE
// MAIN PAGE SHOW FUNCTION LOADED ON EVERY PAGE
$(".application").on('pageshow', function(event){
                console.log("--BEGIN EVENT-------------------------------------------------------------");

                //                loadjscssfile("/assets/non_compiled_assets/temporary.js", "js") //dynamically load and add this .js file
                //                loadjscssfile("/assets/non_compiled_assets/temporary.css", "css") ////dynamically load and add this .css file


                if ( $.cookie('barber_admin' )  &&   $.cookie('barber_admin') != undefined   ) {
                                         console.log("barber_admin cookie found");
                                        loadjscssfile("/assets/non_compiled_assets/store_administration.js", "js")
                }  else {
                                        console.log("no barber_admin cookie found");
                }


                console.log("--BEGIN EVENT-------------------------------------------------------------");
                console.log("begin .application  on pageshow");
                $.mobile.loading('hide');

                bindInfiniteScroll();
                linkActsAsAjax();

                var lastClicked;
                $( 'body').click(function(e) {
                                    console.log( " $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"    ) ;
                                    clicked =    $(this);
                                    console.log( "this.target: "  +  clicked.target     ) ; // Do your stuff to the clicked element here


                                    if (   $(e.target).hasClass("breast_prints_link")  ) {
                                        breastPrintChoices();
                                    }  else {
                                                         console.log("target does not have class breast_prints_link")
                                    }

                                    if (   $(e.target).hasClass("toggle_item_buttons")  ) {
                                                        toggleItemButtons();
                                    }  else {
                                                         console.log("target does not have class toggle_item_buttons")
                                    }



                                   if  (  $( e.target ).attr("href") == "#items_panel" ) {
                                                         console.log("#items_panel clicked.. time");
                                                         $("#item_menu_choices").collapsible("expand");
                                                         $.mobile.silentScroll( $("#item_menu_choices").get(0).offsetTop);
                                   }  else if  ( $( e.target ).attr("href") == "#designs_panel" ) {
                                                         console.log("#designs_panel clicked.. time");
                                                         $("#design_menu_choices").collapsible("expand");
                                                            $.mobile.silentScroll( $("#design_menu_choices").get(0).offsetTop);
                                   }



                                    lastClicked = clicked;

                                    var closest_panel =   $(e.target).closest(".ui-panel") ;
                                    if ( closest_panel.attr("id") == "pages_panel" ) {
                                                        console.log("wrote cookie for pages panel");
                                                           document.cookie = "last_panel=pages_panel; path=/"

                                    } else if ( closest_panel.attr("id") == "items_panel" ) {
                                                        console.log("wrote cookie for items panel");
                                                        document.cookie = "last_panel=items_panel; path=/"
                                    }   else    {
                                                        console.log("wrote cookie for designs panel") ;
                                                         document.cookie = "last_panel=designs panel; path=/"
                                    }
                } )


                $( ".ui-input-btn,   a[href]:not([href*='#'],[href*='tel'],[href*='mailto'] )" ).click(function( event ) {
                                    console.log("mobile loader open" );
                                    if  (  $(event.target).hasClass("no_loader") )  {
                                                console.log("class no_loader found on link");
                                    }  else {
                                                console.log("no special class found on link, loader shown");
                                                 $.mobile.loading('show');
                                    }

                });

                $(document).on('submit', function(){
                                    console.log("initiate functions.js-application pageshow. on submit" );
                                    console.log("mobile loader open due to submit" );
                                    console.log("prevent mobile loading show on local events not directing" );
                                    $.mobile.loading('show');
                });

              $(".search_button").on('click', function(e){
                                    console.log("performSearch" );
                                    $.mobile.loading('show');
                                    performSearch(e);
               });

              $('body').on('click', '.publish_button',  deletePageCache  );


              $('input').focus(function() {
                                    $("#update_quantities").show();
                                    // do something
              }).click(function() {
                                        // do something
              });

                console.log("end .application  on pageshow");
                console.log("-- END EVENT-------------------------------------------------------------");
});





function scrollTo( scroll_position) {
    $(function(){
                    $('html, body').animate({
                                            scrollTop: scroll_position
                    });
    });
}




$(".search_scroll").on('pageshow', function(event){
    console.log("begin .search_scroll  on pageshow");
            if ( isSymbiontInProgress() == true  ) {
                            var  cookie_content = jQuery.parseJSON( $.cookie('barber_preferences') ) ;
                            if (  cookie_content.item_type == "master") {
                                                    console.log("master");
//                                                     $("#item_choices_title").html("Scroll our Item departments");
                                                    $(".item_departments").hide();
                                                    $(".design_departments").show();
                                                    $(".design_choices").show();
                                                    $(".item_only_option").show();
                            }    else {
                                                     console.log("not master");
                                                     $(".item_departments").show();
                                                     $(".design_departments").hide();
//                                                     $("#design_choices_title").html("Scroll our Design departments");
                                                     $(".design_choices").hide();
                            }
            } else {
//                                                $("#item_choices_title").html("Scroll our Design departments");
//                                                $("#design_choices_title").html("Scroll our Item departments");
                                                $(".item_departments").show();
                                                $(".design_departments").show();
                                                $(".design_choices").hide();
                                                $(".item_choices").hide();
            }
});



$("#specsheet_admin_crest_prints_list").on('pageshow', function(event){
                                                console.log("begin .specsheet_admin_crest_prints_list  on pageshow");
                                                watchAdminCrestPrints() ;
                                                console.log("end .specsheet_admin_crest_prints_list on pageshow");
});





$(".page_show").on('pageshow', function(event){
                                           console.log("begin .page_show  on pagebeforeshow");
                                            //    $( "#pages_panel" ).panel( "open");
                                            console.log("end .page_show on pagebeforeshow");
});



$(".cart_index").on('pageshow', function(event){
                                    console.log("begin .cart_index pageshow");
                                    $('.navigate_without_url_change').click(function(e) {
                                                    console.log("navigate_without_url_change")
                                                    e.preventDefault();
                                                    navigate_without_url_change($(this));
                                    });
                                    console.log("end .cart_index pageshow");
});



function isFootVisible() {
                                if ( $(".foot").is(":visible") ) {
                                            console.log(".foot is visible");
                                }  else {
                                            console.log(".foot is not visible");
                                }
}


$(".specsheet_index").on('pageshow', function(event){
                            console.log("begin .specsheet_index pageshow");


                          shareSpecsheet();


                            $('.breast_print').on( 'click', changeBreastPrint );

                          if ( $.cookie('barber_admin' )  &&   $.cookie('barber_admin') != undefined   ) {
                            watchForDragging() ;
                          }

                            console.log("watch for changing dimensions");
                            //    $(document).off('change');
                                watchForDimesionChange();
                            console.log("end .specsheet_index pageinit");
});




function expandItemMenu() {
    console.log(" $.cookie('last_panel'): " +  $.cookie('last_panel') );
    var current_link =   window.location.pathname;

    if ( current_link.indexOf("specsheet") >= 0 ) {
        console.log("current_link a specsheet page. about to look for cookie current_link") ;
        current_link    =  $.cookie('current_link');

    } else {
        console.log("current_link is not a specsheet page, it will be used as current_link") ;
        document.cookie = "current_link=" + current_link + "; path=/" ;
    }
    var cookieLink  = $('a[href="' + current_link + '"]');
    cookieLink.addClass("ui-btn-active") ;
    var  departmentCollapsibleElement =  cookieLink.closest(".department_collapsible")   ;
    departmentCollapsibleElement.collapsible('expand');
}