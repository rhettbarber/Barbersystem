
function growFast() {
  	var lPU = $('lpu')
    var leftPrintHeight = parseInt(lPU.getStyle('height'));  
    var newHeight = leftPrintHeight  + 20 + 'px' ;   
	lPU.setStyle({position:'relative',height: newHeight	});
}

function shrinkFast() {
  	var lPU = $('lpu')
    var leftPrintHeight = parseInt(lPU.getStyle('height'));  
    var newHeight = leftPrintHeight  - 20 + 'px' ;   
	lPU.setStyle({position:'relative',height: newHeight	});
}


function moveLeft() {
  	var lPU = $('lpu')
    var leftPrintLeft = parseInt(lPU.getStyle('left'));  
    var newLeft = leftPrintLeft  - 20 + 'px' ;   
	lPU.setStyle({position:'relative',left: newLeft	});
}

function moveRight() {
  	var lPU = $('lpu')
    var leftPrintLeft = parseInt(lPU.getStyle('left'));  
    var newLeft = leftPrintLeft  + 20 + 'px' ;   
	lPU.setStyle({position:'relative',left: newLeft	});
}

function moveUp() {
  	var lPU = $('lpu')
    var leftPrintTop = parseInt(lPU.getStyle('top'));  
    var newTop = leftPrintTop  - 20 + 'px' ;   
	lPU.setStyle({position:'relative', top: newTop	});
}

function moveDown() {
  	var lPU = $('lpu')
    var leftPrintTop = parseInt(lPU.getStyle('top'));  
    var newTop = leftPrintTop  + 20 + 'px' ;   
	lPU.setStyle({position:'relative', top: newTop	});
}


function moveTo(x, y) {
	var new_opacity = 0.5
	$('left_print_container').setOpacity(new_opacity);
}


//function moveTo(x, y) {
//var new_opacity = 0.5
//alert(new_opacity);
//$('left_print_container').setOpacity(new_opacity);
//}



//hashs:
//var friends = {'ren':'happy', 'stimpy':'joy'}
//friends.ren             // "happy"
//friends['ren']           // "happy"
//$H(friends).keys()  //  ["ren","stimpy"]

//arrays:
//var feelings = ['happy', 'joy']
//feelings.length        // 2
//feelings[0]             // "happy"


//var friends = $H({'ren':'happy', 'stimpy':'joy'})
//>>> $('left_print_container')
//<div id="left_print_container" style="width: 850px; height: 353px; position: relative; top: -353px; z-index: 3;">
//$$() produces an array as shown below
//>>> $$('#left_print_container')
//[div#left_print_container]
//>>> $$('#left_print_container')[0]
//<div id="left_print_container" style="width: 850px; height: 353px; position: relative; top: -353px; z-index: 3;">
//>>> $$('div#left_print_container')[0]
//<div id="left_print_container" style="width: 850px; height: 353px; position: relative; top: -353px; z-index: 3;">
//>>> $$('div#left_print_container').first.show
//$$('a').invoke('hides') // hides all links on page
//$$('a').invoke('show') // shows all links on page
//$$('a').each(function( element) { element.hide( ) } )
//$$('a').each(function( element) { element.hide(); element.doThis() } )
//$$('a, p')
//$$('div p')
//$$('div[id]')  //any div element with id attr
//////////////////////////
//var HandyFunctions = {
//    hideLinks: function() {
//        $$('a').invoke('hide');
//     },
//     showLinks: function() {
//         $$('a').invoke('show');
//      }
//};
//////////////////////////
//peepcode gets into writing classes various ways
// % means remander
//>>> 5 % 2 == 1
//true
//>>> 5 % 2 == 0
//false
//////////////////////////
//Element.addMethods({
//  tell: function(element) {
//        aler(element.inspect());
//        }
//    });


//left_print_update
//>>> $('left_print_update').tell() // tells span id="etc.."























