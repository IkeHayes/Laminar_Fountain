//Fountain Control Main Page Javascript

//LED Color Information
var rgb_led = {
	red:0,
	green:0,
	blue:0
}

//Pump control output percentage
var pump_output = 0;

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
        $("#red_val").text(rgb_led.red);
        setRGB();
  });

  $(document).on('change', 'input[type="range"][id="green_slider"]', function(e) {
        rgb_led.green = e.target.value;
        $("#green_val").text(rgb_led.green);
        setRGB();
  });

  $(document).on('change', 'input[type="range"][id="blue_slider"]', function(e) {
  		rgb_led.blue = e.target.value;
        $("#blue_val").text(rgb_led.blue);
        setRGB();
  });
});

//Process Color Change for RGB LED
function setRGB() {
	$("#color_box").css("background-color","rgb(" + rgb_led.red + "," + rgb_led.green + "," + rgb_led.blue + ")");
}