var default_map_center_latitude = 41.105844;
var default_map_center_longitude = 1.178449;
var default_general_zoom = 14
var default_place_zoom = 20
var map;
var ROOT_URL = 'http://localhost:3000';

// create context menu
var menu_info = function(marker) {
  return [
            {
              text: 'New place on emergency',
              href: 'http://localhost:3000/places/new',
              target: '_blanck'
            },
            {
              text: 'Emergency Follow-up',
              href: 'http://localhost:3000/followup/' + marker.nb.srcElement.title,
              target: '_blanck'
            }
          ];
};

var menu_html = function(marker) {
  var texto = 
  '<a id="menu1" href=' + menu_info(marker)[0].href + '><div class="context">' + menu_info(marker)[0].text + '<\/div><\/a>' +
  '<a id="menu2" href=' + menu_info(marker)[1].href + '><div class="context">' + menu_info(marker)[1].text + '<\/div><\/a>';
  return texto;
};

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
    // TODO create a new palce to pass the palce.id to createMarker
    var place_id = 0
    createMarker(event.latLng, event.latLng.toString(), true, place_id);
  });    
};

// receives the data from server as an array of places
// creates markers for each place
// adds events
function drop_pins(array_of_pinned_places) {
    array_of_pinned_places.forEach(function(element, index, array) {
      drop_a_pin(element);
    });
};

function drop_a_pin(place) {
  var coords = new google.maps.LatLng(parseFloat(place.coord_x), parseFloat(place.coord_y));
  createMarker(coords, place.name, false, place.id);
};

// create a map marker with the coordinates and test passed
function createMarker(coords, title, draggable, place_id) {
  var marker = new google.maps.Marker( {
    position: coords,
    draggable: draggable,
    map: map,
    // icon: 'map-pin-green.png',
    title: title
  });
  add_click_event_listener_to_marker(marker, place_id);
};

var contentString = function(title, text, place_id) {
  return '<div id="infoWindowContent">' +
          '<h1 id="firstHeading" class="firstHeading">' + title + '</h1>' +
          '<div id="bodyContent">'+
            '<p>' + text + '<a href="' + ROOT_URL + '/places/' + place_id + '"> More info</a> '+
          '</div>' +
        '</div>';
};

function add_click_event_listener_to_marker(marker, place_id) {
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
        this.getMap()._infoWindow.setContent(contentString(marker.title, "esto es una pruebad e infowindow", place_id));
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

  // when right-click on a marker
  // open menu to operate with the pin
  // - delete
  // - change title
  // - open emergency
  google.maps.event.addListener(marker, 'rightclick', function(event, marker) {
      console.log("rightclick");
      console.log(event);
      showContextMenu(event);
    });
};

