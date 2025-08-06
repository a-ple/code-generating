REPORT zhcm_action_report.

" Selection screen with select-options for personnel number (PERNR) and subtype (SUBTY)
SELECT-OPTIONS: s_pernr FOR pa0000-pernr,
                s_subty FOR pa0000-subty.

DATA: it_pa0000 TYPE TABLE OF pa0000,
      wa_pa0000 TYPE pa0000.

" Authorization check for Infotype 0000 display (Activity 03)
AUTHORITY-CHECK OBJECT 'HR_INFOTYPE'
  ID 'INFOTYPE' FIELD '0000'
  ID 'ACTVT' FIELD '03'.
IF sy-subrc <> 0.
  MESSAGE 'You are not authorized to display Infotype 0000' TYPE 'E'.
ENDIF.

START-OF-SELECTION.
  " Select data from PA0000 table based on user selections
  SELECT * FROM pa0000
    INTO TABLE it_pa0000
    WHERE pernr IN s_pernr
      AND subty IN s_subty.

  IF sy-subrc <> 0 OR lines( it_pa0000 ) = 0.
    MESSAGE 'No data found for the given selection' TYPE 'I'.
  ENDIF.

  " Display data using classical ALV grid control
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
    TABLES
      t_outtab = it_pa0000.

" End of report