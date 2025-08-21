#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <signal.h>
#include <sys/select.h>

#define DEVICE_PATH "/dev/motion"

static volatile int running = 1;

void signal_handler(int sig) {
    running = 0;
    printf("\nShutting down...\n");
}

int main(int argc, char *argv[]) {
    int fd, ret;
    char buffer[64];
    fd_set readfds;
    struct timeval timeout;
    
    signal(SIGINT, signal_handler);
    signal(SIGTERM, signal_handler);
    
    printf("Motion Detection Test Application\n");
    printf("Opening %s...\n", DEVICE_PATH);
    
    fd = open(DEVICE_PATH, O_RDONLY);
    if (fd < 0) {
        perror("Failed to open device");
        return EXIT_FAILURE;
    }
    
    printf("Device opened successfully. Waiting for motion...\n");
    printf("Press Ctrl+C to exit.\n\n");
    
    while (running) {
        FD_ZERO(&readfds);
        FD_SET(fd, &readfds);
        
        timeout.tv_sec = 1;
        timeout.tv_usec = 0;
        
        ret = select(fd + 1, &readfds, NULL, NULL, &timeout);
        
        if (ret < 0) {
            if (errno == EINTR) continue;
            perror("select failed");
            break;
        }
        
        if (ret == 0) {
            // Timeout - no motion detected
            continue;
        }
        
        if (FD_ISSET(fd, &readfds)) {
            ret = read(fd, buffer, sizeof(buffer) - 1);
            if (ret < 0) {
                perror("read failed");
                break;
            }
            
            buffer[ret] = '\0';
            printf("Motion detected: %s", buffer);
        }
    }
    
    close(fd);
    printf("Test application terminated.\n");
    return EXIT_SUCCESS;
}