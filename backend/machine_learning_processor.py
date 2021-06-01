import gtts
import speech_recognition as sr
import pydub


class machine_learning_processor:
	def __init__(self):
		pass 

	@staticmethod
	def text_to_speech(phrase):
		tts = gtts.gTTS(phrase, lang = 'en', tld = 'ca')
		tts.save('speech.mp3')


	@staticmethod
	def speech_to_text():
		sound = pydub.AudioSegment.from_mp3('input_text.mp3')
		sound.export('input_text.wav', format = 'wav')

		r = sr.Recognizer()

		with sr.AudioFile('input_text.wav') as source:
			audio_data = r.record(source)

			try:
				text = r.recognize_google(audio_data)
				print(text)
				return text
			except:
				return 'Invalid Audio'


	
	