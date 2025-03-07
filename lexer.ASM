format PE
entry start

include 'win32ax.inc'
include 'macro/if.inc'

section '.data' data readable writeable
        Check_num db 0
        Input db 'zzz', 0
        Monkey rb 20
        Mankey rb 20
        keyword_table db ?
        temper db "Temp input"
        temporary dd 0
        set_focus_variable rd 32
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
condition db "vectorize", "matrix", "graphical", "data", "system"  ; Same as focus variable
scan2 rb 200
file 'C:\Users\Adi\Downloads\fasmw17332\SOURCE\IDE\FASMW\test.txt'
sizer_point rb 20
run db 16
size_count rd 32
storage rd 32
lexeme_storage dd 255
control_flow_storage dd 0
array dd ?
temp dd 32
timer db 10
word_array dw 8 dup ?
word_array_dup dd 32 dup ?
word_len dd 32 dup ?
hyphen_array_count dd 32
ebx_dup db 12
edi_dup dd 32
fresh_array dd 32 dup ?
focus_opcode db 0
line_count db 0
function_set db 0
section '.idata' import data readable

library msvcrt, 'msvcrt.dll', kernel32, 'kernel32.dll'
import msvcrt, printf, 'printf', scanf, 'scanf', getch, '_getch'

section '.text' code readable writeable executable

; Lex tokens embeded_if_statement, embeded_for_statement, while_statement,


; Start from top and look for a focus.
start:                                     ; THIS CODE WILL NOT WORK!!!
        mov ax, temper
        jmp handling
handling:
        bsf ax, dx
        cmp dx, 32h
        je space_handling
        add [word_array], dx
        jmp handling
        ;call the comparison engine
        ;Check for focus settings
space_handling:
        inc [word_array]            ; This process does not work
        shr ax, 1
        jmp handling
focus_check_line:
        mov ecx, 0      ;Allocate if necessary
        cmp [word_array], 91h ; FIX THIS. LOAD PROPER ARRAY LOCATION!!!
        je focus_settings
focus_input:
        mov eax, temporary    ; Replace eax with word array in actual script
        bsf eax, ebx
        add [set_focus_variable], ebx
        shr ebx, 1
        cmp ecx, 10
        je focus_error ; Likely will need a different error code
        xor ecx, ecx
        jmp focus_settings
focus_settings:
        inc ecx
        cmp ecx, 6
        je focus_error
        inc [focus_variable]
        cmp set_focus_variable, focus_variable
        je focus_confirm
        jmp focus_error

focus_error:
        ret        ; Implement error code for focus not defined in compiler
focus_confirm:
        mov focus_opcode, ecx        ;Fix this code
        xor ecx, ecx
        xor eax, eax
        xor ebx, ebx
        cmp lexeme_storage, focus_setter_2
        jne error
        cmp lexeme_storage, 10h
        ; jump to the next array point
func_check_line:
        mov eax, temporary
        cmp lexeme_storage, "func"; This will likely be replaced with some other variable
        je func_param_set_1
func_param_set_1:
        inc lexeme_storage
        jmp func_param_set_2
func_param_set_2:                 ; CODE IS EXTREMELY BROKEN. FIX LATER!!!
        cmp eax,58h ; : = 58h
        je func_condition_check
        bsf eax,edx
        add [function_var_storage], edx
        add [func_check], edx
        shr eax,1
        xor edx,edx
        jmp func_param_set_2
func_var_size:
        inc [func_var_sizer]
        jmp func_condition_check
func_condition_check:
        shr eax,1 ; Try implementing stack to use local variables
        cmp eax, 32h  ;Function Condition start err
        jmp next_line_ready
        cmp eax,58h ;: = 58h
        je function_store
        cmp eax,10h
        je error
        add [func_condition], eax

push_var_storage:
        push function_var_storage
        push func_var_sizer
        jmp func_condition_check
func_condition_check
        cmp func_check, function_var_storage
        je error ; Function already initialized
        dec func_var_sizer
        dec function_var_storage
        cmp func_var_sizer, 0
        jmp func_condition_check
pop_var_storage:
        pop function_var_storage
        pop func_var_sizer
        jmp function_store
function_store:
        inc func_condition
        jmp func_next_line_ready
func_next_line_ready:
        inc lexeme_storage  ;Fix code
        mov eax, lexeme_storage       ; make a variable called function storage
        bsf eax, edx
        shl edx,1; Account for shr on condition check
        cmp edx, 32h
        je next_line_ready                                  ; LOOK AT FUNCTION CODE!!!
        cmp eax, keyword_table ; Make sure that this actually works

        jmp func_condition_check

if_confirm:
        xor eax, eax
        mov eax, temporary
        cmp lexeme_storage, "if"
        je first_condition_set
        ; Set a jump location to a lexeme_storage reader
lexeme_move_1:               ; Could likely be called if necessary
        inc lexeme_storage
        jmp first_condition_set ; Would have to use ret if it is being called
lexeme_move_2:
        inc lexeme_storage
        mov eax, lexeme_storage
        jmp second_condition_set
first_condition_set:
        bsf eax, edx
        shr eax, 1
        cmp edx, 44h
        je second_condition_set
        add [first_condition], edx
        jmp first_condition_set
second_condition_set:
        bsf eax, edx
        shr eax, 1
        cmp edx, 32h
        je second_condition_set
        cmp edx, 58h
        jmp if_next_line_ready
        add [second_condition], edx
        jmp second_condition_set
if_next_line_ready:
        inc lexeme_storage  ;Fix code
        mov eax, lexeme_storage       ; make a variable called condition storage
        bsf eax, edx
        shl edx,1; Account for shr on condition check
        cmp edx, 10h
        je if_next_line_ready
        jmp keyword_table_check
        cmp eax, keyword_table ; Make sure that this actually works
        ; Set an actually useful jump location
        jmp func_condition_check
kewyord_table_check:
        cmp eax, keyword_table
        je            ; Set jump location
        inc keyword_table
        inc ecx
        cmp ecx, 15 ; Will likely change later
        je error
        jmp keyword_table_check



possible_save:
        cmp data_types, 0
        je error; The this is bullshit error
        cmp eax, data_types
        je variable_dec
        inc data_types
        jmp possible_save
variable_dec:                   ; MAKE COMPATIBLE WITH LEXEME_
        inc variable_save
        shr eax, 1
        cmp variable_save, 0
        je variable_contents
        add variable_save, eax
        jmp variable_dec
variable_contents:
        inc [var_assigns]
        mov var_assigns, variable_save
        ret ; May not work



; bss keyword table example
; common_keyword_table db "if", "extif", "while", "func", "loop", "switch", "case", "default"
; func condition db "ret"
; loop conditions db "break", "continue"
;data_types db "int", "float", "double", "long", "char", "string", "boolean", "void"


;data_types db "int", "float", "dfloat", "dint"
;numbers db "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
;numbers_mod db "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "."
; truth_table db "true", "false", "True", "False"

;check_int_dec:                ; Check if an array is more optimized.
        cmp word_array, "int"
        je int_save
        jmp int_start_save
;check_float_dec:
        cmp word_array, "float"
        je int_save
        jmp float_start_save
;check_dfloat_dec:
        cmp word_array, "dfloat"
        je int_save
        jmp dfloat_start_save
;check_dint_dec:
        cmp word_array, "dint"
        je int_save
        jmp dint_start_save
;check_bool_dec:
        cmp word_array, "bool"
        je bool_save
        jmp bool_start_save
int_start_save:
        inc [word_array]
        mov eax, word_array
        cmp ecx, 0
        jmp int_save
int_save:
        bsf eax, edx
        add int_save, edx
        shr eax, 1
        cmp edx, 0
        je int_cmp
        jmp int_save
int_cmp:
        inc ecx
        cmp int_save, truth_table
        je variable_save
        cmp ecx, 11
        je error  ; bool error
        jmp int_cmp
float_start_save:
        inc [word_array]
        mov eax, word_array
        cmp ecx, 12
        jmp float_save
float_save:
        bsf eax, edx
        add float_save, edx
        shr eax, 1
        cmp edx, 0
        je float_cmp
        jmp float_save
float_cmp:
        inc ecx
        cmp float_save, truth_table
        je variable_save
        cmp ecx, 5
        je error  ; bool error
        jmp float_cmp
dfloat_start_save:
        inc [word_array]
        mov eax, word_array
        cmp ecx, 0
        jmp dfloat_save
dfloat_save:
        bsf eax, edx
        add dfloat_save, edx
        shr eax, 1
        cmp edx, 0
        je dfloat_cmp
        jmp dfloat_save
dfloat_cmp:
        inc ecx
        cmp dfloat_save, truth_table
        je variable_save
        cmp ecx, 5
        je error  ; bool error
        jmp dfloat_cmp
dint_start_save:
        inc [word_array]
        mov eax, word_array
        cmp ecx, 0
        jmp dint_save
dint_save:
        bsf eax, edx
        add dint_save, edx
        shr eax, 1
        cmp edx, 0
        je dint_cmp
        jmp dint_save
dint_cmp:
        inc ecx
        cmp dint_save, truth_table
        je variable_save
        cmp ecx, 12
        je error  ; bool error
        jmp dint_cmp
bool_start_save:
        inc [word_array]
        mov eax, word_array
        cmp ecx, 0
        jmp bool_save
bool_save:
        bsf eax, edx
        add bool_save, edx
        shr eax, 1
        cmp edx, 0
        je bool_cmp
        jmp bool_save
bool_cmp:
        inc ecx
        cmp bool_save, truth_table
        je variable_save
        cmp ecx, 5
        je error  ; bool error
        jmp bool_cmp
void_start_save:                                   ;je error
        inc [word_array]                           ;jmp bool_cmp
        mov eax, word_array
        cmp ecx, 0
        jmp void_save
void_save:
        inc ecx
        bsf eax, edx
        add void_save, edx
        shr eax, 1
        cmp edx, truth_table
        je variable_save_void
        cmp ecx, 4
        je error ;bool error
        inc [truth_table]
        jmp void_save
variable_save_void:
        inc [word_array]
        mov word_temp_str, word_array
        cmp word_array, "="
        jne error
        add [variable_save], word_temp_str
        jmp variable_store_void
variable_store_void:
        inc [word_array]
        cmp word_array, 10h
        je global_handle
        cmp word_array, "\"        ; FIX THIS CODE
        je variable_special_sit    ; V2 variable store
variable_save:
        inc [word_array]
        mov word_temp_str, word_array
        cmp word_array, "="
        jne error
        add [variable_save], word_temp_str
        jmp variable_store
variable_store:
        inc [word_array]
        cmp word_array, 10h
        je global_handle
        cmp word_array, "\"        ; Fix this code
        je variable_special_sit    ; V2 variable store
variable_special_sit:
        inc [word_array]
        ;cmp common_keyword_table, word_array
        ;je
        cmp word_array, "ret"
        je ret_handle
        mov word_temp_str, word_array
        add [variable_save], word_temp_str
        jmp global_handle
ret_handle:
        inc [word_array]
        cmp word_array, 10h
        je global_handle
        add [variable_save], word_temp_str
        jmp ret_handle
;global_handle:
        inc [word_array_count]
        cmp word_array, common_keyword_table
        je
        cmp word_array, data_types
        je variable_save
        func_param_set_1:
        inc lexeme_storage
        jmp func_param_set_2
func_param_set_2:                 ; CODE IS EXTREMELY BROKEN. FIX LATER!!!
        cmp eax,58h ; : = 58h
        je func_condition_check
        bsf eax,edx
        add [function_var_storage], edx
        add [func_check], edx
        shr eax,1
        xor edx,edx
        jmp func_param_set_2
func_var_size:
        inc [func_var_sizer]
        jmp func_condition_check
func_condition_check:
        shr eax,1 ; Try implementing stack to use local variables
        cmp eax, 32h  ;Function Condition start err
        jmp next_line_ready
        cmp eax,58h ;: = 58h
        je function_store
        cmp eax,10h
        je error
        add [func_condition], eax

push_var_storage:
        push function_var_storage
        push func_var_sizer
        jmp func_condition_check
func_condition_check
        cmp func_check, function_var_storage
        je error ; Function already initialized
        dec func_var_sizer
        dec function_var_storage
        cmp func_var_sizer, 0
        jmp func_condition_check
pop_var_storage:
        pop function_var_storage
        pop func_var_sizer
        jmp function_store
function_store:
        inc [func_condition]
        jmp func_next_line_ready
func_next_line_ready:
        inc lexeme_storage  ;Fix code
        mov eax, lexeme_storage       ; make a variable called function storage
        bsf eax, edx
        shl edx,1; Account for shr on condition check
        cmp edx, 32h
        je next_line_ready                                  ; LOOK AT FUNCTION CODE!!!
        cmp eax, keyword_table ; Make sure that this actually works

        jmp func_condition_check

pre_global_handle:
        inc [word_array]
        jmp global_handle
global_handle:                ; Check if an array is faster
        ; Check if things under are faster
        ; mov eax, word_array
        ; bsf eax, edx
        ; Replace edx with word_array
        cmp word_array, "str"
        je str_start_save
        cmp word_array, "int"
        je int_variable_check
        cmp word_array, "float"
        je float_variable_check
        cmp word_array, "dfloat"
        je dfloat_variable_check
        cmp word_array, "bool"
        je bool_variable_check
        cmp word_array, "dint"
        je dint_variable_check
        ;cmp word_array, "void"
        ;je void_variable_check
        cmp word_array, "func"
        je func_set
        cmp word_array, "if"
        je lexeme_move_1
        cmp word_array, "while"
        je while_confirm
        cmp word_array, "loop"
        je loop_confirm
        jmp pre_global_handle
func_set:
        inc [word_array]
        cmp word_array, "str"
        je str_func_start
        cmp word_array, "int"
        je int_func
        cmp word_array, "float"
        je float_func
        cmp word_array, "dfloat"
        je dfloat_func
        cmp word_array, "bool"
        je bool_func
        cmp word_array, "dint"
        je dint_func
        cmp word_array, "void"
        je void_func
        jmp error; func type not set

loop_confirm:
        inc [word_array]
        mov eax, word_array
        cmp eax, 40h
        je loop_confirm_2

loop_confirm_2:
        inc [word_array]
        mov eax, word_array
        bsf eax, edx
        add [loop_contents], edx
        cmp edx, 0
        je loop
loop_confirm_3:
        inc [word_array]
        mov eax, word_array
        cmp eax, ")"
        je loop_execute
        cmp eax, ","
        jne error
        jmp loop_confirm

loop_execute:




lexeme_move_1:               ; Could likely be called if necessary
        inc [word_array]
        jmp if_first_condition_confirm ; You would have to use ret if it is being called
if_first_condition_confirm:
        bsf eax, edx
        shr eax, 1
        cmp edx, 44h
        je if_second_condition_set
        cmp edx, 41h
        je if_next_line_ready
        add [if_first_condition], edx
        jmp if_first_condition_confirm
if_second_condition_set:
        inc [word_array]
        add [param_num], 1
        jmp if_second_condition_confirm
if_second_condition_confirm:
        bsf eax, edx
        shr eax, 1
        cmp edx, 58h
        jmp if_next_line_ready
        add [if_second_condition], edx
        jmp if_second_condition_confirm
if_next_line_ready:
        inc [word_array]
        mov eax, word_array
        jmp if_next_line_confirm
if_next_line_confirm:
        bsf eax, edx
        shr eax, 1; Account for shr on condition check
        cmp edx, 0
        je if_next_line_ready
        cmp edx, 10h
        je if_next_line_ready
        jmp keyword_table_check
        jmp func_condition_check
kewyord_table_check:
        cmp eax, keyword_table
        je            ; Set jump location
        inc keyword_table
        inc ecx
        cmp ecx, 15 ; Will likely change later
        je error
        jmp keyword_table_check



str_func_start:
        inc [word_array]
        mov eax, word_array
        jmp str_func
str_func:
        inc ecx
        bsf eax, edx
        shr eax, 1
        cmp edx, "("
        je str_func_param_set
        add [str_func_list], edx
        cmp ecx, 100
        je error
        jmp str_func
str_func_param_set:
                             ; Fix this
        shr eax,1
        bsf eax, edx
        cmp edx, 0
        je error  ; func syntax error
        add [str_func_params_list], edx
        cmp edx, ","
        je str_func_params_excess
        cmp edx, ")"
        je str_func_conditions_start
        jmp str_func_param_set

str_func_param_excess:
        inc [str_func_params_list]
        mov eax, str_func_params_list
        jmp str_list_monkey
str_list_monkey

        bsf eax, edx
        shr eax, 1
        cmp edx, ","
        je str_func_param_excess
        cmp edx, ")"
        je str_list_banana
        add [str_func_params_list], edx
        jmp str_list_monkey

str_list_banana:
        bsf eax, edx
        cmp edx, ":"
        je str_func_conditions_start
str_func_params:

        inc [word_array]
        ;cmp edx, "("
        ;jne error; param not set
        ;shr eax, 1
        bsf eax, edx
        cmp edx, ")"
        jne error; func syntax error
        shr eax, 1
        bsf eax, edx
        cmp edx, ":"
        je str_func_conditions_start
        jmp error ; func syntax error
str_func_conditions_start:
        inc [word_array]
        mov eax, word_array
        jmp str_func_conditions
str_func_conditions:
        ; This will be the place where the function condition is stored
        cmp eax, 10h
        je str_next_line_conditions
        jmp error
str_next_line_conditions:
        inc [word_array]
        cmp word_array, "ret"
        jmp str_ret_use
        add [func_store], word_array
        jmp str_next_line_conditions
str_ret_use:
        inc [word_array]
        mov eax, word_array
        jmp str_variable_cycle
str_variable_cycle:
        cmp int_variables, 0  ; End of array
        je str_variable_ret
        cmp eax, [int_variables]
        je str_ret_confirm
        inc [int_variables]
        jmp str_variable_cycle

str_variable_ret:
        bsf eax, edx
        cmp edx, 34h
        je str_check_works
        add [func_store], edx
        je str_ret_confirm
        jmp error

str_check_works:

        shr eax, 1
        bsf eax, edx
        cmp edx, 0
        je error ; return syntax error
        add [func_store], edx
        cmp edx, 34h
        je pre_global_handle
        jmp str_check_works

int_func_start:
        inc [word_array]
        mov eax, word_array
        jmp int_func
int_func:
        inc ecx
        bsf eax, edx
        shr eax, 1
        cmp edx, "("
        je int_func_param_set
        add [int_func_list], edx
        cmp ecx, 100
        je error
        jmp int_func
int_func_param_set:
                             ; Fix this
        shr eax,1
        bsf eax, edx
        cmp edx, 0
        je error  ; func syntax error
        add [int_func_params_list], edx
        cmp edx, ","
        je int_func_params_excess
        cmp edx, ")"
        je int_func_conditions_start
        jmp int_func_param_set

int_func_param_excess:
        inc [int_func_params_list]
        mov eax, int_func_params_list
        jmp int_list_monkey
int_list_monkey

        bsf eax, edx
        shr eax, 1
        cmp edx, ","
        je int_func_param_excess
        cmp edx, ")"
        je int_list_banana
        add [int_func_params_list], edx
        jmp int_list_monkey

int_list_banana:
        bsf eax, edx
        cmp edx, ":"
        je int_func_conditions_start
int_func_params:

        inc [word_array]
        ;cmp edx, "("
        ;jne error; param not set
        ;shr eax, 1
        bsf eax, edx
        cmp edx, ")"
        jne error; func syntax error
        shr eax, 1
        bsf eax, edx
        cmp edx, ":"
        je int_func_conditions_start
        jmp error ; func syntax error
int_func_conditions_start:
        inc [word_array]
        mov eax, word_array
        jmp int_func_conditions
int_func_conditions:
        inc [word_array]
        mov eax, word_array
        jmp str_func_conditions
int_func_conditions:
        ; This will be the place where the function condition is stored
        cmp eax, 10h
        je int_next_line_conditions
        jmp error
int_next_line_conditions:
        inc [word_array]
        cmp word_array, "ret"
        jmp int_ret_use
        add [int_func_store], word_array
        jmp int_next_line_conditions
int_ret_use:
        inc [word_array]
        mov eax, word_array
        cmp eax, "1"
        je int_ret_confirm
        cmp eax, "2"
        je int_ret_confirm
        cmp eax, "3"
        je int_ret_confirm
        cmp eax, "4"
        je int_ret_confirm
        cmp eax, "5"
        je int_ret_confirm
        cmp eax, "6"
        je int_ret_confirm
        cmp eax, "7"
        je int_ret_confirm
        cmp eax, "8"
        je int_ret_confirm
        cmp eax, "9"
        je int_ret_confirm
        cmp eax, "0"
        je int_ret_confirm
        jmp int_variable_cycle
inc_ret_start:
        inc [word_array]
        mov eax, word_array
        add [int_func_store], eax
        jmp int_variable_cycle
int_variable_cycle:
        inc [int_variables]
        cmp eax, int_variables
        je pre_global_handle
        cmp int_variables, 0
        je error
        jmp int_variable_cycle
  ; This will be the place where the function condition is stored
float_func_start:
        inc [word_array]
        mov eax, word_array
        jmp float_func
float_func:
        inc ecx
        bsf eax, edx
        shr eax, 1
        cmp edx, "("
        je float_func_param_set
        add [float_func_list], edx
        cmp ecx, 100
        je error
        jmp float_func
float_func_param_set:
                             ; Fix this
        shr eax,1
        bsf eax, edx
        cmp edx, 0
        je error  ; func syntax error
        add [float_func_params_list], edx
        cmp edx, ","
        je float_func_params_excess
        cmp edx, ")"
        je float_func_conditions_start
        jmp float_func_param_set

float_func_param_excess:
        inc [float_func_params_list]
        mov eax, float_func_params_list
        jmp float_list_monkey
float_list_monkey

        bsf eax, edx
        shr eax, 1
        cmp edx, ","
        je float_func_param_excess
        cmp edx, ")"
        je float_list_banana
        add [float_func_params_list], edx
        jmp float_list_monkey

float_list_banana:
        bsf eax, edx
        cmp edx, ":"
        je float_func_conditions_start
float_func_params:

        inc [word_array]
        ;cmp edx, "("
        ;jne error; param not set
        ;shr eax, 1
        bsf eax, edx
        cmp edx, ")"
        jne error; func syntax error
        shr eax, 1
        bsf eax, edx
        cmp edx, ":"
        je float_func_conditions_start
        jmp error ; func syntax error
float_func_conditions_start:
        inc [word_array]
        mov eax, word_array
        jmp float_func_conditions
float_func_conditions:
        ; This will be the place where the function condition is stored
        cmp eax, 10h
        je float_next_line_conditions
        jmp error
float_next_line_conditions:
        inc [word_array]
        cmp word_array, "ret"
        jmp float_ret_use
        add [float_func_store], word_array
        jmp float_next_line_conditions
float_ret_use:
        inc [word_array]
        mov eax, word_array
        cmp eax, "1"
        je float_ret_confirm
        cmp eax, "2"
        je float_ret_confirm
        cmp eax, "3"
        je float_ret_confirm
        cmp eax, "4"
        je float_ret_confirm
        cmp eax, "5"
        je float_ret_confirm
        cmp eax, "6"
        je float_ret_confirm
        cmp eax, "7"
        je float_ret_confirm
        cmp eax, "8"
        je float_ret_confirm
        cmp eax, "9"
        je float_ret_confirm
        cmp eax, "0"
        je float_ret_confirm
        cmp eax, "."
        je float_ret_confirm
        jmp float_variable_cycle
float_ret_start:
        inc [word_array]
        mov eax, word_array
        add [float_func_store], eax
        jmp float_variable_cycle
float_variable_cycle:
        inc [float_variables]
        cmp eax, float_variables
        je pre_global_handle
        cmp float_variables, 0
        je error
        jmp float_variable_cycle           ; This will be the place where the function condition is stored

dfloat_func_start:
        inc [word_array]
        mov eax, word_array
        jmp dfloat_func
dfloat_func:
        inc ecx
        bsf eax, edx
        shr eax, 1
        cmp edx, "("
        je dfloat_func_param_set
        add [dfloat_func_list], edx
        cmp ecx, 100
        je error
        jmp dfloat_func
dfloat_func_param_set:
                             ; Fix this
        shr eax,1
        bsf eax, edx
        cmp edx, 0
        je error  ; func syntax error
        add [dfloat_func_params_list], edx
        cmp edx, ","
        je dfloat_func_params_excess
        cmp edx, ")"
        je dfloat_func_conditions_start
        jmp dfloat_func_param_set

dfloat_func_param_excess:
        inc [dfloat_func_params_list]
        mov eax, dfloat_func_params_list
        jmp dfloat_list_monkey
dfloat_list_monkey

        bsf eax, edx
        shr eax, 1
        cmp edx, ","
        je dfloat_func_param_excess
        cmp edx, ")"
        je dfloat_list_banana
        add [dfloat_func_params_list], edx
        jmp dfloat_list_monkey

dfloat_list_banana:
        bsf eax, edx
        cmp edx, ":"
        je dfloat_func_conditions_start
dfloat_func_params:

        inc [word_array]
        ;cmp edx, "("
        ;jne error; param not set
        ;shr eax, 1
        bsf eax, edx
        cmp edx, ")"
        jne error; func syntax error
        shr eax, 1
        bsf eax, edx
        cmp edx, ":"
        je dfloat_func_conditions_start
        jmp error ; func syntax error
dfloat_func_conditions_start:
        inc [word_array]
        mov eax, word_array
        jmp dfloat_func_conditions
dfloat_func_conditions:
        inc [word_array]
        mov eax, word_array
        jmp dfloat_func_conditions
dfloat_func_conditions:
        ; This will be the place where the function condition is stored
        cmp eax, 10h
        je dfloat_next_line_conditions
        jmp error
dfloat_next_line_conditions:
        inc [word_array]
        cmp word_array, "ret"
        jmp dfloat_ret_use
        add [dfloat_func_store], word_array
        jmp dfloat_next_line_conditions
dfloat_ret_use:
        inc [word_array]
        mov eax, word_array
        cmp eax, "1"
        je dfloat_ret_confirm
        cmp eax, "2"
        je dfloat_ret_confirm
        cmp eax, "3"
        je dfloat_ret_confirm
        cmp eax, "4"
        je dfloat_ret_confirm
        cmp eax, "5"
        je dfloat_ret_confirm
        cmp eax, "6"
        je dfloat_ret_confirm
        cmp eax, "7"
        je dfloat_ret_confirm
        cmp eax, "8"
        je dfloat_ret_confirm
        cmp eax, "9"
        je dfloat_ret_confirm
        cmp eax, "0"
        je dfloat_ret_confirm
        cmp eax, "."
        je dfloat_ret_confirm
        jmp dfloat_variable_cycle
dfloat_ret_start:
        inc [word_array]
        mov eax, word_array
        add [dfloat_func_store], eax
        jmp dfloat_variable_cycle
dfloat_variable_cycle:
        inc [dfloat_variables]
        cmp eax, dfloat_variables
        je pre_global_handle
        cmp dfloat_variables, 0
        je error
        jmp dfloat_variable_cycle           ; This will be the place where the function condition is stored

bool_func_start:
        inc [word_array]
        mov eax, word_array
        jmp bool_func
bool_func:
        inc ecx
        bsf eax, edx
        shr eax, 1
        cmp edx, "("
        je bool_func_param_set
        add [bool_func_list], edx
        cmp ecx, 100
        je error
        jmp bool_func
bool_func_param_set:
                             ; Fix this
        shr eax,1
        bsf eax, edx
        cmp edx, 0
        je error  ; func syntax error
        add [bool_func_params_list], edx
        cmp edx, ","
        je bool_func_params_excess
        cmp edx, ")"
        je bool_func_conditions_start
        jmp bool_func_param_set

bool_func_param_excess:
        inc [bool_func_params_list]
        mov eax, bool_func_params_list
        jmp bool_list_monkey
bool_list_monkey

        bsf eax, edx
        shr eax, 1
        cmp edx, ","
        je bool_func_param_excess
        cmp edx, ")"
        je bool_list_banana
        add [bool_func_params_list], edx
        jmp bool_list_monkey

bool_list_banana:
        bsf eax, edx
        cmp edx, ":"
        je bool_func_conditions_start
bool_func_params:

        inc [word_array]
        ;cmp edx, "("
        ;jne error; param not set
        ;shr eax, 1
        bsf eax, edx
        cmp edx, ")"
        jne error; func syntax error
        shr eax, 1
        bsf eax, edx
        cmp edx, ":"
        je bool_func_conditions_start
        jmp error ; func syntax error
bool_func_conditions_start:
        inc [word_array]
        mov eax, word_array
        jmp bool_func_conditions
bool_func_conditions:
        ; This will be the place where the function condition is stored
        cmp eax, 10h
        je bool_next_line_conditions
        jmp error
bool_next_line_conditions:
        inc [word_array]
        cmp word_array, "ret"
        jmp bool_ret_use
        add [boolt_func_store], word_array
        jmp bool_next_line_conditions
bool_ret_use:
        inc [word_array]
        mov eax, word_array
        cmp eax, "True"
        je bool_ret_confirm
        cmp eax, "False"
        je bool_ret_confirm
        cmp eax, "true"
        je bool_ret_confirm
        cmp eax, "false"
        jmp bool_variable_cycle
bool_ret_confirm:
        add [bool_func_store], eax
        jmp bool_variable_cycle
bool_variable_cycle:
        inc [bool_variables]
        cmp eax, bool_variables
        je pre_global_handle
        cmp bool_variables, 0
        je error
        jmp bool_variable_cycle           ; This will be the place where the function condition is stored

void_func_start:
        inc [word_array]
        mov eax, word_array
        jmp void_func
void_func:
        inc ecx
        bsf eax, edx
        shr eax, 1
        cmp edx, "("
        je void_func_param_set
        add [void_func_list], edx
        cmp ecx, 100
        je error
        jmp void_func
void_func_param_set:
                             ; Fix this
        shr eax,1
        bsf eax, edx
        cmp edx, 0
        je error  ; func syntax error
        add [void_func_params_list], edx
        cmp edx, ","
        je void_func_params_excess
        cmp edx, ")"
        je void_func_conditions_start
        jmp void_func_param_set

void_func_param_excess:
        inc [void_func_params_list]
        mov eax, void_func_params_list
        jmp void_list_monkey
void_list_monkey

        bsf eax, edx
        shr eax, 1
        cmp edx, ","
        je void_func_param_excess
        cmp edx, ")"
        je void_list_banana
        add [void_func_params_list], edx
        jmp void_list_monkey

void_list_banana:
        bsf eax, edx
        cmp edx, ":"
        je void_func_conditions_start
void_func_params:

        inc [word_array]
        ;cmp edx, "("
        ;jne error; param not set
        ;shr eax, 1
        bsf eax, edx
        cmp edx, ")"
        jne error; func syntax error
        shr eax, 1
        bsf eax, edx
        cmp edx, ":"
        je void_func_conditions_start
        jmp error ; func syntax error
void_func_conditions_start:
        inc [word_array]
        mov eax, word_array
        jmp void_func_conditions
void_func_conditions:             ; Fix this code
        inc [word_array]
        mov eax, word_array
        jmp pre_global_handle
compare_cycle:
        inc [void_variables]
        cmp void_variables, 0
        je void_func_conditions
        cmp eax, void_variables
        jne compare_cycles







str_variable_save:
        inc [word_array]
        mov word_temp_str, word_array
        cmp word_array, "="
        je str_variable_store ; add error
        add [str_variable_save], word_temp_str
        jmp str_variable_store
str_variable_store:
        inc [word_array]
        cmp word_array, 10h
        je global_handle
        cmp word_array, "\"        ; Fix this code
        je str_variable_special_sit    ; V2 variable store
str_variable_special_sit:            ; Rewrite this
        inc [word_array]
        ;cmp common_keyword_table, word_array
        ;je
        cmp word_array, "ret"
        je ret_handle
        mov word_temp_str, word_array
        add [variable_save], word_temp_str
        jmp global_handle
int_variable_check:
        inc [word_array]
        mov eax, word_array
        bsf eax, edx
        cmp edx, 0
        je int_variable_confirm
        add [int_variables], edx
        shr edx, 1
        cmp edx, 0
        jmp int_variable_check
int_variable_confirm:
        cmp word_array, "="
        jne error ; variable definition error
        jmp int_variable_store
int_variable_store:
        add [int_variable_save], word_temp_str
        xor word_temp_str, word_temp_str
        inc [word_array]
        cmp word_array, 10h
        jne error; too many paramters
        jmp global_handle
float_variable_check:
        inc [word_array]
        mov eax, word_array
        bsf eax, edx
        cmp edx, 0
        je float_variable_confirm
        add [float_variables], edx
        shr edx, 1
        cmp edx, 0
        jmp float_variable_check
float_variable_confirm:
        cmp word_array, "="
        jne error ; variable definition error
        inc [word_array]
        jmp float_variable_store
float_variable_store:
        add [float_variable_save], eax
        xor eax, eax
        inc [word_array]
        cmp word_array, 10h
        jne error; too many paramters
        jmp global_handle
dfloat_variable_check:
        inc [word_array]
        mov eax, word_array
        bsf eax, edx
        cmp edx, 0
        je dfloat_variable_confirm
        add [dfloat_variables], edx
        shr edx, 1
        cmp edx, 0
        jmp dfloat_variable_check
dfloat_variable_confirm:
        cmp word_array, "="
        jne error ; variable definition error
        inc [word_array]
        jmp dfloat_variable_store
dfloat_variable_store:
        add [dfloat_variable_save], eax
        xor eax, eax
        inc [word_array]
        cmp word_array, 10h
        jne error; too many paramters
        jmp global_handle
bool_variable_check:
        inc [word_array]
        mov eax, word_array
        bsf eax, edx
        cmp edx, 0
        je bool_variable_confirm
        add [bool_variables], edx
        shr edx, 1
        cmp edx, 0
        jmp bool_variable_check
bool_variable_confirm:
        cmp word_array, "="
        jne error ; variable definition error
        inc [word_array]
        jmp bool_variable_store
bool_variable_store:
        add [bool_variable_save], eax
        xor eax, eax
        inc [word_array]
        cmp word_array, 10h
        jne error; too many paramters
        jmp global_handle
dint_variable_check:
        inc [word_array]
        mov eax, word_array
        bsf eax, edx
        cmp edx, 0
        je dint_variable_confirm
        add [dint_variables], edx
        shr edx, 1
        cmp edx, 0
        jmp dint_variable_check
dint_variable_confirm:
        cmp word_array, "="
        jne error ; variable definition error
        inc [word_array]
        mov eax, word_array
        jmp dint_variable_store
dint_variable_store:
        bsf eax, edx
        add [dint_variable_save], edx
        shr edx, 1
        cmp word_array, 10h
        je global_handle
        cmp edx, ","
        je dint_variable_comma_start
        cmp edx, 32h
        je global_handle
        cmp edx, 0
        jne dint_variable_store
        xor eax, eax
        inc [word_array]
        jmp global_handle
dint_variable_comma_start:
        inc [word_array]
        mov eax, word_array
        inc [dint_variable_save]
        jmp dint_variable_comma
dint_variable_comma:
        bsf eax, edx
        add [dint_variable_save], eax
        shr edx, 1
        cmp edx, 0
        je global_handle
        cmp edx, 10h
        je global_handle
        cmp edx, 32h
        je global_handle
        cmp edx, ","
        je dint_variable_comma_start
        jmp dint_variable_comma
;func_variable_check:
        inc [word_array]
        mov word_temp_func, word_array
        cmp word_array, "="
        jne error ; variable definition error
        jmp func_variable_store
;func_variable_store:
        add [func_variable_save], word_temp_func
        xor word_temp_func, word_temp_func
        inc [word_array]
        cmp word_array, 10h
        jne error; too many paramters
        jmp global_handle