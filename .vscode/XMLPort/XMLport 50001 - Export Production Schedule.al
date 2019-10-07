xmlport 50001 "Export Production Schedule"
{
    // version NAVW17.10

    CaptionML = ENU = 'Export Production Schedule';
    Direction = Export;
    Format = FixedText;
    TextEncoding = UTF8;
    TransactionType = UpdateNoLocks;

    schema
    {
        textelement(Root)
        {
            tableelement("PROD. CMPS data"; "PROD. CMPS data")
            {
                XmlName = 'ContactHeader';
                SourceTableView = SORTING (SEQUENCE);
                fieldelement(COMMAND; "PROD. CMPS data".COMMAND)
                {
                    Width = 1;
                }
                fieldelement(XXX; "PROD. CMPS data".XXX)
                {
                    Width = 3;
                }
                fieldelement(SEQUENCE; "PROD. CMPS data".SEQUENCE)
                {
                    Width = 4;
                }
                fieldelement(ORDER; "PROD. CMPS data".ORDER)
                {
                    Width = 10;
                }
                fieldelement(CUSTOMER_CODE; "PROD. CMPS data"."CUSTOMER CODE")
                {
                    Width = 16;
                }
                fieldelement(CUSTOMER_NAME; "PROD. CMPS data"."CUSTOMER NAME")
                {
                    Width = 40;
                }
                fieldelement(GAP; "PROD. CMPS data".GAP)
                {
                    Width = 4;
                }
                fieldelement(RUN_PAPER; "PROD. CMPS data"."RUN PAPER")
                {
                    Width = 7;
                }
                fieldelement(FLUTE; "PROD. CMPS data".FLUTE)
                {
                    Width = 3;
                }
                fieldelement(WIDTH_mm; "PROD. CMPS data"."WIDTH mm")
                {
                    Width = 4;
                }
                fieldelement(LENGTH_mm; "PROD. CMPS data"."LENGTH mm")
                {
                    Width = 4;
                }
                fieldelement(CUT; "PROD. CMPS data".CUT)
                {
                    Width = 6;
                }
                fieldelement(STACK; "PROD. CMPS data".STACK)
                {
                    Width = 3;
                }
                fieldelement("SC1-1_mm"; "PROD. CMPS data"."SC1-1 mm")
                {
                    Width = 4;
                }
                fieldelement("SC2-1_mm"; "PROD. CMPS data"."SC2-1 mm")
                {
                    Width = 4;
                }
                fieldelement("SC3-1_mm"; "PROD. CMPS data"."SC3-1 mm")
                {
                    Width = 4;
                }
                fieldelement("SC4-1_mm"; "PROD. CMPS data"."SC4-1 mm")
                {
                    Width = 4;
                }
                fieldelement("SC5-1_mm"; "PROD. CMPS data"."SC5-1 mm")
                {
                    Width = 4;
                }
                fieldelement("OUT-1"; "PROD. CMPS data"."OUT-1")
                {
                    Width = 1;
                }
                fieldelement("SC6-2"; "PROD. CMPS data"."SC6-2 mm")
                {
                    Width = 4;
                }
                fieldelement("SC7-2"; "PROD. CMPS data"."SC7-2")
                {
                    Width = 4;
                }
                fieldelement("SC8-2"; "PROD. CMPS data"."SC8-2")
                {
                    Width = 4;
                }
                fieldelement("OUT-2"; "PROD. CMPS data"."OUT-2")
                {
                    Width = 1;
                }
                fieldelement(REMARK; "PROD. CMPS data".REMARK)
                {
                    Width = 20;
                }
                fieldelement(PAPER_DB; "PROD. CMPS data"."DB-PAPER")
                {
                    Width = 30;
                }
                fieldelement(PAPER_1M; "PROD. CMPS data"."1M-PAPER")
                {
                    Width = 30;
                }
                fieldelement(PAPER_1L; "PROD. CMPS data"."1L-PAPER")
                {
                    Width = 30;
                }
                fieldelement(PAPER_2m; "PROD. CMPS data"."2M-PAPER")
                {
                    Width = 30;
                }
                fieldelement(PAPER_2L; "PROD. CMPS data"."2L-PAPER")
                {
                    Width = 30;
                }
                fieldelement(PAPER_3M; "PROD. CMPS data"."3M-PAPER")
                {
                    Width = 30;
                }
                fieldelement(PAPER_3L; "PROD. CMPS data"."3L-PAPER")
                {
                    Width = 30;
                }
                fieldelement(SCORER_TYPE; "PROD. CMPS data".SCORER_TYPE)
                {
                    Width = 1;
                }
                fieldelement(DELIVERY; "PROD. CMPS data".DELIVERY)
                {
                    Width = 8;
                }
                fieldelement(INSERT_ORDER; "PROD. CMPS data"."INSERT ORDER")
                {
                    Width = 10;
                }
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
}

