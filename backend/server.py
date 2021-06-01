from machine_learning_processor import machine_learning_processor
from park_finder import ParkFinder

import flask
import gtts


app = flask.Flask(__name__)
app.config['DEBUG'] = False


@app.route('/', methods=['GET'])
def home_debug():
	return 'Server Running'


@app.route('/text-to-speech', methods=['POST'])
def text_to_speech():
	#check for required headers
	try:
		headers = flask.request.headers
		text = headers['text']
	except:
		return ('Missing Text Header', 404, [['Content-Type', 'text/html']])

	#generate sound file
	machine_learning_processor.text_to_speech(text)

	#send sound file
	response = flask.make_response(open('speech.mp3', 'rb').read())
	response.headers.set('Content-Type', 'sound/mp3')

	return response



@app.route('/speech-to-text', methods = ['POST'])
def speech_to_text():
	#check for required headers
	try:
		headers = flask.request.headers
		file = flask.request.files['audio']
	except:
		return ('Missing File Header', 404, [['Content-Type', 'text/html']])

	#save file and convert it to text
	file.save('input_text.mp3')
	conversion = machine_learning_processor.speech_to_text()

	return (conversion, 200, [['Content-Type', 'text/html']])



@app.route('/find_parks', methods = ['POST'])
def find_park():
	#check for required headers
	try:
		headers = flask.request.headers
		latitude, longitude = float(headers['latitude']), float(headers['longitude'])
	except Exception as e:
		return (str(e), 404, [['Content-Type', 'text/html']])


	#instantiate park_finder class and generate processed image
	finder = ParkFinder(latitude, longitude)
	finder.generate_image()
	finder.process_image()

	#send image as response
	response = flask.make_response(open('location maps/processed.png', 'rb').read())
	response.headers.set('Content-Type', 'image/png')

	return response


if __name__ == '__main__':
	print('Starting Server...')
	print('Server Running')
	app.run(host = '0.0.0.0', port = 8085, debug = True)
