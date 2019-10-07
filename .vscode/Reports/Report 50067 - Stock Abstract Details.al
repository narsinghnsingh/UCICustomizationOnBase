report 50067 "Stock Abstract Details"
{
    // version Sadaf

    // 
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Stock Abstract Details.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;


    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(Sys_Date; WorkDate)
            {
            }
            column(CompName; "Company Information".Name)
            {
            }
            column(CompPic; "Company Information".Picture)
            {
            }
        }
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING ("Item No.") WHERE ("Item Category Code" = FILTER ('PAPER'));
            RequestFilterFields = "Posting Date";
            column(MaxDate; Format('Date: ') + '  ' + Format(MaxDate))
            {
            }
            column(MinDate; Format('From') + '  ' + Format(MinDate))
            {
            }
            column(PaperType; "Item Ledger Entry"."Paper Type")
            {
            }
            column(GSM; "Item Ledger Entry"."Paper GSM")
            {
            }
            column(DecleSize; Item."Deckle Size (mm)")
            {
            }
            column(Item_No; "Item No.")
            {
            }
            column(QTY; Quantity)
            {
            }
            column(ILEQuantity; Quantity)
            {
            }
            column(StockValue; Quantity + "Cost Amount (Expected)" + "Item Ledger Entry"."Cost Amount (Actual)")
            {
            }
            column(Value; "Cost Amount (Expected)" + "Item Ledger Entry"."Cost Amount (Actual)")
            {
            }

            trigger OnAfterGetRecord()
            begin
                MaxDate := "Item Ledger Entry".GetFilter("Item Ledger Entry"."Posting Date");
                Item.Get("Item No.");
                CalcFields("Item Ledger Entry"."Cost Amount (Actual)", "Item Ledger Entry"."Cost Amount (Expected)");
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
        GSM: Code[10];
        PurchRcptLine: Record "Purch. Rcpt. Line";
        MinDate: Date;
        MaxDate: Text[100];
        val: Decimal;
        Item: Record Item;
        ILEQuantity: Decimal;
        ItemValue: Decimal;
}

