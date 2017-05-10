#!/usr/bin/env python
"""
    hello.iface.world
    =================

    GRPC hello service client.
"""
import os
import grpc

from grpc_types import world_pb2, world_pb2_grpc

from libutils import log_util

log = log_util.get_logger(__name__)

if os.environ.get("L5D_PORT_4141_TCP") is None:
    log.error("The env L5D_PORT_4141_TCP has not been set. Communicate with linkerd will fail ...")

LINKERD_INGRESS = os.environ.get("L5D_PORT_4141_TCP")

log.info("Connecting to world service via linkerd: %s", LINKERD_INGRESS)
channel = grpc.insecure_channel('172.17.0.2:4141')
#channel = grpc.insecure_channel(LINKERD_INGRESS)
stub = world_pb2_grpc.WorldStub(channel)


def sayWorld(name):
    response_future = stub.sayWorld.future(world_pb2.WorldRequest(message=name))
    feature = response_future.result()
    return feature
