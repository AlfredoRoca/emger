var default_map_center_latitude = 41.105844;
var default_map_center_longitude = 1.178449;
var default_general_zoom = 14
var default_place_zoom = 20
var map;
var array_of_markers = [];

$(window).load(function() {
  loadScript();
});

function initialize() {
        
  var mapOptions = {
          center: new google.maps.LatLng(default_map_center_latitude, default_map_center_longitude),
          zoom: default_general_zoom,
          mapTypeId: google.maps.MapTypeId.SATELLITE,
          panControl: true,
          scaleControl: true,
          streetViewControl: true,
          overviewMapControl: true
        };

  // initializing map with the above options and draws it in the page
  map = new google.maps.Map(document.getElementById("map-canvas"),mapOptions);

  // request the places with coordinates
  // put a pin in every place 
  // add click event listener to the markers
  $.ajax({
    type: "GET",
    url: 'pinned_places',
    data_type: "json"
  }).done(function(data,textStatus, jqXHR){
      put_a_marker_in_place(data);
    }).fail(function(jqXHR, textStatus, errorThrown){
      alert( textStatus );
    }).always(function() { 
      // alert("complete"); 
    });

}

// create a map marker with the coordinates and test passed
// var marker;
function createMarker(coords, map, title){
  var marker = new google.maps.Marker({
    position: coords,
    map: map,
    title: title
  });
  return marker;
  // add click event listener to the markers
}

// receives the data from server as an array of places
// creates markers for each place
// fills the array_of_markers with each marker
function put_a_marker_in_place(array_of_pinned_places){
  var marker;
    array_of_pinned_places.forEach(function(element, index, array) {
      var coords = new google.maps.LatLng(parseFloat(element.coord_x), parseFloat(element.coord_y));
      marker = createMarker(coords, map, element.name);
      add_click_event_listener_to_marker(marker);
    });
}

function add_click_event_listener_to_marker(marker) {
    google.maps.event.addListener(marker, 'click', function() {
        map.setZoom(default_place_zoom);
        map.setCenter(marker.getPosition());
      });
}

function loadScript() {
  console.log("map loading ...");
  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp' +
    //'&v=3.14'+
    '&key=AIzaSyAHzuI28JBUApyQFAN14ts0bhgvUDl_1Co'+
    '&libraries=drawing'+
    '&callback=initialize';
  document.body.appendChild(script);
}
