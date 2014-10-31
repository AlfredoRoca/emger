(function worker() {
  console.log("Entering worker...");

  $.ajax({
    type: "GET",
    url: 'modbus_info',
    data_type: "json"

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
  })();

function process_modbus_info(data) {
  console.log("Processing modbus info...");
  data.forEach(function(element, index, array) {
    if (element.status == 1) {
      console.log("Emergency in " + element.name );
      request_place(element.name);
    }
  });
}

function request_place(name) {
  console.log("request_place(name): name = " + name);
  $.ajax({
    type: "GET",
    url: 'place_by_name/' + name,
    data_type: "json"

    }).done(function(data,textStatus, jqXHR) {
      console.log("GET place_by_name: ");
      console.log(data);
      drop_a_pin(data);

    }).fail(function(jqXHR, textStatus, errorThrown) {
      alert( "GET place_by_name => " + textStatus );

    }).always(function() { 
      // alert("complete"); 
    });

}
