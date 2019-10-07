report 50001 "Jobwise material status"
{
    // version Production/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Jobwise material status.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING ("Item No.", "Posting Date") ORDER(Ascending);
            RequestFilterFields = "Item No.", "Posting Date", "Item Category Code";
            column(EntryNo_ItemLedgerEntry; "Item Ledger Entry"."Entry No.")
            {
            }
            column(Comp_Name; CompanyInformation.Name)
            {
            }
            column(REP_CAP; REP_CAP)
            {
            }
            column(ALLFILTER; ALLFILTER)
            {
            }
            column(RUN_DATE; WorkDate)
            {
            }
            column(PostingDate_ItemLedgerEntry; "Item Ledger Entry"."Posting Date")
            {
            }
            column(EntryType_ItemLedgerEntry; "Item Ledger Entry"."Entry Type")
            {
            }
            column(ItemNo_ItemLedgerEntry; "Item Ledger Entry"."Item No.")
            {
            }
            column(ITEM_DESC; ITEM_DESC)
            {
            }
            column(OrderNo_ItemLedgerEntry; "Item Ledger Entry"."Order No.")
            {
            }
            column(Quantity_ItemLedgerEntry; "Item Ledger Entry".Quantity)
            {
            }
            column(Netwt; BOXWTPER * "Item Ledger Entry".Quantity)
            {
            }
            column(ORDER_DATE; ORDER_DATE)
            {
            }
            column(ORDERED_QTY; ORDERED_QTY)
            {
            }
            column(PRINT_DETAIL; PRINT_DETAIL)
            {
            }
            column(MAXDATE; MAXDATE)
            {
            }
            column(CUST_NAME; CUST_NAME)
            {
            }
            column(NOOFDAYS; NOOFDAYS)
            {
            }
            column(STATUS; STATUS)
            {
            }
            column(CTN; CTN)
            {
            }
            column(QTYINPALLET; QTYINPALLET)
            {
            }
            column(PRINT_ZERO; PRINT_ZERO)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.Get;

                MAXDATE := "Item Ledger Entry".GetRangeMax("Item Ledger Entry"."Posting Date");

                ALLFILTER := "Item Ledger Entry".GetFilters;
                BOXWT := 1;
                NOOFDIE_UPS := 1;
                BOXWTPER := 1;
                ORDER_DATE := 0D;
                ProductionOrder.Reset;
                ProductionOrder.SetRange(ProductionOrder."No.", "Order No.");
                if ProductionOrder.FindFirst then begin
                    FG_ITEMNO := ProductionOrder."Source No.";
                    STATUS := ProductionOrder.Status;
                    ORDER_DATE := ProductionOrder."Creation Date";
                    Item.Reset;
                    Item.SetRange(Item."No.", FG_ITEMNO);
                    if Item.FindFirst then begin
                        Item.CalcFields(Item."Customer Name");
                        CUST_NAME := Item."Customer Name";
                        ITEM_DESC := Item.Description;
                        ProductDesignHeader.Reset;
                        //ProductDesignHeader.SETFILTER(ProductDesignHeader."Product Design Type",'Main');
                        ProductDesignHeader.SetRange(ProductDesignHeader."Item Code", FG_ITEMNO);
                        if ProductDesignHeader.FindFirst then begin
                            BOXWT := ((ProductDesignHeader."Board Length (mm)- L" * ProductDesignHeader."Board Width (mm)- W" * ProductDesignHeader.Grammage) / 1000000000);
                            NOOFDIE_UPS := ProductDesignHeader."No. of Die Cut Ups";
                        end;
                    end;
                end;
                BOXWTPER := BOXWT / NOOFDIE_UPS;
                ORDERED_QTY := 0;
                ProdOrderLine.Reset;
                ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", "Order No.");
                ProdOrderLine.SetRange(ProdOrderLine."Line No.", "Order Line No.");
                ProdOrderLine.SetRange(ProdOrderLine."Item No.", "Item No.");
                if ProdOrderLine.FindFirst then begin
                    ORDERED_QTY := ProdOrderLine.Quantity;
                end;

                NOOFDAYS := MAXDATE - "Item Ledger Entry"."Posting Date";
                QTYINPALLET := 0;
                PackingListLine.Reset;
                PackingListLine.SetRange(PackingListLine."Prod. Order No.", "Order No.");
                //PackingListLine.SETRANGE(PackingListLine."Item No.","Item No.");
                if PackingListLine.FindFirst then begin
                    repeat
                        QTYINPALLET += PackingListLine."Pallet No.";
                    until PackingListLine.Next = 0;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Print Detail"; PRINT_DETAIL)
                {
                }
                field("Print Zero Qty"; PRINT_ZERO)
                {
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CompanyInformation: Record "Company Information";
        Item: Record Item;
        ITEM_DESC: Text;
        ALLFILTER: Text;
        ProductionOrder: Record "Production Order";
        CUST_NAME: Text;
        FG_ITEMNO: Code[30];
        FG_QTY: Decimal;
        ProductDesignHeader: Record "Product Design Header";
        BOXWT: Decimal;
        NOOFDIE_UPS: Integer;
        BOXWTPER: Decimal;
        ProdOrderLine: Record "Prod. Order Line";
        SL_NO: Integer;
        REP_CAP: Label 'JOBWISE MATERIAL STATUS';
        ORDERED_QTY: Decimal;
        PRINT_DETAIL: Boolean;
        MAXDATE: Date;
        NOOFDAYS: Decimal;
        PRINT_ZERO: Boolean;
        STATUS: Option Simulated,Planned,"Firm Planned",Released,Finished;
        PackingListLine: Record "Packing List Line";
        QTYINPALLET: Integer;
        CTN: Integer;
        ILE: Record "Item Ledger Entry";
        ShowLine: Boolean;
        ORDER_DATE: Date;
}

