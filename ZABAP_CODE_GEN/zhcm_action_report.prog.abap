REPORT zhcm_action_report.

" Selection screen parameters
SELECT-OPTIONS: s_pernr FOR pa0000-pernr,
                s_subty FOR pa0000-subty.

" Internal table and work area to hold selected data
DATA: it_pa0000 TYPE TABLE OF pa0000,
      wa_pa0000 TYPE pa0000.

START-OF-SELECTION.
  PERFORM fetch_data.
  PERFORM display_alv.

FORM fetch_data.
  " Select only required fields with where conditions
  SELECT mandt pernr subty begda endda
    FROM pa0000
    INTO TABLE @it_pa0000
    WHERE pernr IN @s_pernr
      AND subty IN @s_subty.

  IF sy-subrc <> 0 OR lines( it_pa0000 ) = 0.
    MESSAGE 'No data found for selection criteria' TYPE 'I'.
  ENDIF.
ENDFORM.

FORM display_alv.
  " Use CL_SALV_TABLE if available for ALV display
  DATA(lo_alv) = cl_salv_table=>factory( IMPORTING r_salv_table = DATA(lo_table) CHANGING t_table = it_pa0000 ).

  " Optional: set column headers and enable standard features
  lo_table->get_columns( )->set_optimize( abap_true ).

  lo_table->display( ).
ENDFORM.