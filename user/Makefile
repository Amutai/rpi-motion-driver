CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -O2
TARGET = motion_test
SOURCES = motion_test.c

# Cross-compilation support
ifdef CROSS_COMPILE
    CC = $(CROSS_COMPILE)gcc
endif

all: $(TARGET)

$(TARGET): $(SOURCES)
	$(CC) $(CFLAGS) -o $(TARGET) $(SOURCES)

clean:
	rm -f $(TARGET)

install: $(TARGET)
	sudo cp $(TARGET) /usr/local/bin/

uninstall:
	sudo rm -f /usr/local/bin/$(TARGET)

.PHONY: all clean install uninstall