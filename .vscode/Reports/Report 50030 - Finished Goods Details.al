report 50030 "Finished Goods Details"
{
    // version Production/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Finished Goods Details.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Packing List Header"; "Packing List Header")
        {
            DataItemTableView = SORTING (No) ORDER(Ascending) WHERE (Status = CONST (Released));
            RequestFilterFields = "Prod. Order No.";
            column(Pic; CompInfo.Picture)
            {
            }
            column(CompName; CompName)
            {
            }
            column(Conmp_Name; CompInfo.Name)
            {
            }
            column(Packing_list_No; "Packing List Header".No)
            {
            }
            column(work_order_no; "Packing List Header"."Prod. Order No.")
            {
            }
            column(Fg_Item_Np; "Packing List Header"."Item No.")
            {
            }
            column(Order_Qty; "Packing List Header"."Order Quantity")
            {
            }
            column(Produced_Qty; "Packing List Header"."Total Finished Quantity")
            {
            }
            column(CustName; CustName)
            {
            }
            column(SalesPersonCode; SalesPersonCode)
            {
            }
            column(ProdDescrition; ProdDescrition)
            {
            }
            column(LPO_No; "Packing List Header"."Sales Order No.")
            {
            }
            column(sys_Date; Today)
            {
            }
            column(FGReadttoDeliver; FGReadttoDeliver)
            {
            }
            column(PackingSpecification; PackingSpecification)
            {
            }
            column(Desc; Desc)
            {
            }
            column(DeliverQty; DeliverQty)
            {
            }
            column(Produced_On; "Packing List Header"."Creation Date")
            {
            }
            column(ExterDoc; ExterDoc)
            {
            }
            column(ODate; ODate)
            {
            }
            column(TotalPalletQuantity_PackingListHeader; "Packing List Header"."Total Pallet Quantity")
            {
            }
            column(FGqty1; FGqty)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CompInfo.Get;
                CompName := CompInfo.Name;

                CompInfo.CalcFields(CompInfo.Picture);
                ProdOrder.Reset;
                ProdOrder.SetRange(ProdOrder."No.", "Prod. Order No.");
                //ProdOrder.SETRANGE(ProdOrder."Sales Order No.","Sales Order No.");
                if ProdOrder.FindFirst then begin
                    ProdDescrition := ProdOrder.Description;
                    CustName := ProdOrder."Customer Name";
                end;

                SalesHeader.Reset;
                SalesHeader.SetRange(SalesHeader."No.", "Sales Order No.");
                if SalesHeader.FindFirst then
                    CalcFields("Total Shipped Quantity");
                //CALCFIELDS("Total Finished Quantity");
                SalesPersonCode := SalesHeader."Salesperson Code";
                ExterDoc := SalesHeader."External Document No.";
                ODate := SalesHeader."Order Date";
                DeliverQty := "Total Shipped Quantity";
                FGReadttoDeliver := "Total Pallet Quantity" - DeliverQty;

                FGqty := "Packing List Header"."Total Pallet Quantity" - DeliverQty;




                //12-03-15 Firoz

                Packlist.Reset;
                Packlist.SetCurrentKey("Packing List No.", Quantity);
                Packlist.SetRange(Packlist."Packing List No.", No);
                //IF Packlist.Posted <> TRUE THEN BEGIN
                if Packlist.FindFirst then begin

                    OldQty := 0;
                    cnt := 0;
                    PackingSpecification := '';
                    repeat
                        ;
                        if Packlist.Posted = false then
                            if OldQty <> Packlist.Quantity then begin
                                if cnt <> 0 then
                                    PackingSpecification := PackingSpecification + ' ' + Format(OldQty) + ' x ' + Format(cnt);
                                OldQty := Packlist.Quantity;
                                cnt := 1;
                            end else begin
                                cnt := cnt + 1;
                            end;
                    until Packlist.Next = 0;
                    if cnt <> 0 then
                        PackingSpecification := Format(OldQty) + ' x ' + Format(cnt) + ', ' + PackingSpecification;
                end else
                    PackingSpecification := '';
                //END;
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
        CompInfo: Record "Company Information";
        Slno: Integer;
        ProdOrder: Record "Production Order";
        ProdDescrition: Text[250];
        CustName: Text[90];
        SalesHeader: Record "Sales Header";
        SalesPersonCode: Code[20];
        SalesLine: Record "Sales Line";
        DeliverQty: Decimal;
        FGReadttoDeliver: Decimal;
        Desc: Text[250];
        CompName: Text[60];
        temp: Integer;
        Loop1: Integer;
        Packlist: Record "Packing List Line";
        OldQty: Integer;
        PackingSpecification: Text[100];
        cnt: Integer;
        ExterDoc: Code[30];
        ODate: Date;
        FGqty: Decimal;
}

