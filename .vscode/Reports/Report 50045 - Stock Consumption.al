report 50045 "Stock Consumption"
{
    // version Purchase/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Stock Consumption.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING ("Item No.") ORDER(Ascending) WHERE ("Entry Type" = CONST (Consumption), "Item Category Code" = FILTER ('PAPER'));
            RequestFilterFields = "Posting Date";
            column(COMINFO; COMINFO.Name)
            {
            }
            column(Sys_Date; WorkDate)
            {
            }
            column(MINDATE; Format('FROM') + ' ' + Format(MINDATE))
            {
            }
            column(MAXDATE; Format('TO') + ' ' + Format(MAXDATE))
            {
            }
            column(Item_No; "Item Ledger Entry"."Item No.")
            {
            }
            column(GSM; "Item Ledger Entry"."Paper GSM")
            {
            }
            column(PaperType; "Item Ledger Entry"."Paper Type")
            {
            }
            column(QTY; "Item Ledger Entry".Quantity)
            {
            }
            column(Value; "Item Ledger Entry"."Cost Amount (Actual)")
            {
            }
            column(Value_DuringPeriod; "Item Ledger Entry"."Cost Amount (Actual) Sam")
            {
            }
            column(postingDate; "Item Ledger Entry"."Posting Date")
            {
            }
            column(DeckleSize; "Item Ledger Entry"."Deckle Size (mm)")
            {
            }

            trigger OnAfterGetRecord()
            begin
                COMINFO.Get;


                item.Reset;
                item.SetRange(item."No.", "Item No.");
                if item.FindFirst then begin
                    PaperType := item."Paper Type";
                    GSM := item."Paper GSM";
                end;
            end;

            trigger OnPreDataItem()
            begin
                MINDATE := "Item Ledger Entry".GetRangeMin("Item Ledger Entry"."Posting Date");
                MAXDATE := "Item Ledger Entry".GetRangeMax("Item Ledger Entry"."Posting Date");
                SetRange("Item Ledger Entry"."Date Filter", MINDATE, MAXDATE);
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
        RollMaster: Record "Attribute Master";
        PaperType: Code[20];
        GSM: Decimal;
        PurchRcptLine: Record "Purch. Rcpt. Line";
        MinDate1: Date;
        MaxDate1: Date;
        val: Decimal;
        item: Record Item;
        TempDate: Date;
        COMINFO: Record "Company Information";
        MINDATE: Date;
        MAXDATE: Date;
}

