import socket
import threading
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

SERVER_HOST = ''  # Listen on all available interfaces
SERVER_PORT = 5252
MESSAGE_SIZE = 1024 # Consistent message size for both send and recv


def handle_client(conn, addr):
    """Handle communication with a single client."""
    logging.info(f"Client connected: {addr}")
    try:
        while True:
            client_data = conn.recv(MESSAGE_SIZE)
            if not client_data:
                logging.info(f"Client {addr} disconnected")
                break
            response = f"{client_data.decode('utf-8').strip()}Sent text.".encode('utf-8')
            conn.sendall(response)
    except Exception as e:
        logging.error(f"Error handling client {addr}: {e}")
    finally:
        conn.close()


def main():
    """Main server logic."""
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM, socket.IPPROTO_TCP)
    try:
        sock.bind((SERVER_HOST, SERVER_PORT))
        sock.listen()
        logging.info(f"Server listening on port {SERVER_PORT}")

        while True:
            conn, addr = sock.accept()
            threading.Thread(target=handle_client, args=(conn, addr)).start()
    except socket.error as e:
        logging.error(f"Server socket error: {e}")
    except KeyboardInterrupt:
         logging.info("Server shutting down gracefully.")
    finally:
      sock.close()

if __name__ == "__main__":
    main()