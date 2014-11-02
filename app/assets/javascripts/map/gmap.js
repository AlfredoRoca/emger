var default_map_center_latitude = 41.105844;
var default_map_center_longitude = 1.178449;
var default_general_zoom = 15
var default_place_zoom = 20
var map;
var ROOT_URL = 'http://localhost:3000';
var ROOT_API_V1_URL = 'http://localhost:3000/api/v1';
var current_zoom;

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
          center: new google.maps.LatLng(default_map_center_latitude, default_map_center_longitude),
          zoom: default_general_zoom,
          mapTypeId: google.maps.MapTypeId.SATELLITE,
          panControl: true,
          scaleControl: true,
          streetViewControl: true,
          overviewMapControl: true,
          scrollwheel: false
        };

  // initializing map with the above options and draws it in the page
  map = new google.maps.Map(document.getElementById("map-canvas"),mapOptions);

  // request the places with coordinates
  // put a pin in every place 
  // add click event listener to the markers
  // $.ajax({
  //   type: "GET",
  //   url: 'pinned_places',
  //   data_type: "json"

  //   }).done(function(data, textStatus, jqXHR) {
  //     console.log("GET pinned_places...")
  //     // drop_pins(data);

  //   }).fail(function(jqXHR, textStatus, errorThrown) {
  //     alert( textStatus );

  //   }).always(function() { 
  //     // alert("complete"); 

  //   });

  worker(); // in worker.js, to retrieve modbus data periodically

  // drop a new pin when click on the map
  google.maps.event.addListener(map, 'click', function(event) {
    createMarker(event.latLng, event.latLng.toString(), true, 0);
  });    

  document.onkeydown = processKeyPressed;
  // document.onkeyup = processKeyPressed;

};

// zoom in/out when the Z/A key is pressed
var ctrlPressed = false;
function processKeyPressed(event) {
  ctrlPressed = event.ctrlKey;
  keyZPressed = event.keyCode == 90;
  keyAPressed = event.keyCode == 65;
  zoomInKey   = ctrlPressed && keyZPressed;
  zoomOutKey  = ctrlPressed && keyAPressed;
  // console.log("key event...");
  // console.log(event);
  // console.log(ctrlPressed && keyZPressed);
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
// function drop_pins(array_of_pinned_places) {
//     array_of_pinned_places.forEach(function(element, index, array) {
//       drop_a_pin(element);
//     });
// };

function drop_a_pin(place) {
  var coords = new google.maps.LatLng(parseFloat(place.coord_x), parseFloat(place.coord_y));
  createMarker(coords, place.name, false, place.id);
};

// create a map marker with the coordinates and test passed
function createMarker(coords, title, draggable, place_id) {
  // if place_id = 0 means that comes from a click on the map, ie, new emergency
  // if place_id > 0 means that is a new automatic emergency
  var marker = new google.maps.Marker( {
    position: coords,
    draggable: draggable,
    map: map,
    // icon: 'map-pin-green.png',
    title: title
  });
  add_click_event_listener_to_marker(marker, place_id);
};

// html to ask for info to create a new place with emergency
// source: https://developers.google.com/maps/articles/phpsqlinfo_v3
var contentFormString = function(lat, lng) {
  var html = "<table>" +
             "<tr><td>Request status:</td> <td id='xhrStatus'></td></tr>" +
             "<tr><td>Place name:</td> <td><input id='place_name' type='text'/> </td> </tr>" +
             "<tr><td>Description:</td> <td><input id='description' type='text'/></td> </tr>" +
             "<tr><td id='dataset' data-lat=" + lat.toString() + " data-lng=" + lng.toString() + "></td> </tr>" +
             "<tr><td></td><td><input type='button' value='Create new emergency here now' onclick='createNewEmergencyHere()'/></td></tr></table>";
  return html;
};

var contentInfoString = function(name, description, place_id) {
  var html = "<table>" +
             "<tr><td>Place name: " + name + "</td> </tr>" +
             "<tr><td>Description: " + description + "</td> </tr>" +
             "<tr><td><a href='" + ROOT_URL + "/places/" + place_id + "'>More info</a></td> </tr>" +
             "</table>";
  return html;
}

function createNewEmergencyHere() {
  console.log("createNewEmergencyHere...");
  console.log("url: " + ROOT_API_V1_URL + '/herenew/');
  var place_name        = document.getElementById("place_name");
  var description       = document.getElementById("description");
  var data_coordinates  = $("#dataset")[0];
  console.log("Name: " + place_name.value + " :: Description: " + description.value);
  console.log("data_coordinates...");
  console.log(data_coordinates);
  $.ajax({
    type: "POST",
    url: ROOT_API_V1_URL + '/here_new_emergency',
    data: { name:         place_name.value,
            description:  description.value,
            coord_x:      data_coordinates.dataset.lat,
            coord_y:      data_coordinates.dataset.lng
          },
    data_type: "json"

    }).done(function(data, textStatus, jqXHR) {
      console.log("POST herenew data: ");
      console.log(data);
      document.getElementById("xhrStatus").innerHTML = "New place created";
      // TODO change marker title by new place name

    }).fail(function(jqXHR, textStatus, errorThrown) {
      console.log( "ERROR POST herenew - " + textStatus );
      // validation denied respond with status codes
      // response = "Error saving new emergency. Params: #{params}"
      // status   = 451
      // response = "Error saving new place. Params: #{params}"
      // status   =  450
      document.getElementById("xhrStatus").innerHTML = jqXHR.responseText;

    }).always(function() { 
      // alert("complete"); 

    });
}

function add_click_event_listener_to_marker(marker, place_id) {
  // if place_id = 0 means that comes from a click on the map, ie, new emergency
  // if place_id > 0 means that is a new automatic emergency
  google.maps.event.addListener(marker, 'click', function(event) {
    console.log("add_click_event_listener_to_marker...");
    console.log(event);
    // event.latLng
    // event.nb: MouseEvent
    // event.pixel
    // console.log("shift? " + (event.nb.shiftKey ? "true" : "false"));
      if (true) {
      // if (!event.nb.shiftKey && !event.nb.ctrlKey) {
        // when click on a marker, applies zoom and centers on it
        map.setZoom(default_place_zoom);
        map.setCenter(marker.getPosition());

        if (!this.getMap()._infoWindow) {
          this.getMap()._infoWindow = new google.maps.InfoWindow();
        }
        this.getMap()._infoWindow.close();
        var latlng = marker.getPosition();
        if (place_id == 0) { // new emergency --> open a form to enter new info
          this.getMap()._infoWindow.setContent(contentFormString(latlng.lat(), latlng.lng()));
        }
        else { // automatic emergency --> show place info
          // params: name, description, place_id
          // TODO request place info to fill the infoWindow
          this.getMap()._infoWindow.setContent(contentInfoString(latlng.lat(), latlng.lng()));
        }
        this.getMap()._infoWindow.open(this.getMap(), this);

        console.log("click with no buttons:");
        // console.log(event);
      }
      else {
        // console.log("click with button:");
        // console.log(event);
        // removes the marker
        marker.setMap(null);
      };
  });

};

