REPORT zhcm_action_report.

" Selection screen blocks with select-options for filtering
SELECT-OPTIONS: so_pernr FOR pa0000-pernr NO INTERVALS NO-EXTENSION.
SELECT-OPTIONS: so_subty FOR pa0000-subty NO INTERVALS NO-EXTENSION.

" Data declarations
DATA: gt_pa0000 TYPE TABLE OF pa0000,
      gs_pa0000 TYPE pa0000.

DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_alv_grid  TYPE REF TO cl_gui_alv_grid.

DATA: gv_container_name TYPE scrfname VALUE 'CONTAINER'.

" Splash screen container
START-OF-SELECTION.
  PERFORM fetch_data.
  PERFORM display_alv.

"--------------------------------------------------------------------------------------
" Selection screen custom container
INITIALIZATION.
  SET PF-STATUS 'SCREEN_1000' EXCLUDING.

AT SELECTION-SCREEN OUTPUT.
  PERFORM create_container.

"--------------------------------------------------------------------------------------
FORM create_container.
  " Create custom container for ALV grid on the report screen
  IF go_container IS INITIAL.
    CREATE OBJECT go_container
      EXPORTING
        container_name = gv_container_name.

    CREATE OBJECT go_alv_grid
      EXPORTING
        i_parent = go_container.
  ENDIF.
ENDFORM.

"--------------------------------------------------------------------------------------
FORM fetch_data.
  " Fetch data from PA0000 with selection criteria
  SELECT * FROM pa0000 INTO TABLE gt_pa0000
    WHERE pernr IN so_pernr
      AND subty IN so_subty.
ENDFORM.

"--------------------------------------------------------------------------------------
FORM display_alv.
  " Display fetched data in ALV Grid Control
  DATA: lt_fieldcat TYPE lvc_t_fcat,
        ls_fieldcat TYPE lvc_s_fcat.

  " Prepare field catalog dynamically for selected fields
  LOOP AT pa0000 INTO DATA(ls_pa0000).
    " Only need structure info, exit immediately
    EXIT.
  ENDLOOP.

  CLEAR lt_fieldcat.

  " Populate field catalog for relevant fields from PA0000
  ls_fieldcat-fieldname = 'PERNR'.
  ls_fieldcat-seltext_m = 'Personnel Number'.
  ls_fieldcat-coltext = 'Personnel Number'.
  APPEND ls_fieldcat TO lt_fieldcat.

  ls_fieldcat-fieldname = 'BEGDA'.
  ls_fieldcat-seltext_m = 'Start Date'.
  ls_fieldcat-coltext = 'Start Date'.
  APPEND ls_fieldcat TO lt_fieldcat.

  ls_fieldcat-fieldname = 'ENDDA'.
  ls_fieldcat-seltext_m = 'End Date'.
  ls_fieldcat-coltext = 'End Date'.
  APPEND ls_fieldcat TO lt_fieldcat.

  ls_fieldcat-fieldname = 'SUBTY'.
  ls_fieldcat-seltext_m = 'Subtype'.
  ls_fieldcat-coltext = 'Subtype'.
  APPEND ls_fieldcat TO lt_fieldcat.

  ls_fieldcat-fieldname = 'AOBJPS'.
  ls_fieldcat-seltext_m = 'Object Type (PS)'.
  ls_fieldcat-coltext = 'Object Type (PS)'.
  APPEND ls_fieldcat TO lt_fieldcat.

  ls_fieldcat-fieldname = 'OBJPS'.
  ls_fieldcat-seltext_m = 'Object Instance'.
  ls_fieldcat-coltext = 'Object Instance'.
  APPEND ls_fieldcat TO lt_fieldcat.

  " Call method to set table for ALV grid
  CALL METHOD go_alv_grid->set_table_for_first_display
    EXPORTING
      i_structure_name = 'PA0000'
      is_variant       = ' '
      it_fieldcatalog  = lt_fieldcat
    CHANGING
      it_outtab        = gt_pa0000.

  " Register standard event handler for user commands if needed
ENDFORM.

"--------------------------------------------------------------------------------------
" END OF REPORT
