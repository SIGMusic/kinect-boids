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

        for i in range(0, 200, 25):
            print i
            self.send("*" * i)

    def closed(self, code, reason=None):
        print "Closed down", code, reason

    def received_message(self, m):
        print m
        if len(m) == 175:
            self.close(reason='Bye bye')

if __name__ == '__main__':
    try:
        try:
        initOSCServer(ip, port)

        setOSCHandler('/collision', col)

        startOSCServer()
        print "server is running, listening at " + str(ip) + ":" + str(port)

        ws = DummyClient('ws://localhost:9000/', protocols=['http-only', 'chat'])
        ws.connect()
        ws.run_forever()
    except KeyboardInterrupt:
        ws.close()
        closeOSC()

def col(addr, tags, data, source):
    print "got collision"
    print data

