# CSpawn virus modification in Assembly Language
This program is the solution to exercise 4 from page 48 of The Giant Black Book of Computer Viruses by Mark A. Ludwig:

*Add a routine to CSpawn which will demand a password before executing the host, and will exit without executing the host if it doesn't get the right password. You can hard-code the required password.*

Steps:
- I created the procedure CHK_PASSWORD, which is called before executing the host, on line 14. Before calling the procedure, I pushed on the stack the address of the PASSWORD variable. The PASSWORD variable is defined as a DB (2 bytes), and is initialized as "secretPassword". 
- Then, using the Stack Pointer and the Base Pointer registers, I got the offset of the password from the stack. I indexed BP because the return address is the first element in BP and then we have the offset of the password.
- I used the 09h function from the DOS INT 21h, which writes a string to standard output. I'm writing the variable PROMPT, which is defined as a DB and has the value "Enter password".
- Next, I'm using the 06 function which manages the console input and also I'm using buffered input since I'm reading an entire string using 0A.
- After that, I'm comparing the string read from the keyboard with the password. If they are equal we jump to the execute label which continues the virus and executes the host. if they are not equal we just jump to the label exit which jumps to the end of the procedure and doesn't execute the host.
- the RET instruction returns from the procedure and is equivalent to POP IP, which instructs the program to continue executing from the code from where the procedure was called. 