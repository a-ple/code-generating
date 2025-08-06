REPORT zhcm_action_report.

" Selection screen definitions for personnel number and subtype
SELECT-OPTIONS: s_pernr FOR pa0000-pernr,
                s_subty FOR pa0000-subty.

DATA: it_pa0000 TYPE TABLE OF pa0000.

START-OF-SELECTION.

  " Authorization check for Infotype 0000 display
  AUTHORITY-CHECK OBJECT 'HR_INFOTYPE'
    ID 'INFOTYPE' FIELD '0000'
    ID 'ACTVT' FIELD '03'.
  IF sy-subrc <> 0.
    MESSAGE 'Not authorized to display Infotype 0000' TYPE 'E'.
  ENDIF.

  " Data selection from PA0000
  SELECT * FROM pa0000
    INTO TABLE it_pa0000
    WHERE pernr IN s_pernr
      AND subty IN s_subty.

  IF sy-subrc <> 0 OR lines( it_pa0000 ) = 0.
    MESSAGE 'No data found for the given selection' TYPE 'I'.
  ENDIF.

  " Display selected data using REUSE_ALV_GRID_DISPLAY function module
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
    TABLES
      t_outtab = it_pa0000.

END-OF-SELECTION.