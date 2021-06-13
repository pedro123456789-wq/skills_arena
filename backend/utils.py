import smtplib

class utils:
	@staticmethod
	def send_email(dest, subj, body):
		server = smtplib.SMTP("smtp.gmail.com", 587)
		server.ehlo()
		server.starttls()
		server.ehlo()
		server.login("pl156176@gmail.com", "messimagician10")
		msg = f"Subject: {subj}\n\n{body}"
		server.sendmail(
			"pl156176@gmail.com",
			dest,
		    msg)
		server.quit()



