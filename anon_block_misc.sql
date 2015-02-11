and why are you such a doh-doh head?

-- =====================================================================
-- PROGRAM NAME  : anon
-- SOURCE NAME   : anon.sql
-- AUTHOR        : JAM
-- DATE CREATED  : 3 June 1998
-- APPLICATION   : Testing
-- VERSION       :
-- DESCRIPTION   : Anonymous block to call a stored procedure and
--               : display results.  To be updated as necessary.
-- =====================================================================
-- MODIFICATION HISTORY
-- =====================================================================
-- DATE      NAME          DESCRIPTION
-- ---------------------------------------------------------------------
-- ---------------------------------------------------------------------
set feedback off
set verify off
set serveroutput on size 100000
set autocommit off
whenever oserror exit failure rollback
whenever sqlerror exit failure rollback

declare

 others_exception       exception;

g_conc_login_id        fnd_concurrent_requests.last_update_login%type;
g_cur_date             varchar2(30);
g_error                number;
g_last_update_date     fnd_concurrent_requests.last_update_date%type;
g_miscellaneous        varchar2(150);
g_program              varchar2(30)    := 'TESTPROGRAM';
g_program_appl_id      fnd_concurrent_requests.program_application_id%type;
g_program_err          varchar2(150);
g_program_id           fnd_concurrent_requests.concurrent_program_id%type;
g_request_id           fnd_concurrent_requests.request_id%type;
g_results_code         number;
g_revision_id          varchar2(10)    := '1.0';
g_sql_code             number;
g_sql_err              varchar2(150);
g_sql_stmt_num         varchar2(10);
rec_row_who            fnd_concurrent_requests%rowtype;

l_user_id              number :=1177; -- jam
l_structure_id         number :=4030; -- operations = 4010
l_business_unit_id     number :=900;  -- sbc global = 905
l_record_count         number;
l_record_list          XXSCP_SUPPLIER_OBJ_TABLE;
l_list_type            varchar2(10) := 'LOGINLIST';

 l_error_message          VARCHAR2(4000)                := '';
 l_revision_num           po_headers_all.revision_num%TYPE;
 l_release_num            NUMBER                        := null;
 l_new_quantity           number                        := null;
 l_launch_approvals_flag  varchar2(1);
 l_retcode                NUMBER;
 l_api_error              po_api_errors_rec_type;
 l_mesg_count             number := 0;
 l_mesg_len               number;
 l_mesg                   varchar2(4000);
 l_cur_date               varchar2(30);
 l_process_code           number;
 l_po_header_id number;
 l_po_number              po_headers_all.segment1%type;
 l_po_line_item_number  number;
 l_shipment_num         number;
 l_new_unit_price       number  := null;
 l_new_promised_date    date;

begin
  select to_char(sysdate,'DD-MON-YYYY HH24:MI:SS') into
    g_cur_date from dual;
  select sysdate into g_last_update_date from dual;
  dbms_output.put_line('===============================================');
  dbms_output.put_line('Concurrent Program : '||g_program||', v'||g_revision_id);
  dbms_output.put_line('===============================================');
  dbms_output.put_line('Start Date/Time    : '||g_cur_date);
  dbms_output.put_line('===============================================');
  rec_row_who := null;
  rec_row_who.last_updated_by := 1177;
  rec_row_who.last_update_date := sysdate;
  rec_row_who.request_id := 8686;
  g_error := 0;
/*
XXSCP_CR_SYNC_UTIL_PKG.UPDATE_CR_DETAILS_STATUS (
  i_xxscp_cr_header_id            => 146,
  i_xxscp_cr_line_id              => 1080,
  i_current_af_status_id          => 4120,
  i_new_pending_processing_flag   => 'Y',
  i_new_email_to_be_sent_flag     => 'N',
  i_new_af_status_id              => 4120,
  i_new_reason_id                 => null,
  i_new_reason_text               => 'jennifer was here',
  i_new_status                    => 1,
  i_write_audit_flag_yn           => 'Y',
  rec_row_who                     => rec_row_who,
  io_error                        => g_error,
  io_sql_code                     => g_sql_code,
  io_sql_err                      => g_sql_err,
  io_program_err                  => g_program_err);
*/
XXSCP_CR_SYNC_UTIL_PKG.UPDATE_ALL_DETAILS_STATUS (
  i_record_type                   => 'PRLM',
  i_header_id                     => 203,
  i_line_id                       => 1084,
  i_current_af_status_id          => null,
  i_new_pending_processing_flag   => 'N',
  i_new_email_to_be_sent_flag     => 'N',
  i_new_af_status_id              => null,
  i_new_reason_id                 => null,
  i_new_reason_text               => 'jennifer on Wednesday',
  i_new_status                    => null,
  i_write_audit_flag_yn           => 'Y',
  rec_row_who                     => rec_row_who,
  io_error                        => g_error,
  io_sql_code                     => g_sql_code,
  io_sql_err                      => g_sql_err,
  io_program_err                  => g_program_err);

  dbms_output.put_line('===============================================');
  dbms_output.put_line('*** ANONYMOUS CALLING PROGRAM RESULTS ***');
  dbms_output.put_line('===============================================');

  dbms_output.put_line('===============================================');
  dbms_output.put_line('Concurrent Program : ' || g_program);
  dbms_output.put_line('Error returned     : ' || g_error);
  dbms_output.put_line('SQL Code           : ' || g_sql_code);
  dbms_output.put_line('SQL Error          : ' || g_sql_err);
  dbms_output.put_line('Program Error      : ' || g_program_err);
  dbms_output.put_line('Results Code       : ' || g_results_code);
  dbms_output.put_line('Misc               : ' || g_miscellaneous);
  dbms_output.put_line('===============================================');

  if g_error != 0 then
     raise others_exception;
  end if;

-- the end
select to_char(sysdate,'DD-MON-YYYY HH24:MI:SS') into
    g_cur_date from dual;

-- output stats
-- flag that all was successful
  dbms_output.put_line('===============================================');
  dbms_output.put_line('Concurrent Program : '||g_program||
    ' Successfully Completed');
  dbms_output.put_line('===============================================');
  dbms_output.put_line('End Date/Time      : '||g_cur_date);
  dbms_output.put_line('===============================================');
-- ************************************************************************
-- Handle all unhandled errors
-- ************************************************************************
exception when others_exception then
    -- is a custom error_handler raised from inner exceptions
    -- so that only 1 location is used for handling others error
  dbms_output.put_line('===============================================');
  dbms_output.put_line('**** OTHERS_EXCEPTION ****');
  dbms_output.put_line('Concurrent Program : '||g_program|| ' Failed');
  dbms_output.put_line('Error returned: ' || to_char(g_error));
  dbms_output.put_line('SQL Code: ' || to_char(g_sql_code));
  dbms_output.put_line('SQL Error: ' || g_sql_err);
  dbms_output.put_line('Program Error: ' || g_program_err);
  dbms_output.put_line('===============================================');
  raise_application_error (-20001,g_program_err);
when others then
  dbms_output.put_line('===============================================');
  dbms_output.put_line('**** OTHERS RAISED ****');
  dbms_output.put_line('Concurrent Program : '||g_program|| ' Failed');
  dbms_output.put_line('Error returned: ' || to_char(g_error));
  dbms_output.put_line('SQL Code: ' || sqlcode);
  dbms_output.put_line('SQL Error: ' || sqlerrm);
  dbms_output.put_line('Program Error: ' || g_program_err);
  dbms_output.put_line('===============================================');
  raise_application_error (-20001,g_program_err);
END;
/


