function showContextMenu(event) {
    var projection;
    var contextmenuDir;
    projection = map.getProjection();
    $('.contextmenu').remove();
    contextmenuDir = document.createElement("div");
    contextmenuDir.className = 'contextmenu';
    contextmenuDir.innerHTML = menu_html(event);

    $(map.getDiv()).append(contextmenuDir);

    setMenuXY(event.latLng);

    contextmenuDir.style.visibility = "visible";
};

function getCanvasXY(currentLatLng) {
       var scale = Math.pow(2, map.getZoom());
       var nw = new google.maps.LatLng(
           map.getBounds().getNorthEast().lat(),
           map.getBounds().getSouthWest().lng()
       );
       var worldCoordinateNW = map.getProjection().fromLatLngToPoint(nw);
       var worldCoordinate = map.getProjection().fromLatLngToPoint(currentLatLng);
       var currentLatLngOffset = new google.maps.Point(
           Math.floor((worldCoordinate.x - worldCoordinateNW.x) * scale),
           Math.floor((worldCoordinate.y - worldCoordinateNW.y) * scale)
       );
       return currentLatLngOffset;
};

function setMenuXY(currentLatLng) {
    var mapWidth   = $('#map-canvas').width();
    var mapHeight  = $('#map-canvas').height();
    var menuWidth  = $('.contextmenu').width();
    var menuHeight = $('.contextmenu').height();
    var clickedPosition = getCanvasXY(currentLatLng);
    var x = clickedPosition.x ;
    var y = clickedPosition.y ;

    if((mapWidth - x ) < menuWidth)//if to close to the map border, decrease x position
        x = x - menuWidth;
    if((mapHeight - y ) < menuHeight)//if to close to the map border, decrease y position
       y = y - menuHeight;

    $('.contextmenu').css('left',x);
    $('.contextmenu').css('top',y);
};
