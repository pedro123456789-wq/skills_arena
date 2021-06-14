from utils import utils

from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt 
import flask
import os
from random import randint



#clean and comment code
app = flask.Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///user_stats.db'
db = SQLAlchemy(app)
password_handler = Bcrypt()



class User(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	username = db.Column(db.String(20), unique = True, nullable = False)
	email = db.Column(db.String(120), unique = True, nullable = False)
	password = db.Column(db.String(60), unique = False, nullable = False)
	saved_workouts = db.Column(db.Text(), unique = False, default = '')
	workout_data = db.Column(db.Text, unique = False, default = '')
	distances_ran = db.Column(db.Text, unique = False, default = '')
	is_admin = db.Column(db.Integer, unique = False, default = 0)
	email_confirmation_token = db.Column(db.Integer, unique = False, nullable = False)
	is_email_confirmed = db.Column(db.Integer, unique = False, default = 0)
	skils = db.relationship('Skill', backref='creator', lazy = True)

	def __repr__(self):
		return f'User(Id: {self.username}, Email: {self.email}, Password: {self.password})'



class Skill(db.Model):
	id = db.Column(db.Integer, primary_key = True)
	name = db.Column(db.String(100), nullable = False, default = 'Anonymous Skill')
	video_file = db.Column(db.String(100), nullable = True, default = '') 
	user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable = False)



def is_admin(username):
	users = User.query.filter_by(username = username).all()

	if len(users) == 1:
		user = users[0]
		if user.is_admin == 1:
			return True
		else:
			return False
	else:
		return 'Invalid User'



def isAuthenticated(username, password):
	user = User.query.filter_by(username = username).all()

	if len(user) == 1:
		user_instance = user[0]
		if user_instance.is_email_confirmed == 1:
			user_password_hash = user_instance.password

			if password_handler.check_password_hash(user_password_hash, password):
				return True

	return False


@app.route('/query-data', methods=['POST'])
def see_data():
	try:
		headers = flask.request.headers
		column = headers['column']
		value = headers['value']
		username = headers['username']
		password = headers['password']
	except:
		return ('Missing required headers', 404, [['Content-Type', 'text/html']])

	if isAuthenticated(username, password):
		if is_admin(username):
			if column == 'id':
				users = User.query.filter_by(id = int(value)).all()
			elif column == 'username':
				users = User.query.filter_by(username = value).all()
			elif column == 'email':
				users = User.query.filter_by(username = value).all()

			return '\n'.join(list(map(str, users)))


	return ('Invalid API Call', 404, [['Content-Type', 'text/html']])


@app.route('/create-user', methods = ['POST'])
def create_user():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
		email = headers['email']
	except Exception as e:
		return (f'Missing required headers. \n Error: {e}', 404, [['Content-Type', 'text/html']])


	if len(User.query.filter_by(username=username).all()) == 0 and len(User.query.filter_by(email = email).all()) == 0:
		hashed_passord = password_handler.generate_password_hash(password)
		confirmation_token = randint(1000, 9999)
		new_user = User(username = username, password = hashed_passord, email = email, email_confirmation_token = confirmation_token)
		db.session.add(new_user)
		db.session.commit()

		utils.send_email(email, 'Skills Arena comfirmation code', f'Your confirmation code is: {confirmation_token}')

		return ('New User Created', 200, [['Content-Type', 'text/html']])

	else:
		if len(User.query.filter_by(username=username).all()) > 0:
			return ('The chosen username is taken', 404, [['Content-Type', 'text/html']])
		else:
			return ('The chosen email is taken', 404, [['Content-Type', 'text/html']])


@app.route('/view-database', methods = ['POST'])
def view_database():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
	except:
		return ('Missing required headers', 404, [['Content-Type', 'text/html']])

	if isAuthenticated(username, password):
		if is_admin(username):
			return ('\n'.join(list(map(str, User.query.all()))), 200, [['Content-Type', 'text/html']])

	return ('Invalid API call', 404, [['Content-Type', 'text/html']])


@app.route('/delete-user-admin', methods=['POST'])
def delete_user():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
		deletion_username = headers['deletion_username']
	except:
		return ('Missing Required Headers', 404, [['Content-Type', 'text/html']])

	if isAuthenticated(username, password):
		if is_admin(username):
			selected_user = User.query.filter_by(username = deletion_username).delete()
			db.session.commit()

			return ('User deleted', 200, [['Content-Type', 'text/html']])
	return ('Invalid API call', 404, [['Content-Type', 'text/html']])


@app.route('/verify-user', methods = ['POST'])
def verify():
	try:
		headers = flask.request.headers
		code = int(headers['code'])
		username = headers['username']
	except:
		return ('Missing required headers', 404, [['Content-Type', 'text/html']])

	user = User.query.filter_by(username  = username).all()[0]

	if user.email_confirmation_token == code:
		user.is_email_confirmed = 1
		db.session.commit()
		return ('Email has been verified', 200, [['Content-Type', 'text/html']])
	else:
		return ('Invalid confirmation code', 404, [['Content-Type', 'text/html']])


@app.route('/add-workout-data', methods=['POST'])
def add_data():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
		data = flask.request.get_data()
	except:
		return ('Missing Required Headers', 404, [['Content-Type', 'text/html']])


	if isAuthenticated(username, password):
		user = User.query.filter_by(username = username).all()[0]
		user.workout_data += data.decode('utf8')
		db.session.commit()
		return ('Data added to database', 200, [['Content-Type', 'text/html']])
	else:
		return ('Invalid username and passsword combination', 404, [['Content-Type', 'text/html']])


@app.route('/create-session', methods=['POST'])
def create_session():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
		data = flask.request.get_data()
	except Exception as e:
		return (f'Missing Required Headers Error: {str(e)}', 404, [['Content-Type', 'text/html']])


	if isAuthenticated(username, password):
		user = User.query.filter_by(username = username).all()[0]
		user.saved_workouts += data.decode('utf-8')
		db.session.commit()

		return ('Added data to database', 200, [['Content-Type', 'text/html']])
	else:
		return (f'Invalid credentials: {username}, {password}', 404, [['Content-Type', 'text/html']])


@app.route('/get-sessions', methods = ['POST'])
def get_user_sessions():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
	except:
		return ('Missing required headers', 404, [['Content-Type', 'html']])


	if isAuthenticated(username, password):
		user = User.query.filter_by(username = username).all()[0]
		created_sessions = user.saved_workouts

		return (created_sessions, 200, [['Content-Type', 'text/html']])
	else:
		return ('Invalid credentials', 404, [['Content-Type', 'text/html']])


@app.route('/get-session-number', methods = ['POST'])
def get_session_number():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
		session_type = headers['session_type']
	except:
		return ('Missing Reqiuired headers', 404, [['Content-Type', 'text/html']])


	if isAuthenticated(username, password):
		user = User.query.filter_by(username = username).all()[0]
		sessions = [session for session in user.saved_workouts.splitlines() if len(session) > 0 and session.split('-')[0] == session_type]

		return (str(len(sessions)), 200, [['Content-Type', 'text/html']])
	else:
		return ('Invalid credentials', 404, [['Content-Type', 'text/html']])


@app.route('/get-workout-data', methods = ['POST'])
def get_workout_data():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
	except:
		return ('Missing required headers', 404, [['Content-Type', 'html']])


	if isAuthenticated(username, password):
		user = User.query.filter_by(username = username).all()[0]
		data = user.workout_data

		return (data, 200, [['Content-Type', 'text/html']])
	else:
		return ('Invalid credentials', 404, [['Content-Type', 'text/html']])


@app.route('/authenticate-user', methods = ['POST'])
def authenticate():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
	except:
		return ('Missing required headers', 404, [['Content-Type', 'text/html']])

	if isAuthenticated(username, password):
		response = ('Authenticated', 200, [['Content-Type', 'text/html']])
	else:
		response = ('Invalid Credentials', 404, [['Content-Type', 'text/html']])

	return response


@app.route('/add-distance-ran', methods = ['POST'])
def add_distance():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
		body = flask.request.get_data()
	except:
		return ('Missing required headers', 404, [['Content-Type', 'text/html']])


	if isAuthenticated(username, password):
		user = User.query.filter_by(username = username).all()[0]
		user.distances_ran += body.decode()
		db.session.commit()

		return ('Data stored in database', 200, [['Content-Type', 'text/html']])
	else:
		return ('Invalid Credentials', 404, [['Content-Type', 'text/html']])


@app.route('/get-distances-ran', methods = ['POST'])
def get_distances():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
	except:
		return ('Missing Required Headers', 404, [['Content-Type', 'text/html']])

	if isAuthenticated(username, password):
		user = User.query.filter_by(username = username).all()[0]

		return (user.distances_ran, 200, [['Content-Type', 'text/html']])
	else:
		return ('Invalid Credentials', 404, [['Content-Type', 'text/html']])


@app.route('/skills-saved', methods = ['POST'])
def skills_saved():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
	except:
		return ('Invalid Credentials', 404, [['Content-Type', 'text/html']])


	user = User.query.filter_by(username = username).all()[0]
	skills = Skill.query.filter_by(user_id = user.id).all()

	return (str(len(skills)), 200, [['Content-Type', 'text/html']])


@app.route('/is-skill-name-valid', methods = ['POST'])
def is_skill_name_valid():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
		skill_name = headers['skill_name']
	except:
		return ('Missing required headers', 404, [['Content-Type', 'text/html']])


	if isAuthenticated(username, password):
		user = User.query.filter_by(username = username).all()[0]
		matching_name_skills = Skill.query.filter_by(user_id = user.id, name = skill_name).all()

		if len(matching_name_skills) > 0:
			return ('Inavalid Name', 404, [['Content-Type', 'text/html']])
		else:
			return ('Valid Name', 200, [['Content-Type', 'text/html']])
	else:
		return ('Invalid Credentials', 404, [['Content-Type', 'text/html']])


@app.route('/upload-video', methods = ['POST'])
def upload_video():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
		skill_name = headers['skill_name']
		video_file = flask.request.files['video']
	except Exception as e:
		print(e)
		return ('Missing Required Headers', 404, [['Content-Type', 'text/html']])

	print(video_file)
	if isAuthenticated(username, password):
		video_file.seek(0, 2)
		file_size = video_file.tell()
		video_file.seek(0, 0)

		print(file_size)
		
		if file_size < 4500000:
			output_path = f'skill_videos/{username}'

			if (not os.path.exists(output_path)):
				os.mkdir(output_path)

			video_file.save(f'{output_path}/{skill_name}.mp4')

			return ('File Saved', 200, [['Content-Type', 'text/html']])
		else:
			return ('The file uploaded is too large', 404, [['Content-Type', 'text/html']])
	else:
		return ('Invalid credentials', 404, [['Content-Type', 'text/html']])


@app.route('/add-skill', methods = ['POST'])
def add_skill():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
		name = headers['name']
	except:
		return ('Missing required headers', 404, [['Content-Type', 'text/html']])


	if isAuthenticated(username, password):
		user = User.query.filter_by(username = username).all()[0]
		user_id = user.id

		new_skill = Skill(name = name, video_file = f'skill_videos/{username}/{name}.mp4', user_id = user_id)
		db.session.add(new_skill)
		db.session.commit()		

		return ('Added Skill', 200, [['Content-Type', 'text/html']])
	else:
		return ('Invalid credentials', 404, [['Content-Type', 'text/html']])


@app.route('/get-skill-names', methods = ['POST'])
def get_skills():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
	except:
		return ('Missing required headers', 404, [['Content-Type', 'text/html']])


	if isAuthenticated(username, password):
		user = User.query.filter_by(username = username).all()[0]
		skills = Skill.query.filter_by(user_id = user.id).all()

		if len(skills) > 0: 
			return (','.join([skill.name for skill in skills]), 200, [['Content-Type', 'text/html']])
		else:
			return ('The user has not saved any skills', 404, [['Content-Type', 'text/html']])

	else:
		return ('Invalid credentials', 404, [['Content-Type', 'text/html']])


@app.route('/get-skill-video', methods = ['POST'])
def get_skill_video():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
		skill_name = headers['skill_name']
	except:
		return ('Missing required headers', 404, [['Content-Type', 'text/html']])


	if isAuthenticated(username, password):
		user = User.query.filter_by(username = username).all()[0]
		user_skill = Skill.query.filter_by(user_id = user.id, name = skill_name).all()[0]
		skill_video_path = user_skill.video_file

		response = flask.make_response(open(skill_video_path, 'rb').read())

		return response
	else:
		return ('Invalid Credentials', 404, [['Content-Type', 'text/html']])



@app.route('/delete-skill', methods = ['POST'])
def delete_skill():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
		skill_name = headers['skill_name']
	except:
		return ('Required Headers Missing', 404, [['Content-Type', 'text/html']])


	if isAuthenticated(username, password):
		user = User.query.filter_by(username = username).all()[0]
		selected_skill = Skill.query.filter_by(user_id = user.id, name = skill_name).all()

		if len(selected_skill) == 1:
			db.session.delete(selected_skill[0])
			db.session.commit()

			try:
				os.remove(f'skill_videos/{username}/{skill_name}.mp4')
			except:
				pass 

			return ('Removed Skill from database', 200, [['Content-Type', 'text/html']])
		else:
			return ('Skill is not in database', 404, [['Content-Type', 'text/html']])

	else:
		return ('Invalid Credentials', 404, [['Content-Type', 'text/html']])



@app.route('/delete-session', methods = ['POST'])
def delete_session():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
		session_type = headers['session_type']
		session_name = headers['session_name']
	except:
		return ('Missing required headers', 404, [['Content-Type', 'text/html']])

	if isAuthenticated(username, password):
		user = User.query.filter_by(username = username).all()[0]
		workout_data = user.saved_workouts

		data_list = workout_data.splitlines()

		for line in data_list:
			if line != '':
				components = line.split('-')
				current_session_name, current_session_type = components[1].split(':')[0], components[0]

				if (session_name.strip() == current_session_name.strip()) and (session_type.strip() == current_session_type.strip()):
					data_list.pop(data_list.index(line))
					user.saved_workouts = '\n'.join(data_list) + '\n'
					db.session.commit()

					return ('Deleted saved session', 200, [['Content-Type', 'text/html']])
		return ('Could not find session in database', 404, [['Content-Type', 'text/html']])
	else:
		return ('Invalid credentials', 404, [['Content-Type', 'text/html']])


@app.route('/self-delete-account', methods = ['POST'])
def self_delete_account():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
	except:
		return ('Missing required headers', 404, [['Content-Type', 'text/html']])

	if isAuthenticated(username, password):
		user = User.query.filter_by(username = username).all()[0]
		db.session.delete(user)
		db.session.commit()

		return ('Successfully deleted user account', 200, [['Content-Type', 'text/html']])
	else:
		return ('Invalid credentials', 404, [['Content-Type', 'text/html']])


@app.route('/change-password', methods = ['POST'])
def change_password():
	try:
		headers = flask.request.headers
		username = headers['username']
		password = headers['password']
		new_password = headers['new_password']
	except:
		return ('Missing required headers', 404, [['Content-Type', 'text/html']])

	if isAuthenticated(username, password):
		user = User.query.filter_by(username = username).all()[0]
		password_hash = user.password

		if not password_handler.check_password_hash(password_hash, new_password):
			user.password = password_handler.generate_password_hash(new_password)
			db.session.commit()

			return ('Successfully changed password', 200, [['Content-Type', 'text/html']])
		else:
			return ('The new password is the same as the old password', 404, [['Content-Type', 'text/html']])
	else:
		return ('Invalid Credentials', 404, [['Content-Type', 'text/html']])



if __name__ == '__main__':
	print('Starting Database Server...')
	print('Server Running')
	app.run(host = '0.0.0.0', port = 8090, debug = True)