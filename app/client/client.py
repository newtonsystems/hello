#!/usr/bin/env python
"""
    hello.client.client
    ===================

    GRPC hello service client.
"""
from __future__ import print_function
import argparse
import subprocess
import time
from argparse import RawTextHelpFormatter

import grpc

from libutils import log_util
from grpc_types import hello_pb2, hello_pb2_grpc

from functools import partial

_ONE_DAY_IN_SECONDS = 60 * 60 * 24

log = log_util.get_logger(__name__)




COLORS = ('black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white')
STYLES = ()


def color(s, fg=None, bg=None, style=None):
    sgr = []

    if fg:
        if fg in COLORS:
            sgr.append(str(30 + COLORS.index(fg)))
        elif isinstance(fg, int) and 0 <= fg <= 255:
            sgr.append('38;5;%d' % int(fg))
        else:
            raise Exception('Invalid color "%s"' % fg)

    if bg:
        if bg in COLORS:
            sgr.append(str(40 + COLORS.index(bg)))
        elif isinstance(bg, int) and 0 <= bg <= 255:
            sgr.append('48;5;%d' % bg)
        else:
            raise Exception('Invalid color "%s"' % bg)

    if style:
        for st in style.split('+'):
            if st in STYLES:
                sgr.append(str(1 + STYLES.index(st)))
            else:
                raise Exception('Invalid style "%s"' % st)

    if sgr:
        prefix = '\x1b[' + ';'.join(sgr) + 'm'
        suffix = '\x1b[0m'
        return prefix + s + suffix
    else:
        return s

red = partial(color, fg='red')
green = partial(color, fg='green')
yellow = partial(color, fg='yellow')
blue = partial(color, fg='blue')


# ==============================================================================


parser = argparse.ArgumentParser(
    description="Build, tag and push docker image.\n\n"
    "Note: The script will only create a new 'release' docker-compose file "
    "unless specified with the correct options.",
    formatter_class=RawTextHelpFormatter
)

parser.add_argument(
    "--dev-workflow-2",
    dest="dev_workflow_2",
    action="store_true",
    default=False,
    help="If added we connect via linkerd dev-workflow-2 router. \
        To statically connect to a local running docker container."
)
# parser.add_argument(
#     "--dockerhub_release",
#     dest="push_to_dockerhub",
#     action="store_true",
#     default=False,
#     help="If added we push a release to docker hub"
# )

args = parser.parse_args()


def run():
    if args.dev_workflow_2:
        print (green("====>> Building and Tagging Release:"))
        process = subprocess.Popen(
            ["kubectl", "get", "svc", "linkerd", "-o", "jsonpath='{.spec.ports[?(@.name==\"incoming-dev-workflow-2\")].nodePort}'"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        PORT = str(process.communicate()[0]).strip("'")
        log.info("%s", PORT)

    connection = '192.168.99.100:%s' % PORT

    log.info("Going to connect: %s", connection)

    channel = grpc.insecure_channel(connection)
    stub = hello_pb2_grpc.HelloStub(channel)

    log.debug("Sending an asynchronous request to %s", stub)
    response_future = stub.sayHello.future(hello_pb2.HelloRequest(name='async'),)

    #response_future = stub.sayHello.future(
    #    hello_pb2.HelloRequest(name='async'), 
    #    metadata=[("l5d-dtab", "/svc/hello.Hello => /$/inet/192.168.1.237/50000")]
    #)

    #log.debug("Sending a synchronous request to %s", stub)
    #response = stub.sayHello(hello_pb2.HelloRequest(name='you'))
    #log.info("Synchronous message received: " + response.message)




    feature = response_future.result()
    log.info("Asynchronous message received: " + feature.message)

    #try:
    #    while True:
    #        time.sleep(_ONE_DAY_IN_SECONDS)
    #except KeyboardInterrupt:
    #    pass


if __name__ == '__main__':
    run()
