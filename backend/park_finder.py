import folium
from PIL import Image
from html2image import Html2Image



class ParkFinder:
	def __init__(self, latitude, longitude):
		self.latitude = latitude
		self.longitude = longitude
		self.green_range = {
								'R' : [223, 197], 
								'G' : [252, 231], 
								'B' : [226, 148]
							}


	def generate_image(self):
		location_map = folium.Map(location = [self.latitude, self.longitude], zoom_start = 20)
		folium.Marker(location = [self.latitude, self.longitude], popup = 'Your location', icon = folium.Icon(color = 'black', icon = 'street-view', prefix = 'fa')).add_to(location_map)

		screen_shotter = Html2Image(output_path = 'location maps')
		screen_shotter.screenshot(html_file = 'location maps/map_file.html', save_as = 'map_image.png')	


	def is_in_range(self, input_colour):
		for i in range(0, len(input_colour)):
			if input_colour[i] > self.green_range[list(self.green_range.keys())[i]][0] or input_colour[i] < self.green_range[list(self.green_range.keys())[i]][1] or max(input_colour) != input_colour[1]:
				return False

		return True


	def process_image(self):
		image = Image.open('location maps/map_image.png')
		image_pixel_data = image.getdata().convert('RGB')

		converted_image = []

		for data_point in image_pixel_data:
		    if self.is_in_range(data_point):
		    	converted_image.append((255, 0, 0))
		    else:
		        converted_image.append(data_point)

		image.putdata(converted_image)
		image.save('location maps/processed.png', 'PNG')