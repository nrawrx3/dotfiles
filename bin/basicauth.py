#!/usr/bin/env python3

import base64
import sys


def generate_basic_auth_header(username, password):
    credentials = f"{username}:{password}"
    encoded_credentials = base64.b64encode(
        credentials.encode("utf-8")).decode("utf-8")
    return f"Authorization: Basic {encoded_credentials}"


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <username> <password>")
        sys.exit(1)

    username = sys.argv[1]
    password = sys.argv[2]

    header = generate_basic_auth_header(username, password)
    print(header)
