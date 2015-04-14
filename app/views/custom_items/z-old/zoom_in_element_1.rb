<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />

<title>Zooming images with JavaScript (targets any web page element)</title>

<style type="text/css">

body{

padding: 0;

margin: 0;

background: #eee;

}

h1{

font: bold 14pt Arial, Helvetica, sans-serif;

color: #000;

text-align: center;

}

img{

position: absolute;

}

#container{

position: relative;

width: 263px;

height: 150px;

margin-left: auto;

margin-right: auto;

overflow: hidden;

background: #9cf;

border: 1px solid #000;

}

#controlpanel{

width: 263px;

margin-left: auto;

margin-right: auto;

background: #9cf;

text-align: center;

border: 1px solid #000;

}

</style>

<script type="text/javascript">

// zoom in a selected web page element

function ZoomInElement(id,inc,maxWidth){

 var elem=document.getElementById(id);

 if(!elem||elem.getAttribute('width')>=maxWidth){return};

elem.setAttribute('width',parseInt(elem.getAttribute('width'))+inc);

elem.setAttribute('height',parseInt(elem.getAttribute('height'))+inc);

if(!elem.style.left){elem.style.left='0px'};

if(!elem.style.top){elem.style.top='0px'};

elem.style.left=parseInt(elem.style.left)-(inc/2)+'px';

elem.style.top=parseInt(elem.style.top)-(inc/2)+'px';

}

// zoom out a selected web page element

function ZoomOutElement(id,inc,minWidth){

 var elem=document.getElementById(id);

 if(!elem||elem.getAttribute('width')<=minWidth){return};

elem.setAttribute('width',parseInt(elem.getAttribute('width'))-inc);

elem.setAttribute('height',parseInt(elem.getAttribute('height'))-inc);

if(!elem.style.left){elem.style.left='0px'};

if(!elem.style.top){elem.style.top='0px'};

elem.style.left=parseInt(elem.style.left)+(inc/2)+'px';

elem.style.top=parseInt(elem.style.top)+(inc/2)+'px';

}

window.onload=function(){

var btn1=document.getElementById('button1');

if(!btn1){return};

btn1.onclick=function(){

ZoomInElement('image',20,800);

}

var btn2=document.getElementById('button2');

if(!btn2){return};

btn2.onclick=function(){

ZoomOutElement('image',20,263);

}

}

</script>

</head>

<body>

<h1>Zooming elements with JavaScript (targets any web page element)</h1>

<div id="container"><img src="http://localhost:1000/mugshots/0000/0011/6334l_o_rp.png" width="263" height="150" id="image" /></div>

<div id="controlpanel">

<p><input type="button" id="button1" value="+" /><input type="button" id="button2" value="-" /></p>

</div>

</body>

</html>