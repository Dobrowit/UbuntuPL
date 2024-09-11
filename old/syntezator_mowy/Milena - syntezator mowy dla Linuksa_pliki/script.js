function demo_starter()
{
	var tarea=document.getElementById('tekst');
	if (!tarea) return;
	var tlabel=document.getElementById('w');
	if (!tlabel) return;
	tlabel.replaceChild(
		document.createTextNode('Tekst - wpisano '),
		tlabel.firstChild);
	count_znaki();
	
	function count_znaki()
	{
		var znaki=tarea.value.length;
		var d=znaki%100;
		var d1='';
		if (znaki != 1) {
			if (d>=10 && d<=20) d1='\u00F3w';
			else {
				d=d%10;
				if (d>=2 && d<=4) d1='i';
				else d1='\u00F3w';
			}
		}
		d=znaki+' znak'+d1;
		if (znaki>256) {
			d+=' - za du\u017Co';
			tarea.style.backgroundColor='#FF3333'
		}
		else tarea.style.backgroundColor='#FFFFFF'
		tlabel.lastChild.innerHTML=d;
	}
	tarea.onkeyup=count_znaki;
	tarea.onmouseup=count_znaki;
	var dform=document.getElementById('demo');
	dform.onsubmit=function()
	{
		if (tarea.value.length > 256) return false;
		if (document.getElementById('zap').checked) return true;
		var url='./miledemo.cgi?p=1&v='+
			document.getElementById('voice').selectedIndex+
		'&hrs='+(document.getElementById('hrs').checked?1:0)+
		'&emo='+(document.getElementById('emo').checked?1:0)+
		'&pro='+(document.getElementById('pro').checked?1:0)+
		'&t='+encodeURIComponent(tarea.value);
		try {
			player.SetVariable('currentSong', url);
			player.TCallLabel('/','load');
			player.TCallLabel('/','play');
			return false;
		}
		catch(e) {
			return true;
		}
		return true;
	}
}


window.onload=function()
{
	function add_mouse(a)
	{
		var href=a.href;
		if (href.indexOf('#tresc')<0) return;
		a.mouse=0;
		a.onmousedown=function()
		{
			a.mouse=1;
		}
		a.onclick=function()
		{
			if (a.mouse == 1) {
				a.mouse=0;
				window.location=a.href.substr(0,a.href.indexOf('#tresc'));
				return false;
			}
		}
	}
	var tul=document.getElementById('top').
		getElementsByTagName('a');
	var i;
	for (i=0;i<tul.length;i++) {
		add_mouse(tul[i]);
	}
	var lme=document.getElementById('lmenu');
	if (lme) {
		tul=lme.getElementsByTagName('a');
		for (i=0;i<tul.length;i++) {
			add_mouse(tul[i]);
		}
	}
	var eth=document.getElementById('ethanak');
	if (eth) {
		var ts=document.createElement('a');
		var ml=eth.innerHTML+'@polip.com'
		ts.href="mailto:"+ml;
		ts.appendChild(document.createTextNode(ml));
		eth.replaceChild(ts,eth.firstChild);
	}
	demo_starter();
}

if (document.documentElement) {
	if (!document.documentElement.className || document.documentElement.className.indexOf('havejs')<0) 
		document.documentElement.className+=' havejs';
}

var flash_possible=true;
var misio=false;
function kmisio()
{
	var a=navigator.appVersion;
	var b=a.match(/MSIE[^0-9]*([0-9.]+)/);
	if (b.length<2) return 0;
	if (b[1]>=6) return 1;
	return 0;
}

/*@cc_on @*/
/*@if (@_jscript_version >= 5)
	misio=true;
	flash_possible=false;
	if (kmisio()) {
		document.write('<SCR' + 'IPT LANGUAGE=VBScript\> \n'); //FS hide this from IE4.5 Mac by splitting the tag
		document.write('flash_possible = false \n');
		document.write('on error resume next \n');
		document.write('flash_possible = ( IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash.7")))\n');
		document.write('</SCR' + 'IPT\> \n');
	}
@end @*/


function insert_flash(objid,src,w,h)
{
	function apar(name,value)
	{
		var param=document.createElement('param');
		param.setAttribute('name',name);
		param.setAttribute('value',value);
		object.appendChild(param);
	}
	
	function visualise_inner(el)
	{
		if (el.className && el.className.indexOf('innerflash')>=0) el.className=el.className.replace(/innerflash/g,'');
		for (el=el.firstChild;el;el=el.nextSibling) visualise_inner(el);
	}
	
	if (!document.getElementById || !document.createElement) return;
	var div=document.getElementById(objid);
	if (!div) return;
	if (!flash_possible) {
		visualise_inner(div);
		return;
	}
	var object=document.createElement('object');
	var el;
	var post=!misio && (!window.netscape || window.opera);
	
	
	if (!misio) while(div.firstChild) object.appendChild(div.firstChild);
	else while (div.firstChild) div.removeChild(div.firstChild);
	if (!post) div.appendChild(object);
	object.width = w;
	object.height = h;
	if (misio) {
		object.classid= "clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"; 
		object.movie = src;
	}
	else {
		object.type="application/x-shockwave-flash";
		object.data=src;
	}
	var i;
	for (i=4;i<arguments.length-1;i+=2) apar(arguments[i],arguments[i+1]);
	if (post) div.appendChild(object);
	return object;
	
}
