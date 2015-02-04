# Fountain_Control/RGB_LED.py
import Adafruit_BBIO.PWM as PWM

# This class governs the control of an RGB LED
# and tracks all of its properties

class RGB_led (object):

	def __init__(self, red_pin, green_pin, blue_pin):
		#Set IO pin names linked to each color
		self._red_pin = red_pin
		self._green_pin = green_pin
		self._blue_pin = blue_pin
		#Initialize duty cycle variables
		self._red_duty = 0.0
		self._green_duty = 0.0
		self._blue_duty = 0.0
		#Initialize PWM Pins
		PWM.start(self._red_pin, self._red_duty)
		PWM.start(self._green_pin, self._green_duty)
		PWM.start(self._blue_pin, self._blue_duty)
		#Color values in standard 8 bit (0-255)
		self.red = 0
		self.green = 0
		self.blue = 0

	@property
	def red(self):
		return self._red

	@property
	def green(self):
		return self._green

	@property
	def blue(self):
		return self._blue

	@red.setter
	def red(self, val):
		if val < 0:
			self._red = 0
		elif val > 255:
			self._red = 255
		else:
			self._red = val
		self._red_duty = val/2.55
		PWM.set_duty_cycle(self._red_pin, self._red_duty)

	@green.setter
	def green(self, val):
		if val < 0:
			self._green = 0
		elif val > 255:
			self._green = 255
		else:
			self._green = val
		self._green_duty = val/2.55
		PWM.set_duty_cycle(self._green_pin, self._green_duty)

	@blue.setter
	def blue(self, val):
		if val < 0:
			self._blue = 0
		elif val > 255:
			self._blue = 255
		else:
			self._blue = val
		self._blue_duty = val/2.55
		PWM.set_duty_cycle(self._blue_pin, self._blue_duty)

	#Set the RGB value for all colors
	def set_RGB(self, red_val, green_val, blue_val):
		self.red = red_val
		self.green = green_val
		self.blue = blue_val

	#Clean Up PWM
	def clean_up(self):
		PWM.stop(self._red_pin)
		PWM.stop(self._green_pin)
		PWM.stop(self._blue_pin)
		PWM.cleanup()