format PE
entry start
section '.data' data readable writeable
        if_statement db "if cond1 || cond2:"
        cond1 dd ?
        cond2 dd ?
section '.code' data readable executable
        start:
                mov eax, if_statement
                jmp read_if
        read_if:
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

        error:
                ret ; Fix this

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
