//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  function updateAdvancedCombinationBack( combo_id ,  specsheet_type_id,  default_side, verified_correct,  number_of_sides, back_left, back_top, back_width   ) {
      console.log("updateAdvancedCombinationBack");
      $.ajax({
              type: "POST",
              url: "/store/update_advanced_combination/" + combo_id  ,
              data: { advanced_combination: {
                      specsheet_type_id: specsheet_type_id  ,
                      default_side:default_side ,
                    verified_correct:verified_correct ,
                      number_of_sides:number_of_sides ,
                      back_left:back_left ,
                      back_top:back_top ,
                      back_width: back_width
                  }
              }
      }).done(function( msg ) {
          console.log( "Data Saved: " + msg );
      });
  }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  function updateAdvancedCombinationFront( combo_id ,  specsheet_type_id,  default_side, verified_correct,  number_of_sides, front_left, front_top, front_width   ) {
                  console.log("updateAdvancedCombinationFront");
                  $.ajax({
                                      type: "POST",
                                      url: "/store/update_advanced_combination/" + combo_id  ,
                                      data: { advanced_combination: {
                                                      specsheet_type_id: specsheet_type_id  ,
                                                      default_side:default_side ,
                                                      verified_correct:verified_correct ,
                                                      number_of_sides:number_of_sides ,
                                                      front_left: front_left ,
                                                      front_top: front_top ,
                                                      front_width: front_width
                                          }
                          }
                  }).done(function( msg ) {
                                    console.log( "Data Saved: " + msg );
                  });
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$(document).on('click','#submit_size_and_position_back', function() {
           console.log('clicked #submit_size_and_position_back');
            console.log( "back_advanced_combination_id:" +  $('#back_advanced_combination_id').val() );
           if ( $("#side").val()  == "front"   )  {
                                               if ( $("#back_design_verified_correct").val() == 'true' ) {
                                                           alert("Do not set Breast print to verified correct. It will remain unverified.");
                                               }
                                                console.log('clicked #submit_size_and_position_back with what_size == front');
                                                console.log( "USE back_advanced_combination_id:" +  $('#front_advanced_combination_id').val()  );
                                                console.log( "SET advanced_combination.back_width TO  back_design_image width:" +   $('#back_design_image').css('width') );
                                                console.log(" updateAdvancedCombinationBack(  specsheet_type_id,  default_side, number_of_sides, back_left, back_top, back_width   )");
                                                 updateAdvancedCombinationBack( $('#back_advanced_combination_id').val() , $("#item_specsheet_type_id").val() ,  $("#back_design_default_side").val(),  false  , $("#item_number_of_sides").val() ,  $('#back_design_image').css('left') ,  $('#back_design_image').css('top') ,  $('#back_design_image').css('width')   )  ;

           } else {
                                                console.log('clicked #submit_size_and_position_back with what_size NORMAL');
                                                updateAdvancedCombinationBack( $('#back_advanced_combination_id').val(), $("#item_specsheet_type_id").val() ,  $("#back_design_default_side").val(),  $("#back_design_verified_correct").val()  ,  $("#item_number_of_sides").val(),  $('#back_design_image').css('left') ,  $('#back_design_image').css('top') ,  $('#back_design_image').css('width')   )  ;
           }

});
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$(document).on('click','#submit_size_and_position_front', function() {
                console.log('clicked #submit_size_and_position_front');
                console.log('DISABLED.. WORK ON BACK FOR NOW');
                console.log('DISABLED.. WORK ON BACK FOR NOW');
                console.log('DISABLED.. WORK ON BACK FOR NOW');
                console.log('DISABLED.. WORK ON BACK FOR NOW');
                if ( $("#side").val()  == "front"   )  {
                                                 $('#front_advanced_combination_id').val()
                                                console.log('clicked #submit_size_and_position_front with what_size == front');
                                                console.log( "USE front_advanced_combination_id:" +  $('#front_advanced_combination_id').val() );
                                                console.log( "SET advanced_combination.front_width TO  front_design_image width:" +   $('#front_design_image').css('width') );
                                                updateAdvancedCombinationFront( $('#front_advanced_combination_id').val(),  $("#item_specsheet_type_id").val()  , $("#item_default_side").val() ,  $("#front_design_verified_correct").val()   , $("#item_number_of_sides").val() ,  $('#front_design_image').css('left') ,  $('#front_design_image').css('top') ,  $('#front_design_image').css('width')   )  ;
                } else {
                                               if ( $("#front_design_verified_correct").val() == 'true' ) {
                                                                       alert("Do not set Breast print to verified correct. It will remain unverified.");
                                               }
                                               console.log('clicked #submit_size_and_position_front with what_size NORMAL');
                                               console.log( "USE front_advanced_combination_id:" +  $('#front_advanced_combination_id').val() );
                                               console.log( "SET advanced_combination.front_width TO  front_design_image width:" +   $('#front_design_image').css('width') );
                                               updateAdvancedCombinationFront( $('#front_advanced_combination_id').val(),  $("#item_specsheet_type_id").val()  , $("#item_default_side").val(),  false  ,  $("#item_number_of_sides").val() ,  $('#front_design_image').css('left') ,  $('#front_design_image').css('top') ,  $('#front_design_image').css('width')   )  ;
                }
});
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$(document).on('click','#delete_this_page', function() {
    console.log('begin_clicked #delete_this_page');
    console.log('$("#page_id").val(): ' + $("#page_id").val() );
    deletePage();
    console.log('end clicked #delete_this_page');
});
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$(document).on('click','#edit_this_page', function() {
            console.log('begin_clicked #edit_this_page');
            console.log('$("#page_id").val(): ' + $("#page_id").val() );
            editPage();
            console.log('end clicked #edit_this_page');
});
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$(document).on('click','#new_page', function() {
            console.log('begin_clicked #new_page');
            console.log('$(.jstree-clicked.parent().attr(data-page_id)');
            var parent_page_id = $('.jstree-clicked').parent().attr("data-page_id");
            newPage( parent_page_id );
            console.log('end clicked #new_page');
});
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function newPage( parent_page_id ) {
    console.log("begin newPage()");
    console.log(  "parent_page_id: "  + parent_page_id   );
    $(".admin_hidden").hide();
    window.location =  "/page/new/"  +   $('#page_id').val() ;
//    $.mobile.loading('show');
    console.log("end newPage()");
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function editPage() {
    console.log("begin editPage()");
    $("#edit_this_page").hide();
    window.location =  "/page/edit/"  +   $('#page_id').val() ;
    $.mobile.loading('show');
    console.log("end editPage()");
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function deletePage() {
    console.log("begin deletePage()");
    $("#edit_this_page").hide();
    window.location =  "/page/delete/"  +   $('#page_id').val() ;
    $.mobile.loading('show');
    console.log("end deletePage()");
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$(document).on('click','#submit_size_and_position_item', function() {
    console.log('clicked #submit_size_and_position_item');
    $.ajax({
        type: "POST",
        url: "/store/update_advanced_combination/" + $('#item_advanced_combination_id').val() ,
        data: { advanced_combination: {
            specsheet_type_id: $('#item_specsheet_type_id').val() ,
            default_side: $('#item_default_side').val() ,
            number_of_sides: $('#item_number_of_sides').val()
        }
        }
    }).done(function( msg ) {
                console.log( "Data Saved: " + msg );
            });
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
function scaleBack(v) {
                  console.log("begin scale back") ;
                var original_width  =  parseInt($('#back_design_image').css('width').replace(/[^0-9]/g, '')) ;
                var new_width =  original_width + parseInt(v)  ;
                if (  new_width < 200 &&  new_width > 50 ) {
                                     console.log("scale back");
                                $('#back_design_image').css('width',  new_width );
                } else {
                                   console.log("criteria not met to scale back");
                }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
function scaleFront(v) {
    var original_width  =  parseInt($('#front_design_image').css('width').replace(/[^0-9]/g, '')) ;
    var new_width =  original_width + parseInt(v)  ;
    if (  new_width < 200 &&  new_width > 50 ) {
        $('#front_design_image').css('width',  new_width );
    } else {
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
 function watchForDragging() {
    alert("watchForDragging");
     console.log("begin watchForDragging()");

                                     var $dragging = null;
                                    $('.drag').on("mousemove", function(e) {
                                                    if ($dragging ) {
                                                        $dragging.offset({
                                                            top:  e.pageY,
                                                            left: e.pageX
                                                        });
                                                    }
                                    });

                                    $('.drag').on("mousedown", $('#back_design_image'), function (e) {
                                        $dragging = $(e.target);
                                    });

                                    $('.drag').on("mouseup", function (e) {
                                        $dragging = null;
                                    });

     console.log("end watchForDragging()");
 }













//function areControlsVisible() {
//    if ( $("#administer_size_and_position_back").is(":visible")  ) {
//        console.log("controls are visible, proceed watching for resize.");
////                    true
//    }  else  {
//        console.log("controls are hidden");
////                    false
//    }
//}



//
// function sizeAndPosition() {
//     console.log("begin sizeAndPosition()");
////     $('#size_and_position_container').toggle();
//     if ( $("#size_and_position_container").is(":visible")  ) {
//                                  console.log("controls are visible, proceed watching for resize.");
//
//                                     $('#back_slider').slider()
//                                             .on('slide', function(ev){
//                                                 scaleBack(ev.value);
//                                             });
//                            /////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                     $('#front_slider').slider()
//                                             .on('slide', function(ev){
//                                                 scaleFront(ev.value);
//                                             });
//
//
//
//
//                                     var $dragging = null;
//                                    $('.drag').on("mousemove", function(e) {
//                                                    if ($dragging ) {
//                                                        $dragging.offset({
//                                                            top:  e.pageY,
//                                                            left: e.pageX
//                                                        });
//                                                    }
//                                    });
//
//                                    $('.drag').on("mousedown", $('#back_design_image'), function (e) {
//                                        $dragging = $(e.target);
//                                    });
//
//                                    $('.drag').on("mouseup", function (e) {
//                                        $dragging = null;
//                                    });
//     }  else  {
//                                 console.log("controls are hidden");
//                                 var $dragging = null;
//                                 $('.drag').off("mousemove");
//
//                                 $('.drag').off("mousedown");
//
//                                 $('.drag').off("mouseup");
//     }
//     console.log("begin sizeAndPosition()");
// }









//
//$('#administration_toggle').toggle(function () {
//    $(".size_and_position").css({'display': 'table'});
//}, function () {
//    $(".size_and_position").css({'display': "none"});
//});


//$(document).ready(function() {
//                        var $dragging = null;
//                        $('.drag').on("mousemove", function(e) {
//                                        if ($dragging ) {
//                                            $dragging.offset({
//                                                top:  e.pageY,
//                                                left: e.pageX
//                                            });
//                                        }
//                        });
//
//                        $('.drag').on("mousedown", $('#back_design_image'), function (e) {
//                            $dragging = $(e.target);
//                        });
//
//                        $('.drag').on("mouseup", function (e) {
//                            $dragging = null;
//                        });
//});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//$(document).ready(function() {
//       if ( $("#administer_size_and_position_back").is(":visible")  ) {
//                        console.log("controls are visible, proceed watching for resize.");
//                        var $dragging = null;
//
//                        $('.drag').on("mousemove", function(e) {
//                            if ($dragging) {
//                                $dragging.offset({
//                                    top:  e.pageY,
//                                    left: e.pageX
//                                });
//                            }
//                        });
//
//                        $('.drag').on("mousedown", $('#back_design_image'), function (e) {
//                            $dragging = $(e.target);
//                        });
//
//                        $('.drag').on("mouseup", function (e) {
//                            $dragging = null;
//                        });
//       }  else  {
//                        console.log("controls are hidden");
//       }
//});
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////














//
//$('#back_slider').slider()
//.on('slide', function(ev){
//            scaleBack(ev.value);
//});
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//$('#front_slider').slider()
//.on('slide', function(ev){
//            scaleFront(ev.value);
//});
////
////$('#administration_toggle').toggle(function () {
////    $(".size_and_position").css({'display': 'table'});
////}, function () {
////    $(".size_and_position").css({'display': "none"});
////});
//
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//function scaleBack(v) {
//    var original_width  =  parseInt($('#back_design_image').css('width').replace(/[^0-9]/g, '')) ;
//    var new_width =  original_width + parseInt(v)  ;
//    if (  new_width < 200 &&  new_width > 50 ) {
//            $('#back_design_image').css('width',  new_width );
//    } else {
//    }
//}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//function scaleFront(v) {
//    var original_width  =  parseInt($('#front_design_image').css('width').replace(/[^0-9]/g, '')) ;
//    var new_width =  original_width + parseInt(v)  ;
//    if (  new_width < 200 &&  new_width > 50 ) {
//            $('#front_design_image').css('width',  new_width );
//    } else {
//    }
//}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//$(document).ready(function() {
//    var $dragging = null;
//
//    $(document.body).on("mousemove", function(e) {
//        if ($dragging) {
//            $dragging.offset({
//                top:  e.pageY,
//                left: e.pageX
//            });
//        }
//    });
//
//    $(document.body).on("mousedown", $('#back_design_image'), function (e) {
//        $dragging = $(e.target);
//    });
//
//    $(document.body).on("mouseup", function (e) {
//        $dragging = null;
//    });
//});
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//$(document).on('click','#submit_size_and_position_back', function() {
//    console.log('clicked #submit_size_and_position_back');
//    $.ajax({
//        type: "POST",
//        url: "/store/update_advanced_combination/" + $('#back_advanced_combination_id').val() ,
//        data: { advanced_combination: {
//                default_side: $('#back_design_default_side').val() ,
//                number_of_sides: $('#back_design_number_of_sides').val(),
//                back_left: $('#back_design_image').css('left'),
//                back_top: $('#back_design_image').css('top'),
//                back_width: $('#back_design_image').css('width')
//                }
//        }
//    }).done(function( msg ) {
//                console.log( "Data Saved: " + msg );
//    });
//});
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//$(document).on('click','#submit_size_and_position_front', function() {
//    console.log('clicked #submit_size_and_position_front');
//    $.ajax({
//        type: "POST",
//        url: "/store/update_advanced_combination/" + $('#front_advanced_combination_id').val() ,
//        data: { advanced_combination: {
//                default_side: $('#front_design_default_side').val() ,
//                number_of_sides: $('#front_design_number_of_sides').val(),
//                front_left: $('#front_design_image').css('left'),
//                front_top: $('#front_design_image').css('top'),
//                front_width: $('#front_design_image').css('width')
//                }
//        }
//    }).done(function( msg ) {
//                console.log( "Data Saved: " + msg );
//    });
//});
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//////////////////////////////////////////////////////////////////////////////////////////
////        $(e.target).html(e.pageY);
////          $('back_design_image').attr('data-x', e.pageX);
////          $('back_design_image').attr('data-y', e.pageY);
////          console.log(e.pageX);
////          console.log(e.pageY);

//$(function(){
//    var cont = $('.show');
//    $( "input:image"  ).each(function(i, el){
//        $(el).width(cont.width() / 2);
//    });
//}  )

//  function changeImages() {
//            console.log("begin changeImages()");
//              var cont = $('.show');
//              $( "input:image"  ).each(function(i, el){
//                  $(el).width(cont.width() / 2);
//              })
//                console.log("end changeImages()");
//  }