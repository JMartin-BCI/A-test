--  Loads eStore flat file
--  $Header: arestore.ctl 1.0 99/10/26 13:16:13 porting ship $
--

LOAD DATA
APPEND

--  Type 6 -  Payment

INTO TABLE AR_PAYMENTS_INTERFACE_ALL
WHEN RECORD_TYPE = '6'
(STATUS                         CONSTANT 'AR_PLB_NEW_RECORD',
 RECORD_TYPE                    POSITION(01:01) CHAR,
 ITEM_NUMBER                    POSITION(02:07) CHAR,
 REMITTANCE_AMOUNT              POSITION(08:17) CHAR,
 TRANSIT_ROUTING_NUMBER         POSITION(18:25) CHAR,
 ACCOUNT                        POSITION(26:35) CHAR,
 CHECK_NUMBER                   POSITION(36:43) CHAR,
 CURRENCY_CODE                  POSITION(44:46) CHAR,
 EXCHANGE_RATE                  POSITION(47:56) CHAR,
 CUSTOMER_NUMBER                POSITION(57:70) CHAR,
 RECEIPT_DATE                   POSITION(71:79) DATE 'DD-MON-YY'
                                        NULLIF RECEIPT_DATE=BLANKS,
 INVOICE1                     POSITION(80:99) CHAR,
 INVOICE2                     POSITION(100:119) CHAR,
 INVOICE3                     POSITION(120:139) CHAR,
 INVOICE4                     POSITION(140:159) CHAR,
 INVOICE5                     POSITION(160:179) CHAR,
 INVOICE6                     POSITION(180:199) CHAR,
 INVOICE7                     POSITION(200:219) CHAR,
 INVOICE8                     POSITION(220:239) CHAR,
 BILL_TO_LOCATION             POSITION(240:269) CHAR )



