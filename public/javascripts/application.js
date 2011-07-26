var searchResultsWindow;
function showResultsMiniWindow(name, id, gender) {
  var html = "<div style='text-align:center;font-size:1.2em;font-weight:bold;line-height:1.4em;'><a href='javascript:showNameWindow(\"" + name + "\"," + id + ", \"details\")' title='View Details'>" + name + "</a> &nbsp; ";
  html += "<img src='/images/icons/" + gender + ".png' alt='Gender'/> "
  html += "<br /><a href='javascript:showNameWindow(\"" + name + "\"," + id + ", \"details\")' title='View Details'>";
  html += "<img src='/images/icons/user_" + gender + ".png' alt='Overview'/></a>";
  html += " <a href='javascript:showNameWindow(\"" + name + "\"," + id + ", \"popularity\")' title='Chart Popularity'>";
  html += "<img src='/images/icons/chart_curve.png' alt='Chart'/></a>";
  html += " <a href='javascript:showNameWindow(\"" + name + "\"," + id + ", \"photos\")' title='View Photos'>";
  html += "<img src='/images/icons/images.png' alt='Photos'/></a>";
  html += " <a href='javascript:showNameWindow(\"" + name + "\"," + id + ", \"comments\")' title='Read Comments'>";
  html += "<img src='/images/icons/comments.png' alt='Comments'/></a>";
  html += " <a href='javascript:addFave(" + id + ", \"" + name + "\", \"" + gender + "\")' title='Add to Favorites'>";
  html += "<img src='/images/icons/heart_add.png' alt='Favorite'/></a>";
  html += "</div>";
  
  if (searchResultsWindow) {
    searchResultsWindow.close();
  }

  searchResultsWindow = new Ext.Window({
    id:'searchResultsId',
    width: 150,
    height: 70,
    title: 'Search Results',
    html: html,
    closable: true,
    keys: [{
        key: 27,  // hide on Esc
        fn: function(){
            searchResultsWindow.hide();
        }
    }]
  });
  searchResultsWindow.on('minimize', function(){
    win.toggleCollapse();
  });
  width = getViewportWidth();
  searchResultsWindow.setPosition(width-400, 2);
  searchResultsWindow.show();
}

function showNameWindow(name, id, tabToShow, region_id) { 
    if (tabToShow == 'popularity')
       showTabNum = 1;
    else if (tabToShow == 'details')
       showTabNum = 0;
    else if (tabToShow == 'photos')
       showTabNum = 2; 
    else if (tabToShow == 'comments')
       showTabNum = 3;
  
    var tabs = new Ext.TabPanel({
        width: 484,
        height: 408,
        region: 'center',
        activeTab: showTabNum,
        bodyBorder: false,
        border:false,
        defaults:{autoScroll: true},
        items:[{
                title: 'Rating',
                autoLoad: "/name/details/" + id
            },{
                title: 'Popularity',
                autoLoad: "/name/popularity/" + id + "?region_id=" + region_id
            },{
                title: 'Photos',
                autoLoad: "/name/photos/" + id
            },{
                title: 'Comments',
                autoLoad: "/name/comments/" + id
            }
        ]
    });
  var win = new Ext.Window({
    closable: true,
    width: 498,
    height: 440,
    minimizable: true,
    resizable: false,
    title: name,
    items: [tabs]
  });
 
  win.on('minimize', function(){
    win.toggleCollapse();
  });
  win.show();   
}

function compareNames() {
  var win = new Ext.Window({
    closable: true,
    width: 498,
    height: 457,
    minimizable: true,
    resizable: false,
    title: 'Compare Names: Babies per Year',
    autoLoad: '/name/compare'
  });
 
  win.on('minimize', function(){
    win.toggleCollapse();
  });
  win.show();   
}

function clearInput(input) {
  $(input).value = '';
}

function remoteSearch(name, gender) {
  if ((window.location.pathname.indexOf('/name/') != 0) && 
      (window.location.pathname.indexOf('/region/') != 0)) {
    new Ajax.Request('/map/search_xhr?search_name=' + escape(name) + "&gender=" + gender, {
      asynchronous:true, 
      evalScripts:true,
      onFailure:function(request){showXhrFailure(request)}, 
      onComplete:function(request){showSearchProgress(false)}, 
      onCreate:function(request){showSearchProgress(true)}, 
      onSuccess:function(request){eval(request.responseText)}});
  } else if (gender == 'male') {
    window.location.href = "/boys/" + name;
  }
  else {
    window.location.href = "/girls/" + name;
  }
}

function getViewportHeight() {
   d=document;
   yMax=0;
   if(d.getElementById){
     if (d.documentElement && d.documentElement.clientHeight){
      yMax=d.documentElement.clientHeight;
     } else{
      yMax=(d.all)?d.body.clientHeight:window.innerHeight;
     }
   } else if(d.layers){
     yMax=window.innerHeight;
   }
  return yMax;
}

function getViewportWidth() {
   d=document;
   xMax=0;
   if(d.getElementById){
     if (d.documentElement && d.documentElement.clientWidth){
      xMax=d.documentElement.clientWidth;
     } else{
      xMax=(d.all)?d.body.clientWidth:window.innerWidth;
     }
   } else if(d.layers){
     xMax=window.innerWidth;
   }
  return xMax;
}

function showErrorMessage(title, msg) {
  var html = "<p id='msgbox_text'>"
  html +="<img src='/images/error-icon.png' style='float:left;clear:left; margin:10px'/><br/>";
  html += msg + "</p>";
  var win = new Ext.Window({
    width: 350,
    height: 140,
    modal: true,
    minimizable: false,
    title: title,
    html: html,
    closable: true,
    autoScroll:true,
    keys: [{
        key: 27,  // hide on Esc
        fn: function(){
            win.hide();
        }
    }]
  });
  win.on('minimize', function(){
    win.toggleCollapse();
  });
  win.show();
}

function showXhrFailure(request) {
  var html = "<p id='msgbox_text'>"
  html +="<img src='/images/error-icon.png' style='float:left;clear:left; margin:10px'/>";
  html += "<br/>Oops! An error was encountered contacting the web server.  Please try your action again.</p>"; 
  var win = new Ext.Window({
    width: 400,
    height: 150,
    modal: true,
    minimizable: false,
    title: "Error Encountered",
    html: html,
    closable: true,
    autoScroll:true,
    keys: [{
        key: 27,  // hide on Esc
        fn: function(){
            win.hide();
        }
    }]
  });
  win.on('minimize', function(){
    win.toggleCollapse();
  });
  win.show();
}

function showModalInfoWindow(request, winTitle, width, height) { 
  var win = new Ext.Window({
    width: width,
    height: height,
    modal: true,
    minimizable: false,
    title: winTitle,
    html: request.responseText,
    closable: true,
    autoScroll:true,
    keys: [{
        key: 27,  // hide on Esc
        fn: function(){
            win.hide();
        }
    }]
  });
  win.on('minimize', function(){
    win.toggleCollapse();
  });
  win.show();
}

function sendXhrSearch(parameters) {
  new Ajax.Request('/map/search_xhr', {
    asynchronous:true,
    evalScripts:true,
    onFailure:function(request){showXhrFailure(request)},
    onComplete:function(request){showSearchProgress(false)},
    onCreate:function(request){showSearchProgress(true)},
    onSuccess:function(request){eval(request.responseText)},
    parameters:parameters
  });
  return false;
}

function showSearchProgress(show) {
  if (show) {
    Element.hide('search_icon');
    Element.show('search_indicator'); 
  }
  else {
    Element.hide('search_indicator');
    Element.show('search_icon');
  }
}

function showSearchedMap(male, name) {
  showSearchProgress(true);
  if (male) { 
    location.href = '/boys/' + escape(name);
  } else {
    location.href = '/girls/' + escape(name);
  }
}

function updatePopularityGraph(name_id, region_id) {
  var img = '<img width="484" height="350" src="/name/pop_in_region_graph/' + name_id;
  img += '/' + region_id + '"/>';
  Element.update('popularity_graph', img);
  Effect.Grow('popularity_graph')
}

function updateCompareGraph(params) {
  var img = '<img width="484" height="350" src="/name/compare_graph?' + params + '"/>';
  Element.update('compare_graph', img)
  Effect.Grow('compare_graph')
}

function updateNameRating(request) {
  Element.update('rating_div', request.responseText);
  Effect.Grow('name_rating');
}

function addSearchMarker(region_id, point, icon, title, content) {
  var marker = new GMarker(point, {icon: icon, title: title});
  GEvent.addListener(marker, "click", function() {
    marker.openInfoWindowHtml(content);
  });
  map.addOverlay(marker);
  markers[region_id]=marker; // Add to global array of active markers
  return point;
}

function zoomToRegion(lat, lng, region_id, zoomLevel) {
  map.panTo(new GLatLng(lat,lng));
  if (zoomLevel > 6) {
    zoomLevel = 6; // Don't zoom in any more than that
  }
  map.setZoom(zoomLevel);
  marker = markers[region_id];
  if (marker) {
    GEvent.trigger(marker, 'click');
  }
}

function mapUserLocate(href) {
  // Zoom to region if specified in the window location href
  if (href.include('/map/region/')) {
    last_sep = href.lastIndexOf('/');
    region_id = href.substr(last_sep + 1, href.length);
    GEvent.trigger(markers[region_id], 'click');
  } else { // Call to server to determine user's location by IP
    new Ajax.Request('/map/locate', {
      asynchronous:true, 
      evalScripts:true,
      onComplete:function(request){eval(request.responseText)}
    });
  }
}

function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function eraseCookie(name) {
	createCookie(name,"",-1);
}

function loadFaves(faves) {
  var fave_html = "";
  if (faves) {
    faves = faves.split(',');
    fave_html = "<table width='100%' border='0'>";
    for (i=0; i < faves.length; i+=3) {
      fave_html += "<tr><td width='10%'><img src='/images/icons/" + faves[i+2] + ".png'/><td>";
      fave_html += "<td width='70%'><a href='javascript:showNameWindow(\"" + faves[i+1] + "\"," + faves[i] + ",\"popularity\")'>";
      fave_html += faves[i+1] + "</a></td>";
      fave_html += "<td width='10%'><a title='Remove Favorite' href='javascript:removeFave(" + faves[i] + ");'>";
      fave_html += "<img src='/images/icons/heart_delete.png' alt='Remove Favorite'/></a></td>";
      fave_html += "<td width='10%'><a title='Show Popularity on Map' href='javascript:remoteSearch(\"" + faves[i+1] + "\",\"" + faves[i+2] + "\");'>";
      fave_html += "<img src='/images/icons/world_go.png' alt='Show Popularity on Map'/></a></td>";
      fave_html += "</tr>";
    }
    fave_html += "</table>"; 
  }
  else {
    fave_html = "Click <img src='/images/icons/heart_add.png'/> to save your favorite baby names.";
  }
  Element.update('favorites', fave_html);
}

function addFave(id, name, gender) {
  faves = readCookie("favorites");
  if (faves) {
    var faves_list = faves.split(',');
    var exists = false;
    for (i=0; i < faves_list.length; i+=3) {
      if (faves_list[i] == id) {
	exists = true;
      }
    }
    if (!exists) {
      faves = faves + "," + id + "," + name + "," + gender;
    }
  }
  else {
    faves = id + "," + name + "," + gender;
  }
  createCookie('favorites', faves, 365*5);
  loadFaves(faves);
}

function removeFave(id) {
  faves = readCookie("favorites").split(',');
  values = new Array();
  for (i=0; i < faves.length; i+=3) {
    if (faves[i] != id) {
      values.push(faves[i]);
      values.push(faves[i+1]);
      values.push(faves[i+2]);
    }
  }
  if (values.length == 0) {
    eraseCookie('favorites');
    loadFaves(null);
  } else {
    createCookie('favorites', values.join(','), 365*5);
    loadFaves(values.join(','));
  }
} 
