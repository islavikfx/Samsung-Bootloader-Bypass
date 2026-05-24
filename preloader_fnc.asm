; preloader.img // Image Version Check Bypass
; Samsung A32 (SM-A325F) // MT6769T


; fnc 1: img_ver_check @ 0x338c0:
.org 0x338c0
; Original:
;   img_ver_check:
;       PUSH   {R4-R7, LR}          ; F0 B5
;       SUB    SP, SP, #0x...       ; allocate stack
;       LDR    R4, =IMG_VER_FAIL_STR
;       BL     get_otp_ver          ; read eFuse version
;       CMP    R0, #12              ; check fused ver (0x0C)
;       BNE    .L_fail
;       BL     check_image_hash
;       CMP    R0, #0
;       BNE    .L_fail
;       MOV    R0, #0               ; success
;       ADD    SP, SP, #0x...
;       POP    {R4-R7, PC}          ; F0 BD
;   .L_fail:
;       LDR    R0, =img_ver_check_fail_str
;       BL     printf
;       MOV    R0, #-1
;       ADD    SP, SP, #0x...
;       POP    {R4-R7, PC}          ; F0 BD
; Fix:
    MOV  R0, #0          ; 00 20 - return 0 (success)
    BX   LR              ; 70 47


; fnc 2: secondary_ver_check @ 0x3394c:
.org 0x3394c
; Original:
;   secondary_ver_check:
;       PUSH   {R4-R7, LR}          ; F0 B5
;       ... ver check logic ...
;       POP    {R4-R7, PC}          ; F0 BD
; Fix:
    MOV  R0, #0          ; 00 20 - return 0 (success)
    BX   LR              ; 70 47


; strings:
.org 0x38A23
    .ascii "img ver check ok  "