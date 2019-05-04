import smtplib,sys
from email.mime.text import MIMEText
from email.mime.nonmultipart import MIMENonMultipart
msg_from = "1532916189@qq.com"
passwd = "wnzyiihabwqyjhha"
msg_to = "2576978433@qq.com"
subject = sys.argv[1]
content = sys.argv[2]

msg = MIMEText(content,'plain','utf-8')
msg['Subject'] = subject
msg["From"] = msg_from
msg["To"] = msg_to
s = smtplib.SMTP_SSL("smtp.qq.com",465)
s.set_debuglevel(0)
s.login(msg_from,passwd)
s.sendmail(msg_from,msg_to,msg.as_string())
s.close()
