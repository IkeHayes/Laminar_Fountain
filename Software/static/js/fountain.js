//===============================
// Fountain.html Javascript
//
// By Isaac Hayes 2015
// www.scuttlebots.com
//===============================

//===================
// Variable Initilization
//===================

//LED Color Information
var rgb_led = {
	red:0,
	green:0,
	blue:0
}

//Pump control output percentage
var pump_output = 0;

//===================
// Range Slider Handlers
//===================

//Initialize Range Sliders with correct CSS classes for their colors
$(function() {
  $('input[type=range][class="standard_slider"]').rangeslider({
    polyfill: false,
    fillClass: 'rangeslider__fill'
  });

  $('input[type=range][id="red_slider"]').rangeslider({
    polyfill: false,
    fillClass: 'rangeslider__fill__red',
    handleClass: 'rangeslider__handle__red'
  });

  $('input[type=range][id="green_slider"]').rangeslider({
    polyfill: false,
    fillClass: 'rangeslider__fill__green',
    handleClass: 'rangeslider__handle__green'
  });

  $('input[type=range][id="blue_slider"]').rangeslider({
    polyfill: false,
    fillClass: 'rangeslider__fill__blue',
    handleClass: 'rangeslider__handle__blue'
  });
});


//Set On Change functions for each slider
$(function() {
  $(document).on('change', 'input[type="range"][id="pump_slider"]', function(e) {
      pump_output = e.target.value;
      $("#pump_val").text(pump_output);
  });

  $(document).on('change', 'input[type="range"][id="red_slider"]', function(e) {
      rgb_led.red = e.target.value;
      send_RGB();
  });

  $(document).on('change', 'input[type="range"][id="green_slider"]', function(e) {
      rgb_led.green = e.target.value;
      send_RGB();
  });

  $(document).on('change', 'input[type="range"][id="blue_slider"]', function(e) {
  		rgb_led.blue = e.target.value;
      send_RGB();
  });
});

//===================
// AJAX to Flask Server
//===================

//Process Color Change for RGB LED
function send_RGB() {

  $.getJSON($SCRIPT_ROOT + '/_set_rgb', {
      red: rgb_led.red,
      green: rgb_led.green,
      blue: rgb_led.blue
      }, 
      function(data) {
        //rgb_led.red = data.red_value;
        //rgb_led.green = data.green_value;
        //rgb_led.blue = data.blue_value;
        update_RGB();
      });
}

function update_RGB() {
  $("#color_box").css("background-color","rgb(" + rgb_led.red + "," + rgb_led.green + "," + rgb_led.blue + ")");
  $("#red_val").text(rgb_led.red);
  $("#green_val").text(rgb_led.green);
  $("#blue_val").text(rgb_led.blue);
}