report 50027 "Die Impression Report"
{
    // version Production/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Die Impression Report.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Capacity Ledger Entry"; "Capacity Ledger Entry")
        {
            DataItemTableView = SORTING ("Document No.", "Posting Date") ORDER(Ascending);
            RequestFilterFields = "Die Number";
            column(CompInfo_Name; CompanyInformation.Name)
            {
            }
            column(RunDate; WorkDate)
            {
            }
            column(DIEFILTER; DIEFILTER)
            {
            }
            column(DieNumber_CapacityLedgerEntry; "Capacity Ledger Entry"."Die Number")
            {
            }
            column(PPINO; PPINO)
            {
            }
            column(PPIDATE; PPIDATE)
            {
            }
            column(CustName; CustName)
            {
            }
            column(PDINO; PDINO)
            {
            }
            column(ItemNo_CapacityLedgerEntry; "Capacity Ledger Entry"."Item No.")
            {
            }
            column(FGDesc; FGDesc)
            {
            }
            column(DieCutup; DieCutup)
            {
            }
            column(OrderNo_CapacityLedgerEntry; "Capacity Ledger Entry"."Order No.")
            {
            }
            column(OutputQuantity_CapacityLedgerEntry; "Capacity Ledger Entry"."Output Quantity")
            {
            }
            column(Produced_qty; Produced_qty)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.Get;
                DIEFILTER := "Capacity Ledger Entry".GetFilters;


                PPINO := '';
                PPIDATE := '';
                Invamt := 0;
                PurchInvLine.Reset;
                PurchInvLine.SetRange(PurchInvLine."No.", "Die Number");
                if PurchInvLine.FindFirst then begin
                    repeat
                        PPINO := PPINO + PurchInvLine."Document No." + ',';
                        PPIDATE := PPIDATE + Format(PurchInvLine."Posting Date") + ',';
                        Invamt += PurchInvLine."Amount Including VAT";
                    until PurchInvLine.Next = 0
                end;



                PDINO := '';
                FGDesc := '';
                CustName := '';
                No_ofups := 0;
                DieCutup := 0;
                Produced_qty := 0;
                ProductionOrder.Reset;
                ProductionOrder.SetRange(ProductionOrder."No.", "Order No.");
                if ProductionOrder.FindFirst then begin
                    PDINO := ProductionOrder."Estimate Code";
                    FGDesc := ProductionOrder.Description;
                    CustName := ProductionOrder."Customer Name";
                    ProductionOrder.CalcFields(ProductionOrder."Finished Quantity");
                    Produced_qty := ProductionOrder."Finished Quantity";
                    ProductDesignHeader.Reset;
                    ProductDesignHeader.SetRange(ProductDesignHeader."Product Design No.", PDINO);
                    if ProductDesignHeader.FindFirst then begin
                        No_ofups := ProductDesignHeader."Board Ups";
                        DieCutup := ProductDesignHeader."No. of Die Cut Ups";
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
        CompanyInformation: Record "Company Information";
        DIEFILTER: Text;
        PurchInvLine: Record "Purch. Inv. Line";
        PPINO: Text;
        PPIDATE: Text;
        Invamt: Decimal;
        PDINO: Code[30];
        FGDesc: Text;
        CustName: Text;
        ProductionOrder: Record "Production Order";
        ProductDesignHeader: Record "Product Design Header";
        No_ofups: Integer;
        DieCutup: Integer;
        Produced_qty: Decimal;
}

