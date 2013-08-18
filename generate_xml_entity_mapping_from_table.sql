DECLARE
  p_table_name varchar2(2000) := 'PO_LINE_LOCATIONS_ALL';
  p_schema_name varchar2(50) := 'PO';
  p_xml_obj_name varchar2(50) := 'xmlPoLineLocation';
  p_entity_obj_name varchar2(50) := 'entityPoLineLocation';
  CURSOR c_table_columns(c_table_name varchar2, c_schema_name varchar2) IS
    SELECT column_name, data_type, data_default
      FROM all_tab_columns
     WHERE table_name = p_table_name     
     and OWNER = p_schema_name;
  l_col_str VARCHAR2(2000);
BEGIN

  FOR l_cur_table_columns IN c_table_columns(p_table_name, p_schema_name) LOOP
    IF l_cur_table_columns.data_type = 'DATE' THEN
       l_col_str := 'try{'||chr(10)||
                 '  '|| p_xml_obj_name ||'.set' || replace(initcap(l_cur_table_columns.column_name),'_') ||
                 '(getXMLGregarionCalendor('|| p_entity_obj_name||'.get'|| replace(initcap(l_cur_table_columns.column_name),'_')||
                 '()));'||chr(10)||
                 '} catch (Exception e){'||chr(10)||
                 '  e.printStackTrace();'||chr(10)||
                 '}';
    ELSIF l_cur_table_columns.data_type = 'NUMBER' THEN   
      l_col_str := 'try{'||chr(10)||
                 '  '|| p_xml_obj_name||'.set' || replace(initcap(l_cur_table_columns.column_name),'_') ||
                 '(BigInteger.valueOf('|| p_entity_obj_name||'.get'|| replace(initcap(l_cur_table_columns.column_name),'_')||
                 '()));'||chr(10)||
                 '} catch (Exception e){'||chr(10)||
                 '  e.printStackTrace();'||chr(10)||
                 '}';
       /**          
       l_col_str := p_xml_obj_name||'.set' || replace(initcap(l_cur_table_columns.column_name),'_') ||
                 '(new BigInteger('|| p_entity_obj_name||'.get'|| replace(initcap(l_cur_table_columns.column_name),'_')||
                 '().toString()));';             
       **/          
    ELSE 
       l_col_str := p_xml_obj_name ||'.set' || replace(initcap(l_cur_table_columns.column_name),'_') ||
                 '('|| p_entity_obj_name||'.get'|| replace(initcap(l_cur_table_columns.column_name),'_')||
                 '());';    
    END IF;
       

    DBMS_OUTPUT.PUT_LINE(l_col_str);
  END LOOP;

END;
