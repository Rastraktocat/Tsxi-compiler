format PE
entry start

include 'win32ax.inc'

section '.data' data readable writeable
Input rb 16
stringlen db ?
basic_stringlen rd 32
variable_save dd 32 dup ?
common_keyword_table db "if", "extif", "while", "func", "loop", "switch", "case", "default", "ret"
func_condition db "ret", 0 ; temporary
loop_conditions db "break", "continue"
data_types db "int", "float", "char", "double", "boolean", "string", "long" ; add more like static
equal_to_keyword db "=", 0 ; assign variables
comparison db "==", 0  ; compare variables
operator_list db "!", "+", "-", "*", "/", "%", "<", ">", "<=", ">=", "&&", "++", "--"
focus_setter_1 db "[", 0
focus_setter_2 db "]", 0
focus_variables db "vectorize", "matrix", "graphical", "data", "system", "regex"
set_focus_variable db 0
condition db "vectorize", "matrix", "graphical", "data", "system"  ; Same as focus variable
scan2 rb 200
file 'C:\Users\Adi\Downloads\fasmw17332\SOURCE\IDE\FASMW\test.txt'
sizer_point rb 20
Check_num db 16
run db 16
size_count rd 32
storage rd 32
lexeme_storage dd 255
control_flow_storage dd 0
array dd ?
temp dd 32
temper dd 32 ; Fix this
timer db 10
word_array dd 32 dup ?
word_array_dup dd 32 dup ?
word_len dd 32 dup ?
-_array_count dd 32
ebx_dup db 12
edi_dup dd 32
fresh_array dd 32 dup ?
focus_opcode db 0
line_count db 0
function_set db 0

section '.idata' import data readable

library msvcrt, 'msvcrt.dll', kernel32, 'kernel32.dll'
import msvcrt, printf, 'printf', scanf, 'scanf', getch, '_getch'

section '.code' code readable writeable executable
start:
        cinvoke printf, 'Enter string.'
        cinvoke scanf, '%s', eax         ; Only takes a single line
        jmp reg_set                      ; Change later to accept a file

reg_set:
        mov ecx, 0
        ;mov al, temp
        ;mov ax, temper
        mov ebx, 0
        mov esi, 0        ; Set registers
        mov [word_array], 0
        mov word_array_count, 0
        mov edi, keyword_table
        ;mov Input, eax         PAY ATTENTION TO THIS LINE
        jmp strlen
strlen:
        inc ecx
        bsf eax, ebp
        cmp ebp, 0
        je temp_reg_reset
        cmp ebp, 32h             ; Separate words from Input
        je new_word_strlen
        cmp ebp, 10h           ; Newline is not being used as of this moment. Newline character
        je new_line_count
        add [word_array], ebp
        xor ebp,ebp
        shr eax, 1
        cmp ecx, 100
        je reset_word_array ; 100 line limit as of now.
        jmp strlen
        ;jmp temp_reg_reset  ;KEEP IN CASE
        ; Change jump location to comparison engine
;new_line_set:
;        mov line_count, 0
;        xor ebp, ebp
;        jmp new_line_count
new_line_count:                 ; Change to make input able to take multiple lines
        inc line_count
        jmp strlen
        ;jmp temp_reg_reset
temp_reg_reset:                ;Test solution
       ;mov temp, eax
       ;mov temper, ebx
        mov eax, temp      ; These may be pointless
        mov ebp, temper  ; In case temper is needed
        jmp comparison_engine
new_word_strlen:
        inc [word_array]
        add word_array_count, 1
        mov [word_len], ecx           ;Fix this code
        inc [word_len]      ; Store strlen
        xor ecx, ecx
        jmp strlen
reset_word_array:
        dec [word_array]
        dec word_array_count
        cmp word_array_count, 0
        je comparison_engine
        ; Sets array to default
        mov eax, word_array
        xor ecx, ecx
        ;dec [word_array_count]              ; Set jump location
        jmp reset_word_array

comparison_engine_2:
        mov temp_ecx, ecx     ; Store temp_ecx
        cmp temp_ecx, 20
        je error                                     ; point = "Hello"
        inc [word_array]
        mov monkey, common_keyword_table ; This will fail
        mov monkey1, data_types
        mov monkey2, operator_list
        mov monkey3, focus_setter_1
        mov monkey4, focus_variables
        mov monkey5, condition
        ;xor ecx, ecx
        cmp word_array, 0
        je ecx_restore
        cmp word_array, 10
keyword_cmp:
        cmp word_array, monkey ; Assume ecx starts at 0
        ;je lex_set       ; Add a ecx param
        inc ecx
        cmp ecx, 14
        je data_cmp
        jmp keyword_cmp
data_cmp:
        cmp word_array, monkey1
        ;je lex_set
        inc ecx
        cmp ecx, 14         ; rewrite to monkey1 size
        je operator_cmp
        jmp data_cmp
operator_cmp:
        cmp word_array, monkey2
        ;je lex_set
        inc ecx
        cmp ecx, 14
        je focus_setter_cmp   ; rewrite to monkey2 size
        jmp operator_cmp
focus_setter_cmp:
        cmp word_array, monkey3
        ;je lex_set
        inc ecx
        cmp ecx, 14     ; rewrite to monkey3 size
        je focus_var_cmp
        jmp focus_setter_cmp
focus_var_cmp:
        cmp word_array, monkey4
        ;je lex_set
        inc ecx
        cmp ecx, 14  ; rewrite to monkey4 size
        je condition_cmp
        jmp focus_var_cmp
condition_cmp:
        cmp word_array, monkey5
        ;je lex_set
        inc ecx
        cmp ecx, 14 ; rewrite to monkey5 size
        je comparison_engine_2
        jmp condition_cmp
lex_set:   ; This is the true backend of the parser/ lexer
        ; ecx set 4 for func
        ; Read func cmp and variable setting
        ; You have to compare each new word_array for any keywords




; When adding more lists use same cmp format as the above.
comparison_engine:                       ; Take word_array as input
        inc ecx
        cmp ecx, 20             ; Check for infinite loop
        je error   ; Comparison overflow error
        cmp edi, 0    ; cmp word_array, 0
        je ecx_restore    ; Treat null string
        cmp edi,10    ; cmp word_array, 10
        je secondary_comparison_engine        ; Skips index
        cmp edi, temp            ; See if this doesn't work
        ;cmp eax, word_array
        jne remove_from_array
        cmp edi, temp            ; Check for similarity
        je array_storage
        inc edi
        inc [edi_dup]
        jmp comparison_engine
ecx_restore:
        dec ecx
        dec edi
        inc [ebx_dup]
        cmp ebx, 0
        je treat_string_num_start
        jmp ebx_restore
treat_string_num_start:
        cmp edi, 10
        je incer       ; Skips index
        inc edi                             ; Makes new list without all the removed values
        mov [fresh_array], edi
        inc [fresh_array]
        cmp edi, 0                           ;MAKE CONDITION WORK!!!
        je set_fresh_array
        jmp treat_string_num_start
check_final_array:
        cmp edi, 1
        je lex_store_control                  ; Check for final array
        jmp comparison_engine
set_fresh_array:
        mov edi, fresh_array                  ; Replaces new list with edi
        jmp check_final_array
incer:
        inc edi
        jmp treat_string_num_start              ; Skips empty array point
        ;dec ebx
        ;mov timer, 0
        ;jmp treat_string_num

remove_from_array:
        mov edi, 10                            ; Sets empty array point keyword
        inc edi
        inc [edi_dup]; Sets index skip value
        jmp comparison_engine
secondary_comparison_engine:
        inc edi                      ;Skips empty index
        jmp comparison_engine
array_storage:
        inc ecx
        add [array], edi
        cmp ecx, 14
        je move_array_word
        inc [array]      ; Possible point of failure
        inc edi
        jmp comparison_engine
set_run:                                ; LIKELY IRRELEVANT!!!
        add [run], 1                    ; Sets run
        jmp move_array_word
move_array_word:
        cmp ecx, 0
        je comparison_engine
        shr [keyword_table],1        ; Resets tables.
        dec ecx
        dec [keyword_table]
        jmp move_array_word

lex_store_control:                  ; Don't delete
        add [lexeme_storage], "cf "   ;Implement Check lookup table for lexer return
                                      ; Add Check lookup opcodes
        jmp comparison_engine
;Lexeme_storage =
;       Focus = f_1, f_2, f_n. the number indicates the index of the array
;       if = if_1, if_2, if_n. The number indicates which if statement the if statement.
;       extif = eif_1, eif_2, eif_n. The n is the number of extif statements that are in the parsed statement.
;       loop = lp_1, lp_2, lp_n.
;

error:
        ;mov ExitProcess,0


parser:
        cmp lexeme_storage, focus_setter_1  ; Go to lexer.asm to fix the code testing
        jne error
focus_settings:                            ; [<focus>]
        cmp lexeme_storage, focus_setter_1
        jne error
        cmp lexeme_storage, focus_setter_2