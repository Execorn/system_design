import socket
import time
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

SERVER_HOST = 'server' 
SERVER_PORT = 5252
MESSAGE_SIZE = 1024  # Consistent message size for both send and recv
DATA = b'[[DATA REMOVED]]'

def create_socket():
    """Create a socket and connect to the server."""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM, socket.IPPROTO_TCP)
        sock.connect((SERVER_HOST, SERVER_PORT))
        return sock
    except socket.error as e:
        logging.error(f"Error connecting to server: {e}")
        return None


def send_and_receive(sock, data):
    """Send data to the server and receive the response."""
    try:
        sock.sendall(data)
        response = sock.recv(MESSAGE_SIZE)
        return response
    except socket.error as e:
        logging.error(f"Error sending/receiving data: {e}")
        return None

def main():
    """Main client logic."""
    sock = create_socket()
    if not sock:
        return

    try:
        while True:
            response = send_and_receive(sock, DATA)
            if response:
                logging.info(f"Received: {response.decode('utf-8').strip()}")
                time.sleep(2)  # Add a time sleep to not send requests as fast as possible
            else:
                logging.warning("Did not receive any response, retrying connection...")
                sock.close()
                sock = create_socket()
                if not sock:
                    logging.error("Connection failed to be re-established")
                    break
    except KeyboardInterrupt:
        logging.info("Client shutting down gracefully.")
    finally:
        if sock:
            sock.close()


if __name__ == "__main__":
    main()