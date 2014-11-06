var DEFAULT_MAP_CENTER_LATITUDE = 41.105844,
    DEFAULT_MAP_CENTER_LONGITUDE = 1.178449,
    DEFAULT_GENERAL_ZOOM = 15,
    DEFAULT_PLACE_ZOOM = 20,
    map,
    current_zoom,
    KEYZ = 90,
    KEYQ = 81;
    
$(window).load(function() {
  loadScript();
});

function loadScript() {
  console.log("map loading ...");
  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp' +
    '&key=AIzaSyAHzuI28JBUApyQFAN14ts0bhgvUDl_1Co'+
    '&libraries=drawing'+
    '&callback=initialize';
  document.body.appendChild(script);
};

function initialize() {
        
  var mapOptions = {
          center: new google.maps.LatLng(DEFAULT_MAP_CENTER_LATITUDE, DEFAULT_MAP_CENTER_LONGITUDE),
          zoom: DEFAULT_GENERAL_ZOOM,
          mapTypeId: google.maps.MapTypeId.SATELLITE,
          panControl: true,
          scaleControl: true,
          streetViewControl: true,
          overviewMapControl: true,
          scrollwheel: true
        };

  // initializing map with the above options and draws it in the page
  map = new google.maps.Map(document.getElementById("map-canvas"),mapOptions);

  // drop markers for open emergencies
  // request emergencies
  // put a pin in every place 
  // add click event listener to the markers
  $.ajax({
    type: "GET",
    url: "emergencies/places",
    dataType: "json"

    }).done(function(data, textStatus, jqXHR) {
      console.log("GET places of open emergencies...");
      console.log(data);
      dropPins(data, customIcons.blue.icon);

    }).fail(function(jqXHR, textStatus, errorThrown) {
      console.log( textStatus );

    });

  worker(); // in worker.js, to retrieve modbus data periodically

  // drop a new pin when click on the map
  google.maps.event.addListener(map, 'click', function(event) {
    createMarker(event.latLng, "Emergency place", true, 0, customIcons.blue.icon);
  });    

  // map zoom in/out
  document.onkeydown = processKeyPressed;

};

// zoom in/out when the Z/Q key are pressed
var ctrlPressed = false;
function processKeyPressed(event) {
  ctrlPressed = event.ctrlKey;
  var keyPressed = event.keyCode,
  zoomInKey   = ctrlPressed && keyPressed == KEYZ;
  zoomOutKey  = ctrlPressed && keyPressed == KEYQ;
  if (zoomInKey) {
    current_zoom = map.getZoom();
    map.setOptions({zoom: current_zoom + 1});
  }
  if (zoomOutKey) {
    current_zoom = map.getZoom();
    map.setOptions({zoom: current_zoom - 1});
  }
}

// receives the data from server as an array of places
// creates markers for each place
// adds events
function dropPins(array_of_places, icon) {
    array_of_places.forEach(function(place, index, array) {
      dropAPin(place, icon);
    });
};

function dropAPin(place, icon) {
  console.log("Entering drop_a_pin...");
  console.log(place);
  var coords = new google.maps.LatLng(parseFloat(place.coord_x), parseFloat(place.coord_y));
  createMarker(coords, place.name, false, place.id, icon);
};

function createMarker(coords, title, draggable, place_id, icon) {
  // if place_id = 0 means that comes from a click on the map, ie, new emergency
  // if place_id > 0 means that is a new automatic emergency
  var marker = new google.maps.Marker( {
    position: coords,
    draggable: draggable,
    map: map,
    icon: icon,
    title: title + " (" + place_id.toString() + ")"
  });
  addClickEventListenerToMarker(marker, place_id);
};

// html to ask for info to create a new place with emergency
// source: https://developers.google.com/maps/articles/phpsqlinfo_v3
var contentFormString = function(lat, lng) {
  var html = "<table>" +
             "<tr><td>Place name:</td> <td><input id='place_name' type='text'/> </td> </tr>" +
             "<tr><td>Description:</td> <td><input id='description' type='text'/></td> </tr>" +
             "<tr><td id='dataset' data-lat=" + lat.toString() + " data-lng=" + lng.toString() + "></td> </tr>" +
             "<tr><td></td><td><input type='button' value='Create new emergency here now' onclick='createNewEmergencyHere()'/></td></tr>" +
             "<tr><td>Response:</td> <td id='xhrStatus'></td></tr>" +
             "</table>";
  return html;
};

var contentInfoString = function(name, place_id) {
  var html = "<table>" +
             "<tr><td>Place name: " + name + "</td> </tr>" +
             "<tr><td><a href='" + ROOT_URL + "places/" + place_id + "'>More info</a></td> </tr>" +
             "</table>";
  return html;
}

function createNewEmergencyHere() {
  console.log("createNewEmergencyHere...");
  console.log("url: /here_new");
  var place_name        = document.getElementById("place_name");
  var description       = document.getElementById("description");
  var data_coordinates  = $("#dataset")[0];
  console.log("Name: " + place_name.value + " :: Description: " + description.value);
  console.log("data_coordinates...");
  console.log(data_coordinates);
  $.ajax({
    type: "POST",
    url: 'emergencies/here_new',
    data: { name:         place_name.value,
            description:  description.value,
            coord_x:      data_coordinates.dataset.lat,
            coord_y:      data_coordinates.dataset.lng
          },
    dataType: "json"

    }).done(function(data, textStatus, jqXHR) {
      console.log("POST herenew data: ");
      console.log(data);
      document.getElementById("xhrStatus").innerHTML = "New place created";

    }).fail(function(jqXHR, textStatus, errorThrown) {
      console.log( "ERROR POST herenew - " + textStatus );
      // validation denied respond with status codes
      // response = "Error saving new emergency. Params: #{params}"
      // status   = 451
      // response = "Error saving new place. Params: #{params}"
      // status   =  450
      document.getElementById("xhrStatus").innerHTML = jqXHR.responseText;
    });
}

function addClickEventListenerToMarker(marker, place_id) {
  console.log("Entering add click event...");
  console.log(place_id);
  // if place_id = 0 means that comes from a click on the map, ie, new emergency
  // if place_id > 0 means that is a new automatic emergency
  google.maps.event.addListener(marker, 'click', function(event) {
    console.log("add_click_event_listener_to_marker...");
    console.log(event);
        // when click on a marker, applies zoom and centers on it
        map.setZoom(DEFAULT_PLACE_ZOOM);
        map.setCenter(marker.getPosition());

        if (!this.getMap()._infoWindow) {
          this.getMap()._infoWindow = new google.maps.InfoWindow();
        }
        this.getMap()._infoWindow.close();
        var latlng = marker.getPosition();
        if (place_id == 0) { // new emergency --> open a form to enter new info
          console.log("filling infowindow with form");
          this.getMap()._infoWindow.setContent(contentFormString(latlng.lat(), latlng.lng()));
        }
        else { // automatic emergency --> show place info
          console.log("filling infowindow with " + marker.getTitle() + " id " + place_id.toString());
          this.getMap()._infoWindow.setContent(contentInfoString(marker.getTitle(), place_id));
        }
        this.getMap()._infoWindow.open(this.getMap(), this);

  });

};

function deletePin(place_name) {
  console.log("Deleting pin..." + place_name);
  console.log(place_name);
  // localize marker with title=place.name and assign setMap(nul)
};