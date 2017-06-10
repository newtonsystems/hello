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
        """ Say Hello to user name.

            Args:
                request (int): Description of arg1
                context (str): Description of arg2

            Returns:
                hello_pb2.HelloReply: Description of return value
        """
        log.info("Saying Hello hot-reloaded for name: %s", request.name)
        #message = str(world.sayWorld(request.name))
        message = request.name + '  hot-reloaded'
        return hello_pb2.HelloReply(message=message)


def serve():
    """Summary line.

    Extended description of function.

    Args:
        arg1 (int): Description of arg1
        arg2 (str): Description of arg2

    Returns:
        bool: Description of return value

    Examples:
        Examples should be written in doctest format, and should illustrate how
        to use the function.

        >>> print([i for i in example_generator(4)])
        [0, 1, 2, 3]
    """
    log.info("Running on host: %s", os.getenv("HOSTNAME"))
    service = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    helloer = Helloer()

    hello_pb2_grpc.add_HelloServicer_to_server(helloer, service)
    service.add_insecure_port('[::]:50000')

    log.info("Starting a %s service: %s on port 50000", helloer.name, service)
    service.start()

    try:
        while True:
            time.sleep(_ONE_DAY_IN_SECONDS)
    except KeyboardInterrupt:
        service.stop(0)

if __name__ == '__main__':
    serve()
