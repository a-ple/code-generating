REPORT zhcm_action_report.

TABLES: pa0000.

SELECT-OPTIONS: s_pernr FOR pa0000-pernr,
                s_subty FOR pa0000-subty.

DATA: it_pa0000 TYPE TABLE OF pa0000,
      wa_pa0000 TYPE pa0000.

START-OF-SELECTION.
  SELECT * FROM pa0000
    WHERE pernr IN s_pernr
      AND subty IN s_subty
    INTO TABLE it_pa0000.

  IF sy-subrc = 0.
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program = sy-repid
        i_structure_name   = 'PA0000'
      TABLES
        t_outtab           = it_pa0000.
  ELSE.
    WRITE: / 'No data found for the selection'.
  ENDIF.
