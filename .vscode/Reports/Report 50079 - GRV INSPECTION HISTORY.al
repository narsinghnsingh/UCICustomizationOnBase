report 50079 "GRV INSPECTION HISTORY"
{
    // version Purchase/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/GRV INSPECTION HISTORY.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
        {
            DataItemTableView = SORTING ("Document No.", "Line No.") ORDER(Ascending) WHERE ("QA Processed" = FILTER (true), Quantity = FILTER (<> 0));
            RequestFilterFields = "Posting Date";
            column(COMINFO_NAME; COMINFO.Name)
            {
            }
            column(COMINFO_PICTURE; COMINFO.Picture)
            {
            }
            column(RUNDATE; WORKDATE)
            {
            }
            column(MINDATE; FORMAT('FROM: ') + ' ' + FORMAT(MINDATE))
            {
            }
            column(MAXDATE; FORMAT('TO: ') + ' ' + FORMAT(MAXDATE))
            {
            }
            column(DocumentNo_PurchRcptLine; "Purch. Rcpt. Line"."Document No.")
            {
            }
            column(PostingDate_PurchRcptLine; "Purch. Rcpt. Line"."Posting Date")
            {
            }
            column(PaperType_PurchRcptLine; "Purch. Rcpt. Line"."Paper Type")
            {
            }
            column(PaperGSM_PurchRcptLine; "Purch. Rcpt. Line"."Paper GSM")
            {
            }
            column(Quantity_PurchRcptLine; "Purch. Rcpt. Line".Quantity)
            {
            }
            column(AcptUnderDev_PurchRcptLine; "Purch. Rcpt. Line"."Acpt. Under Dev.")
            {
            }
            column(AcceptedQty_PurchRcptLine; "Purch. Rcpt. Line"."Accepted Qty.")
            {
            }
            column(RejectedQty_PurchRcptLine; "Purch. Rcpt. Line"."Rejected Qty.")
            {
            }
            column(VENDOR_NAME; "VENDOR _NAME")
            {
            }
            column(UnitofMeasureCode_PurchRcptLine; "Purch. Rcpt. Line"."Unit of Measure Code")
            {
            }
            dataitem("Posted Inspection Sheet"; "Posted Inspection Sheet")
            {
                DataItemLink = "Document No." = FIELD ("Document No.");
                column(char_code; "Posted Inspection Sheet"."QA Characteristic Code")
                {
                }
                column(NormalValue; "Posted Inspection Sheet"."Normal Value (Num)")
                {
                }
                column(ActualNum; "Posted Inspection Sheet"."Actual Value (Num)")
                {
                }
                column(PostingDate_PostedInspectionSheet; "Posted Inspection Sheet"."Posting Date")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                MAXDATE := "Purch. Rcpt. Line".GETRANGEMAX("Purch. Rcpt. Line"."Posting Date");
                MINDATE := "Purch. Rcpt. Line".GETRANGEMIN("Purch. Rcpt. Line"."Posting Date");


                COMINFO.GET;
                COMINFO.CALCFIELDS(COMINFO.Picture);

                PRH.RESET;
                PRH.SETRANGE(PRH."No.", "Document No.");
                PRH.SETRANGE(PRH."Buy-from Vendor No.", "Buy-from Vendor No.");
                IF PRH.FINDFIRST THEN BEGIN
                    "VENDOR _NAME" := PRH."Buy-from Vendor Name";
                END ELSE BEGIN
                    "VENDOR _NAME" := '';
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
        MAXDATE: Date;
        MINDATE: Date;
        PRH: Record "Purch. Rcpt. Header";
        "VENDOR _NAME": Text[250];
}

