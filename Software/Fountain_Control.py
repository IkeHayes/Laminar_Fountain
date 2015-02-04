#!/usr/bin/python

import Adafruit_BBIO.GPIO as GPIO
import time, atexit

from flask import Flask, render_template, request, jsonify, url_for
app = Flask(__name__)

from RGB_LED import RGB_led


#Initialize classes
red_pin = "P9_14"
green_pin = "P9_22"
blue_pin = "P9_28"
fountain_led = RGB_led(red_pin, green_pin, blue_pin)

#Base page load request
@app.route("/")
def MainPage():
	templateData = {
		"pump_level": 0,
		"red_level": fountain_led.red,
		"green_level": fountain_led.green,
		"blue_level": fountain_led.blue
	}
	return render_template("Fountain.html", **templateData)

#AJAX Request for color setting update
@app.route("/_set_rgb")
def Update_RGB():
	red_req = request.args.get("red", 0, type=int)
	green_req = request.args.get("green", 0, type=int)
	blue_req = request.args.get("blue", 0, type=int)
	fountain_led.set_RGB(red_req, green_req, blue_req)
	print "RGB: " + str(fountain_led.red) + ", " + str(fountain_led.green) + ", " + str(fountain_led.blue)
	return jsonify(result={
		"red_value": fountain_led.red,
		"green_value": fountain_led.green,
		"blue_value": fountain_led.blue
		})

#Executed at program shutdown
@atexit.register
def cleanup_pwm():
	fountain_led.clean_up()

if __name__ == "__main__":
		app.run(host="0.0.0.0",port=80,debug=True)