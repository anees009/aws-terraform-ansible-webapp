import http.server
import socketserver
import socket
from http import HTTPStatus

class Handler(http.server.SimpleHTTPRequestHandler):
    
    def do_GET(self):
        self.host = socket.gethostname()
        self.send_response(HTTPStatus.OK)
        self.end_headers()
        response = ("Hi there, I'm served from %s!\n" % self.host)
        # convert string to byte  
        res = bytes(response, 'utf-8') 
        self.wfile.write(res)

httpd = socketserver.TCPServer(('', 8000), Handler)
httpd.serve_forever()
