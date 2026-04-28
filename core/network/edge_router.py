"""
Enki Sovereign Node — Edge Router
Node 29 | Sovereign Scale: 10^47
"""

import time
import socket
import logging

logging.basicConfig(level=logging.INFO, format="[edge_router] %(message)s")
log = logging.getLogger(__name__)

HOST = "127.0.0.1"
PORT = 9029


def run():
    log.info("Edge router initialised on %s:%d", HOST, PORT)
    log.info("Sovereign Node 29 active at scale 10^47")
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as srv:
        srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        srv.bind((HOST, PORT))
        srv.listen(8)
        log.info("Listening for connections …")
        srv.settimeout(1.0)
        while True:
            try:
                conn, addr = srv.accept()
                with conn:
                    conn.settimeout(5.0)
                    log.info("Connection from %s", addr)
                    conn.sendall(b"SOVEREIGN_NODE_29_OK\r\n")
            except socket.timeout:
                continue
            except Exception as exc:
                log.error("Router error: %s", exc)
                time.sleep(1)


if __name__ == "__main__":
    run()
