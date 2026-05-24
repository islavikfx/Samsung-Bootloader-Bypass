; lk.img (Little Kernel) // SW REV CHECK Bypass
; Samsung A32 (SM-A325F) // MT6769T


; fcn 1: get_anti_rollback_ignore @ 0xE721C:
.org 0xE721C
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
    MOV  W0, #1         ; 20 00 80 52 - always return 1
    RET                 ; C0 03 5F D6


; fnc 2: po_check_rp_handler @ 0x11A5C:
.org 0x11A5C
; Original:
;   po_check_rp_handler:
;       PUSH   {R4-R7, LR}          ; F0 B5
;       MOV    R4, R0
;       BL     get_anti_rollback_ignore
;       CMP    R0, #0               ; 00 28
;       BEQ    .L_check             ; xx D0
;       MOV    R0, #0               ; 00 20
;       POP    {R4-R7, PC}          ; F0 BD
;   .L_check:
;       BL     _check_rp_version
;       CMP    R0, #0               ; 00 28
;       BNE    .L_fail
;       MOV    R0, #0               ; 00 20
;       POP    {R4-R7, PC}          ; F0 BD
;   .L_fail:
;       LDR    R0, =SW_REV_CHECK_FAIL_STR
;       BL     printf
;       MOV    R0, #-1              ; FF 20
;       POP    {R4-R7, PC}          ; F0 BD
; Fix:
    MOV  R0, #0          ; 00 20 - return 0 (success)
    BX   LR              ; 70 47


; strings:
.org 0xDF044
    .ascii "SW REV CHECK OK  "
.org 0xDF060
    .ascii "Fused %d = Binary %d"