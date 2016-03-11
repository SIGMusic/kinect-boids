from ws4py.client.threadedclient import WebSocketClient
import sys
from simpleOSC import initOSCServer, startOSCServer, closeOSC, setOSCHandler

ip = "127.0.0.1"
port = 9435

class DummyClient(WebSocketClient):
    def opened(self):
        def data_provider():
            for i in range(1, 200, 25):
                yield "#" * i

        self.send(data_provider())

        # for i in range(0, 10):
            # print i
        self.send("010101")

    def closed(self, code, reason=None):
        print "Closed down", code, reason

    def received_message(self, m):
        print m
        if len(m) == 175:
            self.close(reason='Bye bye')

def bkgrnd(addr, tags, data, source):
    print "got collision"
    print data[0]
    ws.send("010101");


if __name__ == '__main__':
    # try:
    try:
        initOSCServer(ip, port)

        setOSCHandler('/background', bkgrnd)

        startOSCServer()
        print "server is running, listening at " + str(ip) + ":" + str(port)

        ws = DummyClient('ws://localhost:9000/', protocols=['nlcp'])
        ws.connect()
        ws.run_forever()
        
    except KeyboardInterrupt:
        ws.close()
        closeOSC()



