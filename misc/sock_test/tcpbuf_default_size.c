#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>

int main ()
{
    int sock_buf_size;
    int len = sizeof(sock_buf_size);
    int sock = socket(AF_INET, SOCK_STREAM, 0);

    getsockopt(sock, SOL_SOCKET, SO_RCVBUF, &sock_buf_size, &len);
    printf("%s%d\n", "TCP receive buffer (default): ", sock_buf_size);

    close(sock);
    return 0;
}
