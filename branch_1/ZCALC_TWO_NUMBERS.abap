REPORT zcalc_two_numbers.

PARAMETERS: p_num1 TYPE i,
            p_num2 TYPE i.

DATA: lv_result TYPE i.

lv_result = p_num1 + p_num2.

WRITE: / 'The sum of', p_num1, 'and', p_num2, 'is', lv_result.