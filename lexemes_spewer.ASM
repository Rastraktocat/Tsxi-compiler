format PE
entry start
include 'win32a.inc'   ; Use for file attribution
;include 'kernel32.inc' ; Will be used for file attribution
section '.data' data readable writeable
        Input db "Hello World.", 0; This is a placholder
        string_store rd 32
        ;FilePath db 'C:\Users\Adi\Documents\IR.txt', 0   ; This is the File Path for the creation of the file
        ;hFile dd 0
        ;BytesRead dd 0
        ;BytesWritten dd 0
        ;Buffer rb 256
        ;Buffer.size equ ($ - Buffer) ; Calculates the size at compile time
        ;NULL equ 0
        if_ db "if", 0
        extif_ db "extif", 0
        while_ db "while", 0
        func_ db "func", 0
        loop_ db "loop", 0
        switch_ db "switch", 0
        case_ db "case", 0
        default_ db "default", 0
        return_ db "ret", 0
        int_ db "int", 0
        float_ db "float", 0
        double_ db "double", 0
        bool_ db "boolean", 0
        string_ db "string",0
        long_ db "long", 0
        void_ db "void", 0
        hpalc_ db "hpalc", 0
        while_contents rq 128
section '.code' data readable executable
        start:
                mov eax, Input
                jmp str_work
        str_work:
                bsf eax, edx
                shr eax, 1
                cmp edx, 32h
                je str_sep
                add [string_store], edx
                jmp str_work
        str_sep:
                mov ebx, if_
                cmp [string_store], ebx
                je if_handle
                mov ebx, while_
                cmp [string_store], ebx
                je while_handle
                mov ebx, func_
                cmp [string_store], ebx
                je func_handle
                mov ebx, loop_
                cmp [string_store], ebx
                je loop_handle_1
                mov ebx, switch_
                cmp [string_store], ebx
                ;je switch_handle
                mov ebx, int_
                cmp [string_store], ebx
                ;je error
                mov ebx, float_
                cmp [string_store], ebx
                ;je error
                mov ebx, bool_
                cmp [string_store], ebx
                ;je error
                mov ebx, double_       ; also known as dfloat
                cmp [string_store], ebx
                ;je error
                mov ebx, string_
                cmp [string_store], ebx
                ;je error
                mov ebx, long_
                cmp [string_store], ebx
                ;je void_handle
                mov ebx, void_
                cmp [string_store], ebx
                ;je error
                mov ebx, hpalc_
                cmp [string_store], ebx
                ;je error
                jmp error

                ;invoke CreateFile,FilePath,GENERIC_WRITE,NULL,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL
                ;mov [hFile],eax
                ;invoke WriteFile,[hFile],Buffer,Buffer.size,BytesRead,NULL
                ;invoke CloseHandle,[hFile] ; done


                ;add to IR folder


        loop_handle_1:
                ; mov [hFile], ebx
                jmp loop_handle_2
        loop_handle_2:
                mov [string_store], 0
                shr eax, 1
                bsf eax, edx
                cmp edx, 32h
                jne error
                jmp loop_handle_3
        loop_handle_3:
                add [string_store], edx
                cmp [string_store], "i"
                je check_new_int_variable
                cmp [string_store], "f"
                je check_new_float_variable
                cmp [string_store], "d"
                je check_new_dfloat_variable
                cmp [string_store], "q"
                je check_new_qfloat_variable
                cmp [string_store], "u"
                je check_new_unsigned_variable
                cmp edx, 10h
                je read_loop_contents_1

        number_engine:

        read_loop_contents_1:
                shr eax, 1
                bsf eax, edx
                cmp edx, 9h
                je read_loop_contents_2
                jne str_work ; break out of loop
        read_loop_contents_2:
                mov ecx, 0
                shr eax, 1
                bsf eax, edx
                cmp edx, 10h
                je read_loop_contents_1
                add [string_store], edx      ;
                cmp [string_store], "i"
                je check_new_int_variable
                cmp [string_store], "f"
                je check_new_float_variable
                cmp [string_store], "d"
                je check_new_dfloat_variable
                cmp [string_store], "q"
                je check_new_qfloat_variable
                cmp [string_store], "u"
                je check_new_unsigned_variable
                jmp var_loop_1; Change jump location to a presigned variable location
        check_new_int_variable:
                inc ecx
                shr eax, 1
                bsf eax, edx
                add [string_store], edx
                cmp [string_store], 10h
                je var_loop_1
                cmp ecx, 2
                je finalize_check_int_variable
                jmp check_new_int_variable
        finalize_check_int_variable:
                cmp [string_store], "int"
                jne var_loop_1
                mov ebx, string_store
                ; mov [hFile], ebx
                jmp read_variable_int_1
        read_variable_int_1:
                shr eax, 1
                bsf eax, edx
                cmp edx, 32h
                jne error; Actual error
                jmp read_variable_int_2
        read_variable_int_2:
                shr eax, 1
                bsf eax, edx
                cmp edx, 10h
                je read_loop_contents_1; je read_variable_int_3
                add [string_store], edx
                jmp read_variable_int_2

        read_variable_int_3:
                cmp [string_store], 0
                js error ;Signed variable error
                jmp read_loop_contents_1

        check_new_float_variable:
                inc ecx
                shr eax, 1
                bsf eax, edx
                add [string_store], edx
                cmp [string_store], 10h
                je var_loop_1
                cmp ecx, 4
                je finalize_check_float_variable
                jmp check_new_float_variable
        finalize_check_float_variable:
                cmp [string_store], "float"
                jne var_loop_1
                mov ebx, string_store
                ; mov [hFile], ebx
                jmp read_variable_float_1
        read_variable_float_1:
                shr eax, 1
                bsf eax, edx
                cmp edx, 32h
                jne error; Actual error
                jmp read_variable_float_2
        read_variable_float_2:
                shr eax, 1
                bsf eax, edx
                cmp edx, 10h
                je read_loop_contents_1
                add [string_store], edx
                jmp read_variable_float_2


        check_new_dfloat_variable:
                inc ecx
                shr eax, 1
                bsf eax, edx
                add [string_store], edx
                cmp [string_store], 10h
                je var_loop_1
                cmp ecx, 5
                je finalize_check_dfloat_variable
                jmp check_new_dfloat_variable
        finalize_check_dfloat_variable:
                cmp [string_store], "dfloat"
                jne var_loop_1
                mov ebx, string_store
                ; mov [hFile], ebx
                jmp read_variable_dfloat_1
        read_variable_dfloat_1:
                shr eax, 1
                bsf eax, edx
                cmp edx, 32h
                jne error; Actual error
                jmp read_variable_dfloat_2
        read_variable_dfloat_2:
                shr eax, 1
                bsf eax, edx
                cmp edx, 10h
                je read_loop_contents_1
                add [string_store], edx
                jmp read_variable_dfloat_2

        check_new_qfloat_variable:
                inc ecx
                shr eax, 1
                bsf eax, edx
                add [string_store], edx
                cmp [string_store], 10h
                je var_loop_1
                cmp ecx, 5
                je finalize_check_qfloat_variable
                jmp check_new_qfloat_variable
        finalize_check_qfloat_variable:
                cmp [string_store], "qfloat"
                jne var_loop_1
                mov ebx, string_store
                ; mov [hFile], ebx
                jmp read_variable_qfloat_1
        read_variable_qfloat_1:
                shr eax, 1
                bsf eax, edx
                cmp edx, 32h
                jne error; Actual error
                jmp read_variable_qfloat_2
        read_variable_qfloat_2:
                shr eax, 1
                bsf eax, edx
                cmp edx, 10h
                je read_loop_contents_1
                add [string_store], edx
                jmp read_variable_qfloat_2

        check_new_unsigned_variable:
                shr eax, 1
                bsf eax, edx
                cmp edx, "i"
                je unsigned_check_new_int_variable
                cmp edx, "f"
                je unsigned_check_new_float_variable
                cmp edx, "d"
                je unsigned_check_new_dfloat_variable
                cmp edx, "q"
                je unsigned_check_new_qfloat_variable
                jmp var_loop_1
        unsigned_check_new_int_variable:
                inc ecx
                shr eax, 1
                bsf eax, edx
                add [string_store], edx
                cmp [string_store], 10h
                je var_loop_1
                cmp ecx, 3
                je unsigned_finalize_check_int_variable
                jmp unsigned_check_new_int_variable
        unsigned_finalize_check_int_variable:
                cmp [string_store], "uint"
                jne var_loop_1
                mov ebx, string_store
                ; mov [hFile], ebx
                jmp unsigned_read_variable_int_1
        unsigned_read_variable_int_1:
                shr eax, 1
                bsf eax, edx
                cmp edx, 32h
                jne error; Actual error
                jmp unsigned_read_variable_int_2
        unsigned_read_variable_int_2:
                shr eax, 1
                bsf eax, edx
                cmp edx, 10h
                je check_sign_uint
                add [string_store], edx
                jmp unsigned_read_variable_int_2

        check_sign_uint:
                cmp [sting_store], 0
                js error ;Signed variable error
                jmp read_loop_contents_1

        unsigned_check_new_float_variable:
                inc ecx
                shr eax, 1
                bsf eax, edx
                add [string_store], edx
                cmp [string_store], 10h
                je var_loop_1
                cmp ecx, 5
                je unsigned_finalize_check_float_variable
                jmp unsigned_check_new_float_variable
        unsigned_finalize_check_float_variable:
                cmp [string_store], "ufloat"
                jne var_loop_1
                mov ebx, string_store
                ; mov [hFile], ebx
                jmp unsigned_read_variable_float_1
        unsigned_read_variable_float_1:
                shr eax, 1
                bsf eax, edx
                cmp edx, 32h
                jne error; Actual error
                jmp unsigned_read_variable_float_2
        unsigned_read_variable_float_2:
                shr eax, 1
                bsf eax, edx
                cmp edx, 10h
                je check_sign_ufloat
                add [string_store], edx
                jmp unsigned_read_variable_float_2

        check_sign_ufloat:
                cmp [sting_store], 0
                js error ;Signed variable error
                jmp read_loop_contents_1


        unsigned_check_new_dfloat_variable:
                inc ecx
                shr eax, 1
                bsf eax, edx
                add [string_store], edx
                cmp [string_store], 10h
                je var_loop_1
                cmp ecx, 6
                je unsigned_finalize_check_dfloat_variable
                jmp unsigned_check_new_dfloat_variable
        unsigned_finalize_check_dfloat_variable:
                cmp [string_store], "udfloat"
                jne var_loop_1
                mov ebx, string_store
                ; mov [hFile], ebx
                jmp unsigned_read_variable_dfloat_1
        unsigned_read_variable_dfloat_1:
                shr eax, 1
                bsf eax, edx
                cmp edx, 32h
                jne error; Actual error
                jmp unsigned_read_variable_dfloat_2
        unsigned_read_variable_dfloat_2:
                shr eax, 1
                bsf eax, edx
                cmp edx, 10h
                je check_sign_udfloat
                add [string_store], edx
                jmp unsigned_read_variable_dfloat_2


        check_sign_udfloat:
                cmp [sting_store], 0
                js error ;Signed variable error
                jmp read_loop_contents_1


        unsigned_check_new_qfloat_variable:
                inc ecx
                shr eax, 1
                bsf eax, edx
                add [string_store], edx
                cmp [string_store], 10h
                je var_loop_1
                cmp ecx, 6
                je unsigned_finalize_check_qfloat_variable
                jmp usigned_check_new_qfloat_variable
        unsigned_finalize_check_qfloat_variable:
                cmp [string_store], "uqfloat"
                jne var_loop_1
                mov ebx, string_store
                ; mov [hFile], ebx
                jmp unsigned_read_variable_qfloat_1
        unsigned_read_variable_qfloat_1:
                shr eax, 1
                bsf eax, edx
                cmp edx, 32h
                jne error; Actual error
                jmp unsigned_read_variable_qfloat_2
        unsigned_read_variable_qfloat_2:
                shr eax, 1
                bsf eax, edx
                cmp edx, 10h
                je check_sign_uqfloat
                add [string_store], edx
                jmp unsigned_read_variable_qfloat_2

        check_sign_uqfloat:
                cmp [sting_store], 0
                js error ;Signed variable error
                jmp read_loop_contents_1


        var_loop_1:
                shr eax, 1
                bsf eax, edx
                add [string_store], edx
                cmp edx, 10h
                je var_loop_2
                jmp var_loop_1
        var_loop_2:
                mov ebx, string_store
                ; add [hFile], ebx
                jmp read_loop_contents_1

        func_handle:


                ;add [hFile], string_store
                mov [string_store], 0
                jmp func_handle2
       func_handle2:
                bsf eax, edx
                shr eax, 1
                cmp edx, 32h
                je func_ret
                add [string_store], edx
                jmp func_handle2
       func_ret:
                mov ebx, int_
                cmp [string_store], ebx
                je error
                mov ebx, float_
                cmp [string_store], ebx
                je error
                mov ebx, bool_
                cmp [string_store], ebx
                je error
                mov ebx, double_
                cmp [string_store], ebx
                je error
                mov ebx, string_
                cmp [string_store], ebx
                je error
                mov ebx, long_
                cmp [string_store], ebx
                je error
                mov ebx, void_
                cmp [string_store], ebx
                je error
       int_func_start:
                mov [string_store], 0
                ; add to IR folder
                ; mov [hFile], "int_func"
                jmp int_func
       int_func:
                bsf eax, edx
                shr eax, 1
                cmp edx, "("
                je func_name_set
                add [string_store], edx
                jmp int_func
       func_name_set:
                mov ebx, [string_store]
                ; add [hFile], ebx
                jmp param_set
       param_set:
                shr eax, 1
                bsf eax, edx
                cmp edx, ","
                je param_lock
                cmp edx, ")"
                je func_contents
                add [func_params], edx
       param_lock:
                mov ebx, [func_params]
                ; add [hFile], ebx

                jmp param_set
       func_contents:

       error:
                ret

       if_handle:
                cmp byte [eax - 1], ":"
                jne error
                cmp byte [eax + 3], 32h
                jne error
                shr eax, 3
                bsf eax, edx
                mov ecx, 3
                cmp eax, "!"
                je not_condition_read
                jmp read_checking
       read_checking:
                inc ecx
                shr eax, 1
                bsf eax, edx
                cmp edx, ":"
                je single_condition
                cmp edx, "<"
                je lesser_cond_addition
                cmp edx, ">"
                je greater_cond_addition
                cmp edx, "o"
                je or_keyword_confirm
                cmp edx, "a"
                je and_keyword_confirm
                cmp edx, "|"
                je bar_confirm
                cmp edx, "&"
                je amp_confirm
                add [cond1], edx
                jmp read_checking
        not_condition_read:
                inc ecx
                shr eax, 1
                bsf eax, edx
                cmp edx, ":"
                je not_single_condition
                cmp edx, "<"
                je not_lesser_cond_addition
                cmp edx, ">"
                je not_greater_cond_addition
                cmp edx, "o"
                je or_keyword_confirm
                cmp edx, "a"
                je and_keyword_confirm
                cmp edx, "|"
                je not_bar_confirm
                cmp edx, "&"
                je not_amp_confirm
                add [cond1], edx
                jmp not_condition_read

        or_keyword_confirm:
                shr eax, 1
                bsf eax, edx
                cmp edx, "r"
                je or_equal_cond_addition
                jmp error

        not_or_keyword_confirm:
                shr eax, 1
                bsf eax, edx
                cmp edx, "r"
                je not_or_equal_cond_addition

        and_keyword_confirm:
                shr eax, 1
                bsf eax, edx
                cmp edx, "n"
                jne error
                shr eax, 1
                bsf eax, edx
                cmp edx, "d"
                je or_equal_cond_addition
                jmp error

        not_and_keyword_confirm:
                shr eax, 1
                bsf eax, edx
                cmp edx, "n"
                jne error
                shr eax, 1
                bsf eax, edx
                cmp edx, "d"
                je not_or_equal_cond_addition
                jmp error

        bar_confirm:
                shr eax, 1
                bsf eax, edx
                cmp edx, "|"
                je or_equal_cond_addition
        amp_confirm:
                shr eax, 1
                bsf eax, edx
                cmp edx, "&"
                je and_equal_cond_addition

        not_bar_confirm:
                shr eax, 1
                bsf eax, edx
                cmp edx, "|"
                je not_or_equal_cond_addition
        not_amp_confirm:
                shr eax, 1
                bsf eax, edx
                cmp edx, "&"
                je not_and_equal_cond_addition

        single_condition:
                mov ebx, cond1
                or ebx, ebx
                jz read_condition
        not_single_condition:
                mov ebx, cond1
                or ebx, ebx
                jz not_read_condition
        lesser_cond_addition:
                shr eax, 1
                bsf eax, edx
                cmp edx, 61h
                je lesser_eq_cond_addition
                cmp edx, 32h
                je lesser_cond_addition
                jmp lesser_cond_addition_2
        lesser_eq_cond_addition:
                shr eax, 1
                bsf eax, edx
                cmp dl, 32h
                je lesser_eq_cond_addition_2
                add [cond2], edx
                jmp lesser_eq_cond_addition
        lesser_eq_cond_addition_2:
                shr eax, 1
                bsf eax, edx
                cmp edx, 10h
                je read_condition
                add [cond2], edx
                jmp read_lesser_eq_condition_true
        read_lesser_eq_condition_true:
                mov edx, cond2
                mov ebx, cond1
                cmp ebx, edx
                jl read_condition
                cmp ebx, edx
                je read_condition
                ; add not return functionality
        lesser_cond_addition_2:
                shr eax, 1
                bsf eax, edx
                cmp edx, 10h
                je read_lesser_condition_true
                add [cond2], edx
                jmp lesser_cond_addition_2
        read_lesser_condition_true:
                mov edx, cond2
                mov ebx, cond1
                cmp ebx, edx
                jl read_condition
                jmp not_read_condition



        greater_cond_addition:
                shr eax, 1
                bsf eax, edx
                cmp edx, 61h
                je greater_eq_cond_addition
                cmp edx, 32h
                je greater_cond_addition
                jmp greater_cond_addition_2
        greater_eq_cond_addition:
                shr eax, 1
                bsf eax, edx
                cmp dl, 32h
                je greater_eq_cond_addition_2
                add [cond2], edx
                jmp greater_eq_cond_addition
        greater_eq_cond_addition_2:
                shr eax, 1
                bsf eax, edx
                cmp edx, 10h
                je read_condition
                add [cond2], edx
                jmp read_greater_eq_condition_true
        read_greater_eq_condition_true:
                mov edx, cond2
                mov ebx, cond1
                cmp ebx, edx
                jl read_condition
                cmp ebx, edx
                je read_condition
                ; add not return functionality
        greater_cond_addition_2:
                shr eax, 1
                bsf eax, edx
                cmp edx, 10h
                je read_greater_condition_true
                add [cond2], edx
                jmp greater_cond_addition_2
        read_greater_condition_true:
                mov edx, cond2
                mov ebx, cond1
                cmp ebx, edx
                jl read_condition
                jmp not_read_condition

        not_greater_cond_addition:
                shr eax, 1
                bsf eax, edx
                cmp edx, 61h
                je not_greater_eq_cond_addition
                cmp edx, 32h
                je not_greater_cond_addition
                jmp not_greater_cond_addition_2
        not_greater_eq_cond_addition:
                shr eax, 1
                bsf eax, edx
                cmp dl, 32h
                je not_greater_eq_cond_addition_2
                add [cond2], edx
                jmp not_greater_eq_cond_addition
        not_greater_eq_cond_addition_2:
                shr eax, 1
                bsf eax, edx
                cmp edx, 10h
                je read_condition
                add [cond2], edx
                jmp not_read_greater_eq_condition_true
        not_read_greater_eq_condition_true:
                mov edx, cond2
                mov ebx, cond1
                cmp ebx, edx
                jl read_condition
                cmp ebx, edx
                je read_condition
                ; add not return functionality
        not_greater_cond_addition_2:
                shr eax, 1
                bsf eax, edx
                cmp edx, 10h
                je not_read_greater_condition_true
                add [cond2], edx
                jmp not_greater_cond_addition_2
        not_read_greater_condition_true:
                mov edx, cond2
                mov ebx, cond1
                cmp ebx, edx
                jl read_condition
                jmp not_read_condition


        not_or_equal_cond_addition:
                shr eax, 1
                bsf eax, edx
                cmp edx, 32h
                je not_or_equal_cond_addition
                cmp edx, 33h
                je not_cond2_not_or_equal_cond_addition
                cmp edx, 58h
                je not_or_equal_cond_addition
                add [cond2], edx
                jmp not_or_equal_cond_addition
        not_or_equal_condition_true:
                mov eax, cond1
                mov ebx, cond2
                or eax, ebx
                jnz read_condition
        not_cond2_not_or_equal_cond_addition:
                shr eax, 1
                bsf eax, edx
                cmp edx, 58h
                je not_cond2_not_or_equal_condition_true
                add [cond2], edx
                jmp not_cond2_not_or_equal_cond_addition
        not_cond2_not_or_equal_condition_true:
                mov eax, cond1
                mov ebx, cond2
                not ebx
                or eax, ebx
                jnz read_condition

        or_equal_cond_addition:
                shr eax, 1
                bsf eax, edx
                cmp edx, 32h
                je or_equal_cond_addition
                cmp edx, 33h
                je cond2_not_or_equal_cond_addition
                cmp edx, 58h
                je or_equal_cond_addition
                add [cond2], edx
                jmp or_equal_cond_addition
        or_equal_condition_true:
                mov eax, cond1
                mov ebx, cond2
                or eax, ebx
                jnz read_condition
        cond2_not_or_equal_cond_addition:
                shr eax, 1
                bsf eax, edx
                cmp edx, 58h
                je cond2_not_or_equal_condition_true
                add [cond2], edx
                jmp cond2_not_or_equal_cond_addition
        cond2_not_or_equal_condition_true:
                mov eax, cond1
                mov ebx, cond2
                not ebx
                or eax, ebx
                jnz read_condition


        and_equal_cond_addition:
                shr eax, 1
                bsf eax, edx
                cmp edx, 32h
                je and_equal_cond_addition
                cmp edx, 33h
                je cond2_not_and_equal_cond_addition
                cmp edx, 58h
                je and_equal_cond_addition
                add [cond2], edx
                jmp and_equal_cond_addition
        and_equal_condition_true:
                mov eax, cond1
                mov ebx, cond2
                and eax, ebx
                jnz read_condition
        cond2_not_and_equal_cond_addition:
                shr eax, 1
                bsf eax, edx
                cmp edx, 58h
                je cond2_not_and_equal_condition_true
                add [cond2], edx
                jmp cond2_not_and_equal_cond_addition
        cond2_not_and_equal_condition_true:
                mov eax, cond1
                mov ebx, cond2
                not ebx
                and eax, ebx
                jnz read_condition

        not_and_equal_cond_addition:
                shr eax, 1
                bsf eax, edx
                cmp edx, 32h
                je not_and_equal_cond_addition
                cmp edx, 33h
                je not_cond2_not_and_equal_cond_addition
                cmp edx, 58h
                je not_and_equal_cond_addition
                add [cond2], edx
                jmp not_and_equal_cond_addition
        not_and_equal_condition_true:
                mov eax, cond1
                mov ebx, cond2
                not eax
                and eax, ebx
                jnz read_condition
        not_cond2_not_and_equal_cond_addition:
                shr eax, 1
                bsf eax, edx
                cmp edx, 58h
                je not_cond2_not_and_equal_condition_true
                add [cond2], edx
                jmp not_cond2_not_and_equal_cond_addition
        not_cond2_not_and_equal_condition_true:
                mov eax, cond1
                mov ebx, cond2
                not eax
                not ebx
                and eax, ebx
                jnz read_condition






        not_lesser_cond_addition:
                shr eax, 1
                bsf eax, edx
                cmp edx, 61h
                je not_lesser_eq_cond_addition
                cmp edx, 32h
                je not_lesser_cond_addition
                jmp not_lesser_cond_addition_2
        not_lesser_eq_cond_addition:
                shr eax, 1
                bsf eax, edx
                cmp edx, 32h
                je not_lesser_eq_cond_addition_2
                add [cond2], edx
                jmp lesser_eq_cond_addition
        not_lesser_eq_cond_addition_2:
                shr eax, 1
                bsf eax, edx
                cmp edx, 10h
                je read_condition
                add [cond2], edx
                jmp read_lesser_eq_condition_true
        not_read_lesser_eq_condition_true:
                mov eax, cond1
                mov ebx, cond2
                not eax
                not ebx
                cmp eax, ebx
                jl read_condition
                cmp eax, ebx
                je read_condition
                ; add not return functionality
        not_lesser_cond_addition_2:
                shr eax, 1
                bsf eax, edx
                cmp edx, 10h
                je read_lesser_condition_true
                add [cond2], edx
                jmp lesser_cond_addition_2
        not_read_lesser_condition_true:
                mov eax, cond1
                mov ebx, cond2
                not eax
                not ebx
                cmp eax, ebx
                jl read_condition
                jmp not_read_condition


        read_condition:             ; Treat like read_contents
                bsf eax, edx
                cmp edx, 9h
                je read_condition2
                jmp global_handle; Break out of the if statement condition
        read_condition2:
                cmp edx, 10h
                je read_condition
                shr eax, 1
                bsf eax, edx
                add [contents_if], edx
                jmp read_condition2

       not_read_condition:             ; Treat like read_contents
                bsf eax, edx
                cmp edx, 9h
                je not_read_condition2
                jmp global_handle; Break out of the if statement condition
       not_read_condition2:
                cmp edx, 10h
                je not_read_condition
                shr eax, 1
                bsf eax, edx
                add [contents_if], edx
                jmp not_read_condition2








        while_handle:
                shr eax, 1
                bsf eax, edx
                cmp edx, 32h
                jne error
                jmp while_handle_cont
        whlie_handle_cont:
                mov [string_store], 0
                shr eax, 1
                bsf eax, edx
                cmp edx, 32h
                je func_while_handle_cont
                add [string_store], edx
                cmp edx, ":"
                je single_condition_while
                cmp edx, "<"
                je lesser_cond_addition_while
                cmp edx, ">"
                je greater_cond_addition_while
                cmp edx, "o"
                je or_keyword_confirm_while
                cmp edx, "a"
                je and_keyword_confirm_while
                cmp edx, "|"
                je bar_confirm_while
                cmp edx, "&"
                je amp_confirm_while
                jmp while_handle_cont
        func_while_handle_cont:
                mov ebp, [string_store]
                mov [while_func], ebp
                xor ebp, ebp
                jmp while_handle_cont
        single_condition_while_1:
                mov eax, [string_store]
                mov [string_store], 0
                jmp single_condition_checking
        single_condition_checking:
                and [while_func], [while_func]
                je while_condition_execute
        while_condition_execute:
                shr eax, 1
                bsf eax, edx
                cmp edx, 9h
                je while_condition_execute_2; breaks out of loop
        while_condition_execute_2:
                shr eax, 1
                bsf eax, edx
                add [while_contents], edx
                cmp edx, 10h
                je while_condition_execute_1
                jmp while_condition_execute_2
