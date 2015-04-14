
//      	maskObj = document.getElementById('mask_container'); 
//		maskObj.style.zIndex=5;


   var selObj = null;


   function moveHandler(e){

      if (e == null) { e = window.event } 
      if (e.button<=1&&dragOK){
         selObj.style.left=e.clientX-dragXoffset+'px';
         selObj.style.top=e.clientY-dragYoffset+'px';
//////////////////////////// RHETTS INJECTIONS
            lPos = document.getElementById('lpos');  
			 lPos.innerHTML= selObj.style.left ; 
//////////////////////////// RHETTS INJECTIONS		 
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
      var htype='-moz-grabbing';
      if (e == null) { e = window.event; htype='move';} 
      var target = e.target != null ? e.target : e.srcElement;
      selObj=target;
      orgCursor=target.style.cursor;
      if (target.className=="vidFrame"||target.className=="moveable") {
         target.style.cursor=htype;
         dragOK=true;
         dragXoffset=e.clientX-parseInt(selObj.style.left);
         dragYoffset=e.clientY-parseInt(selObj.style.top);
         document.onmousemove=moveHandler;
         document.onmouseup=cleanup;
         return false;
      }
      
   }
	 
	 document.onmousedown=dragHandler;