xmlport 50002 "Import Production Schedule"
{
    // version Prod. Schedule

    CaptionML = ENU = 'Import Production Schedule';
    Direction = Import;
    Format = FixedText;
    TextEncoding = UTF8;
    TransactionType = UpdateNoLocks;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement("PROD. CMPS data Import";"PROD. CMPS data Import")
            {
                XmlName = 'ContactHeader';
                SourceTableView = SORTING(ORDER) ORDER(Ascending);
                fieldelement(ORDER;"PROD. CMPS data Import".ORDER)
                {
                    Width = 10;
                }
                fieldelement(CUSTOMERCODE;"PROD. CMPS data Import"."CUSTOMER CODE")
                {
                    Width = 16;
                }
                fieldelement(CUSTOMERNAME;"PROD. CMPS data Import"."CUSTOMER NAME")
                {
                    Width = 40;
                }
                fieldelement(GAP;"PROD. CMPS data Import".GAP)
                {
                    Width = 4;
                }
                fieldelement(RUNPAPER;"PROD. CMPS data Import"."RUN PAPER")
                {
                    Width = 7;
                }
                fieldelement(FLUTE;"PROD. CMPS data Import".FLUTE)
                {
                    Width = 3;
                }
                fieldelement(WIDTH;"PROD. CMPS data Import"."WIDTH mm")
                {
                    Width = 4;
                }
                fieldelement(LENGTH;"PROD. CMPS data Import"."LENGTH mm")
                {
                    Width = 4;
                }
                fieldelement(CUT;"PROD. CMPS data Import".CUT)
                {
                    Width = 6;
                }
                fieldelement(STACK;"PROD. CMPS data Import".STACK)
                {
                    Width = 3;
                }
                fieldelement("SC1-1";"PROD. CMPS data Import"."SC1-1 mm")
                {
                    Width = 4;
                }
                fieldelement("SC2-1";"PROD. CMPS data Import"."SC2-1 mm")
                {
                    Width = 4;
                }
                fieldelement("SC3-1";"PROD. CMPS data Import"."SC3-1 mm")
                {
                    Width = 4;
                }
                fieldelement("SC4-1";"PROD. CMPS data Import"."SC4-1 mm")
                {
                    Width = 4;
                }
                fieldelement("SC5-1";"PROD. CMPS data Import"."SC5-1 mm")
                {
                    Width = 4;
                }
                fieldelement("OUT-1";"PROD. CMPS data Import"."OUT-1")
                {
                    Width = 1;
                }
                fieldelement("SC6-2";"PROD. CMPS data Import"."SC6-2")
                {
                    Width = 4;
                }
                fieldelement("SC7-2";"PROD. CMPS data Import"."SC7-2")
                {
                    Width = 4;
                }
                fieldelement("SC8-2";"PROD. CMPS data Import"."SC8-2")
                {
                    Width = 4;
                }
                fieldelement("OUT-2";"PROD. CMPS data Import"."OUT-2")
                {
                    Width = 1;
                }
                fieldelement(REMARK;"PROD. CMPS data Import".REMARK)
                {
                    Width = 20;
                }
                fieldelement(DBPAPER;"PROD. CMPS data Import"."DB-PAPER")
                {
                    Width = 8;
                }
                fieldelement(PAPER1M;"PROD. CMPS data Import"."1M-PAPER")
                {
                    Width = 8;
                }
                fieldelement(PAPER1L;"PROD. CMPS data Import"."1L-PAPER")
                {
                    Width = 8;
                }
                fieldelement(Paper2m;"PROD. CMPS data Import"."2M-PAPER")
                {
                    Width = 8;
                }
                fieldelement(Paper2L;"PROD. CMPS data Import"."2L-PAPER")
                {
                    Width = 8;
                }
                fieldelement(PAPER3M;"PROD. CMPS data Import"."3M-PAPER")
                {
                    Width = 8;
                }
                fieldelement(PAPER3L;"PROD. CMPS data Import"."3L-PAPER")
                {
                    Width = 8;
                }
                fieldelement(ScType;"PROD. CMPS data Import".ScType)
                {
                    Width = 1;
                }
                fieldelement(DELIVERY;"PROD. CMPS data Import".DELIVERY)
                {
                    Width = 8;
                }
                fieldelement(MACHINE;"PROD. CMPS data Import".MACHINE)
                {
                    Width = 1;
                }
                fieldelement(SHIFT;"PROD. CMPS data Import".SHIFT)
                {
                    Width = 1;
                }
                fieldelement(GOODSHEET;"PROD. CMPS data Import"."GOOD SHEET")
                {
                    Width = 6;
                }
                fieldelement(SCRAPESHEET;"PROD. CMPS data Import"."SCRAPE SHEET")
                {
                    Width = 6;
                }
                fieldelement(DBRUNMETER;"PROD. CMPS data Import"."DB RUN METER")
                {
                    Width = 6;
                }
                fieldelement(RUNMETER1F;"PROD. CMPS data Import"."1F RUN METER")
                {
                    Width = 6;
                }
                fieldelement(RUNMETER2F;"PROD. CMPS data Import"."2F RUN METER")
                {
                    Width = 6;
                }
                fieldelement(RUNMETER3F;"PROD. CMPS data Import"."3F RUN METER")
                {
                    Width = 6;
                }
                fieldelement(STARTDATE;"PROD. CMPS data Import"."START DATE")
                {
                    Width = 8;
                }
                fieldelement(STARTTIME;"PROD. CMPS data Import"."START TIME")
                {
                    Width = 8;
                }
                fieldelement(RUNTIME;"PROD. CMPS data Import"."RUN TIME")
                {
                    Width = 8;
                }
                fieldelement(STOPTIME;"PROD. CMPS data Import"."STOP TIME")
                {
                    Width = 8;
                }
                fieldelement(STOPCOUNT;"PROD. CMPS data Import"."STOP COUNT")
                {
                    Width = 3;
                }

                trigger OnBeforeInsertRecord()
                begin
                    TempLineNumber:=TempLineNumber+10000;
                    //MESSAGE('Currentpath'+currXMLport.CURRENTPATH);
                    //MESSAGE('%1 %2 %3 %4 %5 %6 %7 %8',currXMLport.FILENAME,currXMLport.IMPORTFILE,currXMLport.FIELDDELIMITER,currXMLport.FIELDSEPARATOR,currXMLport.RECORDSEPARATOR,currXMLport.TABLESEPARATOR,currXMLport.TEXTENCODING,currXMLport.CURRENTPATH  );
                    "PROD. CMPS data Import".ReportDate:=Format(WorkDate);//currXMLport.CURRENTPATH;
                    "PROD. CMPS data Import".LineNumber:=TempLineNumber;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        TempLineNumber: Integer;
}

