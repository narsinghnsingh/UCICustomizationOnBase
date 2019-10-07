report 50050 "Production Schedule"
{
    // version Production/Sadaf/Firoz

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Production Schedule.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(CompName; "Company Information".Name)
            {
            }
        }
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = SORTING ("No.", Status);
            RequestFilterFields = "Due Date";
            column(Prod_ord_due_date; "Production Order"."Due Date")
            {
            }
            column(Production_Order_No; "Production Order"."No.")
            {
            }
            column(Prod_ord_Customer_name; "Production Order"."Customer Name")
            {
            }
            column(totalCutting; totalCutting)
            {
            }
            column(totalWeight; totalWeight)
            {
            }
            column(ProdQTyPerUnit; ProdQTyPerUnit)
            {
            }
            column(Prod_ord_Qty; "Production Order".Quantity)
            {
            }
            column(PaperQuantity1; PaperQuantity[1])
            {
            }
            column(PaperQuantity2; PaperQuantity[2])
            {
            }
            column(PaperQuantity3; PaperQuantity[3])
            {
            }
            column(PaperQuantity4; PaperQuantity[4])
            {
            }
            column(GSMArr1; GSMArr[1] + ' ' + GSMType[1])
            {
            }
            column(GSMArr2; GSMArr[2] + ' ' + GSMType[2])
            {
            }
            column(GSMArr3; GSMArr[3] + ' ' + GSMType[3])
            {
            }
            column(GSMArr4; GSMArr[4] + ' ' + GSMType[4])
            {
            }
            column(GSMArr5; GSMArr[5] + ' ' + GSMType[5])
            {
            }
            column(PaperQuantity5; PaperQuantity[5])
            {
            }
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = "Prod. Order No." = FIELD ("No.");
                column(Prod_line_Item_No; "Prod. Order Line"."Item No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //MESSAGE("Prod. Order Line"."Item No.");
                end;
            }
            dataitem("Product Design Header"; "Product Design Header")
            {
                DataItemLink = "Product Design No." = FIELD ("Estimate Code"), "Production Order No." = FIELD ("No.");
                column(BoardUps_EstimateHeader; "Product Design Header"."Board Ups")
                {
                }
                column(Flute; "Product Design Header"."No. of Joint")
                {
                }
                column(Estimate_RW; "Product Design Header"."Roll Width (mm)")
                {
                }
            }
            dataitem("Prod. Order Component"; "Prod. Order Component")
            {
                DataItemLink = "Prod. Order No." = FIELD ("No.");
            }

            trigger OnAfterGetRecord()
            begin
                //Firoz 24-03-15

                ProdOrdComp.Reset;
                ProdOrdComp.SetRange(ProdOrdComp."Prod. Order No.", "Production Order"."No.");
                if ProdOrdComp.FindFirst then begin
                    repeat
                        if ProdOrdComp."Paper Position" = 1 then begin
                            PaperQuantity[1] := ProdOrdComp."Expected Quantity";
                            AttributValEntry.Reset;
                            AttributValEntry.SetRange(AttributValEntry."Item No.", ProdOrdComp."Item No.");
                            if AttributValEntry.FindFirst then begin
                                repeat
                                    if AttributValEntry."Item Attribute Code" = 'PAPERGSM' then
                                        GSMArr[1] := AttributValEntry."Item Attribute Value";
                                    if AttributValEntry."Item Attribute Code" = 'PAPERTYPE' then
                                        GSMType[1] := AttributValEntry."Item Attribute Value";
                                until AttributValEntry.Next = 0;
                            end;


                        end;
                        if ProdOrdComp."Paper Position" = 2 then begin
                            PaperQuantity[2] := ProdOrdComp."Expected Quantity";
                            AttributValEntry.Reset;
                            AttributValEntry.SetRange(AttributValEntry."Item No.", ProdOrdComp."Item No.");
                            if AttributValEntry.FindFirst then begin
                                repeat
                                    if AttributValEntry."Item Attribute Code" = 'PAPERGSM' then
                                        GSMArr[2] := AttributValEntry."Item Attribute Value";
                                    if AttributValEntry."Item Attribute Code" = 'PAPERTYPE' then
                                        GSMType[2] := AttributValEntry."Item Attribute Value";
                                until AttributValEntry.Next = 0;
                            end;

                        end;

                        if ProdOrdComp."Paper Position" = 3 then begin
                            PaperQuantity[3] := ProdOrdComp."Expected Quantity";
                            AttributValEntry.Reset;
                            AttributValEntry.SetRange(AttributValEntry."Item No.", ProdOrdComp."Item No.");
                            if AttributValEntry.FindFirst then begin
                                repeat
                                    if AttributValEntry."Item Attribute Code" = 'PAPERGSM' then
                                        GSMArr[3] := AttributValEntry."Item Attribute Value";
                                    if AttributValEntry."Item Attribute Code" = 'PAPERTYPE' then
                                        GSMType[3] := AttributValEntry."Item Attribute Value";
                                until AttributValEntry.Next = 0;
                            end;

                        end;

                        if ProdOrdComp."Paper Position" = 4 then begin
                            PaperQuantity[4] := ProdOrdComp."Expected Quantity";
                            AttributValEntry.Reset;
                            AttributValEntry.SetRange(AttributValEntry."Item No.", ProdOrdComp."Item No.");
                            if AttributValEntry.FindFirst then begin
                                repeat
                                    if AttributValEntry."Item Attribute Code" = 'PAPERGSM' then
                                        GSMArr[4] := AttributValEntry."Item Attribute Value";
                                    if AttributValEntry."Item Attribute Code" = 'PAPERTYPE' then
                                        GSMType[4] := AttributValEntry."Item Attribute Value";
                                until AttributValEntry.Next = 0;
                            end;

                        end;

                        if ProdOrdComp."Paper Position" = 5 then begin
                            PaperQuantity[5] := ProdOrdComp."Expected Quantity";
                            AttributValEntry.Reset;
                            AttributValEntry.SetRange(AttributValEntry."Item No.", ProdOrdComp."Item No.");
                            if AttributValEntry.FindFirst then begin
                                repeat
                                    if AttributValEntry."Item Attribute Code" = 'PAPERGSM' then
                                        GSMArr[5] := AttributValEntry."Item Attribute Value";
                                    if AttributValEntry."Item Attribute Code" = 'PAPERTYPE' then
                                        GSMType[5] := AttributValEntry."Item Attribute Value";
                                until AttributValEntry.Next = 0;
                            end;

                        end;


                    until ProdOrdComp.Next = 0;
                end;
                totalWeight := PaperQuantity[1] + PaperQuantity[2] + PaperQuantity[3] + PaperQuantity[4] + PaperQuantity[5];


                //Total Weight
                estimate.Reset;
                if estimate.FindFirst then begin
                    if estimate."No. of Die Cut Ups" = 0 then
                        estimate."No. of Die Cut Ups" := 1;
                    if estimate."Board Ups" = 0 then
                        estimate."Board Ups" := 1;
                end;
                estimate.SetRange(estimate."Production Order No.", "No.");
                estimate.SetRange(estimate."Product Design Type", estimate."Product Design Type");
                //estimate.SETRANGE(,estimate."Box Type"::"2",estimate."Box Type"::"1");
                if estimate.FindFirst then begin
                    totalCutting := (Quantity / (estimate."No. of Die Cut Ups" * estimate."Board Ups"));
                end else
                    totalCutting := (Quantity / estimate."Board Ups");
                //MESSAGE(FORMAT(totalCutting));
                //MESSAGE(FORMAT(Quantity));
                //MESSAGE(FORMAT(estimatee Cut Ups"));
                //MESSAGE(FORMAT( estimate."No. of Ups"));
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
        AttributValEntry: Record "Item Attribute Entry";
        Flute: Code[10];
        GSM: Code[50];
        type: Code[30];
        GSMType: array[5] of Code[20];
        ProdQTyPerUnit: Decimal;
        estimate: Record "Product Design Header";
        totalWeight: Decimal;
        totalCutting: Decimal;
        ProdOrdComp: Record "Prod. Order Component";
        PaperQuantity: array[5] of Decimal;
        TypeArr: array[5] of Integer;
        GSMArr: array[5] of Code[20];
}

