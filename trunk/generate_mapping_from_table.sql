DECLARE
  p_table_name varchar2(2000) := 'PO_LINES_ALL';
  p_schema_name varchar2(50) := 'PO';
  CURSOR c_table_columns(c_table_name varchar2, c_schema_name varchar2) IS
    SELECT column_name, data_type, data_default
      FROM all_tab_columns
     WHERE table_name = p_table_name     
     and OWNER = p_schema_name
     order by column_name;
  --AND owner = c_schema_name;
  l_col_str VARCHAR2(2000);
BEGIN

  --DBMS_OUTPUT.PUT_LINE('<?xml version="1.0" encoding="UTF-8"?>');
--  DBMS_OUTPUT.PUT_LINE('<xsd:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">');
--  DBMS_OUTPUT.PUT_LINE('<' || lower(p_table_name) || '>');
--  DBMS_OUTPUT.PUT_LINE('<xsd:complexType>');
--  DBMS_OUTPUT.PUT_LINE('Field Name,Source Table, Source Column');
  FOR l_cur_table_columns IN c_table_columns(p_table_name, p_schema_name) LOOP
    l_col_str := 'Po>PoLine>' || replace(initcap(l_cur_table_columns.column_name),'_') ||','||upper(p_table_name)||','||upper(l_cur_table_columns.column_name);
    DBMS_OUTPUT.PUT_LINE(l_col_str);
  END LOOP;
END;
