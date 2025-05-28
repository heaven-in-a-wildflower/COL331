#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

#define MAX_ATTEMPTS 3
char *argv[] = { "sh", 0 };

void login() {
  char username[20];
  char password[20];
  int attempts = 0;

  while(attempts < MAX_ATTEMPTS) {
    printf(1, "Enter Username: ");
    gets(username, sizeof(username));
    username[strlen(username) - 1] = '\0';  // Remove newline

    if(strcmp(username, USERNAME) == 0) {
      printf(1, "Enter Password: ");
      gets(password, sizeof(password));
      password[strlen(password) - 1] = '\0';  // Remove newline

      if(strcmp(password, PASSWORD) == 0) {
        printf(1, "Login successful\n");
        return;  // Authentication successful, start shell
      } else {
        printf(1, "Incorrect Password\n");
      }
    } else {
      printf(1, "Invalid Username\n");
    }
    attempts++;
  }
  printf(1, "Maximum login attempts reached. System locked.\n");
  exit();  // Shutdown if max attempts are reached
}

int main(void) {
  int pid, wpid;

  if(open("console", O_RDWR) < 0) {
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);
  dup(0);

  login();  // Call login before starting shell

  for(;;) {
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0) {
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0) {
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid = wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
}
