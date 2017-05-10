import grpc_types
from time import sleep
import sys

from libutils.log_formatters import ColoredFormatter, LevelFormatter

from flask import Flask
from waitress import serve
import logging

FORMAT = '%(asctime)-15s %(levelname)s:%(message)s'
logging.basicConfig(format=FORMAT, datefmt='%Y-%m-%dT%I:%M:%S', level=logging.INFO)
ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)
formatter = LevelFormatter()
ch.setFormatter(formatter)

log = logging.getLogger(__name__)
log.addHandler(ch)

app = Flask(__name__)


@app.route("/")
def hello():
    log.info("Hello World!")
    return "Hello World!"


if __name__ == "__main__":
    print("fdlsjk")
    log.error("Starting a server on 8001")
    serve(app, host="0.0.0.0", port="8001")

# if __name__ == "__main__":
#     print("It worked!")
#     import logging
#     logging.basicConfig()
#     logger = logging.getLogger()
#     sh = logging.StreamHandler(sys.stdout)
#     sh.setFormatter(LevelFormatter)
#     logger.debug('DEBUG message')
#     logger.info('INFO message')
#     logger.warn('WARN message')
#     logger.error('ERROR message')
#     logger.critical('CRITICAL message')
#     print "dskljhfkjhdskj"
    #sleep(2000)
