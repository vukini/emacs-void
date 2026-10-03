# -*- mode: snippet -*-
# name: makefile
# key: makefile
# --
CC = gcc
CC_FLAGS = -Wall -Werror -Wextra
CFLAGS ?= $(CC_FLAGS)

SRCS = $(wildcard *.c)
TARGET = main

all:
	$(CC) $(CFLAGS) $(SRCS) -o $(TARGET)
