report 50093 "QualityTest Before"
{
    // version Firoz

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/QualityTest Before.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(CompName; "Company Information".Name)
            {
            }
            column(Pic; "Company Information".Picture)
            {
            }
            dataitem("Inspection Header"; "Inspection Header")
            {
                RequestFilterFields = "No.";
                column(InspectionHeaderNo; "Inspection Header"."No.")
                {
                }
                column(InspectionheaderJobNo; "Inspection Header"."Job No.")
                {
                }
                column(InspectionHeaderItemNo; "Inspection Header"."Item No.")
                {
                }
                column(LPONo; LPONo)
                {
                }
                column(CustName; CustName)
                {
                }
                column(SupplierCustName; SupplierCustName)
                {
                }
                column(Remarks; "Inspection Header".Remarks)
                {
                }
                column(OrderQty; OrderQty)
                {
                }
                column(LPODate; LPODate)
                {
                }
                column(InspectionHaederDesc; "Inspection Header"."Item Description")
                {
                }
                column(FG_Ply; FG_Ply)
                {
                }
                column(FG_GSM; FG_GSM)
                {
                }
                column(FG_LENGTH; FG_LENGTH + ' X ' + FG_WIDTH + ' X ' + FG_HEIGHT)
                {
                }
                column(FG_WIDTH; FG_WIDTH)
                {
                }
                column(FG_HEIGHT; FG_HEIGHT)
                {
                }
                column(FG_DESC; FG_DESC)
                {
                }
                column(FG_Color; FG_Color)
                {
                }
                column(FG_Flute; FG_Flute)
                {
                }
                column(ITEM_NO2; ITEM_NO2)
                {
                }
                dataitem("Posted Inspection Sheet"; "Posted Inspection Sheet")
                {
                    DataItemLink = "Source Document No." = FIELD ("Job No."), "Inspection Receipt No." = FIELD ("No."), "Item No." = FIELD ("Item No.");
                    DataItemTableView = SORTING ("Sequence No") ORDER(Ascending) WHERE ("Source Type" = CONST (Output));
                    column(QAdeasc; "Posted Inspection Sheet"."QA Characteristic Description")
                    {
                    }
                    column(ActualValueText; "Posted Inspection Sheet"."Actual  Value (Text)")
                    {
                    }
                    column(ActualValueNum; "Posted Inspection Sheet"."Actual Value (Num)")
                    {
                    }
                    column(Actual; Actual)
                    {
                    }
                    column(StandardValue; StandardValue)
                    {
                    }
                    column(SlNo; SlNo)
                    {
                    }
                    column(InspectionSheetDocDate; "Posted Inspection Sheet"."Document Date")
                    {
                    }
                    column(SourceDocNo; "Posted Inspection Sheet"."Source Document No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin

                        SlNo := SlNo + 1;


                        if Quantitative = true then begin
                            Actual := Format("Actual Value (Num)");
                            if "Posted Inspection Sheet"."Normal Value (Num)" <> 0 then
                                StandardValue := Format("Posted Inspection Sheet"."Normal Value (Num)");
                        end;

                        if Qualitative = true then begin
                            Actual := "Actual  Value (Text)";
                            StandardValue := "Posted Inspection Sheet"."Normal Value (Text)"
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin

                    /*InspectionHeader.RESET;
                    InspectionHeader.SETCURRENTKEY("No.");
                    InspectionHeader.SETRANGE(InspectionHeader."Source Type",InspectionHeader."Source Type"::Output);
                    InspectionHeader.SETRANGE(InspectionHeader."Job No.","Sales Invoice Line"."Prod. Order No.");
                    InspectionHeader.SETRANGE(InspectionHeader.Posted,TRUE);
                    IF InspectionHeader.FINDLAST THEN BEGIN
                      TempInspection:=InspectionHeader."No.";
                      TempRemarks:=InspectionHeader.Remarks;
                    END ELSE BEGIN
                      TempInspection:='';
                      TempRemarks:='';
                    END;
                    */




                    ProdOrderHeader.Reset;
                    SalesHeader.Reset;
                    ProdOrderHeader.SetRange(ProdOrderHeader."No.", "Inspection Header"."Job No.");
                    if ProdOrderHeader.FindFirst then begin
                        SalesHeader.SetRange(SalesHeader."No.", ProdOrderHeader."Sales Order No.");
                        if SalesHeader.FindFirst then
                            LPODate := SalesHeader."Document Date";
                        LPONo := SalesHeader."External Document No.";
                        CustName := SalesHeader."Sell-to Customer Name";
                    end;
                    ProdOrderHeader1.Reset;
                    ProdOrderHeader1.SetRange(ProdOrderHeader1."No.", "Inspection Header"."Job No.");
                    if ProdOrderHeader1.FindFirst then begin
                        OrderQty := ProdOrderHeader1.Quantity;
                    end;
                    //MESSAGE(FORMAT(ProdOrderHeader1.Quantity));
                    ITEM_NO2 := '';
                    ITEM.Reset;
                    ITEM.SetRange(ITEM."No.", "Item No.");
                    if ITEM.FindFirst then begin
                        ITEM_NO2 := ITEM."No. 2";
                    end;

                    SupplierCustName := '';
                    EstimateCards.Reset;
                    EstimateCards.SetRange(EstimateCards."Item Code", "Item No.");
                    if EstimateCards.FindFirst then
                        SupplierCustName := EstimateCards.Name;



                    ItemAttributeEntryRec.Reset;
                    ItemAttributeEntryRec.SetRange(ItemAttributeEntryRec."Item No.", "Item No.");
                    if ItemAttributeEntryRec.FindFirst then begin
                        repeat
                            if ItemAttributeEntryRec."Item Attribute Code" = 'PLY' then begin
                                FG_Ply := ItemAttributeEntryRec."Item Attribute Value";

                            end;
                        until ItemAttributeEntryRec.Next = 0;
                    end;

                    ItemAttributeEntryRec.Reset;
                    ItemAttributeEntryRec.SetRange(ItemAttributeEntryRec."Item No.", "Item No.");
                    if ItemAttributeEntryRec.FindFirst then begin
                        repeat
                            if ItemAttributeEntryRec."Item Attribute Code" = 'FG_GSM' then begin
                                FG_GSM := ItemAttributeEntryRec."Item Attribute Value";
                            end;
                        until ItemAttributeEntryRec.Next = 0;
                    end;

                    ItemAttributeEntryRec.Reset;
                    ItemAttributeEntryRec.SetRange(ItemAttributeEntryRec."Item No.", "Item No.");
                    if ItemAttributeEntryRec.FindFirst then begin
                        repeat
                            if ItemAttributeEntryRec."Item Attribute Code" = 'FG_DESC' then begin
                                FG_DESC := ItemAttributeEntryRec."Item Attribute Value";

                            end;
                        until ItemAttributeEntryRec.Next = 0;
                    end;
                    ItemAttributeEntryRec.Reset;
                    ItemAttributeEntryRec.SetRange(ItemAttributeEntryRec."Item No.", "Item No.");
                    if ItemAttributeEntryRec.FindFirst then begin
                        repeat
                            if ItemAttributeEntryRec."Item Attribute Code" = 'LENGTH' then begin
                                FG_LENGTH := ItemAttributeEntryRec."Item Attribute Value";
                            end;
                        until ItemAttributeEntryRec.Next = 0;
                    end;

                    ItemAttributeEntryRec.Reset;
                    ItemAttributeEntryRec.SetRange(ItemAttributeEntryRec."Item No.", "Item No.");
                    if ItemAttributeEntryRec.FindFirst then begin
                        repeat
                            if ItemAttributeEntryRec."Item Attribute Code" = 'WIDTH' then begin
                                FG_WIDTH := ItemAttributeEntryRec."Item Attribute Value";
                            end;
                        until ItemAttributeEntryRec.Next = 0;
                    end;
                    ItemAttributeEntryRec.Reset;
                    ItemAttributeEntryRec.SetRange(ItemAttributeEntryRec."Item No.", "Item No.");
                    if ItemAttributeEntryRec.FindFirst then begin
                        repeat
                            if ItemAttributeEntryRec."Item Attribute Code" = 'HEIGHT' then begin
                                FG_HEIGHT := ItemAttributeEntryRec."Item Attribute Value";
                            end;
                        until ItemAttributeEntryRec.Next = 0;
                    end;

                    ItemAttributeEntryRec.Reset;
                    ItemAttributeEntryRec.SetRange(ItemAttributeEntryRec."Item No.", "Item No.");
                    if ItemAttributeEntryRec.FindFirst then begin
                        repeat
                            if ItemAttributeEntryRec."Item Attribute Code" = 'FLUTE' then begin
                                FG_Flute := ItemAttributeEntryRec."Item Attribute Value";
                            end;
                        until ItemAttributeEntryRec.Next = 0;
                    end;


                    ItemAttributeEntryRec.Reset;
                    ItemAttributeEntryRec.SetRange(ItemAttributeEntryRec."Item No.", "Item No.");
                    if ItemAttributeEntryRec.FindFirst then begin
                        repeat
                            if ItemAttributeEntryRec."Item Attribute Code" = 'COLOUR' then begin
                                FG_Color := ItemAttributeEntryRec."Item Attribute Value";
                            end;
                        until ItemAttributeEntryRec.Next = 0;
                    end;

                end;
            }
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
        Actual: Text[50];
        StandardValue: Text[50];
        SlNo: Integer;
        ProdOrderHeader: Record "Production Order";
        SalesHeader: Record "Sales Header";
        LPODate: Date;
        LPONo: Code[30];
        CustName: Text[60];
        InspectionHeader: Record "Inspection Header";
        TempInspection: Text[60];
        TempRemarks: Text[60];
        OrderQty: Decimal;
        ProdOrderHeader1: Record "Production Order";
        ITEM: Record Item;
        ITEM_NO2: Code[20];
        EstimateCards: Record "Product Design Header";
        SupplierCustName: Text[60];
        ItemAttributeEntryRec: Record "Item Attribute Entry";
        FG_Ply: Code[10];
        FG_GSM: Code[10];
        FG_Color: Code[10];
        FG_LENGTH: Code[10];
        FG_WIDTH: Code[10];
        FG_HEIGHT: Code[10];
        FG_DESC: Code[30];
        FG_Flute: Code[10];
}

