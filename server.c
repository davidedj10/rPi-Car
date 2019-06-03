
#include <wiringPi.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>



int getData( int sockfd ) {
  char buffer[32];
  int n;

  if ( (n = read(sockfd,buffer,31) ) < 0 )
    printf( "Errore nessuna Risposta dal SOCKET!");
  buffer[n] = '\0';
  return atoi( buffer );
}

void rstRear(){

  digitalWrite(5, LOW);
  digitalWrite(6, LOW);

}

void rstFront(){

  digitalWrite(10, LOW);
  digitalWrite(11, LOW);

}

void ledConnectStatus(int status){

  if(status == 1){

    digitalWrite(8, LOW);
    digitalWrite(9, HIGH);

  }else{

    digitalWrite(8, HIGH);
    digitalWrite(9, LOW);

  }

}

int main(int argc, char *argv[]) {

      wiringPiSetup () ;

      //LED STATUS
      pinMode (8, OUTPUT) ;
      pinMode (9, OUTPUT) ;
      //REAR MOTORS
      pinMode (5, OUTPUT) ;
      pinMode (6, OUTPUT) ;
      //FRONT SERVO!!!
      pinMode (10, OUTPUT) ;
      pinMode (11, OUTPUT) ;

     int sockfd, newsockfd, portno = 51718, clilen;
     char buffer[256];
     struct sockaddr_in serv_addr, cli_addr;
     int n;
     int data;

     printf( "porta utilizzata: [#%d]\n", portno );
     ledConnectStatus(1);

     sockfd = socket(AF_INET, SOCK_STREAM, 0);
     if (sockfd < 0)
        printf("Errore durante l apertura della Porta!");
     bzero((char *) &serv_addr, sizeof(serv_addr));

     serv_addr.sin_family = AF_INET;
     serv_addr.sin_addr.s_addr = INADDR_ANY;
     serv_addr.sin_port = htons( portno );
     if (bind(sockfd, (struct sockaddr *) &serv_addr,
              sizeof(serv_addr)) < 0)
     printf( "Errore di binding" );
     listen(sockfd,5);
     clilen = sizeof(cli_addr);

     //--- infinite wait on a connection ---
     while ( 1 ) {
        printf( "Aspetto per un client...\n" );
        if ( ( newsockfd = accept( sockfd, (struct sockaddr *) &cli_addr, (socklen_t*) &clilen) ) < 0 )
           printf("Errore di handshake");
        printf( "Connessione Stabilita!\n" );
        ledConnectStatus(0);
        while ( 1 ) {

            char array[40];
            int number = data;

            memset(array, 0x00, sizeof(array));

            sprintf(array, "%d", number);



            if(array[0] == 49){

            printf("AVANTI\n");

            digitalWrite (5, LOW) ;
            digitalWrite (6, HIGH) ;

            }else if(array[1] == 49){

            printf("DIETRO\n");

            digitalWrite (5, HIGH) ;
            digitalWrite (6, LOW) ;

            }else{

              rstRear();

            }



            if(array[2] == 49){

            printf("Sterzo SINISTRO\n");
            digitalWrite (10, HIGH) ;
            digitalWrite (11, LOW) ;

            }else if(array[3] == 49){

            printf("Sterzo DESTRO\n");
            digitalWrite (10, LOW) ;
            digitalWrite (11, HIGH) ;

            }else{

              rstFront();

            }


            printf("%d %d %d %d", array[0], array[1], array[2], array[3]);

            printf( "got %d\n", data );

        }
        close( newsockfd );

        //--- if -2 sent by client, we can quit ---
        if ( data == -2 )
          break;
     }

     return 0;
}
