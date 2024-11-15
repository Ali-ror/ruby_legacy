/*!
 * jQuery jCarousellite Plugin v1.3.1
 *
 * Date: Mon Dec 6 19:36:31 2010 -0500
 * Requires: jQuery v1.4+
 *
 * Copyright 2007 Ganeshji Marwaha (gmarwaha.com)
 * Modifications/enhancements by Karl Swedberg
 * Dual licensed under the MIT and GPL licenses (just like jQuery):
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 *
 * jQuery plugin to navigate images/any content in a carousel style widget.
 *
*/
(function(e){function p(r,a){return parseInt(e.css(r[0],a),10)||0}e.jCarouselLite={version:"1.3.1"};e.fn.jCarouselLite=function(r){var a=e.extend({},e.fn.jCarouselLite.defaults,r);return this.each(function(){function n(c){if(!s){a.beforeStart&&a.beforeStart.call(this,f.slice(g).slice(0,b));if(a.circular)if(c<=k-b-1){j.css(q,-((i-b*2)*l)+"px");g=c==k-b-1?i-b*2-1:i-b*2-a.scroll}else if(c>=i-b+1){j.css(q,-(b*l)+"px");g=c==i-b+1?b+1:b+a.scroll}else g=c;else{a.$btnPrev.toggleClass(a.btnDisabledClass,a.btnPrev&&
c<=0);a.$btnNext.toggleClass(a.btnDisabledClass,a.btnNext&&c>i-b);g=c<0?0:c>i-b?i-b:c}s=true;v[q]=-(g*l);j.animate(v,a.speed,a.easing,function(){a.afterEnd&&a.afterEnd.call(this,f.slice(g).slice(0,b));s=false})}return false}var s=false,q=a.vertical?"top":"left",v={},w=a.vertical?"height":"width",m=this,d=e(this),j=d.find("ul").eq(0),o=j.children("li"),t=o.length,b=a.visible,k=Math.min(a.start,t-1);if(a.circular){j.prepend(o.slice(t-b-1+1).clone(true)).append(o.slice(0,b).clone(true));k+=b}var f=j.children("li"),
i=f.length,g=k;d.css("visibility","visible");f.css({overflow:a.vertical?"hidden":"visible","float":a.vertical?"none":"left"});j.css({margin:"0",padding:"0",position:"relative",listStyleType:"none",zIndex:1});d.css({overflow:"hidden",position:"relative",zIndex:2,left:"0px"});var l=a.vertical?f[0].offsetHeight+p(f,"marginTop")+p(f,"marginBottom"):f[0].offsetWidth+p(f,"marginLeft")+p(f,"marginRight");o=l*i;var z=l*b;f.css({width:f.width(),height:f.height()});j.css(w,o+"px").css(q,-(g*l));d.css(w,z+"px");
e.each(["btnPrev","btnNext"],function(c,h){if(a[h]){a["$"+h]=e.isFunction(a[h])?a[h].call(d[0]):e(a[h]);a["$"+h].bind("click.jc",function(){return n(c==0?g-a.scroll:g+a.scroll)})}});if(!a.circular){a.btnPrev&&k==0&&a.$btnPrev.addClass(a.btnDisabledClass);a.btnNext&&k+a.visible>=i&&a.$btnNext.addClass(a.btnDisabledClass)}a.btnGo&&e.each(a.btnGo,function(c,h){e(h).bind("click.jc",function(){return n(a.circular?a.visible+c:c)})});a.mouseWheel&&d.mousewheel&&d.bind("mousewheel.jc",function(c,h){return h>
0?n(g-a.scroll):n(g+a.scroll)});if(a.auto){var x=0,y=a.autoStop&&(a.circular?a.autoStop:Math.min(t,a.autoStop)),u=function(){m.setAutoAdvance=setTimeout(function(){if(!y||y>x){n(g+a.scroll);x++;u()}},a.timeout+a.speed)};u();d.bind("pauseCarousel.jc",function(){clearTimeout(m.setAutoAdvance);d.data("pausedjc",true)}).bind("resumeCarousel.jc",function(){u();d.removeData("pausedjc")});a.pause&&d.bind("mouseenter.jc",function(){d.trigger("pauseCarousel")}).bind("mouseleave.jc",function(){d.trigger("resumeCarousel")})}d.bind("endCarousel.jc",
function(){m.setAutoAdvance&&clearTimeout(m.setAutoAdvance);a.btnPrev&&a[$btnPrev].addClass(a.btnDisabledClass).unbind(".jc");a.btnNext&&a[$btnNext].addClass(a.btnDisabledClass).unbind(".jc");a.btnGo&&e.each(a.btnGo,function(c,h){e(h).unbind(".jc")});if(m.setAutoAdvance)m.setAutoAdvance=null;d.removeData("pausejc");d.unbind(".jc")})})};e.fn.jCarouselLite.defaults={btnPrev:null,btnNext:null,btnDisabledClass:"disabled",btnGo:null,mouseWheel:false,speed:200,easing:null,auto:false,autoStop:false,timeout:4E3,
pause:true,vertical:false,circular:true,visible:3,start:0,scroll:1,beforeStart:null,afterEnd:null}})(jQuery);

/*
 * jQuery Easing v1.1 - http://gsgd.co.uk/sandbox/jquery.easing.php
 *
 * Uses the built in easing capabilities added in jQuery 1.1
 * to offer multiple easing options
 *
 * Copyright (c) 2007 George Smith
 * Licensed under the MIT License:
 *   http://www.opensource.org/licenses/mit-license.php
 */

jQuery.easing = {
	easein: function(x, t, b, c, d) {
		return c*(t/=d)*t + b; // in
	},
	easeinout: function(x, t, b, c, d) {
		if (t < d/2) return 2*c*t*t/(d*d) + b;
		var ts = t - d/2;
		return -2*c*ts*ts/(d*d) + 2*c*ts/d + c/2 + b;		
	},
	easeout: function(x, t, b, c, d) {
		return -c*t*t/(d*d) + 2*c*t/d + b;
	},
	expoin: function(x, t, b, c, d) {
		var flip = 1;
		if (c < 0) {
			flip *= -1;
			c *= -1;
		}
		return flip * (Math.exp(Math.log(c)/d * t)) + b;		
	},
	expoout: function(x, t, b, c, d) {
		var flip = 1;
		if (c < 0) {
			flip *= -1;
			c *= -1;
		}
		return flip * (-Math.exp(-Math.log(c)/d * (t-d)) + c + 1) + b;
	},
	expoinout: function(x, t, b, c, d) {
		var flip = 1;
		if (c < 0) {
			flip *= -1;
			c *= -1;
		}
		if (t < d/2) return flip * (Math.exp(Math.log(c/2)/(d/2) * t)) + b;
		return flip * (-Math.exp(-2*Math.log(c/2)/d * (t-d)) + c + 1) + b;
	},
	bouncein: function(x, t, b, c, d) {
		return c - jQuery.easing['bounceout'](x, d-t, 0, c, d) + b;
	},
	bounceout: function(x, t, b, c, d) {
		if ((t/=d) < (1/2.75)) {
			return c*(7.5625*t*t) + b;
		} else if (t < (2/2.75)) {
			return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
		} else if (t < (2.5/2.75)) {
			return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
		} else {
			return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
		}
	},
	bounceinout: function(x, t, b, c, d) {
		if (t < d/2) return jQuery.easing['bouncein'] (x, t*2, 0, c, d) * .5 + b;
		return jQuery.easing['bounceout'] (x, t*2-d,0, c, d) * .5 + c*.5 + b;
	},
	elasin: function(x, t, b, c, d) {
		var s=1.70158;var p=0;var a=c;
		if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
		if (a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
	},
	elasout: function(x, t, b, c, d) {
		var s=1.70158;var p=0;var a=c;
		if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
		if (a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		return a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b;
	},
	elasinout: function(x, t, b, c, d) {
		var s=1.70158;var p=0;var a=c;
		if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
		if (a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
		return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b;
	},
	backin: function(x, t, b, c, d) {
		var s=1.70158;
		return c*(t/=d)*t*((s+1)*t - s) + b;
	},
	backout: function(x, t, b, c, d) {
		var s=1.70158;
		return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
	},
	backinout: function(x, t, b, c, d) {
		var s=1.70158;
		if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
		return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
	},
	linear: function(x, t, b, c, d) {
		return c*t/d + b; //linear
	}
};