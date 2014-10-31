function worker() {
  console.log("Entering worker...");

  $.ajax({
    type: "GET",
    url: 'modbus_info',
    data_type: "json"
    // expected response: array of ...
    // { name: Place.find(set[3]).name, status: set[0], value: set[1], condition: set[2], place_id: set[3] }

    }).done(function(data,textStatus, jqXHR) {
      console.log("GET modbus_info done");
      process_modbus_info(data);

    }).fail(function(jqXHR, textStatus, errorThrown) {
      console.log( "Function worker says: " + textStatus );

    }).always(function() { 
      // Schedule the next request when the current one's complete
      // alert("complete"); 
      setTimeout(worker, 5000);

    });
  };

function process_modbus_info(data) {
  console.log("Processing modbus info...");
  data.forEach(function(element, index, array) {
    if (element.status == 1) {
      console.log("Emergency in " + element.name );
      request_place_info(element.place_id);
    }
  });
}

function request_place_info(place_id) {
  console.log("request_place_info(place_id): place_id = " + place_id);
  $.ajax({
    type: "GET",
    url: 'place/' + place_id,
    data_type: "json"

    }).done(function(data,textStatus, jqXHR) {
      console.log("GET request_place_info: ");
      console.log(data);
      drop_a_pin(data);

    }).fail(function(jqXHR, textStatus, errorThrown) {
      console.log( "GET request_place_info => " + textStatus );

    }).always(function() { 
      // alert("complete"); 
    });

}
