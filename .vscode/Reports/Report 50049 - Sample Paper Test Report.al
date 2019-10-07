report 50049 "Sample Paper Test Report"
{
    // version Firoz

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Sample Paper Test Report.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Posted Inspection Sheet"; "Posted Inspection Sheet")
        {
            DataItemTableView = SORTING ("Inspection Receipt No.", "Item No.", "QA Characteristic Code") ORDER(Ascending);
            RequestFilterFields = "Inspection Receipt No.", "Paper Type", "Paper GSM";
            column(COMINFO_NAME; COMINFO.Name)
            {
            }
            column(COMINFO_PICTURE; COMINFO.Picture)
            {
            }
            column(SLNO; SLNO)
            {
            }
            column(VENDORNAME; VENDORNAME)
            {
            }
            column(GRVDATE; "Posted Inspection Sheet"."Posting Date")
            {
            }
            column(SourceType_InspectionSheet; "Posted Inspection Sheet"."Document Type")
            {
            }
            column(SourceDocumentNo_InspectionSheet; "Posted Inspection Sheet"."Inspection Receipt No.")
            {
            }
            column(RollNumber_InspectionSheet; "Posted Inspection Sheet"."Roll No")
            {
            }
            column(PaperType_InspectionSheet; "Posted Inspection Sheet"."Paper Type")
            {
            }
            column(PaperGSM_InspectionSheet; "Posted Inspection Sheet"."Paper GSM")
            {
            }
            column(QACharacteristicDescription_InspectionSheet; "Posted Inspection Sheet"."QA Characteristic Description")
            {
            }
            column(QACharacteristicCode_InspectionSheet; "Posted Inspection Sheet"."QA Characteristic Code")
            {
            }
            column(MinValueNum_InspectionSheet; "Posted Inspection Sheet"."Min. Value (Num)")
            {
            }
            column(MaxValueNum_InspectionSheet; "Posted Inspection Sheet"."Max. Value (Num)")
            {
            }
            column(ActualValueNum_InspectionSheet; "Posted Inspection Sheet"."Actual Value (Num)")
            {
            }
            column(Observation1Num_InspectionSheet; "Posted Inspection Sheet"."Observation 1 (Num)")
            {
            }
            column(Observation2Num_InspectionSheet; "Posted Inspection Sheet"."Observation 2 (Num)")
            {
            }
            column(Observation3Num_InspectionSheet; "Posted Inspection Sheet"."Observation 3 (Num)")
            {
            }
            column(Observation4Num_InspectionSheet; "Posted Inspection Sheet"."Observation 4 (Num)")
            {
            }
            column(GRVQTY; GRVQTY)
            {
            }
            column(QTYACCPTED; QTYACCPTED)
            {
            }
            column(QTYREJECTED; QTYREJECTED)
            {
            }
            column(QTYUNDERDEV; QTYUNDERDEV)
            {
            }
            column(DEVREMARKS; DEVREMARKS)
            {
            }
            column(REJECTEDREMARK; REJECTEDREMARK)
            {
            }
            column(DocType; "Posted Inspection Sheet"."Document Type")
            {
            }
            column(Sampletype; Sampletype)
            {
            }
            column(Remarks; Remarks)
            {
            }

            trigger OnAfterGetRecord()
            begin
                COMINFO.GET;
                COMINFO.CALCFIELDS(COMINFO.Picture);

                SLNO := SLNO + 1;


                PRH.RESET;
                PRH.SETRANGE(PRH."No.", "Document No.");
                IF PRH.FINDFIRST THEN BEGIN
                    VENDORNAME := PRH."Buy-from Vendor Name";
                    GRVDATE := PRH."Posting Date";
                END ELSE BEGIN
                    VENDORNAME := '';
                    GRVDATE := 0D;
                END;

                GRVQTY := 0;
                PRL.RESET;
                PRL.SETRANGE(PRL."Document No.", "Document No.");
                PRL.SETRANGE(PRL."Paper Type", "Paper Type");
                PRL.SETRANGE(PRL."Paper GSM", "Paper GSM");
                IF PRL.FINDFIRST THEN BEGIN
                    REPEAT
                        GRVQTY += PRL.Quantity;
                        QTYACCPTED += PRL."Accepted Qty.";
                        QTYREJECTED += PRL."Rejected Qty.";
                        QTYUNDERDEV += PRL."Acpt. Under Dev.";
                    UNTIL PRL.NEXT = 0;
                    // MESSAGE(FORMAT(GRVQTY));
                END;

                /*
                ROLL_ENTRY.RESET;
                ROLL_ENTRY.SETRANGE(ROLL_ENTRY."Modification Date and Time","Document No.");
                ROLL_ENTRY.SETFILTER(ROLL_ENTRY."Acpt. Under Dev.",'TRUE');
                ROLL_ENTRY.SETRANGE(ROLL_ENTRY."Paper Type","Paper Type");
                ROLL_ENTRY.SETRANGE(ROLL_ENTRY."Paper GSM","Paper GSM");
                IF ROLL_ENTRY.FINDFIRST THEN BEGIN
                  DEVREMARKS := ROLL_ENTRY."Acpt. Under Dev. Remark";
                END;
                */
                /*
                ROLL_ENTRY.RESET;
                ROLL_ENTRY.SETRANGE(ROLL_ENTRY."Modification Date and Time","Document No.");
                ROLL_ENTRY.SETFILTER(ROLL_ENTRY.Accepted,'FALSE');
                ROLL_ENTRY.SETFILTER(ROLL_ENTRY."Acpt. Under Dev.",'FALSE');
                ROLL_ENTRY.SETRANGE(ROLL_ENTRY."Paper Type","Paper Type");
                ROLL_ENTRY.SETRANGE(ROLL_ENTRY."Paper GSM","Paper GSM");
                IF ROLL_ENTRY.FINDFIRST THEN BEGIN
                  REJECTEDREMARK := ROLL_ENTRY."Rejection Remark";
                END;
                */
                InspectionHeader.RESET;
                InspectionHeader.SETRANGE(InspectionHeader."No.", "Inspection Receipt No.");
                IF InspectionHeader.FINDFIRST THEN BEGIN
                    Sampletype := InspectionHeader."Inspection Type";
                    Remarks := InspectionHeader.Remarks;
                END;

            end;
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

    labels
    {
    }

    var
        COMINFO: Record "Company Information";
        SLNO: Integer;
        PRH: Record "Purch. Rcpt. Header";
        GRVDATE: Date;
        VENDORNAME: Text[250];
        PRL: Record "Purch. Rcpt. Line";
        GRVQTY: Decimal;
        QTYACCPTED: Decimal;
        QTYREJECTED: Decimal;
        QTYUNDERDEV: Decimal;
        ROLL_ENTRY: Record "Attribute Master";
        DEVREMARKS: Text[250];
        REJECTEDREMARK: Text[250];
        COMPANY_INF: Record "Company Information";
        InspectionHeader: Record "Inspection Header";
        Sampletype: Option Production,"Sample Paper",Item;
        InsHeader: Record "Inspection Header";
        Remarks: Text[300];
}

