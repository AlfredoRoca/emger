var default_map_center_latitude = 41.105844;
var default_map_center_longitude = 1.178449;
var default_general_zoom = 14
var default_place_zoom = 20
var map;
var ROOT_URL = 'http://localhost:3000';
var ROOT_API_V1_URL = 'http://localhost:3000/api/v1';

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
    // TODO create a context menu to create a new place with emergency
    // TODO create a new place to pass the place.id to createMarker
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

// html to ask for creating a new place with emergency
// option A
// with GET, passing lat/lng, there is the problem with decimal point
// var contentString = function(title, place_id, lat, lng) {
//   var html_content = 
//         '<div id="infoWindowWrapper">' +
//           '<h1 id="firstHeading" class="firstHeading">' + title + '</h1>' +
//           '<div id="infoWindowContent">';
//   if (place_id > 0) {
//       html_content += '<p><a href="' + ROOT_URL + '/places/' + place_id + '"> More info</a></p>';
//   }
//   else {
//       html_content += '<p><a href="' + ROOT_API_V1_URL + '/herenew/' + lat + '/' + lng + '"> Create new emergency here</a></p>';
//   };
//   html_content += '</div></div>';
//   return html_content;
// };


// html to ask for creating a new place with emergency
// option B: https://developers.google.com/maps/articles/phpsqlinfo_v3
var contentString = function(lat, lng) {
  var html = "<table>" +
             "<tr><td>Place name:</td> <td><input type='text' id='place_name'/> </td> </tr>" +
             "<tr><td>Description:</td> <td><input type='text' id='description'/></td> </tr>" +
             "<tr><td data-lat=" + lat.toString() + " data-lng=" + lng.toString() + "></td> </tr>" +
             "<tr><td></td><td><input type='button' value='Create new emergency here now' onclick='createNewEmergencyHere()'/></td></tr></table>";
  return html;
}

function createNewEmergencyHere() {
  console.log("createNewEmergencyHere...");
  console.log("url: " + ROOT_API_V1_URL + '/herenew/');
  var place_name = escape(document.getElementById("place_name").value);
  var description = escape(document.getElementById("description").value);
  // var latlng = marker.getPosition();
  // var url = "phpsqlinfo_addrow.php?name=" + name + "&address=" + address +
  //           "&type=" + type + "&lat=" + latlng.lat() + "&lng=" + latlng.lng();
  // downloadUrl(url, function(data, responseCode) {
  //   if (responseCode == 200 && data.length >= 1) {
  //     infowindow.close();
  //     // document.getElementById("message").innerHTML = "Location added.";
  //     console.log("Location added.");
  $.ajax({
    type: "POST",
    url: ROOT_API_V1_URL + '/herenew/',
    data: { name: place_name,
            description: description,
            coord_x: 41.1, //latlng.lat(),
            coord_y: 1.2 //latlng.lng()
          },
    data_type: "json"

    }).done(function(data, textStatus, jqXHR) {
      console.log("POST herenew data: ");
      console.log(data);

    }).fail(function(jqXHR, textStatus, errorThrown) {
      alert( "ERROR POST herenew - " + textStatus );

    }).always(function() { 
      // alert("complete"); 

    });

}



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
        var latlng = marker.getPosition();
        this.getMap()._infoWindow.setContent(contentString(latlng.lat(), latlng.lng()));
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

