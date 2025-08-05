REPORT zhcm_action_report.

TABLES: pa0000.

SELECT-OPTIONS: so_pernr FOR pa0000-pernr,
                 so_subty FOR pa0000-subty.

START-OF-SELECTION.
  DATA: lt_pa0000 TYPE TABLE OF pa0000,
        ls_pa0000 TYPE pa0000.

  SELECT * FROM pa0000
    WHERE pernr IN so_pernr
      AND subty IN so_subty
    INTO TABLE lt_pa0000.

  IF lt_pa0000 IS NOT INITIAL.
    LOOP AT lt_pa0000 INTO ls_pa0000.
      WRITE: / ls_pa0000-pernr, ls_pa0000-subty, ls_pa0000-begda, ls_pa0000-endda.
    ENDLOOP.
  ELSE.
    WRITE: / 'No data found'.
  ENDIF.