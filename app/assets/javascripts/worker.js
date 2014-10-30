(function worker() {
  console.log("Entering worker...");
  $.ajax({
    type: "GET",
    url: 'modbus_info',
    data_type: "json"
  }).done(function(data,textStatus, jqXHR) {
      console.log("done");
      process_modbus_info(data);
    }).fail(function(jqXHR, textStatus, errorThrown) {
      console.log( "Function worker says: " + textStatus );
    }).always(function() { 
      // Schedule the next request when the current one's complete
      // alert("complete"); 
      setTimeout(worker, 3000);
    });
  })();

function process_modbus_info(data) {

}