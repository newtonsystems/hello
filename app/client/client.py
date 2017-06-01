#!/usr/bin/env python
"""
    hello.client.client
    ===================

    GRPC hello service client.
"""
from __future__ import print_function
import time

import grpc

from libutils import log_util
from grpc_types import hello_pb2, hello_pb2_grpc

_ONE_DAY_IN_SECONDS = 60 * 60 * 24

log = log_util.get_logger(__name__)


def run():
    channel = grpc.insecure_channel('192.168.99.100:32244')
    stub = hello_pb2_grpc.HelloStub(channel)

    log.debug("Sending an asynchronous request to %s", stub)
    response_future = stub.sayHello.future(
        hello_pb2.HelloRequest(name='async'), 
        metadata=[("l5d-dtab", "/svc/hello.Hello => /$/inet/192.168.1.237/50000")]
    )

    log.debug("Sending a synchronous request to %s", stub)
    #response = stub.sayHello(hello_pb2.HelloRequest(name='you'))
    #log.info("Synchronous message received: " + response.message)

    feature = response_future.result()
    log.info("Asynchronous message received: " + feature.message)

    try:
        while True:
            time.sleep(_ONE_DAY_IN_SECONDS)
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    run()
