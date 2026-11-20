
main ?= "top.Top"
venv ?= ./scripts/.venv
port ?= "COM4"
sampleRate ?= "44100"
baud ?= "921600"


all:
	sbt "runMain $(main)"

activate_unix:
	source $(venv)/bin/activate

activate:  # run the echoed command
	echo $(venv)/Scripts/Activate.ps1

# following rules assumes venv has been activated

playback:
	python scripts/serial_send.py $(port) -b $(baud) -r $(sampleRate) --recv play

devices:
	python scripts/serial_send.py --list-devices

ports:
	python scripts/serial_send.py --list-ports

vars:
	echo "main=$(main) \
	venv=$(venv) \
	port=$(port) \
	sampleRate=$(sampleRate) \
	baud=$(baud)"
