
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    return -1;
  return 0;
}

int main(void)
{
       0:	f3 0f 1e fb          	endbr32
       4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       8:	83 e4 f0             	and    $0xfffffff0,%esp
       b:	ff 71 fc             	push   -0x4(%ecx)
       e:	55                   	push   %ebp
       f:	89 e5                	mov    %esp,%ebp
      11:	53                   	push   %ebx
      12:	51                   	push   %ecx
      13:	83 ec 40             	sub    $0x40,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while ((fd = open("console", O_RDWR)) >= 0)
      16:	eb 11                	jmp    29 <main+0x29>
      18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
      1f:	00 
  {
    if (fd >= 3)
      20:	83 f8 02             	cmp    $0x2,%eax
      23:	0f 8f 1f 03 00 00    	jg     348 <main+0x348>
  while ((fd = open("console", O_RDWR)) >= 0)
      29:	83 ec 08             	sub    $0x8,%esp
      2c:	6a 02                	push   $0x2
      2e:	68 41 16 00 00       	push   $0x1641
      33:	e8 bb 10 00 00       	call   10f3 <open>
      38:	83 c4 10             	add    $0x10,%esp
      3b:	85 c0                	test   %eax,%eax
      3d:	79 e1                	jns    20 <main+0x20>
      3f:	eb 3a                	jmp    7b <main+0x7b>
      41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    //     runcmd(parsecmd(buf));
    //   }
    //   continue;
    // }

    if (buf[0] == 'h' && buf[1] == 'i' && buf[2] == 's' && buf[3] == 't' && buf[4] == 'o' && buf[5] == 'r' && buf[6] == 'y')
      48:	3c 68                	cmp    $0x68,%al
      4a:	0f 85 f8 00 00 00    	jne    148 <main+0x148>
      50:	80 3d 01 1d 00 00 69 	cmpb   $0x69,0x1d01
      57:	0f 84 9b 02 00 00    	je     2f8 <main+0x2f8>
      5d:	8d 76 00             	lea    0x0(%esi),%esi

int fork1(void)
{
  int pid;

  pid = fork();
      60:	e8 46 10 00 00       	call   10ab <fork>
  if (pid == -1)
      65:	83 f8 ff             	cmp    $0xffffffff,%eax
      68:	0f 84 21 03 00 00    	je     38f <main+0x38f>
    if (fork1() == 0)
      6e:	85 c0                	test   %eax,%eax
      70:	0f 84 e3 02 00 00    	je     359 <main+0x359>
    wait();
      76:	e8 40 10 00 00       	call   10bb <wait>
  while (getcmd(buf, sizeof(buf)) >= 0)
      7b:	83 ec 08             	sub    $0x8,%esp
      7e:	6a 64                	push   $0x64
      80:	68 00 1d 00 00       	push   $0x1d00
      85:	e8 96 03 00 00       	call   420 <getcmd>
      8a:	83 c4 10             	add    $0x10,%esp
      8d:	85 c0                	test   %eax,%eax
      8f:	0f 88 ae 02 00 00    	js     343 <main+0x343>
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
      95:	0f b6 05 00 1d 00 00 	movzbl 0x1d00,%eax
      9c:	3c 63                	cmp    $0x63,%al
      9e:	75 a8                	jne    48 <main+0x48>
      a0:	0f b6 05 01 1d 00 00 	movzbl 0x1d01,%eax
      a7:	3c 64                	cmp    $0x64,%al
      a9:	0f 84 f1 01 00 00    	je     2a0 <main+0x2a0>
    if (buf[0] == 'c' && buf[1] == 'h' && buf[2] == 'm' && buf[3] == 'o' && buf[4] == 'd' && buf[5] == ' ') {
      af:	3c 68                	cmp    $0x68,%al
      b1:	75 ad                	jne    60 <main+0x60>
      b3:	80 3d 02 1d 00 00 6d 	cmpb   $0x6d,0x1d02
      ba:	75 a4                	jne    60 <main+0x60>
      bc:	80 3d 03 1d 00 00 6f 	cmpb   $0x6f,0x1d03
      c3:	75 9b                	jne    60 <main+0x60>
      c5:	80 3d 04 1d 00 00 64 	cmpb   $0x64,0x1d04
      cc:	75 92                	jne    60 <main+0x60>
      ce:	80 3d 05 1d 00 00 20 	cmpb   $0x20,0x1d05
      d5:	75 89                	jne    60 <main+0x60>
      int i = 6, j = 0;
      d7:	b8 06 00 00 00       	mov    $0x6,%eax
      dc:	eb 10                	jmp    ee <main+0xee>
      while (buf[i] != ' ' && buf[i] != '\n' && buf[i] != 0 && j < 49) {
      de:	83 f8 37             	cmp    $0x37,%eax
      e1:	0f 84 0e 03 00 00    	je     3f5 <main+0x3f5>
        filename[j++] = buf[i++];
      e7:	83 c0 01             	add    $0x1,%eax
      ea:	88 54 05 bf          	mov    %dl,-0x41(%ebp,%eax,1)
      while (buf[i] != ' ' && buf[i] != '\n' && buf[i] != 0 && j < 49) {
      ee:	0f b6 90 00 1d 00 00 	movzbl 0x1d00(%eax),%edx
      f5:	8d 48 fa             	lea    -0x6(%eax),%ecx
      f8:	80 fa 20             	cmp    $0x20,%dl
      fb:	0f 84 de 02 00 00    	je     3df <main+0x3df>
     101:	80 fa 0a             	cmp    $0xa,%dl
     104:	0f 84 d5 02 00 00    	je     3df <main+0x3df>
     10a:	84 d2                	test   %dl,%dl
     10c:	75 d0                	jne    de <main+0xde>
      filename[j] = 0; 
     10e:	c6 44 0d c6 00       	movb   $0x0,-0x3a(%ebp,%ecx,1)
      int mode = atoi(buf + i);
     113:	83 ec 0c             	sub    $0xc,%esp
     116:	05 00 1d 00 00       	add    $0x1d00,%eax
     11b:	50                   	push   %eax
     11c:	e8 1f 0f 00 00       	call   1040 <atoi>
      if (mode < 0 || mode > 7) {
     121:	83 c4 10             	add    $0x10,%esp
     124:	83 f8 07             	cmp    $0x7,%eax
     127:	0f 86 6f 02 00 00    	jbe    39c <main+0x39c>
        printf(2, "Invalid mode\n");
     12d:	51                   	push   %ecx
     12e:	51                   	push   %ecx
     12f:	68 a1 16 00 00       	push   $0x16a1
     134:	6a 02                	push   $0x2
     136:	e8 f5 10 00 00       	call   1230 <printf>
     13b:	83 c4 10             	add    $0x10,%esp
     13e:	e9 38 ff ff ff       	jmp    7b <main+0x7b>
     143:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if (buf[0] == 'b' && buf[1] == 'l' && buf[2] == 'o' && buf[3] == 'c' && buf[4] == 'k')
     148:	3c 62                	cmp    $0x62,%al
     14a:	0f 85 98 00 00 00    	jne    1e8 <main+0x1e8>
     150:	80 3d 01 1d 00 00 6c 	cmpb   $0x6c,0x1d01
     157:	0f 85 03 ff ff ff    	jne    60 <main+0x60>
     15d:	80 3d 02 1d 00 00 6f 	cmpb   $0x6f,0x1d02
     164:	0f 85 f6 fe ff ff    	jne    60 <main+0x60>
     16a:	80 3d 03 1d 00 00 63 	cmpb   $0x63,0x1d03
     171:	0f 85 e9 fe ff ff    	jne    60 <main+0x60>
     177:	80 3d 04 1d 00 00 6b 	cmpb   $0x6b,0x1d04
     17e:	0f 85 dc fe ff ff    	jne    60 <main+0x60>
      int i = 5;
     184:	b8 05 00 00 00       	mov    $0x5,%eax
     189:	eb 03                	jmp    18e <main+0x18e>
        i++;
     18b:	83 c0 01             	add    $0x1,%eax
      while (buf[i] == ' ')
     18e:	80 b8 00 1d 00 00 20 	cmpb   $0x20,0x1d00(%eax)
     195:	74 f4                	je     18b <main+0x18b>
      int syscall_num = 0;
     197:	31 db                	xor    %ebx,%ebx
     199:	eb 0a                	jmp    1a5 <main+0x1a5>
        syscall_num = syscall_num * 10 + (buf[i] - '0');
     19b:	6b db 0a             	imul   $0xa,%ebx,%ebx
        i++;
     19e:	83 c0 01             	add    $0x1,%eax
        syscall_num = syscall_num * 10 + (buf[i] - '0');
     1a1:	8d 5c 13 d0          	lea    -0x30(%ebx,%edx,1),%ebx
      while (buf[i] >= '0' && buf[i] <= '9')
     1a5:	0f be 90 00 1d 00 00 	movsbl 0x1d00(%eax),%edx
     1ac:	8d 4a d0             	lea    -0x30(%edx),%ecx
     1af:	80 f9 09             	cmp    $0x9,%cl
     1b2:	76 e7                	jbe    19b <main+0x19b>
      if (block(syscall_num) < 0 || syscall_num == 0)
     1b4:	83 ec 0c             	sub    $0xc,%esp
     1b7:	53                   	push   %ebx
     1b8:	e8 9e 0f 00 00       	call   115b <block>
     1bd:	83 c4 10             	add    $0x10,%esp
     1c0:	85 db                	test   %ebx,%ebx
     1c2:	74 08                	je     1cc <main+0x1cc>
     1c4:	85 c0                	test   %eax,%eax
     1c6:	0f 89 fd 01 00 00    	jns    3c9 <main+0x3c9>
        printf(2, "Failed to block syscall %d\n", syscall_num);
     1cc:	50                   	push   %eax
     1cd:	53                   	push   %ebx
     1ce:	68 57 16 00 00       	push   $0x1657
     1d3:	6a 02                	push   $0x2
     1d5:	e8 56 10 00 00       	call   1230 <printf>
     1da:	83 c4 10             	add    $0x10,%esp
     1dd:	e9 99 fe ff ff       	jmp    7b <main+0x7b>
     1e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (buf[0] == 'u' && buf[1] == 'n' && buf[2] == 'b' && buf[3] == 'l' && buf[4] == 'o' && buf[5] == 'c' && buf[6] == 'k')
     1e8:	3c 75                	cmp    $0x75,%al
     1ea:	0f 85 70 fe ff ff    	jne    60 <main+0x60>
     1f0:	80 3d 01 1d 00 00 6e 	cmpb   $0x6e,0x1d01
     1f7:	0f 85 63 fe ff ff    	jne    60 <main+0x60>
     1fd:	80 3d 02 1d 00 00 62 	cmpb   $0x62,0x1d02
     204:	0f 85 56 fe ff ff    	jne    60 <main+0x60>
     20a:	80 3d 03 1d 00 00 6c 	cmpb   $0x6c,0x1d03
     211:	0f 85 49 fe ff ff    	jne    60 <main+0x60>
     217:	80 3d 04 1d 00 00 6f 	cmpb   $0x6f,0x1d04
     21e:	0f 85 3c fe ff ff    	jne    60 <main+0x60>
     224:	80 3d 05 1d 00 00 63 	cmpb   $0x63,0x1d05
     22b:	0f 85 2f fe ff ff    	jne    60 <main+0x60>
     231:	80 3d 06 1d 00 00 6b 	cmpb   $0x6b,0x1d06
     238:	0f 85 22 fe ff ff    	jne    60 <main+0x60>
      int i = 7;
     23e:	b8 07 00 00 00       	mov    $0x7,%eax
     243:	eb 03                	jmp    248 <main+0x248>
        i++;
     245:	83 c0 01             	add    $0x1,%eax
      while (buf[i] == ' ')
     248:	80 b8 00 1d 00 00 20 	cmpb   $0x20,0x1d00(%eax)
     24f:	74 f4                	je     245 <main+0x245>
      int syscall_num = 0;
     251:	31 db                	xor    %ebx,%ebx
     253:	eb 0a                	jmp    25f <main+0x25f>
        syscall_num = syscall_num * 10 + (buf[i] - '0');
     255:	6b db 0a             	imul   $0xa,%ebx,%ebx
        i++;
     258:	83 c0 01             	add    $0x1,%eax
        syscall_num = syscall_num * 10 + (buf[i] - '0');
     25b:	8d 5c 13 d0          	lea    -0x30(%ebx,%edx,1),%ebx
      while (buf[i] >= '0' && buf[i] <= '9')
     25f:	0f be 90 00 1d 00 00 	movsbl 0x1d00(%eax),%edx
     266:	8d 4a d0             	lea    -0x30(%edx),%ecx
     269:	80 f9 09             	cmp    $0x9,%cl
     26c:	76 e7                	jbe    255 <main+0x255>
      if (unblock(syscall_num) < 0 || syscall_num == 0)
     26e:	83 ec 0c             	sub    $0xc,%esp
     271:	53                   	push   %ebx
     272:	e8 ec 0e 00 00       	call   1163 <unblock>
     277:	83 c4 10             	add    $0x10,%esp
     27a:	85 db                	test   %ebx,%ebx
     27c:	74 08                	je     286 <main+0x286>
     27e:	85 c0                	test   %eax,%eax
     280:	0f 89 78 01 00 00    	jns    3fe <main+0x3fe>
        printf(2, "Failed to unblock system call %d\n", syscall_num);
     286:	50                   	push   %eax
     287:	53                   	push   %ebx
     288:	68 f4 16 00 00       	push   $0x16f4
     28d:	6a 02                	push   $0x2
     28f:	e8 9c 0f 00 00       	call   1230 <printf>
     294:	83 c4 10             	add    $0x10,%esp
     297:	e9 df fd ff ff       	jmp    7b <main+0x7b>
     29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
     2a0:	80 3d 02 1d 00 00 20 	cmpb   $0x20,0x1d02
     2a7:	0f 85 b3 fd ff ff    	jne    60 <main+0x60>
      buf[strlen(buf) - 1] = 0; // Chop \n
     2ad:	83 ec 0c             	sub    $0xc,%esp
     2b0:	68 00 1d 00 00       	push   $0x1d00
     2b5:	e8 16 0c 00 00       	call   ed0 <strlen>
      if (chdir(buf + 3) < 0)
     2ba:	c7 04 24 03 1d 00 00 	movl   $0x1d03,(%esp)
      buf[strlen(buf) - 1] = 0; // Chop \n
     2c1:	c6 80 ff 1c 00 00 00 	movb   $0x0,0x1cff(%eax)
      if (chdir(buf + 3) < 0)
     2c8:	e8 56 0e 00 00       	call   1123 <chdir>
     2cd:	83 c4 10             	add    $0x10,%esp
     2d0:	85 c0                	test   %eax,%eax
     2d2:	0f 89 a3 fd ff ff    	jns    7b <main+0x7b>
        printf(2, "cannot cd %s\n", buf + 3);
     2d8:	50                   	push   %eax
     2d9:	68 03 1d 00 00       	push   $0x1d03
     2de:	68 49 16 00 00       	push   $0x1649
     2e3:	6a 02                	push   $0x2
     2e5:	e8 46 0f 00 00       	call   1230 <printf>
     2ea:	83 c4 10             	add    $0x10,%esp
     2ed:	e9 89 fd ff ff       	jmp    7b <main+0x7b>
     2f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (buf[0] == 'h' && buf[1] == 'i' && buf[2] == 's' && buf[3] == 't' && buf[4] == 'o' && buf[5] == 'r' && buf[6] == 'y')
     2f8:	80 3d 02 1d 00 00 73 	cmpb   $0x73,0x1d02
     2ff:	0f 85 5b fd ff ff    	jne    60 <main+0x60>
     305:	80 3d 03 1d 00 00 74 	cmpb   $0x74,0x1d03
     30c:	0f 85 4e fd ff ff    	jne    60 <main+0x60>
     312:	80 3d 04 1d 00 00 6f 	cmpb   $0x6f,0x1d04
     319:	0f 85 41 fd ff ff    	jne    60 <main+0x60>
     31f:	80 3d 05 1d 00 00 72 	cmpb   $0x72,0x1d05
     326:	0f 85 34 fd ff ff    	jne    60 <main+0x60>
     32c:	80 3d 06 1d 00 00 79 	cmpb   $0x79,0x1d06
     333:	0f 85 27 fd ff ff    	jne    60 <main+0x60>
      gethistory();
     339:	e8 15 0e 00 00       	call   1153 <gethistory>
      continue;
     33e:	e9 38 fd ff ff       	jmp    7b <main+0x7b>
  exit();
     343:	e8 6b 0d 00 00       	call   10b3 <exit>
      close(fd);
     348:	83 ec 0c             	sub    $0xc,%esp
     34b:	50                   	push   %eax
     34c:	e8 8a 0d 00 00       	call   10db <close>
      break;
     351:	83 c4 10             	add    $0x10,%esp
     354:	e9 22 fd ff ff       	jmp    7b <main+0x7b>
      if (buf[0] == 's' && buf[1] == 'h')
     359:	80 3d 00 1d 00 00 73 	cmpb   $0x73,0x1d00
     360:	74 15                	je     377 <main+0x377>
      runcmd(parsecmd(buf));
     362:	83 ec 0c             	sub    $0xc,%esp
     365:	68 00 1d 00 00       	push   $0x1d00
     36a:	e8 71 0a 00 00       	call   de0 <parsecmd>
     36f:	89 04 24             	mov    %eax,(%esp)
     372:	e8 19 01 00 00       	call   490 <runcmd>
      if (buf[0] == 's' && buf[1] == 'h')
     377:	80 3d 01 1d 00 00 68 	cmpb   $0x68,0x1d01
     37e:	75 e2                	jne    362 <main+0x362>
        realsh(2); // Child is real sh
     380:	83 ec 0c             	sub    $0xc,%esp
     383:	6a 02                	push   $0x2
     385:	e8 e9 0d 00 00       	call   1173 <realsh>
     38a:	83 c4 10             	add    $0x10,%esp
     38d:	eb d3                	jmp    362 <main+0x362>
    panic("fork");
     38f:	83 ec 0c             	sub    $0xc,%esp
     392:	68 ca 15 00 00       	push   $0x15ca
     397:	e8 d4 00 00 00       	call   470 <panic>
      } else if (chmod(filename, mode) < 0) {
     39c:	52                   	push   %edx
     39d:	52                   	push   %edx
     39e:	50                   	push   %eax
     39f:	8d 45 c6             	lea    -0x3a(%ebp),%eax
     3a2:	50                   	push   %eax
     3a3:	e8 c3 0d 00 00       	call   116b <chmod>
     3a8:	83 c4 10             	add    $0x10,%esp
     3ab:	85 c0                	test   %eax,%eax
     3ad:	0f 89 c8 fc ff ff    	jns    7b <main+0x7b>
        printf(2, "chmod failed\n");
     3b3:	50                   	push   %eax
     3b4:	50                   	push   %eax
     3b5:	68 af 16 00 00       	push   $0x16af
     3ba:	6a 02                	push   $0x2
     3bc:	e8 6f 0e 00 00       	call   1230 <printf>
     3c1:	83 c4 10             	add    $0x10,%esp
      continue;
     3c4:	e9 b2 fc ff ff       	jmp    7b <main+0x7b>
        printf(1, "Blocked syscall %d\n", syscall_num);
     3c9:	50                   	push   %eax
     3ca:	53                   	push   %ebx
     3cb:	68 73 16 00 00       	push   $0x1673
     3d0:	6a 01                	push   $0x1
     3d2:	e8 59 0e 00 00       	call   1230 <printf>
     3d7:	83 c4 10             	add    $0x10,%esp
     3da:	e9 9c fc ff ff       	jmp    7b <main+0x7b>
      filename[j] = 0; 
     3df:	c6 44 0d c6 00       	movb   $0x0,-0x3a(%ebp,%ecx,1)
      if (buf[i] == ' ') i++;
     3e4:	80 fa 20             	cmp    $0x20,%dl
     3e7:	0f 85 26 fd ff ff    	jne    113 <main+0x113>
     3ed:	83 c0 01             	add    $0x1,%eax
     3f0:	e9 1e fd ff ff       	jmp    113 <main+0x113>
      filename[j] = 0; 
     3f5:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
      if (buf[i] == ' ') i++;
     3f9:	e9 15 fd ff ff       	jmp    113 <main+0x113>
        printf(1, "Unblocked system call %d\n", syscall_num);
     3fe:	50                   	push   %eax
     3ff:	53                   	push   %ebx
     400:	68 87 16 00 00       	push   $0x1687
     405:	6a 01                	push   $0x1
     407:	e8 24 0e 00 00       	call   1230 <printf>
     40c:	83 c4 10             	add    $0x10,%esp
     40f:	e9 67 fc ff ff       	jmp    7b <main+0x7b>
     414:	66 90                	xchg   %ax,%ax
     416:	66 90                	xchg   %ax,%ax
     418:	66 90                	xchg   %ax,%ax
     41a:	66 90                	xchg   %ax,%ax
     41c:	66 90                	xchg   %ax,%ax
     41e:	66 90                	xchg   %ax,%ax

00000420 <getcmd>:
{
     420:	f3 0f 1e fb          	endbr32
     424:	55                   	push   %ebp
     425:	89 e5                	mov    %esp,%ebp
     427:	56                   	push   %esi
     428:	53                   	push   %ebx
     429:	8b 75 0c             	mov    0xc(%ebp),%esi
     42c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "$ ");
     42f:	83 ec 08             	sub    $0x8,%esp
     432:	68 98 15 00 00       	push   $0x1598
     437:	6a 02                	push   $0x2
     439:	e8 f2 0d 00 00       	call   1230 <printf>
  memset(buf, 0, nbuf);
     43e:	83 c4 0c             	add    $0xc,%esp
     441:	56                   	push   %esi
     442:	6a 00                	push   $0x0
     444:	53                   	push   %ebx
     445:	e8 c6 0a 00 00       	call   f10 <memset>
  gets(buf, nbuf);
     44a:	58                   	pop    %eax
     44b:	5a                   	pop    %edx
     44c:	56                   	push   %esi
     44d:	53                   	push   %ebx
     44e:	e8 1d 0b 00 00       	call   f70 <gets>
  if (buf[0] == 0) // EOF
     453:	83 c4 10             	add    $0x10,%esp
     456:	31 c0                	xor    %eax,%eax
     458:	80 3b 00             	cmpb   $0x0,(%ebx)
     45b:	0f 94 c0             	sete   %al
}
     45e:	8d 65 f8             	lea    -0x8(%ebp),%esp
     461:	5b                   	pop    %ebx
  if (buf[0] == 0) // EOF
     462:	f7 d8                	neg    %eax
}
     464:	5e                   	pop    %esi
     465:	5d                   	pop    %ebp
     466:	c3                   	ret
     467:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     46e:	00 
     46f:	90                   	nop

00000470 <panic>:
{
     470:	f3 0f 1e fb          	endbr32
     474:	55                   	push   %ebp
     475:	89 e5                	mov    %esp,%ebp
     477:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     47a:	ff 75 08             	push   0x8(%ebp)
     47d:	68 3d 16 00 00       	push   $0x163d
     482:	6a 02                	push   $0x2
     484:	e8 a7 0d 00 00       	call   1230 <printf>
  exit();
     489:	e8 25 0c 00 00       	call   10b3 <exit>
     48e:	66 90                	xchg   %ax,%ax

00000490 <runcmd>:
{
     490:	f3 0f 1e fb          	endbr32
     494:	55                   	push   %ebp
     495:	89 e5                	mov    %esp,%ebp
     497:	53                   	push   %ebx
     498:	83 ec 14             	sub    $0x14,%esp
     49b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (cmd == 0)
     49e:	85 db                	test   %ebx,%ebx
     4a0:	74 7e                	je     520 <runcmd+0x90>
  switch (cmd->type)
     4a2:	83 3b 05             	cmpl   $0x5,(%ebx)
     4a5:	0f 87 15 01 00 00    	ja     5c0 <runcmd+0x130>
     4ab:	8b 03                	mov    (%ebx),%eax
     4ad:	3e ff 24 85 c4 16 00 	notrack jmp *0x16c4(,%eax,4)
     4b4:	00 
    if (pipe(p) < 0)
     4b5:	83 ec 0c             	sub    $0xc,%esp
     4b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
     4bb:	50                   	push   %eax
     4bc:	e8 02 0c 00 00       	call   10c3 <pipe>
     4c1:	83 c4 10             	add    $0x10,%esp
     4c4:	85 c0                	test   %eax,%eax
     4c6:	0f 88 16 01 00 00    	js     5e2 <runcmd+0x152>
  pid = fork();
     4cc:	e8 da 0b 00 00       	call   10ab <fork>
  if (pid == -1)
     4d1:	83 f8 ff             	cmp    $0xffffffff,%eax
     4d4:	0f 84 71 01 00 00    	je     64b <runcmd+0x1bb>
    if (fork1() == 0)
     4da:	85 c0                	test   %eax,%eax
     4dc:	0f 84 0d 01 00 00    	je     5ef <runcmd+0x15f>
  pid = fork();
     4e2:	e8 c4 0b 00 00       	call   10ab <fork>
  if (pid == -1)
     4e7:	83 f8 ff             	cmp    $0xffffffff,%eax
     4ea:	0f 84 5b 01 00 00    	je     64b <runcmd+0x1bb>
    if (fork1() == 0)
     4f0:	85 c0                	test   %eax,%eax
     4f2:	0f 84 25 01 00 00    	je     61d <runcmd+0x18d>
    close(p[0]);
     4f8:	83 ec 0c             	sub    $0xc,%esp
     4fb:	ff 75 f0             	push   -0x10(%ebp)
     4fe:	e8 d8 0b 00 00       	call   10db <close>
    close(p[1]);
     503:	58                   	pop    %eax
     504:	ff 75 f4             	push   -0xc(%ebp)
     507:	e8 cf 0b 00 00       	call   10db <close>
    wait();
     50c:	e8 aa 0b 00 00       	call   10bb <wait>
    wait();
     511:	e8 a5 0b 00 00       	call   10bb <wait>
    break;
     516:	83 c4 10             	add    $0x10,%esp
     519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
     520:	e8 8e 0b 00 00       	call   10b3 <exit>
  pid = fork();
     525:	e8 81 0b 00 00       	call   10ab <fork>
  if (pid == -1)
     52a:	83 f8 ff             	cmp    $0xffffffff,%eax
     52d:	0f 84 18 01 00 00    	je     64b <runcmd+0x1bb>
    if (fork1() == 0)
     533:	85 c0                	test   %eax,%eax
     535:	75 e9                	jne    520 <runcmd+0x90>
     537:	eb 7c                	jmp    5b5 <runcmd+0x125>
    printf(1, "hello1\n");
     539:	50                   	push   %eax
     53a:	50                   	push   %eax
     53b:	68 a2 15 00 00       	push   $0x15a2
     540:	6a 01                	push   $0x1
     542:	e8 e9 0c 00 00       	call   1230 <printf>
    if (ecmd->argv[0] == 0)
     547:	8b 43 04             	mov    0x4(%ebx),%eax
     54a:	83 c4 10             	add    $0x10,%esp
     54d:	85 c0                	test   %eax,%eax
     54f:	74 cf                	je     520 <runcmd+0x90>
    exec(ecmd->argv[0], ecmd->argv);
     551:	8d 53 04             	lea    0x4(%ebx),%edx
     554:	51                   	push   %ecx
     555:	51                   	push   %ecx
     556:	52                   	push   %edx
     557:	50                   	push   %eax
     558:	e8 8e 0b 00 00       	call   10eb <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     55d:	83 c4 0c             	add    $0xc,%esp
     560:	ff 73 04             	push   0x4(%ebx)
     563:	68 aa 15 00 00       	push   $0x15aa
     568:	6a 02                	push   $0x2
     56a:	e8 c1 0c 00 00       	call   1230 <printf>
    break;
     56f:	83 c4 10             	add    $0x10,%esp
     572:	eb ac                	jmp    520 <runcmd+0x90>
  pid = fork();
     574:	e8 32 0b 00 00       	call   10ab <fork>
  if (pid == -1)
     579:	83 f8 ff             	cmp    $0xffffffff,%eax
     57c:	0f 84 c9 00 00 00    	je     64b <runcmd+0x1bb>
    if (fork1() == 0)
     582:	85 c0                	test   %eax,%eax
     584:	74 2f                	je     5b5 <runcmd+0x125>
    wait();
     586:	e8 30 0b 00 00       	call   10bb <wait>
    runcmd(lcmd->right);
     58b:	83 ec 0c             	sub    $0xc,%esp
     58e:	ff 73 08             	push   0x8(%ebx)
     591:	e8 fa fe ff ff       	call   490 <runcmd>
    close(rcmd->fd);
     596:	83 ec 0c             	sub    $0xc,%esp
     599:	ff 73 14             	push   0x14(%ebx)
     59c:	e8 3a 0b 00 00       	call   10db <close>
    if (open(rcmd->file, rcmd->mode) < 0)
     5a1:	58                   	pop    %eax
     5a2:	5a                   	pop    %edx
     5a3:	ff 73 10             	push   0x10(%ebx)
     5a6:	ff 73 08             	push   0x8(%ebx)
     5a9:	e8 45 0b 00 00       	call   10f3 <open>
     5ae:	83 c4 10             	add    $0x10,%esp
     5b1:	85 c0                	test   %eax,%eax
     5b3:	78 18                	js     5cd <runcmd+0x13d>
      runcmd(bcmd->cmd);
     5b5:	83 ec 0c             	sub    $0xc,%esp
     5b8:	ff 73 04             	push   0x4(%ebx)
     5bb:	e8 d0 fe ff ff       	call   490 <runcmd>
    panic("runcmd");
     5c0:	83 ec 0c             	sub    $0xc,%esp
     5c3:	68 9b 15 00 00       	push   $0x159b
     5c8:	e8 a3 fe ff ff       	call   470 <panic>
      printf(2, "open %s failed\n", rcmd->file);
     5cd:	51                   	push   %ecx
     5ce:	ff 73 08             	push   0x8(%ebx)
     5d1:	68 ba 15 00 00       	push   $0x15ba
     5d6:	6a 02                	push   $0x2
     5d8:	e8 53 0c 00 00       	call   1230 <printf>
      exit();
     5dd:	e8 d1 0a 00 00       	call   10b3 <exit>
      panic("pipe");
     5e2:	83 ec 0c             	sub    $0xc,%esp
     5e5:	68 cf 15 00 00       	push   $0x15cf
     5ea:	e8 81 fe ff ff       	call   470 <panic>
      close(1);
     5ef:	83 ec 0c             	sub    $0xc,%esp
     5f2:	6a 01                	push   $0x1
     5f4:	e8 e2 0a 00 00       	call   10db <close>
      dup(p[1]);
     5f9:	58                   	pop    %eax
     5fa:	ff 75 f4             	push   -0xc(%ebp)
     5fd:	e8 29 0b 00 00       	call   112b <dup>
      close(p[0]);
     602:	58                   	pop    %eax
     603:	ff 75 f0             	push   -0x10(%ebp)
     606:	e8 d0 0a 00 00       	call   10db <close>
      close(p[1]);
     60b:	58                   	pop    %eax
     60c:	ff 75 f4             	push   -0xc(%ebp)
     60f:	e8 c7 0a 00 00       	call   10db <close>
      runcmd(pcmd->left);
     614:	5a                   	pop    %edx
     615:	ff 73 04             	push   0x4(%ebx)
     618:	e8 73 fe ff ff       	call   490 <runcmd>
      close(0);
     61d:	83 ec 0c             	sub    $0xc,%esp
     620:	6a 00                	push   $0x0
     622:	e8 b4 0a 00 00       	call   10db <close>
      dup(p[0]);
     627:	5a                   	pop    %edx
     628:	ff 75 f0             	push   -0x10(%ebp)
     62b:	e8 fb 0a 00 00       	call   112b <dup>
      close(p[0]);
     630:	59                   	pop    %ecx
     631:	ff 75 f0             	push   -0x10(%ebp)
     634:	e8 a2 0a 00 00       	call   10db <close>
      close(p[1]);
     639:	58                   	pop    %eax
     63a:	ff 75 f4             	push   -0xc(%ebp)
     63d:	e8 99 0a 00 00       	call   10db <close>
      runcmd(pcmd->right);
     642:	58                   	pop    %eax
     643:	ff 73 08             	push   0x8(%ebx)
     646:	e8 45 fe ff ff       	call   490 <runcmd>
    panic("fork");
     64b:	83 ec 0c             	sub    $0xc,%esp
     64e:	68 ca 15 00 00       	push   $0x15ca
     653:	e8 18 fe ff ff       	call   470 <panic>
     658:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     65f:	00 

00000660 <fork1>:
{
     660:	f3 0f 1e fb          	endbr32
     664:	55                   	push   %ebp
     665:	89 e5                	mov    %esp,%ebp
     667:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     66a:	e8 3c 0a 00 00       	call   10ab <fork>
  if (pid == -1)
     66f:	83 f8 ff             	cmp    $0xffffffff,%eax
     672:	74 02                	je     676 <fork1+0x16>
  return pid;
}
     674:	c9                   	leave
     675:	c3                   	ret
    panic("fork");
     676:	83 ec 0c             	sub    $0xc,%esp
     679:	68 ca 15 00 00       	push   $0x15ca
     67e:	e8 ed fd ff ff       	call   470 <panic>
     683:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     68a:	00 
     68b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00000690 <execcmd>:
// PAGEBREAK!
//  Constructors

struct cmd *
execcmd(void)
{
     690:	f3 0f 1e fb          	endbr32
     694:	55                   	push   %ebp
     695:	89 e5                	mov    %esp,%ebp
     697:	53                   	push   %ebx
     698:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     69b:	6a 54                	push   $0x54
     69d:	e8 ee 0d 00 00       	call   1490 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     6a2:	83 c4 0c             	add    $0xc,%esp
     6a5:	6a 54                	push   $0x54
  cmd = malloc(sizeof(*cmd));
     6a7:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     6a9:	6a 00                	push   $0x0
     6ab:	50                   	push   %eax
     6ac:	e8 5f 08 00 00       	call   f10 <memset>
  cmd->type = EXEC;
     6b1:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd *)cmd;
}
     6b7:	89 d8                	mov    %ebx,%eax
     6b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     6bc:	c9                   	leave
     6bd:	c3                   	ret
     6be:	66 90                	xchg   %ax,%ax

000006c0 <redircmd>:

struct cmd *
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     6c0:	f3 0f 1e fb          	endbr32
     6c4:	55                   	push   %ebp
     6c5:	89 e5                	mov    %esp,%ebp
     6c7:	53                   	push   %ebx
     6c8:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     6cb:	6a 18                	push   $0x18
     6cd:	e8 be 0d 00 00       	call   1490 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     6d2:	83 c4 0c             	add    $0xc,%esp
     6d5:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     6d7:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     6d9:	6a 00                	push   $0x0
     6db:	50                   	push   %eax
     6dc:	e8 2f 08 00 00       	call   f10 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
     6e1:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = REDIR;
     6e4:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     6ea:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     6ed:	8b 45 0c             	mov    0xc(%ebp),%eax
     6f0:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     6f3:	8b 45 10             	mov    0x10(%ebp),%eax
     6f6:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     6f9:	8b 45 14             	mov    0x14(%ebp),%eax
     6fc:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     6ff:	8b 45 18             	mov    0x18(%ebp),%eax
     702:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd *)cmd;
}
     705:	89 d8                	mov    %ebx,%eax
     707:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     70a:	c9                   	leave
     70b:	c3                   	ret
     70c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000710 <pipecmd>:

struct cmd *
pipecmd(struct cmd *left, struct cmd *right)
{
     710:	f3 0f 1e fb          	endbr32
     714:	55                   	push   %ebp
     715:	89 e5                	mov    %esp,%ebp
     717:	53                   	push   %ebx
     718:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     71b:	6a 0c                	push   $0xc
     71d:	e8 6e 0d 00 00       	call   1490 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     722:	83 c4 0c             	add    $0xc,%esp
     725:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     727:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     729:	6a 00                	push   $0x0
     72b:	50                   	push   %eax
     72c:	e8 df 07 00 00       	call   f10 <memset>
  cmd->type = PIPE;
  cmd->left = left;
     731:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = PIPE;
     734:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     73a:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     73d:	8b 45 0c             	mov    0xc(%ebp),%eax
     740:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd *)cmd;
}
     743:	89 d8                	mov    %ebx,%eax
     745:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     748:	c9                   	leave
     749:	c3                   	ret
     74a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000750 <listcmd>:

struct cmd *
listcmd(struct cmd *left, struct cmd *right)
{
     750:	f3 0f 1e fb          	endbr32
     754:	55                   	push   %ebp
     755:	89 e5                	mov    %esp,%ebp
     757:	53                   	push   %ebx
     758:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     75b:	6a 0c                	push   $0xc
     75d:	e8 2e 0d 00 00       	call   1490 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     762:	83 c4 0c             	add    $0xc,%esp
     765:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     767:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     769:	6a 00                	push   $0x0
     76b:	50                   	push   %eax
     76c:	e8 9f 07 00 00       	call   f10 <memset>
  cmd->type = LIST;
  cmd->left = left;
     771:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = LIST;
     774:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     77a:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     77d:	8b 45 0c             	mov    0xc(%ebp),%eax
     780:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd *)cmd;
}
     783:	89 d8                	mov    %ebx,%eax
     785:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     788:	c9                   	leave
     789:	c3                   	ret
     78a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000790 <backcmd>:

struct cmd *
backcmd(struct cmd *subcmd)
{
     790:	f3 0f 1e fb          	endbr32
     794:	55                   	push   %ebp
     795:	89 e5                	mov    %esp,%ebp
     797:	53                   	push   %ebx
     798:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     79b:	6a 08                	push   $0x8
     79d:	e8 ee 0c 00 00       	call   1490 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     7a2:	83 c4 0c             	add    $0xc,%esp
     7a5:	6a 08                	push   $0x8
  cmd = malloc(sizeof(*cmd));
     7a7:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     7a9:	6a 00                	push   $0x0
     7ab:	50                   	push   %eax
     7ac:	e8 5f 07 00 00       	call   f10 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
     7b1:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = BACK;
     7b4:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     7ba:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd *)cmd;
}
     7bd:	89 d8                	mov    %ebx,%eax
     7bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     7c2:	c9                   	leave
     7c3:	c3                   	ret
     7c4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     7cb:	00 
     7cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007d0 <gettoken>:

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int gettoken(char **ps, char *es, char **q, char **eq)
{
     7d0:	f3 0f 1e fb          	endbr32
     7d4:	55                   	push   %ebp
     7d5:	89 e5                	mov    %esp,%ebp
     7d7:	57                   	push   %edi
     7d8:	56                   	push   %esi
     7d9:	53                   	push   %ebx
     7da:	83 ec 0c             	sub    $0xc,%esp
  char *s;
  int ret;

  s = *ps;
     7dd:	8b 45 08             	mov    0x8(%ebp),%eax
{
     7e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     7e3:	8b 75 10             	mov    0x10(%ebp),%esi
  s = *ps;
     7e6:	8b 38                	mov    (%eax),%edi
  while (s < es && strchr(whitespace, *s))
     7e8:	39 df                	cmp    %ebx,%edi
     7ea:	72 0b                	jb     7f7 <gettoken+0x27>
     7ec:	eb 21                	jmp    80f <gettoken+0x3f>
     7ee:	66 90                	xchg   %ax,%ax
    s++;
     7f0:	83 c7 01             	add    $0x1,%edi
  while (s < es && strchr(whitespace, *s))
     7f3:	39 fb                	cmp    %edi,%ebx
     7f5:	74 18                	je     80f <gettoken+0x3f>
     7f7:	0f be 07             	movsbl (%edi),%eax
     7fa:	83 ec 08             	sub    $0x8,%esp
     7fd:	50                   	push   %eax
     7fe:	68 f4 1c 00 00       	push   $0x1cf4
     803:	e8 28 07 00 00       	call   f30 <strchr>
     808:	83 c4 10             	add    $0x10,%esp
     80b:	85 c0                	test   %eax,%eax
     80d:	75 e1                	jne    7f0 <gettoken+0x20>
  if (q)
     80f:	85 f6                	test   %esi,%esi
     811:	74 02                	je     815 <gettoken+0x45>
    *q = s;
     813:	89 3e                	mov    %edi,(%esi)
  ret = *s;
     815:	0f b6 07             	movzbl (%edi),%eax
  switch (*s)
     818:	3c 3c                	cmp    $0x3c,%al
     81a:	0f 8f d0 00 00 00    	jg     8f0 <gettoken+0x120>
     820:	3c 3a                	cmp    $0x3a,%al
     822:	0f 8f b4 00 00 00    	jg     8dc <gettoken+0x10c>
     828:	84 c0                	test   %al,%al
     82a:	75 44                	jne    870 <gettoken+0xa0>
     82c:	31 f6                	xor    %esi,%esi
    ret = 'a';
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if (eq)
     82e:	8b 55 14             	mov    0x14(%ebp),%edx
     831:	85 d2                	test   %edx,%edx
     833:	74 05                	je     83a <gettoken+0x6a>
    *eq = s;
     835:	8b 45 14             	mov    0x14(%ebp),%eax
     838:	89 38                	mov    %edi,(%eax)

  while (s < es && strchr(whitespace, *s))
     83a:	39 df                	cmp    %ebx,%edi
     83c:	72 09                	jb     847 <gettoken+0x77>
     83e:	eb 1f                	jmp    85f <gettoken+0x8f>
    s++;
     840:	83 c7 01             	add    $0x1,%edi
  while (s < es && strchr(whitespace, *s))
     843:	39 fb                	cmp    %edi,%ebx
     845:	74 18                	je     85f <gettoken+0x8f>
     847:	0f be 07             	movsbl (%edi),%eax
     84a:	83 ec 08             	sub    $0x8,%esp
     84d:	50                   	push   %eax
     84e:	68 f4 1c 00 00       	push   $0x1cf4
     853:	e8 d8 06 00 00       	call   f30 <strchr>
     858:	83 c4 10             	add    $0x10,%esp
     85b:	85 c0                	test   %eax,%eax
     85d:	75 e1                	jne    840 <gettoken+0x70>
  *ps = s;
     85f:	8b 45 08             	mov    0x8(%ebp),%eax
     862:	89 38                	mov    %edi,(%eax)
  return ret;
}
     864:	8d 65 f4             	lea    -0xc(%ebp),%esp
     867:	89 f0                	mov    %esi,%eax
     869:	5b                   	pop    %ebx
     86a:	5e                   	pop    %esi
     86b:	5f                   	pop    %edi
     86c:	5d                   	pop    %ebp
     86d:	c3                   	ret
     86e:	66 90                	xchg   %ax,%ax
  switch (*s)
     870:	79 5e                	jns    8d0 <gettoken+0x100>
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     872:	39 fb                	cmp    %edi,%ebx
     874:	77 34                	ja     8aa <gettoken+0xda>
  if (eq)
     876:	8b 45 14             	mov    0x14(%ebp),%eax
     879:	be 61 00 00 00       	mov    $0x61,%esi
     87e:	85 c0                	test   %eax,%eax
     880:	75 b3                	jne    835 <gettoken+0x65>
     882:	eb db                	jmp    85f <gettoken+0x8f>
     884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     888:	0f be 07             	movsbl (%edi),%eax
     88b:	83 ec 08             	sub    $0x8,%esp
     88e:	50                   	push   %eax
     88f:	68 ec 1c 00 00       	push   $0x1cec
     894:	e8 97 06 00 00       	call   f30 <strchr>
     899:	83 c4 10             	add    $0x10,%esp
     89c:	85 c0                	test   %eax,%eax
     89e:	75 22                	jne    8c2 <gettoken+0xf2>
      s++;
     8a0:	83 c7 01             	add    $0x1,%edi
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     8a3:	39 fb                	cmp    %edi,%ebx
     8a5:	74 cf                	je     876 <gettoken+0xa6>
     8a7:	0f b6 07             	movzbl (%edi),%eax
     8aa:	83 ec 08             	sub    $0x8,%esp
     8ad:	0f be f0             	movsbl %al,%esi
     8b0:	56                   	push   %esi
     8b1:	68 f4 1c 00 00       	push   $0x1cf4
     8b6:	e8 75 06 00 00       	call   f30 <strchr>
     8bb:	83 c4 10             	add    $0x10,%esp
     8be:	85 c0                	test   %eax,%eax
     8c0:	74 c6                	je     888 <gettoken+0xb8>
    ret = 'a';
     8c2:	be 61 00 00 00       	mov    $0x61,%esi
     8c7:	e9 62 ff ff ff       	jmp    82e <gettoken+0x5e>
     8cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  switch (*s)
     8d0:	3c 26                	cmp    $0x26,%al
     8d2:	74 08                	je     8dc <gettoken+0x10c>
     8d4:	8d 48 d8             	lea    -0x28(%eax),%ecx
     8d7:	80 f9 01             	cmp    $0x1,%cl
     8da:	77 96                	ja     872 <gettoken+0xa2>
  ret = *s;
     8dc:	0f be f0             	movsbl %al,%esi
    s++;
     8df:	83 c7 01             	add    $0x1,%edi
    break;
     8e2:	e9 47 ff ff ff       	jmp    82e <gettoken+0x5e>
     8e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     8ee:	00 
     8ef:	90                   	nop
  switch (*s)
     8f0:	3c 3e                	cmp    $0x3e,%al
     8f2:	75 1c                	jne    910 <gettoken+0x140>
    if (*s == '>')
     8f4:	80 7f 01 3e          	cmpb   $0x3e,0x1(%edi)
    s++;
     8f8:	8d 47 01             	lea    0x1(%edi),%eax
    if (*s == '>')
     8fb:	74 1c                	je     919 <gettoken+0x149>
    s++;
     8fd:	89 c7                	mov    %eax,%edi
     8ff:	be 3e 00 00 00       	mov    $0x3e,%esi
     904:	e9 25 ff ff ff       	jmp    82e <gettoken+0x5e>
     909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch (*s)
     910:	3c 7c                	cmp    $0x7c,%al
     912:	74 c8                	je     8dc <gettoken+0x10c>
     914:	e9 59 ff ff ff       	jmp    872 <gettoken+0xa2>
      s++;
     919:	83 c7 02             	add    $0x2,%edi
      ret = '+';
     91c:	be 2b 00 00 00       	mov    $0x2b,%esi
     921:	e9 08 ff ff ff       	jmp    82e <gettoken+0x5e>
     926:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     92d:	00 
     92e:	66 90                	xchg   %ax,%ax

00000930 <peek>:

int peek(char **ps, char *es, char *toks)
{
     930:	f3 0f 1e fb          	endbr32
     934:	55                   	push   %ebp
     935:	89 e5                	mov    %esp,%ebp
     937:	57                   	push   %edi
     938:	56                   	push   %esi
     939:	53                   	push   %ebx
     93a:	83 ec 0c             	sub    $0xc,%esp
     93d:	8b 7d 08             	mov    0x8(%ebp),%edi
     940:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     943:	8b 1f                	mov    (%edi),%ebx
  while (s < es && strchr(whitespace, *s))
     945:	39 f3                	cmp    %esi,%ebx
     947:	72 0e                	jb     957 <peek+0x27>
     949:	eb 24                	jmp    96f <peek+0x3f>
     94b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    s++;
     950:	83 c3 01             	add    $0x1,%ebx
  while (s < es && strchr(whitespace, *s))
     953:	39 de                	cmp    %ebx,%esi
     955:	74 18                	je     96f <peek+0x3f>
     957:	0f be 03             	movsbl (%ebx),%eax
     95a:	83 ec 08             	sub    $0x8,%esp
     95d:	50                   	push   %eax
     95e:	68 f4 1c 00 00       	push   $0x1cf4
     963:	e8 c8 05 00 00       	call   f30 <strchr>
     968:	83 c4 10             	add    $0x10,%esp
     96b:	85 c0                	test   %eax,%eax
     96d:	75 e1                	jne    950 <peek+0x20>
  *ps = s;
     96f:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     971:	0f be 03             	movsbl (%ebx),%eax
     974:	31 d2                	xor    %edx,%edx
     976:	84 c0                	test   %al,%al
     978:	75 0e                	jne    988 <peek+0x58>
}
     97a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     97d:	89 d0                	mov    %edx,%eax
     97f:	5b                   	pop    %ebx
     980:	5e                   	pop    %esi
     981:	5f                   	pop    %edi
     982:	5d                   	pop    %ebp
     983:	c3                   	ret
     984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return *s && strchr(toks, *s);
     988:	83 ec 08             	sub    $0x8,%esp
     98b:	50                   	push   %eax
     98c:	ff 75 10             	push   0x10(%ebp)
     98f:	e8 9c 05 00 00       	call   f30 <strchr>
     994:	83 c4 10             	add    $0x10,%esp
     997:	31 d2                	xor    %edx,%edx
     999:	85 c0                	test   %eax,%eax
     99b:	0f 95 c2             	setne  %dl
}
     99e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9a1:	5b                   	pop    %ebx
     9a2:	89 d0                	mov    %edx,%eax
     9a4:	5e                   	pop    %esi
     9a5:	5f                   	pop    %edi
     9a6:	5d                   	pop    %ebp
     9a7:	c3                   	ret
     9a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     9af:	00 

000009b0 <parseredirs>:
  return cmd;
}

struct cmd *
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     9b0:	f3 0f 1e fb          	endbr32
     9b4:	55                   	push   %ebp
     9b5:	89 e5                	mov    %esp,%ebp
     9b7:	57                   	push   %edi
     9b8:	56                   	push   %esi
     9b9:	53                   	push   %ebx
     9ba:	83 ec 1c             	sub    $0x1c,%esp
     9bd:	8b 75 0c             	mov    0xc(%ebp),%esi
     9c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int tok;
  char *q, *eq;

  while (peek(ps, es, "<>"))
     9c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     9c8:	83 ec 04             	sub    $0x4,%esp
     9cb:	68 f1 15 00 00       	push   $0x15f1
     9d0:	53                   	push   %ebx
     9d1:	56                   	push   %esi
     9d2:	e8 59 ff ff ff       	call   930 <peek>
     9d7:	83 c4 10             	add    $0x10,%esp
     9da:	85 c0                	test   %eax,%eax
     9dc:	74 6a                	je     a48 <parseredirs+0x98>
  {
    tok = gettoken(ps, es, 0, 0);
     9de:	6a 00                	push   $0x0
     9e0:	6a 00                	push   $0x0
     9e2:	53                   	push   %ebx
     9e3:	56                   	push   %esi
     9e4:	e8 e7 fd ff ff       	call   7d0 <gettoken>
     9e9:	89 c7                	mov    %eax,%edi
    if (gettoken(ps, es, &q, &eq) != 'a')
     9eb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     9ee:	50                   	push   %eax
     9ef:	8d 45 e0             	lea    -0x20(%ebp),%eax
     9f2:	50                   	push   %eax
     9f3:	53                   	push   %ebx
     9f4:	56                   	push   %esi
     9f5:	e8 d6 fd ff ff       	call   7d0 <gettoken>
     9fa:	83 c4 20             	add    $0x20,%esp
     9fd:	83 f8 61             	cmp    $0x61,%eax
     a00:	75 51                	jne    a53 <parseredirs+0xa3>
      panic("missing file for redirection");
    switch (tok)
     a02:	83 ff 3c             	cmp    $0x3c,%edi
     a05:	74 31                	je     a38 <parseredirs+0x88>
     a07:	83 ff 3e             	cmp    $0x3e,%edi
     a0a:	74 05                	je     a11 <parseredirs+0x61>
     a0c:	83 ff 2b             	cmp    $0x2b,%edi
     a0f:	75 b7                	jne    9c8 <parseredirs+0x18>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
      break;
    case '+': // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
     a11:	83 ec 0c             	sub    $0xc,%esp
     a14:	6a 01                	push   $0x1
     a16:	68 01 02 00 00       	push   $0x201
     a1b:	ff 75 e4             	push   -0x1c(%ebp)
     a1e:	ff 75 e0             	push   -0x20(%ebp)
     a21:	ff 75 08             	push   0x8(%ebp)
     a24:	e8 97 fc ff ff       	call   6c0 <redircmd>
      break;
     a29:	83 c4 20             	add    $0x20,%esp
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
     a2c:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     a2f:	eb 97                	jmp    9c8 <parseredirs+0x18>
     a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     a38:	83 ec 0c             	sub    $0xc,%esp
     a3b:	6a 00                	push   $0x0
     a3d:	6a 00                	push   $0x0
     a3f:	eb da                	jmp    a1b <parseredirs+0x6b>
     a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
  }
  return cmd;
}
     a48:	8b 45 08             	mov    0x8(%ebp),%eax
     a4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a4e:	5b                   	pop    %ebx
     a4f:	5e                   	pop    %esi
     a50:	5f                   	pop    %edi
     a51:	5d                   	pop    %ebp
     a52:	c3                   	ret
      panic("missing file for redirection");
     a53:	83 ec 0c             	sub    $0xc,%esp
     a56:	68 d4 15 00 00       	push   $0x15d4
     a5b:	e8 10 fa ff ff       	call   470 <panic>

00000a60 <parseexec>:
  return cmd;
}

struct cmd *
parseexec(char **ps, char *es)
{
     a60:	f3 0f 1e fb          	endbr32
     a64:	55                   	push   %ebp
     a65:	89 e5                	mov    %esp,%ebp
     a67:	57                   	push   %edi
     a68:	56                   	push   %esi
     a69:	53                   	push   %ebx
     a6a:	83 ec 30             	sub    $0x30,%esp
     a6d:	8b 75 08             	mov    0x8(%ebp),%esi
     a70:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if (peek(ps, es, "("))
     a73:	68 f4 15 00 00       	push   $0x15f4
     a78:	57                   	push   %edi
     a79:	56                   	push   %esi
     a7a:	e8 b1 fe ff ff       	call   930 <peek>
     a7f:	83 c4 10             	add    $0x10,%esp
     a82:	85 c0                	test   %eax,%eax
     a84:	0f 85 96 00 00 00    	jne    b20 <parseexec+0xc0>
     a8a:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
     a8c:	e8 ff fb ff ff       	call   690 <execcmd>
  cmd = (struct execcmd *)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     a91:	83 ec 04             	sub    $0x4,%esp
     a94:	57                   	push   %edi
     a95:	56                   	push   %esi
     a96:	50                   	push   %eax
  ret = execcmd();
     a97:	89 45 d0             	mov    %eax,-0x30(%ebp)
  ret = parseredirs(ret, ps, es);
     a9a:	e8 11 ff ff ff       	call   9b0 <parseredirs>
  while (!peek(ps, es, "|)&;"))
     a9f:	83 c4 10             	add    $0x10,%esp
  ret = parseredirs(ret, ps, es);
     aa2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while (!peek(ps, es, "|)&;"))
     aa5:	eb 1c                	jmp    ac3 <parseexec+0x63>
     aa7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     aae:	00 
     aaf:	90                   	nop
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if (argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     ab0:	83 ec 04             	sub    $0x4,%esp
     ab3:	57                   	push   %edi
     ab4:	56                   	push   %esi
     ab5:	ff 75 d4             	push   -0x2c(%ebp)
     ab8:	e8 f3 fe ff ff       	call   9b0 <parseredirs>
     abd:	83 c4 10             	add    $0x10,%esp
     ac0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while (!peek(ps, es, "|)&;"))
     ac3:	83 ec 04             	sub    $0x4,%esp
     ac6:	68 0b 16 00 00       	push   $0x160b
     acb:	57                   	push   %edi
     acc:	56                   	push   %esi
     acd:	e8 5e fe ff ff       	call   930 <peek>
     ad2:	83 c4 10             	add    $0x10,%esp
     ad5:	85 c0                	test   %eax,%eax
     ad7:	75 67                	jne    b40 <parseexec+0xe0>
    if ((tok = gettoken(ps, es, &q, &eq)) == 0)
     ad9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     adc:	50                   	push   %eax
     add:	8d 45 e0             	lea    -0x20(%ebp),%eax
     ae0:	50                   	push   %eax
     ae1:	57                   	push   %edi
     ae2:	56                   	push   %esi
     ae3:	e8 e8 fc ff ff       	call   7d0 <gettoken>
     ae8:	83 c4 10             	add    $0x10,%esp
     aeb:	85 c0                	test   %eax,%eax
     aed:	74 51                	je     b40 <parseexec+0xe0>
    if (tok != 'a')
     aef:	83 f8 61             	cmp    $0x61,%eax
     af2:	75 6b                	jne    b5f <parseexec+0xff>
    cmd->argv[argc] = q;
     af4:	8b 45 e0             	mov    -0x20(%ebp),%eax
     af7:	8b 55 d0             	mov    -0x30(%ebp),%edx
     afa:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     afe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     b01:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     b05:	83 c3 01             	add    $0x1,%ebx
    if (argc >= MAXARGS)
     b08:	83 fb 0a             	cmp    $0xa,%ebx
     b0b:	75 a3                	jne    ab0 <parseexec+0x50>
      panic("too many args");
     b0d:	83 ec 0c             	sub    $0xc,%esp
     b10:	68 fd 15 00 00       	push   $0x15fd
     b15:	e8 56 f9 ff ff       	call   470 <panic>
     b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return parseblock(ps, es);
     b20:	83 ec 08             	sub    $0x8,%esp
     b23:	57                   	push   %edi
     b24:	56                   	push   %esi
     b25:	e8 66 01 00 00       	call   c90 <parseblock>
     b2a:	83 c4 10             	add    $0x10,%esp
     b2d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     b30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     b33:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b36:	5b                   	pop    %ebx
     b37:	5e                   	pop    %esi
     b38:	5f                   	pop    %edi
     b39:	5d                   	pop    %ebp
     b3a:	c3                   	ret
     b3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  cmd->argv[argc] = 0;
     b40:	8b 45 d0             	mov    -0x30(%ebp),%eax
     b43:	8d 04 98             	lea    (%eax,%ebx,4),%eax
     b46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  cmd->eargv[argc] = 0;
     b4d:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
}
     b54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     b57:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b5a:	5b                   	pop    %ebx
     b5b:	5e                   	pop    %esi
     b5c:	5f                   	pop    %edi
     b5d:	5d                   	pop    %ebp
     b5e:	c3                   	ret
      panic("syntax");
     b5f:	83 ec 0c             	sub    $0xc,%esp
     b62:	68 f6 15 00 00       	push   $0x15f6
     b67:	e8 04 f9 ff ff       	call   470 <panic>
     b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b70 <parsepipe>:
{
     b70:	f3 0f 1e fb          	endbr32
     b74:	55                   	push   %ebp
     b75:	89 e5                	mov    %esp,%ebp
     b77:	57                   	push   %edi
     b78:	56                   	push   %esi
     b79:	53                   	push   %ebx
     b7a:	83 ec 14             	sub    $0x14,%esp
     b7d:	8b 75 08             	mov    0x8(%ebp),%esi
     b80:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
     b83:	57                   	push   %edi
     b84:	56                   	push   %esi
     b85:	e8 d6 fe ff ff       	call   a60 <parseexec>
  if (peek(ps, es, "|"))
     b8a:	83 c4 0c             	add    $0xc,%esp
     b8d:	68 10 16 00 00       	push   $0x1610
  cmd = parseexec(ps, es);
     b92:	89 c3                	mov    %eax,%ebx
  if (peek(ps, es, "|"))
     b94:	57                   	push   %edi
     b95:	56                   	push   %esi
     b96:	e8 95 fd ff ff       	call   930 <peek>
     b9b:	83 c4 10             	add    $0x10,%esp
     b9e:	85 c0                	test   %eax,%eax
     ba0:	75 0e                	jne    bb0 <parsepipe+0x40>
}
     ba2:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ba5:	89 d8                	mov    %ebx,%eax
     ba7:	5b                   	pop    %ebx
     ba8:	5e                   	pop    %esi
     ba9:	5f                   	pop    %edi
     baa:	5d                   	pop    %ebp
     bab:	c3                   	ret
     bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    gettoken(ps, es, 0, 0);
     bb0:	6a 00                	push   $0x0
     bb2:	6a 00                	push   $0x0
     bb4:	57                   	push   %edi
     bb5:	56                   	push   %esi
     bb6:	e8 15 fc ff ff       	call   7d0 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     bbb:	58                   	pop    %eax
     bbc:	5a                   	pop    %edx
     bbd:	57                   	push   %edi
     bbe:	56                   	push   %esi
     bbf:	e8 ac ff ff ff       	call   b70 <parsepipe>
     bc4:	89 5d 08             	mov    %ebx,0x8(%ebp)
     bc7:	83 c4 10             	add    $0x10,%esp
     bca:	89 45 0c             	mov    %eax,0xc(%ebp)
}
     bcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
     bd0:	5b                   	pop    %ebx
     bd1:	5e                   	pop    %esi
     bd2:	5f                   	pop    %edi
     bd3:	5d                   	pop    %ebp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     bd4:	e9 37 fb ff ff       	jmp    710 <pipecmd>
     bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000be0 <parseline>:
{
     be0:	f3 0f 1e fb          	endbr32
     be4:	55                   	push   %ebp
     be5:	89 e5                	mov    %esp,%ebp
     be7:	57                   	push   %edi
     be8:	56                   	push   %esi
     be9:	53                   	push   %ebx
     bea:	83 ec 14             	sub    $0x14,%esp
     bed:	8b 75 08             	mov    0x8(%ebp),%esi
     bf0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
     bf3:	57                   	push   %edi
     bf4:	56                   	push   %esi
     bf5:	e8 76 ff ff ff       	call   b70 <parsepipe>
  while (peek(ps, es, "&"))
     bfa:	83 c4 10             	add    $0x10,%esp
  cmd = parsepipe(ps, es);
     bfd:	89 c3                	mov    %eax,%ebx
  while (peek(ps, es, "&"))
     bff:	eb 1f                	jmp    c20 <parseline+0x40>
     c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    gettoken(ps, es, 0, 0);
     c08:	6a 00                	push   $0x0
     c0a:	6a 00                	push   $0x0
     c0c:	57                   	push   %edi
     c0d:	56                   	push   %esi
     c0e:	e8 bd fb ff ff       	call   7d0 <gettoken>
    cmd = backcmd(cmd);
     c13:	89 1c 24             	mov    %ebx,(%esp)
     c16:	e8 75 fb ff ff       	call   790 <backcmd>
     c1b:	83 c4 10             	add    $0x10,%esp
     c1e:	89 c3                	mov    %eax,%ebx
  while (peek(ps, es, "&"))
     c20:	83 ec 04             	sub    $0x4,%esp
     c23:	68 12 16 00 00       	push   $0x1612
     c28:	57                   	push   %edi
     c29:	56                   	push   %esi
     c2a:	e8 01 fd ff ff       	call   930 <peek>
     c2f:	83 c4 10             	add    $0x10,%esp
     c32:	85 c0                	test   %eax,%eax
     c34:	75 d2                	jne    c08 <parseline+0x28>
  if (peek(ps, es, ";"))
     c36:	83 ec 04             	sub    $0x4,%esp
     c39:	68 0e 16 00 00       	push   $0x160e
     c3e:	57                   	push   %edi
     c3f:	56                   	push   %esi
     c40:	e8 eb fc ff ff       	call   930 <peek>
     c45:	83 c4 10             	add    $0x10,%esp
     c48:	85 c0                	test   %eax,%eax
     c4a:	75 14                	jne    c60 <parseline+0x80>
}
     c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c4f:	89 d8                	mov    %ebx,%eax
     c51:	5b                   	pop    %ebx
     c52:	5e                   	pop    %esi
     c53:	5f                   	pop    %edi
     c54:	5d                   	pop    %ebp
     c55:	c3                   	ret
     c56:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c5d:	00 
     c5e:	66 90                	xchg   %ax,%ax
    gettoken(ps, es, 0, 0);
     c60:	6a 00                	push   $0x0
     c62:	6a 00                	push   $0x0
     c64:	57                   	push   %edi
     c65:	56                   	push   %esi
     c66:	e8 65 fb ff ff       	call   7d0 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     c6b:	58                   	pop    %eax
     c6c:	5a                   	pop    %edx
     c6d:	57                   	push   %edi
     c6e:	56                   	push   %esi
     c6f:	e8 6c ff ff ff       	call   be0 <parseline>
     c74:	89 5d 08             	mov    %ebx,0x8(%ebp)
     c77:	83 c4 10             	add    $0x10,%esp
     c7a:	89 45 0c             	mov    %eax,0xc(%ebp)
}
     c7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c80:	5b                   	pop    %ebx
     c81:	5e                   	pop    %esi
     c82:	5f                   	pop    %edi
     c83:	5d                   	pop    %ebp
    cmd = listcmd(cmd, parseline(ps, es));
     c84:	e9 c7 fa ff ff       	jmp    750 <listcmd>
     c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000c90 <parseblock>:
{
     c90:	f3 0f 1e fb          	endbr32
     c94:	55                   	push   %ebp
     c95:	89 e5                	mov    %esp,%ebp
     c97:	57                   	push   %edi
     c98:	56                   	push   %esi
     c99:	53                   	push   %ebx
     c9a:	83 ec 10             	sub    $0x10,%esp
     c9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
     ca0:	8b 75 0c             	mov    0xc(%ebp),%esi
  if (!peek(ps, es, "("))
     ca3:	68 f4 15 00 00       	push   $0x15f4
     ca8:	56                   	push   %esi
     ca9:	53                   	push   %ebx
     caa:	e8 81 fc ff ff       	call   930 <peek>
     caf:	83 c4 10             	add    $0x10,%esp
     cb2:	85 c0                	test   %eax,%eax
     cb4:	74 4a                	je     d00 <parseblock+0x70>
  gettoken(ps, es, 0, 0);
     cb6:	6a 00                	push   $0x0
     cb8:	6a 00                	push   $0x0
     cba:	56                   	push   %esi
     cbb:	53                   	push   %ebx
     cbc:	e8 0f fb ff ff       	call   7d0 <gettoken>
  cmd = parseline(ps, es);
     cc1:	58                   	pop    %eax
     cc2:	5a                   	pop    %edx
     cc3:	56                   	push   %esi
     cc4:	53                   	push   %ebx
     cc5:	e8 16 ff ff ff       	call   be0 <parseline>
  if (!peek(ps, es, ")"))
     cca:	83 c4 0c             	add    $0xc,%esp
     ccd:	68 30 16 00 00       	push   $0x1630
  cmd = parseline(ps, es);
     cd2:	89 c7                	mov    %eax,%edi
  if (!peek(ps, es, ")"))
     cd4:	56                   	push   %esi
     cd5:	53                   	push   %ebx
     cd6:	e8 55 fc ff ff       	call   930 <peek>
     cdb:	83 c4 10             	add    $0x10,%esp
     cde:	85 c0                	test   %eax,%eax
     ce0:	74 2b                	je     d0d <parseblock+0x7d>
  gettoken(ps, es, 0, 0);
     ce2:	6a 00                	push   $0x0
     ce4:	6a 00                	push   $0x0
     ce6:	56                   	push   %esi
     ce7:	53                   	push   %ebx
     ce8:	e8 e3 fa ff ff       	call   7d0 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     ced:	83 c4 0c             	add    $0xc,%esp
     cf0:	56                   	push   %esi
     cf1:	53                   	push   %ebx
     cf2:	57                   	push   %edi
     cf3:	e8 b8 fc ff ff       	call   9b0 <parseredirs>
}
     cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
     cfb:	5b                   	pop    %ebx
     cfc:	5e                   	pop    %esi
     cfd:	5f                   	pop    %edi
     cfe:	5d                   	pop    %ebp
     cff:	c3                   	ret
    panic("parseblock");
     d00:	83 ec 0c             	sub    $0xc,%esp
     d03:	68 14 16 00 00       	push   $0x1614
     d08:	e8 63 f7 ff ff       	call   470 <panic>
    panic("syntax - missing )");
     d0d:	83 ec 0c             	sub    $0xc,%esp
     d10:	68 1f 16 00 00       	push   $0x161f
     d15:	e8 56 f7 ff ff       	call   470 <panic>
     d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000d20 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd *
nulterminate(struct cmd *cmd)
{
     d20:	f3 0f 1e fb          	endbr32
     d24:	55                   	push   %ebp
     d25:	89 e5                	mov    %esp,%ebp
     d27:	53                   	push   %ebx
     d28:	83 ec 04             	sub    $0x4,%esp
     d2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if (cmd == 0)
     d2e:	85 db                	test   %ebx,%ebx
     d30:	0f 84 9a 00 00 00    	je     dd0 <nulterminate+0xb0>
    return 0;

  switch (cmd->type)
     d36:	83 3b 05             	cmpl   $0x5,(%ebx)
     d39:	77 6d                	ja     da8 <nulterminate+0x88>
     d3b:	8b 03                	mov    (%ebx),%eax
     d3d:	3e ff 24 85 dc 16 00 	notrack jmp *0x16dc(,%eax,4)
     d44:	00 
     d45:	8d 76 00             	lea    0x0(%esi),%esi
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd *)cmd;
    nulterminate(lcmd->left);
     d48:	83 ec 0c             	sub    $0xc,%esp
     d4b:	ff 73 04             	push   0x4(%ebx)
     d4e:	e8 cd ff ff ff       	call   d20 <nulterminate>
    nulterminate(lcmd->right);
     d53:	58                   	pop    %eax
     d54:	ff 73 08             	push   0x8(%ebx)
     d57:	e8 c4 ff ff ff       	call   d20 <nulterminate>
    break;
     d5c:	83 c4 10             	add    $0x10,%esp
     d5f:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd *)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     d61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     d64:	c9                   	leave
     d65:	c3                   	ret
     d66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     d6d:	00 
     d6e:	66 90                	xchg   %ax,%ax
    nulterminate(bcmd->cmd);
     d70:	83 ec 0c             	sub    $0xc,%esp
     d73:	ff 73 04             	push   0x4(%ebx)
     d76:	e8 a5 ff ff ff       	call   d20 <nulterminate>
    break;
     d7b:	89 d8                	mov    %ebx,%eax
     d7d:	83 c4 10             	add    $0x10,%esp
}
     d80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     d83:	c9                   	leave
     d84:	c3                   	ret
     d85:	8d 76 00             	lea    0x0(%esi),%esi
    for (i = 0; ecmd->argv[i]; i++)
     d88:	8b 4b 04             	mov    0x4(%ebx),%ecx
     d8b:	8d 43 08             	lea    0x8(%ebx),%eax
     d8e:	85 c9                	test   %ecx,%ecx
     d90:	74 16                	je     da8 <nulterminate+0x88>
     d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *ecmd->eargv[i] = 0;
     d98:	8b 50 24             	mov    0x24(%eax),%edx
     d9b:	83 c0 04             	add    $0x4,%eax
     d9e:	c6 02 00             	movb   $0x0,(%edx)
    for (i = 0; ecmd->argv[i]; i++)
     da1:	8b 50 fc             	mov    -0x4(%eax),%edx
     da4:	85 d2                	test   %edx,%edx
     da6:	75 f0                	jne    d98 <nulterminate+0x78>
  switch (cmd->type)
     da8:	89 d8                	mov    %ebx,%eax
}
     daa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     dad:	c9                   	leave
     dae:	c3                   	ret
     daf:	90                   	nop
    nulterminate(rcmd->cmd);
     db0:	83 ec 0c             	sub    $0xc,%esp
     db3:	ff 73 04             	push   0x4(%ebx)
     db6:	e8 65 ff ff ff       	call   d20 <nulterminate>
    *rcmd->efile = 0;
     dbb:	8b 43 0c             	mov    0xc(%ebx),%eax
    break;
     dbe:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     dc1:	c6 00 00             	movb   $0x0,(%eax)
    break;
     dc4:	89 d8                	mov    %ebx,%eax
}
     dc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     dc9:	c9                   	leave
     dca:	c3                   	ret
     dcb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return 0;
     dd0:	31 c0                	xor    %eax,%eax
     dd2:	eb 8d                	jmp    d61 <nulterminate+0x41>
     dd4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     ddb:	00 
     ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000de0 <parsecmd>:
{
     de0:	f3 0f 1e fb          	endbr32
     de4:	55                   	push   %ebp
     de5:	89 e5                	mov    %esp,%ebp
     de7:	56                   	push   %esi
     de8:	53                   	push   %ebx
  es = s + strlen(s);
     de9:	8b 5d 08             	mov    0x8(%ebp),%ebx
     dec:	83 ec 0c             	sub    $0xc,%esp
     def:	53                   	push   %ebx
     df0:	e8 db 00 00 00       	call   ed0 <strlen>
  cmd = parseline(&s, es);
     df5:	59                   	pop    %ecx
     df6:	5e                   	pop    %esi
  es = s + strlen(s);
     df7:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     df9:	8d 45 08             	lea    0x8(%ebp),%eax
     dfc:	53                   	push   %ebx
     dfd:	50                   	push   %eax
     dfe:	e8 dd fd ff ff       	call   be0 <parseline>
  peek(&s, es, "");
     e03:	83 c4 0c             	add    $0xc,%esp
  cmd = parseline(&s, es);
     e06:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     e08:	8d 45 08             	lea    0x8(%ebp),%eax
     e0b:	68 a9 15 00 00       	push   $0x15a9
     e10:	53                   	push   %ebx
     e11:	50                   	push   %eax
     e12:	e8 19 fb ff ff       	call   930 <peek>
  if (s != es)
     e17:	8b 45 08             	mov    0x8(%ebp),%eax
     e1a:	83 c4 10             	add    $0x10,%esp
     e1d:	39 d8                	cmp    %ebx,%eax
     e1f:	75 12                	jne    e33 <parsecmd+0x53>
  nulterminate(cmd);
     e21:	83 ec 0c             	sub    $0xc,%esp
     e24:	56                   	push   %esi
     e25:	e8 f6 fe ff ff       	call   d20 <nulterminate>
}
     e2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
     e2d:	89 f0                	mov    %esi,%eax
     e2f:	5b                   	pop    %ebx
     e30:	5e                   	pop    %esi
     e31:	5d                   	pop    %ebp
     e32:	c3                   	ret
    printf(2, "leftovers: %s\n", s);
     e33:	52                   	push   %edx
     e34:	50                   	push   %eax
     e35:	68 32 16 00 00       	push   $0x1632
     e3a:	6a 02                	push   $0x2
     e3c:	e8 ef 03 00 00       	call   1230 <printf>
    panic("syntax");
     e41:	c7 04 24 f6 15 00 00 	movl   $0x15f6,(%esp)
     e48:	e8 23 f6 ff ff       	call   470 <panic>
     e4d:	66 90                	xchg   %ax,%ax
     e4f:	90                   	nop

00000e50 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     e50:	f3 0f 1e fb          	endbr32
     e54:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     e55:	31 c0                	xor    %eax,%eax
{
     e57:	89 e5                	mov    %esp,%ebp
     e59:	53                   	push   %ebx
     e5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
     e5d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
     e60:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     e64:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     e67:	83 c0 01             	add    $0x1,%eax
     e6a:	84 d2                	test   %dl,%dl
     e6c:	75 f2                	jne    e60 <strcpy+0x10>
    ;
  return os;
}
     e6e:	89 c8                	mov    %ecx,%eax
     e70:	5b                   	pop    %ebx
     e71:	5d                   	pop    %ebp
     e72:	c3                   	ret
     e73:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     e7a:	00 
     e7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00000e80 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     e80:	f3 0f 1e fb          	endbr32
     e84:	55                   	push   %ebp
     e85:	89 e5                	mov    %esp,%ebp
     e87:	53                   	push   %ebx
     e88:	8b 4d 08             	mov    0x8(%ebp),%ecx
     e8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     e8e:	0f b6 01             	movzbl (%ecx),%eax
     e91:	0f b6 1a             	movzbl (%edx),%ebx
     e94:	84 c0                	test   %al,%al
     e96:	75 19                	jne    eb1 <strcmp+0x31>
     e98:	eb 26                	jmp    ec0 <strcmp+0x40>
     e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     ea0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
     ea4:	83 c1 01             	add    $0x1,%ecx
     ea7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
     eaa:	0f b6 1a             	movzbl (%edx),%ebx
     ead:	84 c0                	test   %al,%al
     eaf:	74 0f                	je     ec0 <strcmp+0x40>
     eb1:	38 d8                	cmp    %bl,%al
     eb3:	74 eb                	je     ea0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
     eb5:	29 d8                	sub    %ebx,%eax
}
     eb7:	5b                   	pop    %ebx
     eb8:	5d                   	pop    %ebp
     eb9:	c3                   	ret
     eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     ec0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
     ec2:	29 d8                	sub    %ebx,%eax
}
     ec4:	5b                   	pop    %ebx
     ec5:	5d                   	pop    %ebp
     ec6:	c3                   	ret
     ec7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     ece:	00 
     ecf:	90                   	nop

00000ed0 <strlen>:

uint
strlen(const char *s)
{
     ed0:	f3 0f 1e fb          	endbr32
     ed4:	55                   	push   %ebp
     ed5:	89 e5                	mov    %esp,%ebp
     ed7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     eda:	80 3a 00             	cmpb   $0x0,(%edx)
     edd:	74 21                	je     f00 <strlen+0x30>
     edf:	31 c0                	xor    %eax,%eax
     ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     ee8:	83 c0 01             	add    $0x1,%eax
     eeb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     eef:	89 c1                	mov    %eax,%ecx
     ef1:	75 f5                	jne    ee8 <strlen+0x18>
    ;
  return n;
}
     ef3:	89 c8                	mov    %ecx,%eax
     ef5:	5d                   	pop    %ebp
     ef6:	c3                   	ret
     ef7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     efe:	00 
     eff:	90                   	nop
  for(n = 0; s[n]; n++)
     f00:	31 c9                	xor    %ecx,%ecx
}
     f02:	5d                   	pop    %ebp
     f03:	89 c8                	mov    %ecx,%eax
     f05:	c3                   	ret
     f06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     f0d:	00 
     f0e:	66 90                	xchg   %ax,%ax

00000f10 <memset>:

void*
memset(void *dst, int c, uint n)
{
     f10:	f3 0f 1e fb          	endbr32
     f14:	55                   	push   %ebp
     f15:	89 e5                	mov    %esp,%ebp
     f17:	57                   	push   %edi
     f18:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     f1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
     f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
     f21:	89 d7                	mov    %edx,%edi
     f23:	fc                   	cld
     f24:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     f26:	89 d0                	mov    %edx,%eax
     f28:	5f                   	pop    %edi
     f29:	5d                   	pop    %ebp
     f2a:	c3                   	ret
     f2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00000f30 <strchr>:

char*
strchr(const char *s, char c)
{
     f30:	f3 0f 1e fb          	endbr32
     f34:	55                   	push   %ebp
     f35:	89 e5                	mov    %esp,%ebp
     f37:	8b 45 08             	mov    0x8(%ebp),%eax
     f3a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     f3e:	0f b6 10             	movzbl (%eax),%edx
     f41:	84 d2                	test   %dl,%dl
     f43:	75 16                	jne    f5b <strchr+0x2b>
     f45:	eb 21                	jmp    f68 <strchr+0x38>
     f47:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     f4e:	00 
     f4f:	90                   	nop
     f50:	0f b6 50 01          	movzbl 0x1(%eax),%edx
     f54:	83 c0 01             	add    $0x1,%eax
     f57:	84 d2                	test   %dl,%dl
     f59:	74 0d                	je     f68 <strchr+0x38>
    if(*s == c)
     f5b:	38 d1                	cmp    %dl,%cl
     f5d:	75 f1                	jne    f50 <strchr+0x20>
      return (char*)s;
  return 0;
}
     f5f:	5d                   	pop    %ebp
     f60:	c3                   	ret
     f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
     f68:	31 c0                	xor    %eax,%eax
}
     f6a:	5d                   	pop    %ebp
     f6b:	c3                   	ret
     f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000f70 <gets>:

char*
gets(char *buf, int max)
{
     f70:	f3 0f 1e fb          	endbr32
     f74:	55                   	push   %ebp
     f75:	89 e5                	mov    %esp,%ebp
     f77:	57                   	push   %edi
     f78:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     f79:	31 f6                	xor    %esi,%esi
{
     f7b:	53                   	push   %ebx
     f7c:	89 f3                	mov    %esi,%ebx
     f7e:	83 ec 1c             	sub    $0x1c,%esp
     f81:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
     f84:	eb 33                	jmp    fb9 <gets+0x49>
     f86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     f8d:	00 
     f8e:	66 90                	xchg   %ax,%ax
    cc = read(0, &c, 1);
     f90:	83 ec 04             	sub    $0x4,%esp
     f93:	8d 45 e7             	lea    -0x19(%ebp),%eax
     f96:	6a 01                	push   $0x1
     f98:	50                   	push   %eax
     f99:	6a 00                	push   $0x0
     f9b:	e8 2b 01 00 00       	call   10cb <read>
    if(cc < 1)
     fa0:	83 c4 10             	add    $0x10,%esp
     fa3:	85 c0                	test   %eax,%eax
     fa5:	7e 1c                	jle    fc3 <gets+0x53>
      break;
    buf[i++] = c;
     fa7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     fab:	83 c7 01             	add    $0x1,%edi
     fae:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
     fb1:	3c 0a                	cmp    $0xa,%al
     fb3:	74 23                	je     fd8 <gets+0x68>
     fb5:	3c 0d                	cmp    $0xd,%al
     fb7:	74 1f                	je     fd8 <gets+0x68>
  for(i=0; i+1 < max; ){
     fb9:	83 c3 01             	add    $0x1,%ebx
     fbc:	89 fe                	mov    %edi,%esi
     fbe:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     fc1:	7c cd                	jl     f90 <gets+0x20>
     fc3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
     fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
     fc8:	c6 03 00             	movb   $0x0,(%ebx)
}
     fcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
     fce:	5b                   	pop    %ebx
     fcf:	5e                   	pop    %esi
     fd0:	5f                   	pop    %edi
     fd1:	5d                   	pop    %ebp
     fd2:	c3                   	ret
     fd3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     fd8:	8b 75 08             	mov    0x8(%ebp),%esi
     fdb:	8b 45 08             	mov    0x8(%ebp),%eax
     fde:	01 de                	add    %ebx,%esi
     fe0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
     fe2:	c6 03 00             	movb   $0x0,(%ebx)
}
     fe5:	8d 65 f4             	lea    -0xc(%ebp),%esp
     fe8:	5b                   	pop    %ebx
     fe9:	5e                   	pop    %esi
     fea:	5f                   	pop    %edi
     feb:	5d                   	pop    %ebp
     fec:	c3                   	ret
     fed:	8d 76 00             	lea    0x0(%esi),%esi

00000ff0 <stat>:

int
stat(const char *n, struct stat *st)
{
     ff0:	f3 0f 1e fb          	endbr32
     ff4:	55                   	push   %ebp
     ff5:	89 e5                	mov    %esp,%ebp
     ff7:	56                   	push   %esi
     ff8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ff9:	83 ec 08             	sub    $0x8,%esp
     ffc:	6a 00                	push   $0x0
     ffe:	ff 75 08             	push   0x8(%ebp)
    1001:	e8 ed 00 00 00       	call   10f3 <open>
  if(fd < 0)
    1006:	83 c4 10             	add    $0x10,%esp
    1009:	85 c0                	test   %eax,%eax
    100b:	78 2b                	js     1038 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    100d:	83 ec 08             	sub    $0x8,%esp
    1010:	ff 75 0c             	push   0xc(%ebp)
    1013:	89 c3                	mov    %eax,%ebx
    1015:	50                   	push   %eax
    1016:	e8 f0 00 00 00       	call   110b <fstat>
  close(fd);
    101b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    101e:	89 c6                	mov    %eax,%esi
  close(fd);
    1020:	e8 b6 00 00 00       	call   10db <close>
  return r;
    1025:	83 c4 10             	add    $0x10,%esp
}
    1028:	8d 65 f8             	lea    -0x8(%ebp),%esp
    102b:	89 f0                	mov    %esi,%eax
    102d:	5b                   	pop    %ebx
    102e:	5e                   	pop    %esi
    102f:	5d                   	pop    %ebp
    1030:	c3                   	ret
    1031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
    1038:	be ff ff ff ff       	mov    $0xffffffff,%esi
    103d:	eb e9                	jmp    1028 <stat+0x38>
    103f:	90                   	nop

00001040 <atoi>:

int
atoi(const char *s)
{
    1040:	f3 0f 1e fb          	endbr32
    1044:	55                   	push   %ebp
    1045:	89 e5                	mov    %esp,%ebp
    1047:	53                   	push   %ebx
    1048:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    104b:	0f be 02             	movsbl (%edx),%eax
    104e:	8d 48 d0             	lea    -0x30(%eax),%ecx
    1051:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    1054:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    1059:	77 1a                	ja     1075 <atoi+0x35>
    105b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
    1060:	83 c2 01             	add    $0x1,%edx
    1063:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    1066:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    106a:	0f be 02             	movsbl (%edx),%eax
    106d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    1070:	80 fb 09             	cmp    $0x9,%bl
    1073:	76 eb                	jbe    1060 <atoi+0x20>
  return n;
}
    1075:	89 c8                	mov    %ecx,%eax
    1077:	5b                   	pop    %ebx
    1078:	5d                   	pop    %ebp
    1079:	c3                   	ret
    107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001080 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1080:	f3 0f 1e fb          	endbr32
    1084:	55                   	push   %ebp
    1085:	89 e5                	mov    %esp,%ebp
    1087:	57                   	push   %edi
    1088:	8b 45 10             	mov    0x10(%ebp),%eax
    108b:	8b 55 08             	mov    0x8(%ebp),%edx
    108e:	56                   	push   %esi
    108f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1092:	85 c0                	test   %eax,%eax
    1094:	7e 0f                	jle    10a5 <memmove+0x25>
    1096:	01 d0                	add    %edx,%eax
  dst = vdst;
    1098:	89 d7                	mov    %edx,%edi
    109a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
    10a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    10a1:	39 f8                	cmp    %edi,%eax
    10a3:	75 fb                	jne    10a0 <memmove+0x20>
  return vdst;
}
    10a5:	5e                   	pop    %esi
    10a6:	89 d0                	mov    %edx,%eax
    10a8:	5f                   	pop    %edi
    10a9:	5d                   	pop    %ebp
    10aa:	c3                   	ret

000010ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    10ab:	b8 01 00 00 00       	mov    $0x1,%eax
    10b0:	cd 40                	int    $0x40
    10b2:	c3                   	ret

000010b3 <exit>:
SYSCALL(exit)
    10b3:	b8 02 00 00 00       	mov    $0x2,%eax
    10b8:	cd 40                	int    $0x40
    10ba:	c3                   	ret

000010bb <wait>:
SYSCALL(wait)
    10bb:	b8 03 00 00 00       	mov    $0x3,%eax
    10c0:	cd 40                	int    $0x40
    10c2:	c3                   	ret

000010c3 <pipe>:
SYSCALL(pipe)
    10c3:	b8 04 00 00 00       	mov    $0x4,%eax
    10c8:	cd 40                	int    $0x40
    10ca:	c3                   	ret

000010cb <read>:
SYSCALL(read)
    10cb:	b8 05 00 00 00       	mov    $0x5,%eax
    10d0:	cd 40                	int    $0x40
    10d2:	c3                   	ret

000010d3 <write>:
SYSCALL(write)
    10d3:	b8 10 00 00 00       	mov    $0x10,%eax
    10d8:	cd 40                	int    $0x40
    10da:	c3                   	ret

000010db <close>:
SYSCALL(close)
    10db:	b8 15 00 00 00       	mov    $0x15,%eax
    10e0:	cd 40                	int    $0x40
    10e2:	c3                   	ret

000010e3 <kill>:
SYSCALL(kill)
    10e3:	b8 06 00 00 00       	mov    $0x6,%eax
    10e8:	cd 40                	int    $0x40
    10ea:	c3                   	ret

000010eb <exec>:
SYSCALL(exec)
    10eb:	b8 07 00 00 00       	mov    $0x7,%eax
    10f0:	cd 40                	int    $0x40
    10f2:	c3                   	ret

000010f3 <open>:
SYSCALL(open)
    10f3:	b8 0f 00 00 00       	mov    $0xf,%eax
    10f8:	cd 40                	int    $0x40
    10fa:	c3                   	ret

000010fb <mknod>:
SYSCALL(mknod)
    10fb:	b8 11 00 00 00       	mov    $0x11,%eax
    1100:	cd 40                	int    $0x40
    1102:	c3                   	ret

00001103 <unlink>:
SYSCALL(unlink)
    1103:	b8 12 00 00 00       	mov    $0x12,%eax
    1108:	cd 40                	int    $0x40
    110a:	c3                   	ret

0000110b <fstat>:
SYSCALL(fstat)
    110b:	b8 08 00 00 00       	mov    $0x8,%eax
    1110:	cd 40                	int    $0x40
    1112:	c3                   	ret

00001113 <link>:
SYSCALL(link)
    1113:	b8 13 00 00 00       	mov    $0x13,%eax
    1118:	cd 40                	int    $0x40
    111a:	c3                   	ret

0000111b <mkdir>:
SYSCALL(mkdir)
    111b:	b8 14 00 00 00       	mov    $0x14,%eax
    1120:	cd 40                	int    $0x40
    1122:	c3                   	ret

00001123 <chdir>:
SYSCALL(chdir)
    1123:	b8 09 00 00 00       	mov    $0x9,%eax
    1128:	cd 40                	int    $0x40
    112a:	c3                   	ret

0000112b <dup>:
SYSCALL(dup)
    112b:	b8 0a 00 00 00       	mov    $0xa,%eax
    1130:	cd 40                	int    $0x40
    1132:	c3                   	ret

00001133 <getpid>:
SYSCALL(getpid)
    1133:	b8 0b 00 00 00       	mov    $0xb,%eax
    1138:	cd 40                	int    $0x40
    113a:	c3                   	ret

0000113b <sbrk>:
SYSCALL(sbrk)
    113b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1140:	cd 40                	int    $0x40
    1142:	c3                   	ret

00001143 <sleep>:
SYSCALL(sleep)
    1143:	b8 0d 00 00 00       	mov    $0xd,%eax
    1148:	cd 40                	int    $0x40
    114a:	c3                   	ret

0000114b <uptime>:
SYSCALL(uptime)
    114b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1150:	cd 40                	int    $0x40
    1152:	c3                   	ret

00001153 <gethistory>:
SYSCALL(gethistory)
    1153:	b8 16 00 00 00       	mov    $0x16,%eax
    1158:	cd 40                	int    $0x40
    115a:	c3                   	ret

0000115b <block>:
SYSCALL(block)
    115b:	b8 17 00 00 00       	mov    $0x17,%eax
    1160:	cd 40                	int    $0x40
    1162:	c3                   	ret

00001163 <unblock>:
SYSCALL(unblock)
    1163:	b8 18 00 00 00       	mov    $0x18,%eax
    1168:	cd 40                	int    $0x40
    116a:	c3                   	ret

0000116b <chmod>:
SYSCALL(chmod)
    116b:	b8 19 00 00 00       	mov    $0x19,%eax
    1170:	cd 40                	int    $0x40
    1172:	c3                   	ret

00001173 <realsh>:
SYSCALL(realsh)
    1173:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1178:	cd 40                	int    $0x40
    117a:	c3                   	ret
    117b:	66 90                	xchg   %ax,%ax
    117d:	66 90                	xchg   %ax,%ax
    117f:	90                   	nop

00001180 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1180:	55                   	push   %ebp
    1181:	89 e5                	mov    %esp,%ebp
    1183:	57                   	push   %edi
    1184:	56                   	push   %esi
    1185:	53                   	push   %ebx
    1186:	83 ec 3c             	sub    $0x3c,%esp
    1189:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    118c:	89 d1                	mov    %edx,%ecx
{
    118e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    1191:	85 d2                	test   %edx,%edx
    1193:	0f 89 7f 00 00 00    	jns    1218 <printint+0x98>
    1199:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    119d:	74 79                	je     1218 <printint+0x98>
    neg = 1;
    119f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    11a6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    11a8:	31 db                	xor    %ebx,%ebx
    11aa:	8d 75 d7             	lea    -0x29(%ebp),%esi
    11ad:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    11b0:	89 c8                	mov    %ecx,%eax
    11b2:	31 d2                	xor    %edx,%edx
    11b4:	89 cf                	mov    %ecx,%edi
    11b6:	f7 75 c4             	divl   -0x3c(%ebp)
    11b9:	0f b6 92 18 17 00 00 	movzbl 0x1718(%edx),%edx
    11c0:	89 45 c0             	mov    %eax,-0x40(%ebp)
    11c3:	89 d8                	mov    %ebx,%eax
    11c5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    11c8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    11cb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    11ce:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    11d1:	76 dd                	jbe    11b0 <printint+0x30>
  if(neg)
    11d3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    11d6:	85 c9                	test   %ecx,%ecx
    11d8:	74 0c                	je     11e6 <printint+0x66>
    buf[i++] = '-';
    11da:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    11df:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    11e1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    11e6:	8b 7d b8             	mov    -0x48(%ebp),%edi
    11e9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    11ed:	eb 07                	jmp    11f6 <printint+0x76>
    11ef:	90                   	nop
    11f0:	0f b6 13             	movzbl (%ebx),%edx
    11f3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    11f6:	83 ec 04             	sub    $0x4,%esp
    11f9:	88 55 d7             	mov    %dl,-0x29(%ebp)
    11fc:	6a 01                	push   $0x1
    11fe:	56                   	push   %esi
    11ff:	57                   	push   %edi
    1200:	e8 ce fe ff ff       	call   10d3 <write>
  while(--i >= 0)
    1205:	83 c4 10             	add    $0x10,%esp
    1208:	39 de                	cmp    %ebx,%esi
    120a:	75 e4                	jne    11f0 <printint+0x70>
    putc(fd, buf[i]);
}
    120c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    120f:	5b                   	pop    %ebx
    1210:	5e                   	pop    %esi
    1211:	5f                   	pop    %edi
    1212:	5d                   	pop    %ebp
    1213:	c3                   	ret
    1214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    1218:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    121f:	eb 87                	jmp    11a8 <printint+0x28>
    1221:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    1228:	00 
    1229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001230 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1230:	f3 0f 1e fb          	endbr32
    1234:	55                   	push   %ebp
    1235:	89 e5                	mov    %esp,%ebp
    1237:	57                   	push   %edi
    1238:	56                   	push   %esi
    1239:	53                   	push   %ebx
    123a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    123d:	8b 75 0c             	mov    0xc(%ebp),%esi
    1240:	0f b6 1e             	movzbl (%esi),%ebx
    1243:	84 db                	test   %bl,%bl
    1245:	0f 84 b4 00 00 00    	je     12ff <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
    124b:	8d 45 10             	lea    0x10(%ebp),%eax
    124e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
    1251:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    1254:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
    1256:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1259:	eb 33                	jmp    128e <printf+0x5e>
    125b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    1260:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    1263:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    1268:	83 f8 25             	cmp    $0x25,%eax
    126b:	74 17                	je     1284 <printf+0x54>
  write(fd, &c, 1);
    126d:	83 ec 04             	sub    $0x4,%esp
    1270:	88 5d e7             	mov    %bl,-0x19(%ebp)
    1273:	6a 01                	push   $0x1
    1275:	57                   	push   %edi
    1276:	ff 75 08             	push   0x8(%ebp)
    1279:	e8 55 fe ff ff       	call   10d3 <write>
    127e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
    1281:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    1284:	0f b6 1e             	movzbl (%esi),%ebx
    1287:	83 c6 01             	add    $0x1,%esi
    128a:	84 db                	test   %bl,%bl
    128c:	74 71                	je     12ff <printf+0xcf>
    c = fmt[i] & 0xff;
    128e:	0f be cb             	movsbl %bl,%ecx
    1291:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    1294:	85 d2                	test   %edx,%edx
    1296:	74 c8                	je     1260 <printf+0x30>
      }
    } else if(state == '%'){
    1298:	83 fa 25             	cmp    $0x25,%edx
    129b:	75 e7                	jne    1284 <printf+0x54>
      if(c == 'd'){
    129d:	83 f8 64             	cmp    $0x64,%eax
    12a0:	0f 84 9a 00 00 00    	je     1340 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    12a6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    12ac:	83 f9 70             	cmp    $0x70,%ecx
    12af:	74 5f                	je     1310 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    12b1:	83 f8 73             	cmp    $0x73,%eax
    12b4:	0f 84 d6 00 00 00    	je     1390 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    12ba:	83 f8 63             	cmp    $0x63,%eax
    12bd:	0f 84 8d 00 00 00    	je     1350 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    12c3:	83 f8 25             	cmp    $0x25,%eax
    12c6:	0f 84 b4 00 00 00    	je     1380 <printf+0x150>
  write(fd, &c, 1);
    12cc:	83 ec 04             	sub    $0x4,%esp
    12cf:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    12d3:	6a 01                	push   $0x1
    12d5:	57                   	push   %edi
    12d6:	ff 75 08             	push   0x8(%ebp)
    12d9:	e8 f5 fd ff ff       	call   10d3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    12de:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    12e1:	83 c4 0c             	add    $0xc,%esp
    12e4:	6a 01                	push   $0x1
    12e6:	83 c6 01             	add    $0x1,%esi
    12e9:	57                   	push   %edi
    12ea:	ff 75 08             	push   0x8(%ebp)
    12ed:	e8 e1 fd ff ff       	call   10d3 <write>
  for(i = 0; fmt[i]; i++){
    12f2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    12f6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    12f9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    12fb:	84 db                	test   %bl,%bl
    12fd:	75 8f                	jne    128e <printf+0x5e>
    }
  }
}
    12ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1302:	5b                   	pop    %ebx
    1303:	5e                   	pop    %esi
    1304:	5f                   	pop    %edi
    1305:	5d                   	pop    %ebp
    1306:	c3                   	ret
    1307:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    130e:	00 
    130f:	90                   	nop
        printint(fd, *ap, 16, 0);
    1310:	83 ec 0c             	sub    $0xc,%esp
    1313:	b9 10 00 00 00       	mov    $0x10,%ecx
    1318:	6a 00                	push   $0x0
    131a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    131d:	8b 45 08             	mov    0x8(%ebp),%eax
    1320:	8b 13                	mov    (%ebx),%edx
    1322:	e8 59 fe ff ff       	call   1180 <printint>
        ap++;
    1327:	89 d8                	mov    %ebx,%eax
    1329:	83 c4 10             	add    $0x10,%esp
      state = 0;
    132c:	31 d2                	xor    %edx,%edx
        ap++;
    132e:	83 c0 04             	add    $0x4,%eax
    1331:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1334:	e9 4b ff ff ff       	jmp    1284 <printf+0x54>
    1339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    1340:	83 ec 0c             	sub    $0xc,%esp
    1343:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1348:	6a 01                	push   $0x1
    134a:	eb ce                	jmp    131a <printf+0xea>
    134c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    1350:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    1353:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1356:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    1358:	6a 01                	push   $0x1
        ap++;
    135a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    135d:	57                   	push   %edi
    135e:	ff 75 08             	push   0x8(%ebp)
        putc(fd, *ap);
    1361:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1364:	e8 6a fd ff ff       	call   10d3 <write>
        ap++;
    1369:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    136c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    136f:	31 d2                	xor    %edx,%edx
    1371:	e9 0e ff ff ff       	jmp    1284 <printf+0x54>
    1376:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    137d:	00 
    137e:	66 90                	xchg   %ax,%ax
        putc(fd, c);
    1380:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1383:	83 ec 04             	sub    $0x4,%esp
    1386:	e9 59 ff ff ff       	jmp    12e4 <printf+0xb4>
    138b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    1390:	8b 45 d0             	mov    -0x30(%ebp),%eax
    1393:	8b 18                	mov    (%eax),%ebx
        ap++;
    1395:	83 c0 04             	add    $0x4,%eax
    1398:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    139b:	85 db                	test   %ebx,%ebx
    139d:	74 17                	je     13b6 <printf+0x186>
        while(*s != 0){
    139f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    13a2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    13a4:	84 c0                	test   %al,%al
    13a6:	0f 84 d8 fe ff ff    	je     1284 <printf+0x54>
    13ac:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    13af:	89 de                	mov    %ebx,%esi
    13b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
    13b4:	eb 1a                	jmp    13d0 <printf+0x1a0>
          s = "(null)";
    13b6:	bb bd 16 00 00       	mov    $0x16bd,%ebx
        while(*s != 0){
    13bb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    13be:	b8 28 00 00 00       	mov    $0x28,%eax
    13c3:	89 de                	mov    %ebx,%esi
    13c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    13c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    13cf:	00 
  write(fd, &c, 1);
    13d0:	83 ec 04             	sub    $0x4,%esp
          s++;
    13d3:	83 c6 01             	add    $0x1,%esi
    13d6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    13d9:	6a 01                	push   $0x1
    13db:	57                   	push   %edi
    13dc:	53                   	push   %ebx
    13dd:	e8 f1 fc ff ff       	call   10d3 <write>
        while(*s != 0){
    13e2:	0f b6 06             	movzbl (%esi),%eax
    13e5:	83 c4 10             	add    $0x10,%esp
    13e8:	84 c0                	test   %al,%al
    13ea:	75 e4                	jne    13d0 <printf+0x1a0>
    13ec:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    13ef:	31 d2                	xor    %edx,%edx
    13f1:	e9 8e fe ff ff       	jmp    1284 <printf+0x54>
    13f6:	66 90                	xchg   %ax,%ax
    13f8:	66 90                	xchg   %ax,%ax
    13fa:	66 90                	xchg   %ax,%ax
    13fc:	66 90                	xchg   %ax,%ax
    13fe:	66 90                	xchg   %ax,%ax

00001400 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1400:	f3 0f 1e fb          	endbr32
    1404:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1405:	a1 64 1d 00 00       	mov    0x1d64,%eax
{
    140a:	89 e5                	mov    %esp,%ebp
    140c:	57                   	push   %edi
    140d:	56                   	push   %esi
    140e:	53                   	push   %ebx
    140f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1412:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    1414:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1417:	39 c8                	cmp    %ecx,%eax
    1419:	73 15                	jae    1430 <free+0x30>
    141b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    1420:	39 d1                	cmp    %edx,%ecx
    1422:	72 14                	jb     1438 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1424:	39 d0                	cmp    %edx,%eax
    1426:	73 10                	jae    1438 <free+0x38>
{
    1428:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    142a:	8b 10                	mov    (%eax),%edx
    142c:	39 c8                	cmp    %ecx,%eax
    142e:	72 f0                	jb     1420 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1430:	39 d0                	cmp    %edx,%eax
    1432:	72 f4                	jb     1428 <free+0x28>
    1434:	39 d1                	cmp    %edx,%ecx
    1436:	73 f0                	jae    1428 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1438:	8b 73 fc             	mov    -0x4(%ebx),%esi
    143b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    143e:	39 fa                	cmp    %edi,%edx
    1440:	74 1e                	je     1460 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1442:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1445:	8b 50 04             	mov    0x4(%eax),%edx
    1448:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    144b:	39 f1                	cmp    %esi,%ecx
    144d:	74 28                	je     1477 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    144f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    1451:	5b                   	pop    %ebx
  freep = p;
    1452:	a3 64 1d 00 00       	mov    %eax,0x1d64
}
    1457:	5e                   	pop    %esi
    1458:	5f                   	pop    %edi
    1459:	5d                   	pop    %ebp
    145a:	c3                   	ret
    145b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
    1460:	03 72 04             	add    0x4(%edx),%esi
    1463:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1466:	8b 10                	mov    (%eax),%edx
    1468:	8b 12                	mov    (%edx),%edx
    146a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    146d:	8b 50 04             	mov    0x4(%eax),%edx
    1470:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1473:	39 f1                	cmp    %esi,%ecx
    1475:	75 d8                	jne    144f <free+0x4f>
    p->s.size += bp->s.size;
    1477:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    147a:	a3 64 1d 00 00       	mov    %eax,0x1d64
    p->s.size += bp->s.size;
    147f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1482:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1485:	89 10                	mov    %edx,(%eax)
}
    1487:	5b                   	pop    %ebx
    1488:	5e                   	pop    %esi
    1489:	5f                   	pop    %edi
    148a:	5d                   	pop    %ebp
    148b:	c3                   	ret
    148c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001490 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1490:	f3 0f 1e fb          	endbr32
    1494:	55                   	push   %ebp
    1495:	89 e5                	mov    %esp,%ebp
    1497:	57                   	push   %edi
    1498:	56                   	push   %esi
    1499:	53                   	push   %ebx
    149a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    149d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    14a0:	8b 3d 64 1d 00 00    	mov    0x1d64,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    14a6:	8d 70 07             	lea    0x7(%eax),%esi
    14a9:	c1 ee 03             	shr    $0x3,%esi
    14ac:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    14af:	85 ff                	test   %edi,%edi
    14b1:	0f 84 a9 00 00 00    	je     1560 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14b7:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    14b9:	8b 48 04             	mov    0x4(%eax),%ecx
    14bc:	39 f1                	cmp    %esi,%ecx
    14be:	73 6d                	jae    152d <malloc+0x9d>
    14c0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    14c6:	bb 00 10 00 00       	mov    $0x1000,%ebx
    14cb:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    14ce:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    14d5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    14d8:	eb 17                	jmp    14f1 <malloc+0x61>
    14da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14e0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    14e2:	8b 4a 04             	mov    0x4(%edx),%ecx
    14e5:	39 f1                	cmp    %esi,%ecx
    14e7:	73 4f                	jae    1538 <malloc+0xa8>
    14e9:	8b 3d 64 1d 00 00    	mov    0x1d64,%edi
    14ef:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    14f1:	39 c7                	cmp    %eax,%edi
    14f3:	75 eb                	jne    14e0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    14f5:	83 ec 0c             	sub    $0xc,%esp
    14f8:	ff 75 e4             	push   -0x1c(%ebp)
    14fb:	e8 3b fc ff ff       	call   113b <sbrk>
  if(p == (char*)-1)
    1500:	83 c4 10             	add    $0x10,%esp
    1503:	83 f8 ff             	cmp    $0xffffffff,%eax
    1506:	74 1b                	je     1523 <malloc+0x93>
  hp->s.size = nu;
    1508:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    150b:	83 ec 0c             	sub    $0xc,%esp
    150e:	83 c0 08             	add    $0x8,%eax
    1511:	50                   	push   %eax
    1512:	e8 e9 fe ff ff       	call   1400 <free>
  return freep;
    1517:	a1 64 1d 00 00       	mov    0x1d64,%eax
      if((p = morecore(nunits)) == 0)
    151c:	83 c4 10             	add    $0x10,%esp
    151f:	85 c0                	test   %eax,%eax
    1521:	75 bd                	jne    14e0 <malloc+0x50>
        return 0;
  }
}
    1523:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    1526:	31 c0                	xor    %eax,%eax
}
    1528:	5b                   	pop    %ebx
    1529:	5e                   	pop    %esi
    152a:	5f                   	pop    %edi
    152b:	5d                   	pop    %ebp
    152c:	c3                   	ret
    if(p->s.size >= nunits){
    152d:	89 c2                	mov    %eax,%edx
    152f:	89 f8                	mov    %edi,%eax
    1531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    1538:	39 ce                	cmp    %ecx,%esi
    153a:	74 54                	je     1590 <malloc+0x100>
        p->s.size -= nunits;
    153c:	29 f1                	sub    %esi,%ecx
    153e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    1541:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    1544:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    1547:	a3 64 1d 00 00       	mov    %eax,0x1d64
}
    154c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    154f:	8d 42 08             	lea    0x8(%edx),%eax
}
    1552:	5b                   	pop    %ebx
    1553:	5e                   	pop    %esi
    1554:	5f                   	pop    %edi
    1555:	5d                   	pop    %ebp
    1556:	c3                   	ret
    1557:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    155e:	00 
    155f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
    1560:	c7 05 64 1d 00 00 68 	movl   $0x1d68,0x1d64
    1567:	1d 00 00 
    base.s.size = 0;
    156a:	bf 68 1d 00 00       	mov    $0x1d68,%edi
    base.s.ptr = freep = prevp = &base;
    156f:	c7 05 68 1d 00 00 68 	movl   $0x1d68,0x1d68
    1576:	1d 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1579:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    157b:	c7 05 6c 1d 00 00 00 	movl   $0x0,0x1d6c
    1582:	00 00 00 
    if(p->s.size >= nunits){
    1585:	e9 36 ff ff ff       	jmp    14c0 <malloc+0x30>
    158a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    1590:	8b 0a                	mov    (%edx),%ecx
    1592:	89 08                	mov    %ecx,(%eax)
    1594:	eb b1                	jmp    1547 <malloc+0xb7>
