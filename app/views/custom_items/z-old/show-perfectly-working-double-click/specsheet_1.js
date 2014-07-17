function scalereverse(v) {
//console.log("SCALING");
  var scalePhotos = document.getElementsByClassName('reverse');
  floorSize = .26;
  ceilingSize = 1.0;
  v = floorSize + (v * (ceilingSize - floorSize));
  for (i=0; i < scalePhotos.length; i++) {
    scalePhotos[i].style.width = (v*190)+'px';
  }
} 

function scalemain(v) {
//console.log("SCALING");
  var scalePhotos = document.getElementsByClassName('main');
  floorSize = .26;
  ceilingSize = 1.0;
  v = floorSize + (v * (ceilingSize - floorSize));
  for (i=0; i < scalePhotos.length; i++) {
    scalePhotos[i].style.width = (v*190)+'px';
  }
} 

function doOnload()  {
	var reverseSlider = new Control.Slider('reverse_print_handle','reverse_print_track',
	{axis:'horizontal', minimum: 0, maximum:200, alignX: 2, increment: 2, sliderValue: 1});
	reverseSlider.options.onSlide = function(value){
	  scalereverse(value);
	}
	reverseSlider.options.onChange = function(value){
	  scalereverse(value);
	} 
	
	var mainSlider = new Control.Slider('main_print_handle','main_print_track',
	{axis:'horizontal', minimum: 0, maximum:200, alignX: 2, increment: 2, sliderValue: 1});
	mainSlider.options.onSlide = function(value){
	  scalemain(value);
	}
	mainSlider.options.onChange = function(value){
	  scalemain(value);
	} 	
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
   var selObj = null;
   
   function moveHandler(e){
      	console.log("MOVEHANDLER")
      if (e == null) { e = window.event } 
      if (e.button<=1&&dragOK){
         selObj.style.left=e.clientX-dragXoffset+'px';
         selObj.style.top=e.clientY-dragYoffset+'px';
            lPos = document.getElementById('lpos');  
			 lPos.innerHTML= selObj.style.left ; 
            mask = document.getElementById('mask');  
            console.log(mask);
			 mask.style.zIndex = 6; 
         return false;
      }
   }

   function cleanup(e) {
      document.onmousemove=null;
      document.onmouseup=null;
      selObj.style.cursor=orgCursor;
      dragOK=false;
   }

   function dragHandler(e){
   	console.log("DRAGHANDLER");
      var htype='-moz-grabbing';
      	var maskImage = e.target != null ? e.target : e.srcElement;  
     	 if (maskImage.className=="mask") {
     		console.log("MOUSEOVER HIT THE MASK CLASS");
     		  console.log(target);
     		 var masks_div = document.getElementById('mask');  
     		masks_div.style.zIndex = 1;
   		 }
    
      if (e == null) { e = window.event; htype='move';} 
      var target = e.target != null ? e.target : e.srcElement;
     standardLog(e);
      selObj=target;
      orgCursor=target.style.cursor;
      if (target.className=="main" || target.className=="reverse" )  {
      	  console.log("IS MOVABLE");
         target.style.cursor=htype;
         dragOK=true;
         dragXoffset=e.clientX-parseInt(selObj.style.left);
         dragYoffset=e.clientY-parseInt(selObj.style.top);
         document.onmousemove=moveHandler;
         document.onmouseup=cleanup;
         return false;
      }
      else {
      	console.log("IS NOT MOVABLE");
      }
   } 
   
	 document.onmousedown =   dragHandler;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
function standardLog(evt) {
   	console.time("begin time");
   	var a = "BEGIN--------------------------------:";
   	var b = 0;
   	var c = "END--------------------------------:";
   	console.log("LOG %s and value for b is %d", a, b );
   	console.log(evt);
   	console.log(evt.type);
   	console.log(evt.target);
   	console.log(evt.target.className);
   	console.log(evt.target.style);
   console.log("LOG %s and value for b is %d", c, b );	
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// WORKING SCALE WITH PRINTS BEFORE MOVING
//
//function scalereverse(v) {
////console.log("SCALING");
//  var scalePhotos = document.getElementsByClassName('reverse');
//  floorSize = .26;
//  ceilingSize = 1.0;
//  v = floorSize + (v * (ceilingSize - floorSize));
//  for (i=0; i < scalePhotos.length; i++) {
//    scalePhotos[i].style.width = (v*190)+'px';
//  }
//} 
//
//function scalemain(v) {
////console.log("SCALING");
//  var scalePhotos = document.getElementsByClassName('main');
//  floorSize = .26;
//  ceilingSize = 1.0;
//  v = floorSize + (v * (ceilingSize - floorSize));
//  for (i=0; i < scalePhotos.length; i++) {
//    scalePhotos[i].style.width = (v*190)+'px';
//  }
//} 
//
//function doOnload()  {
//	var reverseSlider = new Control.Slider('reverse_print_handle','reverse_print_track',
//	{axis:'horizontal', minimum: 0, maximum:200, alignX: 2, increment: 2, sliderValue: 1});
//	reverseSlider.options.onSlide = function(value){
//	  scalereverse(value);
//	}
//	reverseSlider.options.onChange = function(value){
//	  scalereverse(value);
//	} 
//	
//	var mainSlider = new Control.Slider('main_print_handle','main_print_track',
//	{axis:'horizontal', minimum: 0, maximum:200, alignX: 2, increment: 2, sliderValue: 1});
//	mainSlider.options.onSlide = function(value){
//	  scalemain(value);
//	}
//	mainSlider.options.onChange = function(value){
//	  scalemain(value);
//	} 	
//}
//

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

//function scaleIt(v) {
//  var scalePhotos = document.getElementsByClassName('scale-image');
//
//  floorSize = .26;
//  ceilingSize = 1.0;
//  v = floorSize + (v * (ceilingSize - floorSize));
//
//  for (i=0; i < scalePhotos.length; i++) {
//    scalePhotos[i].style.width = (v*190)+'px';
//  }
//} 
//
//
//function doOnload()  {
//	var demoSlider = new Control.Slider('reverse_print_hand','reverse_print_track',
//	{axis:'horizontal', minimum: 0, maximum:200, alignX: 2, increment: 2, sliderValue: 1});
//	
//	demoSlider.options.onSlide = function(value){
//	  scaleIt(value);
//	}
//	
//	demoSlider.options.onChange = function(value){
//	  scaleIt(value);
//	} 
//}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//function scaleMain(v) {
//  var scalePhotos = document.getElementsByClassName('main_print_image');
//  floorSize = .26;
//  ceilingSize = 1.0;
//  v = floorSize + (v * (ceilingSize - floorSize));
//  for (i=0; i < scalePhotos.length; i++) {
//    scalePhotos[i].style.width = (v*190)+'px';
//  }
//} 
//
//function scaleReverse(v) {
//  var scalePhotos = document.getElementsByClassName('reverse_print_image');
//  floorSize = .26;
//  ceilingSize = 1.0;
//  v = floorSize + (v * (ceilingSize - floorSize));
//  for (i=0; i < scalePhotos.length; i++) {
//    scalePhotos[i].style.width = (v*190)+'px';
//  }
//} 
//
//function doOnload()  {
//	var reverseSlider = new Control.Slider('main_print_handle','main_print_track',
//	{axis:'horizontal', minimum: 0, maximum:200, alignX: 2, increment: 2, sliderValue: 1});
//	reverseSlider.options.onSlide = function(value){
//	  scaleReverse(value);
//	}
//	reverseSlider.options.onChange = function(value){
//	  scaleReverse(value);
//	} 
//	
//	var mainSlider = new Control.Slider('reverse_print_handle','reverse_print_track',
//	{axis:'horizontal', minimum: 0, maximum:200, alignX: 2, increment: 2, sliderValue: 1});
//	mainSlider.options.onSlide = function(value){
//	  scaleMain(value);
//	}
//	mainSlider.options.onChange = function(value){
//	  scaleMain(value);
//	} 
//}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

//function scaleIt(v) {
//  var scalePhotos = document.getElementsByClassName('scale-image');
//
//  floorSize = .26;
//  ceilingSize = 1.0;
//  v = floorSize + (v * (ceilingSize - floorSize));
//
//  for (i=0; i < scalePhotos.length; i++) {
//    scalePhotos[i].style.width = (v*190)+'px';
//  }
//} 
//
//
//function doOnload()  {
//	var demoSlider = new Control.Slider('handle1','track1',
//	{axis:'horizontal', minimum: 0, maximum:200, alignX: 2, increment: 2, sliderValue: 1});
//	
//	demoSlider.options.onSlide = function(value){
//	  scaleIt(value);
//	}
//	
//	demoSlider.options.onChange = function(value){
//	  scaleIt(value);
//	} 
//}
//


///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//function doOnload() {
//		console.log("TESTING BODY ONLOAD");
//		var handles = ['square_slider_handle_min', 'square_slider_handle_max'];
//		var square_slider = new Control.Slider(handles, 'square_slider', {
//		    range: $R(0, 100),
//		    values: $R(0, 100),
//		    sliderValue: [20, 80],
//		    spans: ["square_slider_span"],
//		    restricted: true
//		});
//}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//   var selObj = null;
//   
//   function moveHandler(e){
//      	console.log("MOVEHANDLER")
//      if (e == null) { e = window.event } 
//      if (e.button<=1&&dragOK){
//         selObj.style.left=e.clientX-dragXoffset+'px';
//         selObj.style.top=e.clientY-dragYoffset+'px';
//            lPos = document.getElementById('lpos');  
//			 lPos.innerHTML= selObj.style.left ; 
//            mask = document.getElementById('mask');  
//			 mask.style.zIndex = 6; 
//         return false;
//      }
//   }
//
//   function cleanup(e) {
//      document.onmousemove=null;
//      document.onmouseup=null;
//      selObj.style.cursor=orgCursor;
//      dragOK=false;
//   }
//
//   function dragHandler(e){
//   	console.log("DRAGHANDLER");
//      var htype='-moz-grabbing';
//      	var maskImage = e.target != null ? e.target : e.srcElement;  
//     	 if (maskImage.className=="mask") {
//     		console.log("MOUSEOVER HIT THE MASK CLASS");
//     		  console.log(target);
//     		 var masks_div = document.getElementById('mask');  
//     		masks_div.style.zIndex = 1;
//   		 }
//    
//      if (e == null) { e = window.event; htype='move';} 
//      var target = e.target != null ? e.target : e.srcElement;
//     standardLog(e);
//      selObj=target;
//      orgCursor=target.style.cursor;
//      if (target.className=="moveable") {
//      	  console.log("IS MOVABLE");
//         target.style.cursor=htype;
//         dragOK=true;
//         dragXoffset=e.clientX-parseInt(selObj.style.left);
//         dragYoffset=e.clientY-parseInt(selObj.style.top);
//         document.onmousemove=moveHandler;
//         document.onmouseup=cleanup;
//         return false;
//      }
//      else {
//      	console.log("IS NOT MOVABLE");
//      }
//   } 
//   
//	 document.onmousedown =   dragHandler;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//function standardLog(evt) {
//   	console.time("begin time");
//   	var a = "BEGIN--------------------------------:";
//   	var b = 0;
//   	var c = "END--------------------------------:";
//   	console.log("LOG %s and value for b is %d", a, b );
//   	console.log(evt);
//   	console.log(evt.type);
//   	console.log(evt.target);
//   	console.log(evt.target.className);
//   	console.log(evt.target.style);
//   console.log("LOG %s and value for b is %d", c, b );	
//}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

// function maskHide(e) {
//// 		standardLog(e)
////       console.log("MASK MANAGER ON MOUSEOVER");
//     	var maskImage = e.target != null ? e.target : e.srcElement;  
//     	 if (target.className=="mask") {
//     		console.log("MOUSEOVER HIT THE MASK CLASS");
//     		  console.log(target);
//     		 var masks_div = document.getElementById('mask');  
//     		masks_div.style.zIndex = 1;
//   		 }
//   } 
 

//    document.onmouseover   =   maskHide;

//
//function zoom(type, imgx ) {
//	imgd = findDOM(imgx);
//	if (type=="+" ) {
//		imgd.style.width  = 500;
//		imgd.style.height = 500;
//		}
//	if (type=="-" ) {
//		imgd.style.width  = 100; 
//		imgd.style.height = 100;
//		}
//} 
//
//function findDOM(objectId) {
//	if (document.getElementById) {
//		return (document.getElementById(objectId));
//	}
//	if (document.all) {
//		return (document.all[objectId]);
//	}
//}

///////////////////////////////////////////////////////////////////////////////

//function doThis() {
//		var b = "testing";
//		console.error(b);		
//}


//document.addEventListener(
//   'click',
//   function (evt) {
//   	console.time("begin time");
//   	//	console.timeEnd("end time") ;
//   	var a = "BEGIN--------------------------------:";
//   	var b = 0;
//   	var c = "END--------------------------------:";
//   	//console.info(a) // console.warn(a) // console.error(a)
//   	console.log("LOG %s and value for b is %d", a, b );
//   	console.log(evt);
//   	console.log(evt.type);
//   	console.log(evt.target);
//   	console.log(evt.target.style);
//   console.log("LOG %s and value for b is %d", c, b );	
//   	
//   	 if (evt.target.className=="otherstuff") 	 
//   	   {
//     		alert(evt.type + ' for ' + evt.target + "e:" + evt);
//     		evt.target.style.zIndex = 1;
//    	 }
//   },
//   false
//)
//;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//   var selObj = null;
//
//
//   function moveHandler(e){
//      if (e == null) { e = window.event } 
//      if (e.button<=1&&dragOK){
//         selObj.style.left=e.clientX-dragXoffset+'px';
//         selObj.style.top=e.clientY-dragYoffset+'px';
////////////////////////////// RHETTS INJECTIONS
//            lPos = document.getElementById('lpos');  
//			 lPos.innerHTML= selObj.style.left ; 
//			 
//            mask = document.getElementById('mask');  
//			 mask.style.zIndex = 6;
//			 
//			 
////////////////////////////// RHETTS INJECTIONS		 
//         return false;
//      }
//   }
//
//   function cleanup(e) {
//      document.onmousemove=null;
//      document.onmouseup=null;
//      selObj.style.cursor=orgCursor;
//      dragOK=false;
//   }
//
//   function dragHandler(e){
//      var htype='-moz-grabbing';
//      if (e == null) { e = window.event; htype='move';} 
//      var target = e.target != null ? e.target : e.srcElement;
//      selObj=target;
//      orgCursor=target.style.cursor;
//      if (target.className=="vidFrame"||target.className=="moveable") {
//         target.style.cursor=htype;
//         dragOK=true;
//         dragXoffset=e.clientX-parseInt(selObj.style.left);
//         dragYoffset=e.clientY-parseInt(selObj.style.top);
//         document.onmousemove=moveHandler;
//         document.onmouseup=cleanup;
//         return false;
//      }
//   
//   } 
//	 document.onmousedown=dragHandler;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////

//   // Logic to execute when the end user   
//   // clicks the element  
//   function myOnClickFunction(elem) {  
//     alert(elem);  
//   }  
//     
//   // Register the onclick event for all elements   
//   // the given class name  
//   window.onload = function() {  
//     // Find all elements that use that given CSS class  
//     var elements = document.getElementsByClassName("makeMeBeautiful");  
//     elements.each(  
//       function(e) {  
//         // Assign the onclick method to the element  
//         Event.observe(e, "click", myOnClickFunction);  
//       }  
//     );  
//   }  
