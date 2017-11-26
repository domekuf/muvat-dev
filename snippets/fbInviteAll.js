function eventFire(el, etype){
  if (el.fireEvent) {
    el.fireEvent('on' + etype);
  } else {
    var evObj = document.createEvent('Events');
    evObj.initEvent(etype, true, false);
    el.dispatchEvent(evObj);
  }
}

ar=document.getElementsByTagName("button");
for (i in ar){
    if (ar[i].innerHTML && ar[i].innerHTML.indexOf("nvita") !== -1)
        {eventFire(ar[i], 'click');
    }
}
