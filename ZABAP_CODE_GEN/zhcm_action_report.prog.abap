REPORT zhcm_action_report.

" Selection screen for personnel number and subtype
SELECT-OPTIONS: s_pernr FOR pa0000-pernr,
                 s_subty FOR pa0000-subty.

DATA: it_pa0000 TYPE TABLE OF pa0000,
      wa_pa0000 TYPE pa0000.

START-OF-SELECTION.

  " Check if select-options are filled; if not, select all
  IF s_pernr[] IS INITIAL AND s_subty[] IS INITIAL.
    " No selection made, select all entries
    SELECT * FROM pa0000 INTO TABLE it_pa0000.
  ELSE.
    SELECT * FROM pa0000
      INTO TABLE it_pa0000
      WHERE pernr IN s_pernr
        AND subty IN s_subty.
  ENDIF.

  " Display ALV grid using REUSE_ALV_GRID_DISPLAY (classic ALV)
  IF sy-subrc = 0.
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program = sy-repid
        i_structure_name   = 'PA0000'
      TABLES
        t_outtab           = it_pa0000
      EXCEPTIONS
        program_error      = 1
        OTHERS             = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ELSE.
    WRITE: / 'No data found for the selection criteria.'.
  ENDIF.
