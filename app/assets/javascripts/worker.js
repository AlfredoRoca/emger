var MODBUS_SERVER_VALUE_FOR_EMERGENCY = 1,
    MODBUS_SERVER_VALUE_FOR_CLEAR     = 2;

function worker() {
  $.ajax({
    type: "GET",
    url: 'modbus_info',
    dataType: "json"
    // expected response: array of ...
    // { name: Place.find(set[3]).name, status: set[0], value: set[1], condition: set[2], place_id: set[3] }

    }).done(function(data,textStatus, jqXHR) {
      console.log("GET modbus_info done");
      processModbusInfo(data);

    }).fail(function(jqXHR, textStatus, errorThrown) {
      console.log( "Function worker says: " + textStatus );

    }).always(function() { 
      // Schedule the next request when the current one's complete
      // alert("complete"); 
      setTimeout(worker, 3000);

    });
};

function processModbusInfo(data) {
  console.log("Processing modbus info...");
  console.log(data);
  data.forEach(function(element, index, array) {
    if (element.status == MODBUS_SERVER_VALUE_FOR_EMERGENCY) {
      console.log("Emergency in " + element.name );
      requestPlaceInfo(element.place_id); 
      // and create an emergency and put a pin
    }
    if (element.status == MODBUS_SERVER_VALUE_FOR_CLEAR) {
      // close the emergency associated
      requestCloseEmergency(element.place_id);
    }
  });
}

function requestPlaceInfo(place_id) {
  console.log("request_place_info(place_id): place_id = " + place_id);
  $.ajax({
    type: "GET",
    url: 'places/' + place_id,
    dataType: "json"

    }).done(function(place,textStatus, jqXHR) {
      console.log("GET request_place_info: ");
      console.log(place);
      dropAPin(place, customIcons.red.icon);
      createANewModbusEmergency(place);

    }).fail(function(jqXHR, textStatus, errorThrown) {
      console.log( "GET request_place_info => " + textStatus );

    });
}

// if new emergency via modbus
// check if there is already an open emergency in that place
// if not, create a new emergency on it
function createANewModbusEmergency(place) {
  $.ajax({
    type: "POST",
    url: 'emergencies/' + place.id.toString() + '/modbus_new_emergency',
    data: { },
    dataType: "json"

    }).done(function(data, textStatus, jqXHR) {
      console.log("POST create_a_new_modbus_emergency: ");
      console.log(data);

    }).fail(function(jqXHR, textStatus, errorThrown) {
      console.log( "ERROR POST create_a_new_modbus_emergency - " + textStatus );
      // validation denied respond with status codes
      // response = "Error saving new emergency. Params: #{params}"
      // status   = 451
      console.log(jqXHR.responseText);

    });
}

function requestCloseEmergency(place_id) {
  console.log("request_close_emergency: place_id = " + place_id);
  $.ajax({
    type: "GET",
    url: 'emergency/' + place_id + "/close_by_place",
    dataType: "json"

    }).done(function(data,textStatus, jqXHR) {
      // data = {"place" => @place, "emergency" => @emergency}
      console.log("GET request_close_emergency: ");
      console.log(data);
      deletePin(data.place.name);

    }).fail(function(jqXHR, textStatus, errorThrown) {
      console.log( "GET request_close_emergency => " + textStatus );

    });
}
