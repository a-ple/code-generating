REPORT zhcm_action_report.

SELECT-OPTIONS: s_pernr FOR pa0000-pernr,
                s_subty FOR pa0000-subty.

DATA: lt_pa0000 TYPE TABLE OF pa0000.

START-OF-SELECTION.
  SELECT * FROM pa0000 INTO TABLE lt_pa0000
    WHERE pernr IN s_pernr
    AND subty IN s_subty.

  IF sy-subrc = 0.
    LOOP AT lt_pa0000 INTO DATA(ls_pa0000).
      WRITE: / ls_pa0000-pernr, ls_pa0000-subty, ls_pa0000-begda, ls_pa0000-endda.
    ENDLOOP.
  ELSE.
    WRITE: 'No data found'.
  ENDIF.