report 50107 "JobWise Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/JobWise Summary.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            RequestFilterFields = "Posting Date", "Item No.", "Salesperson Code";
            column(EntryNo_ItemLedgerEntry; "Item Ledger Entry"."Entry No.")
            {
            }
            column(ItemNo_ItemLedgerEntry; "Item Ledger Entry"."Item No.")
            {
            }
            column(PostingDate_ItemLedgerEntry; Format("Item Ledger Entry"."Posting Date"))
            {
            }
            column(Quantity_ItemLedgerEntry; "Item Ledger Entry".Quantity)
            {
            }
            column(SalespersonCode_ItemLedgerEntry; "Item Ledger Entry"."Salesperson Code")
            {
            }
            column(OrderNo_ItemLedgerEntry; "Item Ledger Entry"."Order No.")
            {
            }
            column(GrossWt; GrossWt)
            {
            }
            column(WORKDATE; Format(WorkDate))
            {
            }
            column(NetWt; NetWt)
            {
            }
            column(CompanyInfo_Name; CompanyInformation.Name)
            {
            }
            column(RemainingQuantity_ItemLedgerEntry; "Item Ledger Entry"."Remaining Quantity")
            {
            }
            column(TotalGrossWt; "Item Ledger Entry".Quantity * GrossWt / 1000)
            {
            }
            column(DocumentType_ItemLedgerEntry; "Item Ledger Entry"."Document Type")
            {
            }
            column(SalesCode; SalesCode)
            {
            }
            column(ITEM_DESC; ITEM_DESC)
            {
            }
            column(CUST_NAME; CUST_NAME)
            {
            }
            column(FilterString; FilterString)
            {
            }
            column(REP_CAP; REP_CAP)
            {
            }
            column(JobNo; JobNo)
            {
            }
            column(ILEQTY; ILEQTY)
            {
            }
            column(TotalQty; TotalQty)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.Get;

                Clear(SalesCode);
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Item No.", "Item Ledger Entry"."Item No.");
                ItemLedgerEntry.SetFilter(ItemLedgerEntry."Salesperson Code", '<>%1', '');
                if ItemLedgerEntry.FindLast then
                    SalesCode := ItemLedgerEntry."Salesperson Code";
                /*
                CLEAR(JobNo);
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETCURRENTKEY(ItemLedgerEntry."Entry No.");
                ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Posting Date","Item Ledger Entry"."Posting Date");
                ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Item No.","Item Ledger Entry"."Item No.");
                ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Salesperson Code","Item Ledger Entry"."Salesperson Code");
                ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Item Category Code","Item Ledger Entry"."Item Category Code");
                ItemLedgerEntry.SETRANGE(ItemLedgerEntry.Open,TRUE);
                IF ItemLedgerEntry.FINDFIRST THEN  BEGIN
                   REPEAT
                   JobNo := ItemLedgerEntry."Order No.";
                   UNTIL ItemLedgerEntry.NEXT = 0;
                END;
                */

                FilterString := "Item Ledger Entry".GetFilters;

                ProductionOrder.Reset;
                ProductionOrder.SetRange(ProductionOrder."No.", "Order No.");
                if ProductionOrder.FindFirst then begin
                    FG_ITEMNO := ProductionOrder."Source No.";
                    //STATUS := ProductionOrder.Status;
                    Item1.Reset;
                    Item1.SetRange(Item1."No.", FG_ITEMNO);
                    if Item1.FindFirst then begin
                        Item1.CalcFields(Item1."Customer Name");
                        CUST_NAME := Item1."Customer Name";
                        ITEM_DESC := Item1.Description;
                        GrossWt := Item1."Gross Weight";
                        NetWt := Item1."Net Weight";
                    end;
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
        GrossWt: Decimal;
        NetWt: Decimal;
        CompanyInformation: Record "Company Information";
        Item1: Record Item;
        ITEM_DESC: Text;
        ProductionOrder: Record "Production Order";
        CUST_NAME: Text;
        FG_ITEMNO: Code[30];
        FG_QTY: Decimal;
        FilterString: Text;
        MAXDATE: Date;
        ILEQTY: Decimal;
        SalesCode: Code[20];
        ItemLedgerEntry: Record "Item Ledger Entry";
        REP_CAP: Label 'JOBWISE MATERIAL STATUS SUMMARY';
        JobNo: Code[20];
        TotalQty: Decimal;
}

