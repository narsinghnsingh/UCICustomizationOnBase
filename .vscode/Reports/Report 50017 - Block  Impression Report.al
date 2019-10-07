report 50017 "Block  Impression Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Block  Impression Report.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Capacity Ledger Entry"; "Capacity Ledger Entry")
        {
            CalcFields = "Customer No.";
            DataItemTableView = SORTING ("Document No.", "Posting Date") ORDER(Ascending) WHERE ("Work Center No." = FILTER ('WC0002'));
            RequestFilterFields = "Item No.", "Customer No.", "Plate Item";
            column(CompInfo_Name; CompanyInformation.Name)
            {
            }
            column(PreviewFilter; PreviewFilter)
            {
            }
            column(RUNDATE; WorkDate)
            {
            }
            column(ItemNo_CapacityLedgerEntry; "Capacity Ledger Entry"."Item No.")
            {
            }
            column(CustomerNo_CapacityLedgerEntry; "Capacity Ledger Entry"."Customer No.")
            {
            }
            column(PlateItem_CapacityLedgerEntry; "Capacity Ledger Entry"."Plate Item")
            {
            }
            column(PlateItemNo2_CapacityLedgerEntry; "Capacity Ledger Entry"."Plate Item No. 2")
            {
            }
            column(OrderNo_CapacityLedgerEntry; "Capacity Ledger Entry"."Order No.")
            {
            }
            column(OutputQuantity_CapacityLedgerEntry; "Capacity Ledger Entry"."Output Quantity")
            {
            }
            column(PDINO; PDINO)
            {
            }
            column(NoOfDieCutups; NoOfDieCutups)
            {
            }
            column(Cust_Name; Cust_Name)
            {
            }
            column(Item_Desc; Item_Desc)
            {
            }
            column(PPINO1; PPINO1)
            {
            }
            column(PPIDATE1; PPIDATE1)
            {
            }
            column(PPINO2; PPINO2)
            {
            }
            column(PPIDATE2; PPIDATE2)
            {
            }
            column(Produced_Qty; Produced_Qty)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.Get;
                "Capacity Ledger Entry".CalcFields("Capacity Ledger Entry"."Customer No.");

                PreviewFilter := "Capacity Ledger Entry".GetFilters;

                PDINO := '';
                NoOfDieCutups := 0;
                ProductDesignHeader.Reset;
                ProductDesignHeader.SetRange(ProductDesignHeader."Item Code", "Item No.");
                if ProductDesignHeader.FindFirst then begin
                    PDINO := ProductDesignHeader."Product Design No.";
                    NoOfDieCutups := ProductDesignHeader."No. of Die Cut Ups";
                end;

                Customer.Reset;
                Customer.SetRange(Customer."No.", "Customer No.");
                if Customer.FindFirst then begin
                    Cust_Name := Customer.Name;
                end;


                ProductionOrder.Reset;
                ProductionOrder.SetRange(ProductionOrder."No.", "Order No.");
                if ProductionOrder.FindFirst then begin
                    Item_Desc := ProductionOrder.Description;
                    ProductionOrder.CalcFields(ProductionOrder."Finished Quantity");
                    Produced_Qty := ProductionOrder."Finished Quantity";
                end;


                PPINO1 := '';
                PPIDATE1 := '';
                PurchInvLine.Reset;
                PurchInvLine.SetRange(PurchInvLine."Item Category Code", 'PLATE_FILM');
                PurchInvLine.SetRange(PurchInvLine."No.", "Plate Item");
                if PurchInvLine.FindFirst then begin
                    repeat
                        PPINO1 := PPINO1 + PurchInvLine."Document No." + ',';
                        PPIDATE1 := PPIDATE1 + Format(PurchInvLine."Posting Date") + ',';
                    until PurchInvLine.Next = 0
                end;

                PPINO2 := '';
                PPIDATE2 := '';
                PurchInvLine.Reset;
                PurchInvLine.SetRange(PurchInvLine."Item Category Code", 'PLATE_FILM');
                PurchInvLine.SetRange(PurchInvLine."No.", "Plate Item No. 2");
                if PurchInvLine.FindFirst then begin
                    repeat
                        PPINO2 := PPINO2 + PurchInvLine."Document No." + ',';
                        PPIDATE2 := PPIDATE2 + Format(PurchInvLine."Posting Date") + ',';
                    until PurchInvLine.Next = 0
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
        CompanyInformation: Record "Company Information";
        ProductDesignHeader: Record "Product Design Header";
        PDINO: Code[20];
        NoOfDieCutups: Decimal;
        Customer: Record Customer;
        Cust_Name: Text;
        ProductionOrder: Record "Production Order";
        Item_Desc: Text;
        Produced_Qty: Decimal;
        PurchInvLine: Record "Purch. Inv. Line";
        PPINO1: Text;
        PPIDATE1: Text;
        PPINO2: Text;
        PPIDATE2: Text;
        PreviewFilter: Text;
}

