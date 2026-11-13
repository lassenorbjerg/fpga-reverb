
main ?= "top.Top"

all:
	sbt "runMain $(main)"
