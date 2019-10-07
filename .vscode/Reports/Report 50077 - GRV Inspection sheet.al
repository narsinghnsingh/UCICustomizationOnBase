report 50077 "GRV Inspection sheet"
{
    // version Purchase/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/GRV Inspection sheet.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Inspection Sheet"; "Inspection Sheet")
        {
            DataItemTableView = SORTING ("Sequence No") ORDER(Ascending);
            RequestFilterFields = "Source Document No.", "Paper Type", "Paper GSM";
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
            column(GRVDATE; GRVDATE)
            {
            }
            column(SourceType_InspectionSheet; "Inspection Sheet"."Source Type")
            {
            }
            column(SourceDocumentNo_InspectionSheet; "Inspection Sheet"."Source Document No.")
            {
            }
            column(RollNumber_InspectionSheet; "Inspection Sheet"."Roll Number")
            {
            }
            column(PaperType_InspectionSheet; "Inspection Sheet"."Paper Type")
            {
            }
            column(PaperGSM_InspectionSheet; "Inspection Sheet"."Paper GSM")
            {
            }
            column(ORIGIN; ORIGIN)
            {
            }
            column(SUPPLIER; MILL_NAME)
            {
            }
            column(QACharacteristicDescription_InspectionSheet; "Inspection Sheet"."QA Characteristic Description")
            {
            }
            column(QACharacteristicCode_InspectionSheet; "Inspection Sheet"."QA Characteristic Code")
            {
            }
            column(MinValueNum_InspectionSheet; "Inspection Sheet"."Min. Value (Num)")
            {
            }
            column(MaxValueNum_InspectionSheet; "Inspection Sheet"."Max. Value (Num)")
            {
            }
            column(ActualValueNum_InspectionSheet; "Inspection Sheet"."Actual Value (Num)")
            {
            }
            column(Observation1Num_InspectionSheet; "Inspection Sheet"."Observation 1 (Num)")
            {
            }
            column(Observation2Num_InspectionSheet; "Inspection Sheet"."Observation 2 (Num)")
            {
            }
            column(Observation3Num_InspectionSheet; "Inspection Sheet"."Observation 3 (Num)")
            {
            }
            column(Observation4Num_InspectionSheet; "Inspection Sheet"."Observation 4 (Num)")
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
            column(Remarks; "Inspection Sheet".Remarks)
            {
            }
            column(AVG; AVG)
            {
            }
            column(ROLLWT; ROLLWT)
            {
            }

            trigger OnAfterGetRecord()
            begin
                COMINFO.GET;
                COMINFO.CALCFIELDS(COMINFO.Picture);

                /*QualitySpecLine.RESET;
                QualitySpecLine.SETRANGE(QualitySpecLine."Spec ID","Inspection Sheet"."Spec ID");
                QualitySpecLine.SETRANGE(QualitySpecLine."Character Code","Inspection Sheet"."QA Characteristic Code");
                IF QualitySpecLine.FINDFIRST THEN
                  SLNO := QualitySpecLine."Sequence No" ;
                */

                SLNO := SLNO + 1;


                PRH.RESET;
                PRH.SETRANGE(PRH."No.", "Source Document No.");
                IF PRH.FINDFIRST THEN BEGIN
                    VENDORNAME := PRH."Buy-from Vendor Name";
                    GRVDATE := PRH."Posting Date";
                END ELSE BEGIN
                    VENDORNAME := '';
                    GRVDATE := 0D;
                END;

                ITEM_VARIANT.RESET;
                ITEM_VARIANT.SETRANGE(ITEM_VARIANT."Purchase Receipt No.", "Source Document No.");
                IF ITEM_VARIANT.FINDFIRST THEN BEGIN
                    REPEAT
                        ROLLWT := ITEM_VARIANT."MILL Reel No.";
                    UNTIL ITEM_VARIANT.NEXT = 0
                END;

                GRVQTY := 0;
                PRL.RESET;
                PRL.SETRANGE(PRL."Document No.", "Source Document No.");
                PRL.SETRANGE(PRL."Paper Type", "Paper Type");
                PRL.SETRANGE(PRL."Paper GSM", "Paper GSM");
                IF PRL.FINDFIRST THEN BEGIN
                    REPEAT
                        GRVQTY += PRL.Quantity;
                        QTYACCPTED += PRL."Accepted Qty.";
                        QTYREJECTED += PRL."Rejected Qty.";
                        QTYUNDERDEV += PRL."Acpt. Under Dev.";
                        ORIGIN := PRL.ORIGIN;
                    UNTIL PRL.NEXT = 0;
                    // MESSAGE(FORMAT(GRVQTY));
                END;


                /*ROLL_ENTRY.RESET;
                ROLL_ENTRY.SETRANGE(ROLL_ENTRY."Attribute Code","Source Document No.");
                ROLL_ENTRY.SETFILTER(ROLL_ENTRY."Acpt. Under Dev.",'TRUE');
                ROLL_ENTRY.SETRANGE(ROLL_ENTRY."Paper Type","Paper Type");
                ROLL_ENTRY.SETRANGE(ROLL_ENTRY."Paper GSM","Paper GSM");
                IF ROLL_ENTRY.FINDFIRST THEN BEGIN
                  DEVREMARKS := ROLL_ENTRY."Acpt. Under Dev. Remark";
                END;
                 */

                /*ROLL_ENTRY.RESET;
                ROLL_ENTRY.SETRANGE(ROLL_ENTRY."Modification Date and Time","Source Document No.");
                ROLL_ENTRY.SETFILTER(ROLL_ENTRY.Accepted,'FALSE');
                ROLL_ENTRY.SETFILTER(ROLL_ENTRY."Acpt. Under Dev.",'FALSE');
                ROLL_ENTRY.SETRANGE(ROLL_ENTRY."Paper Type","Paper Type");
                ROLL_ENTRY.SETRANGE(ROLL_ENTRY."Paper GSM","Paper GSM");
                IF ROLL_ENTRY.FINDFIRST THEN BEGIN
                  REJECTEDREMARK := ROLL_ENTRY."Rejection Remark";
                END;
                */

                /*ROLL_ENTRY.RESET;
                ROLL_ENTRY.SETRANGE(ROLL_ENTRY."Modification Date and Time","Source Document No.");
                IF ROLL_ENTRY.FINDFIRST THEN BEGIN
                    MILL_NAME := ROLL_ENTRY.SUPPLIER;
                    ORIGIN := ROLL_ENTRY.ORIGIN;
                END;
                 */


                AVG := ("Inspection Sheet"."Observation 1 (Num)" + "Inspection Sheet"."Observation 2 (Num)" + "Inspection Sheet"."Observation 3 (Num)" + "Inspection Sheet"."Observation 4 (Num)") / 4;

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
        MILL_NAME: Code[30];
        ORIGIN: Code[30];
        QualitySpecLine: Record "Quality Spec Line";
        MyPostingDate: Date;
        AVG: Decimal;
        ITEM_VARIANT: Record "Item Variant";
        ROLLWT: Code[1000];
}

