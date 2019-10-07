report 50015 "Jobwise material statusSummar"
{
    // version Production/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Jobwise material statusSummar.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING ("Item No.", "Order No.") ORDER(Ascending);
            RequestFilterFields = "Item No.", "Posting Date", "Item Category Code", Quantity, "Salesperson Code";
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
            column(DocumentType_ItemLedgerEntry; "Item Ledger Entry"."Document Type")
            {
            }
            column(DocNum_ItemLedgerEntry; "Item Ledger Entry"."Document No.")
            {
            }
            column(OrderNo_ItemLedgerEntry; "Item Ledger Entry"."Order No.")
            {
            }
            column(SalespersonCode_ItemLedgerEntry; "Item Ledger Entry"."Salesperson Code")
            {
            }
            column(Quantity_ItemLedgerEntry; RemainQty)
            {
            }
            column(Netwt; BOXWTPER * "Item Ledger Entry".Quantity)
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
            column(DonotPrintZero; "Donot Print Zero")
            {
            }
            column(Quantity_ItemLedgerEntry1; ILEQTY)
            {
            }
            column(GrossWt; GrossWt)
            {
            }
            column(NetWt1; NetWt)
            {
            }
            column(TotalGrossWt; "Item Ledger Entry".Quantity * GrossWt / 1000)
            {
            }
            column(RemainingQuantity_ItemLedgerEntry; "Item Ledger Entry"."Remaining Quantity")
            {
            }
            column(SalesCode; SalesCode)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.Get;

                MAXDATE := "Item Ledger Entry".GetRangeMax("Item Ledger Entry"."Posting Date");

                //ILEQTY += "Item Ledger Entry".Quantity;
                // MESSAGE('%1,%2',"Item Ledger Entry".Quantity,ILEQTY);
                Clear(SalesCode);
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Item No.", "Item Ledger Entry"."Item No.");
                ItemLedgerEntry.SetFilter(ItemLedgerEntry."Salesperson Code", '<>%1', '');
                if ItemLedgerEntry.FindLast then
                    SalesCode := ItemLedgerEntry."Salesperson Code";


                ALLFILTER := "Item Ledger Entry".GetFilters;
                BOXWT := 1;
                NOOFDIE_UPS := 1;
                BOXWTPER := 1;
                Clear(GrossWt);
                Clear(NetWt);
                ProductionOrder.Reset;
                ProductionOrder.SetRange(ProductionOrder."No.", "Order No.");
                if ProductionOrder.FindFirst then begin
                    FG_ITEMNO := ProductionOrder."Source No.";
                    STATUS := ProductionOrder.Status;
                    Item.Reset;
                    Item.SetRange(Item."No.", FG_ITEMNO);
                    if Item.FindFirst then begin
                        Item.CalcFields(Item."Customer Name");
                        CUST_NAME := Item."Customer Name";
                        ITEM_DESC := Item.Description;
                        GrossWt := Item."Gross Weight";
                        NetWt := Item."Net Weight";
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
                /*
                "Donot Print Zero":=FALSE;
                RemainQty:=0;
                
                IF "Item Ledger Entry".Positive = TRUE THEN BEGIN
                  ItemApplicationEntry.RESET;
                  ItemApplicationEntry.SETCURRENTKEY("Inbound Item Entry No.","Posting Date");
                  ItemApplicationEntry.SETRANGE(ItemApplicationEntry."Inbound Item Entry No.","Item Ledger Entry"."Entry No.");
                  ItemApplicationEntry.SETRANGE(ItemApplicationEntry."Posting Date",0D,MAXDATE);
                  IF ItemApplicationEntry.FINDFIRST THEN BEGIN
                    REPEAT
                      RemainQty+=ItemApplicationEntry.Quantity;
                
                     UNTIL ItemApplicationEntry.NEXT=0;
                  END;
                END ELSE BEGIN
                
                END;
                
                IF RemainQty<>0 THEN
                    "Donot Print Zero":=TRUE ELSE "Donot Print Zero":=FALSE;
                */
                if ("Item Ledger Entry"."Remaining Quantity" = 0) then
                    CurrReport.Skip;

            end;

            trigger OnPreDataItem()
            begin
                Clear(ILEQTY);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Donot Print Zero"; "Donot Print Zero")
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
        REP_CAP: Label 'JOBWISE MATERIAL STATUS SUMMARY';
        ORDERED_QTY: Decimal;
        PRINT_DETAIL: Boolean;
        MAXDATE: Date;
        NOOFDAYS: Decimal;
        PRINT_ZERO: Boolean;
        STATUS: Option Simulated,Planned,"Firm Planned",Released,Finished;
        PackingListLine: Record "Packing List Line";
        QTYINPALLET: Integer;
        CTN: Integer;
        "Print_ Summary": Boolean;
        DonontPrintZero: Boolean;
        ShowLine: Boolean;
        ItemApplicationEntry: Record "Item Application Entry";
        RemainQty: Decimal;
        "Donot Print Zero": Boolean;
        GrossWt: Decimal;
        NetWt: Decimal;
        ILEQTY: Decimal;
        SalesCode: Code[20];
        ItemLedgerEntry: Record "Item Ledger Entry";
}

