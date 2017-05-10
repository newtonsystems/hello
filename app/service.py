#! /usr/bin/env python
"""
    hello.service
    =============

    The hello service of the GRPC
"""
import os
import time
from concurrent import futures

import grpc

from libutils import log_util
from grpc_types import hello_pb2, hello_pb2_grpc

from iface import world

_ONE_DAY_IN_SECONDS = 60 * 60 * 24

log = log_util.get_logger(__name__)


class Helloer(hello_pb2_grpc.HelloServicer):
    name = 'hello'

    def sayHello(self, request, context):
        """ Say Hello to user name. """
        log.info("Saying Hello for name: %s", request.name)
        message = str(world.sayWorld(request.name))
        # message = request.name
        return hello_pb2.HelloReply(message=message)


def serve():
    log.info("Running on Host: %s", os.getenv("HOSTNAME"))
    service = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    helloer = Helloer()

    hello_pb2_grpc.add_HelloServicer_to_server(helloer, service)
    service.add_insecure_port('[::]:50000')

    log.info("Starting a %s service: %s on 50000", helloer.name, service)
    service.start()

    try:
        while True:
            time.sleep(_ONE_DAY_IN_SECONDS)
    except KeyboardInterrupt:
        service.stop(0)

if __name__ == '__main__':
    serve()
