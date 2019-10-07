report 50061 "Pending Order Summary"
{
    // version Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Pending Order Summary.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Purchase Line"; "Purchase Line")
        {
            DataItemTableView = SORTING ("Document Type", "Buy-from Vendor No.") ORDER(Ascending) WHERE ("Document Type" = CONST (Order), "Posting Group" = FILTER ('PAPER'), "For Location Roll Entry" = FILTER (Mother));
            RequestFilterFields = "Buy-from Vendor No.";
            column(CompName; CompName)
            {
            }
            column(SysDate; WorkDate)
            {
            }
            column(VEndor_no; PH."Buy-from Vendor No.")
            {
            }
            column(Vend_Name; PH."Buy-from Vendor Name")
            {
            }
            column(Order_No; PH."No.")
            {
            }
            column(Order_Date; PH."Order Date")
            {
            }
            column(Vendor_OrderNo; PH."Vendor Order No.")
            {
            }
            column(PaperType; "Purchase Line"."Paper Type")
            {
            }
            column(ITEM_DECKLESIZE; ITEM_DECKLESIZE)
            {
            }
            column(GSM; "Purchase Line"."Paper GSM")
            {
            }
            column(Origin; "Purchase Line".ORIGIN)
            {
            }
            column(Line_Quantity; "Purchase Line".Quantity)
            {
            }
            column(QuantityReceived_PurchaseLine; "Purchase Line"."Quantity Received")
            {
            }
            column(OutstandingQuantity_PurchaseLine; "Purchase Line"."Outstanding Quantity")
            {
            }
            column(Direct_Unit_Cost; "Purchase Line"."Direct Unit Cost")
            {
            }
            column(LCNo_PurchaseHeader; PH."LC No.")
            {
            }
            column(UnitofMeasure_PurchaseLine; "Purchase Line"."Unit of Measure")
            {
            }
            column(UnitofMeasureCode_PurchaseLine; "Purchase Line"."Unit of Measure Code")
            {
            }
            column(CURR_CODE; CURR_CODE)
            {
            }
            column(AllFilters; AllFilters)
            {
            }
            column(QuantityInvoiced; "Purchase Line"."Quantity Invoiced")
            {
            }
            column(QTY_RECEIVED; "Purchase Line"."Quantity Received")
            {
            }
            column(QTY_INVOICED; QTY_INVOICED)
            {
            }

            trigger OnAfterGetRecord()
            begin
                AllFilters := "Purchase Line".GetFilters;
                PH.Get("Document Type", "Document No.");

                compInfo.Get;
                CompName := compInfo.Name;


                PH.Reset;
                PH.SetRange(PH."No.", "Document No.");
                if PH.FindFirst then begin
                    CURR_CODE := PH."Currency Code";
                end else begin
                    CURR_CODE := '';
                end;

                ITEM_DECKLESIZE := 0;
                ITEM.Reset;
                ITEM.SetRange(ITEM."No.", "No.");
                if ITEM.FindFirst then begin
                    ITEM_DECKLESIZE := ITEM."Deckle Size (mm)";
                end;


                QTY_INVOICED := 0;
                PurchaseLine.Reset;
                PurchaseLine.SetRange(PurchaseLine."Document No.", "Document No.");
                PurchaseLine.SetRange(PurchaseLine."No.", "No.");
                PurchaseLine.SetFilter(PurchaseLine."For Location Roll Entry", 'Child');
                if PurchaseLine.FindFirst then begin
                    repeat
                        QTY_INVOICED += PurchaseLine."Quantity Invoiced";
                    until PurchaseLine.Next = 0;
                end;
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
        PH: Record "Purchase Header";
        compInfo: Record "Company Information";
        CompName: Text[100];
        CURR_CODE: Code[20];
        AllFilters: Text[100];
        ITEM: Record Item;
        ITEM_DECKLESIZE: Decimal;
        PurchaseLine: Record "Purchase Line";
        QTY_RECEIVED: Decimal;
        QTY_INVOICED: Decimal;
}

