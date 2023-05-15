#!/usr/bin/env python

from flask import Flask, request, jsonify
import os
import sys
import subprocess
import threading
import logging

logging.basicConfig(filename='/tmp/app.log', level=logging.DEBUG)

app = Flask(__name__)

FLASK_TOKEN = os.environ.get('FLASK_TOKEN')

@app.route('/hello', methods=['GET'])  # This is the new route
def hello_world():
    return "Hello, World!\n"

@app.route('/exec', methods=['POST'])
def route_exec():
    token = request.json.get("token")

    if not token or token != FLASK_TOKEN:
        return jsonify({"error": "Invalid or missing token"}), 403

    command = request.json.get("command")

    if not command:
        return jsonify({"error": "Command not provided"}), 400

    try:
        completedProcess = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=120, universal_newlines=True)
        return jsonify({"output": completedProcess.stdout}), 200
    except subprocess.TimeoutExpired:
        return jsonify({"error": "Command execution timed out"}), 400
    except Exception as e:
        return jsonify({"error": f"Command execution failed: {str(e)}"}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
