!function(){"use strict";var o=window.location,n=window.document,r=n.currentScript,p=r.getAttribute("data-api")||new URL(r.src).origin+"/api/event";function e(e,t){if(!(window._phantom||window.__nightmare||window.navigator.webdriver||window.Cypress)){try{if("true"==window.localStorage.plausible_ignore)return void console.warn("Ignoring Event: localStorage flag")}catch(e){}var i={};i.n=e,i.u=o.href,i.d=r.getAttribute("data-domain"),i.r=n.referrer||null,i.w=window.innerWidth,t&&t.meta&&(i.m=JSON.stringify(t.meta)),t&&t.props&&(i.p=JSON.stringify(t.props)),i.h=1;var a=new XMLHttpRequest;a.open("POST",p,!0),a.setRequestHeader("Content-Type","text/plain"),a.send(JSON.stringify(i)),a.onreadystatechange=function(){4==a.readyState&&t&&t.callback&&t.callback()}}}var t=r.getAttribute("file-types"),l=t&&t.split(",")||["pdf","xlsx","docx","txt","rtf","csv","exe","key","pps","ppt","pptx","7z","pkg","rar","gz","zip","avi","mov","mp4","mpeg","wmv","midi","mp3","wav","wma"];function i(e){for(var t,i,a=e.target,n="auxclick"==e.type&&2==e.which,r="click"==e.type;a&&(void 0===a.tagName||"a"!=a.tagName.toLowerCase()||!a.href);)a=a.parentNode;a&&a.href&&(t=a.href,i=t.split(".").pop(),l.some(function(e){return e==i}))&&((n||r)&&plausible("File Download",{props:{url:a.href}}),a.target&&!a.target.match(/^_(self|parent|top)$/i)||e.ctrlKey||e.metaKey||e.shiftKey||!r||(setTimeout(function(){o.href=a.href},150),e.preventDefault()))}n.addEventListener("click",i),n.addEventListener("auxclick",i);var a=window.plausible&&window.plausible.q||[];window.plausible=e;for(var s,c=0;c<a.length;c++)e.apply(this,a[c]);function d(){s=o.pathname,e("pageview")}window.addEventListener("hashchange",d),"prerender"===n.visibilityState?n.addEventListener("visibilitychange",function(){s||"visible"!==n.visibilityState||d()}):d()}();