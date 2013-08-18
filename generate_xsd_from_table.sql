DECLARE
  p_table_name varchar2(2000) := 'PO_LINE_LOCATIONS_ALL';
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

  DBMS_OUTPUT.PUT_LINE('<?xml version="1.0" encoding="UTF-8"?>');
  DBMS_OUTPUT.PUT_LINE('<xsd:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">');
  DBMS_OUTPUT.PUT_LINE('<' || lower(p_table_name) || '>');
  DBMS_OUTPUT.PUT_LINE('<xsd:complexType>');
  DBMS_OUTPUT.PUT_LINE('<xsd:sequence>');
  FOR l_cur_table_columns IN c_table_columns(p_table_name, p_schema_name) LOOP
    l_col_str := '<xsd:element name= "' || replace(initcap(l_cur_table_columns.column_name),'_') ||
                 '" type="';
    IF l_cur_table_columns.data_type = 'VARCHAR2' THEN
      l_col_str := l_col_str || 'xsd:string' || '"';    
    ELSIF l_cur_table_columns.data_type = 'DATE' THEN
      l_col_str := l_col_str || 'xsd:date' || '"';
    ELSIF l_cur_table_columns.data_type = 'NUMBER' THEN
      IF (lower(l_cur_table_columns.column_name) like '%qty%') OR
         (lower(l_cur_table_columns.column_name) like '%quantity%') OR
         (lower(l_cur_table_columns.column_name) like '%amount%') OR
         (lower(l_cur_table_columns.column_name) like '%price%') OR
         (lower(l_cur_table_columns.column_name) like '%rate%')
         THEN
             l_col_str := l_col_str || 'xsd:decimal' || '"';
         ELSE        
             l_col_str := l_col_str || 'xsd:integer' || '"';
      END If;       
    END IF;
  
    IF l_cur_table_columns.data_default IS NOT NULL THEN
      l_col_str := l_col_str || ' default="' ||
                   TRIM(l_cur_table_columns.data_default) || '"';
    END IF;
    l_col_str := l_col_str || ' minOccurs="0"/>';
    DBMS_OUTPUT.PUT_LINE(l_col_str);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('</xsd:sequence>');
  DBMS_OUTPUT.PUT_LINE('</xsd:complexType>');
  DBMS_OUTPUT.PUT_LINE('</' || lower(p_table_name) || '>');
END;
