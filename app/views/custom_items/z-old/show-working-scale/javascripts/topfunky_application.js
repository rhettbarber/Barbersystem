Event.addBehavior({
  
  'h1': function() {
    this.setStyle({
      color:'purple',
      'border-':'1px solid purple'
    });
  },
  
//   'body': function() {
//  	var lPU = $('lpu')
//    var leftPrintLeft = parseInt(lPU.getStyle('left'));
//    var leftPrintTop = parseInt(lPU.getStyle('top'));
//    
//    var newLeft = leftPrintLeft  + 10 + 'px' ;   
//    var newTop = leftPrintTop + 10 + 'px' ; 
//    
//     alert('left: ' + leftPrintLeft + ' newleft: ' + newLeft + '  top: ' + leftPrintTop   + ' newtop: ' + newTop  );
//    
//	lPU.setStyle({position:'relative',top: '100px' ,left: '200px' 	});
//	
//	
//    ;
//  },
   
//  
//  'a': function() {
//    var linkTipTop = $(document.body).getStyle('font-size');
//    
//    var linkTip = $div(this.href);
//    linkTip.setStyle({
//      top:linkTipTop
//    });
//    linkTip.addClassName('linktip');
//    linkTip.hide();
//    
//    this.makePositioned();
//    this.appendChild(linkTip);
//
//// /*
//    // Log messages for debugging positioning.
//    // Does nearly the same thing in three ways.
//    console.log(linkTip);
//    console.log("top %s", linkTipTop);
//    
//    var templateTip = new Template('top: #{top}');
//    var templateText = templateTip.evaluate({top:linkTipTop});
//    console.log(templateText);
//// */    
//
//    this.observe('mouseover', function() { linkTip.show() });
//    this.observe('mouseout', function() { linkTip.hide() });
//  } 
//});

// $('footer').methods()
// Element.methods('footer')
Element.addMethods({
  
  methods: function(element) {
    return Object.keys(element).select(function(methodName) {
      return typeof element[methodName] == 'function';
    }).sort();
  }
  
});









//   'body': function() {
//    var leftPrintLeft = parseInt($('left_print_update').getStyle('left'));
//    var leftPrintTop = parseInt($('left_print_update').getStyle('top'));
//    var newLeft = leftPrintLeft  + 10 ;   
//    var newTop = leftPrintTop + 10;                     
//    alert('left: ' + leftPrintLeft + ' newleft: ' + newLeft + '  top: ' + leftPrintTop   + ' newtop: ' + newTop  );
////	$('left_print_update').setStyle({position:'relative',top: '100px' ,left: '200px' 	});
//    ;
//  },
//   