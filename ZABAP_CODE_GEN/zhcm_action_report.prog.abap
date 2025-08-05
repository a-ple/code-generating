REPORT zhcm_action_report.

" Selection screen with select-options using standard SAP data elements
SELECT-OPTIONS: so_pernr FOR pa0000-pernr,
                so_subty FOR pa0000-subty.

" Internal table to hold selected PA0000 records
DATA: it_pa0000 TYPE TABLE OF pa0000.

START-OF-SELECTION.
  " Fetch filtered data from PA0000
  SELECT * FROM pa0000
    INTO TABLE @it_pa0000
    WHERE pernr IN @so_pernr
      AND subty IN @so_subty.

  IF lines( it_pa0000 ) = 0.
    WRITE: / 'No records found for the specified criteria.'.
  ELSE.
    " Display data with classical ALV function module
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
      WRITE: / 'Error displaying ALV output.'.
    ENDIF.
  ENDIF.
