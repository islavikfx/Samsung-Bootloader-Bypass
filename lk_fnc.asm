; lk.img (Little Kernel) // SW REV CHECK Bypass
; Samsung A32 (SM-A325F) // MT6769T


; fcn 1 / get_anti_rollback_ignore:
.org 0xe721c
; Original:
;   get_anti_rollback_ignore:
;       STP  X29, X30, [SP, #-0x10]!
;       MOV  X29, SP
;       BL   get_anti_rollback_secure_group_ver
;       CMP  W0, #0
;       B.NE .L_ignore
;       MOV  W0, #0
;       LDP  X29, X30, [SP], #0x10
;       RET
;   .L_ignore:
;       MOV  W0, #1
;       LDP  X29, X30, [SP], #0x10
;       RET
; Fix:
    MOV  W0, #1         ; 20 00 80 52 - return 1
    RET                 ; c0 03 5f d6


; fnc 2 / po_check_rp_handler:
.org 0x11a5c
; Original:
;   po_check_rp_handler:
;       PUSH   {R4-R7, LR}          ; f0 b5
;       MOV    R4, R0
;       BL     get_anti_rollback_ignore
;       CMP    R0, #0               ; 00 28
;       BEQ    .L_check
;       MOV    R0, #0
;       POP    {R4-R7, PC}
;   .L_check:
;       BL     _check_rp_version
;       CMP    R0, #0
;       BNE    .L_fail
;       MOV    R0, #0
;       POP    {R4-R7, PC}
;   .L_fail:
;       LDR    R0, =SW_REV_CHECK_FAIL_STR
;       BL     printf
;       MOV    R0, #-1              ; ff 20
;       POP    {R4-R7, PC}          ; f0 bd
; Fix:
    MOV  R0, #0          ; 00 20 - return 0
    BX   LR              ; 70 47


; strings:
.org 0xdf044
    .ascii "SW REV CHECK OK  "
.org 0xdf060
    .ascii "Fused %d = Binary %d"