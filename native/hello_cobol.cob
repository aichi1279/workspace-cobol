       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO-COBOL.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       
       01  PREFIX        PIC X(6)
           VALUE "Hello ".
       
       01  SUFFIX        PIC X(16)
           VALUE " from GnuCOBOL".
       
       LINKAGE SECTION.
       
       01  IN-NAME       PIC X(100).
       01  OUT-MESSAGE   PIC X(100).
       
       PROCEDURE DIVISION USING IN-NAME OUT-MESSAGE.
       
           MOVE SPACES TO OUT-MESSAGE
           MOVE "Hello from GnuCOBOL" TO OUT-MESSAGE
       
           STRING
               PREFIX
               FUNCTION TRIM(IN-NAME)
               SUFFIX
               DELIMITED BY SIZE
               INTO OUT-MESSAGE
           END-STRING
       
      *    MOVE 1 TO RETURN-CODE
      *    STOP RUN.
           GOBACK.