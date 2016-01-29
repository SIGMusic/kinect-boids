import sys
from simpleOSC import initOSCServer, startOSCServer, closeOSC, setOSCHandler

ip = "127.0.0.1"
port = 9433

def run():
	try:
		initOSCServer(ip, port)

		setOSCHandler('/collision', col)

		startOSCServer()
		print "server is running, listening at " + str(ip) + ":" + str(port)
	except KeyboardInterrupt:
		closeOSC()


def col(addr, tags, data, source):
	print "got collision"
	print data

if __name__ == "__main__":
	run()