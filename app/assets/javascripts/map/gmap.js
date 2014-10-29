var default_map_center_latitude = 41.105844;
var default_map_center_longitude = 1.178449;

$(window).load(function() {
  loadScript();
});

var map;

function initialize() {
        
  var mapOptions = {
          center: new google.maps.LatLng(default_map_center_latitude, default_map_center_longitude),
          zoom: 14,
          mapTypeId: google.maps.MapTypeId.SATELLITE,
          panControl: true,
          scaleControl: false,
          streetViewControl: true,
          overviewMapControl: true
        };
  // initializing map
  map = new google.maps.Map(document.getElementById("map-canvas"),mapOptions);

  //put the places pins
  $.ajax({
    type: "GET",
    url: 'pinned_places',
    data_type: "json"
  }).done(function(data,textStatus, jqXHR){
      // this works
      // data.forEach(function(element, index, array) {
      //   console.log("element:", element.name + ": (" + element.coord_x + ", " + element.coord_y + ")"); });
      traverse_array_of_pinned_places(data);
    }).fail(function(jqXHR, textStatus, errorThrown){
      alert( textStatus );
    }).always(function() { 
      // alert("complete"); 
    });
}

function loadScript() {
  console.log("map loading ...");
  var script = document.createElement('script');
  script.type = 'text/javascript';
  //'https://maps.googleapis.com/maps/api/js?v=3.exp&key=AIzaSyBJYFdplGeKUUEmGZ-vL4ydiSZ09Khsa_o&sensor=false&libraries=drawing'
  script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp' +
    //'&v=3.14'+
    '&key=AIzaSyAHzuI28JBUApyQFAN14ts0bhgvUDl_1Co'+
    '&libraries=drawing'+
    '&callback=initialize';
  document.body.appendChild(script);
}

var marker;
function createMarker(coords, map, title){
  marker = new google.maps.Marker({
    position: coords,
    map: map,
    title: title
  });
}


function traverse_array_of_pinned_places(array_of_pinned_places){
    array_of_pinned_places.forEach(function(element, index, array) {
      console.log("element:", element.name + ": (" + element.coord_x + ", " + element.coord_y + ")"); 
      var coords = new google.maps.LatLng(parseFloat(element.coord_x), parseFloat(element.coord_y));
      createMarker(coords, map, element.name);
    });
}
