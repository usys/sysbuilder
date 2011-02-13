BFD = src\bfd.cmd
BFD_OS_NAME = win98se
BFD_TYPE = 144
BFD_DST = ..\build
BFD_SRC	= src
BFD_PKG = $(BFD_SRC)\cabs
BFD_BIN = $(BFD_SRC)\bin
BFD_OS = $(BFD_SRC)\os
#BFD_NAME = modboot

all:	xrdos

.PHONY: build_arg build_img
build_arg: 
export BFD_ARG = -o $(BFD_OS_NAME) -t $(BFD_TYPE) -i $(BFD_DST)\$(BFD_IMG) $(BFD_NAME)
build_arg: build_img

build_img: 
export BFD_IMG = $(BFD_NAME).img

cdos:	BFD_NAME := cdos
cdos: build

reader:	BFD_NAME := reader
reader: build

xrdos:	BFD_NAME := xrdos
xrdos:  build

win98se: BFD_NAME := win98se
win98se: build

freedos: BFD_NAME := freedos
freedos: BFD_OS_NAME := fdos10
freedos: build

build: build_arg
	$(BFD) $(BFD_ARG)

