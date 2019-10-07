report 50032 "Confirm Schedule"
{
    // version Production/ Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Confirm Schedule.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Production Schedule Line"; "Production Schedule Line")
        {
            DataItemTableView = SORTING ("Schedule No.", "Prod. Order No.", "Prod. Order Line No.", "Deckle Size Schedule(mm)", "Schedule Line") ORDER(Ascending) WHERE ("Deckle Size Schedule(mm)" = FILTER (<> ''));
            RequestFilterFields = "Schedule Date", "Schedule No.";
            column(CompName; CompInfo.Name)
            {
            }
            column(AllFilters; AllFilters)
            {
            }
            column(SHIFT_CODE; SHIFT_CODE)
            {
            }
            column(MachineDesc; MachineDesc)
            {
            }
            column(ScheduleNo; "Production Schedule Line"."Schedule No.")
            {
            }
            column(ProdOrderNo; "Production Schedule Line"."Prod. Order No.")
            {
            }
            column(DeckleSize; "Production Schedule Line"."Deckle Size Schedule(mm)")
            {
            }
            column(ScheduleDtae; "Production Schedule Line"."Schedule Date")
            {
            }
            column(RequestDeliveryDate; "Production Schedule Line"."Requested Delivery Date")
            {
            }
            column(MachineNo; "Production Schedule Line"."Machine No.")
            {
            }
            column(OrderQuantity; "Production Schedule Line"."Quantity To Schedule")
            {
            }
            column(QuantityToSchedule; "Production Schedule Line"."Quantity To Schedule")
            {
            }
            column(ItemCode; "Production Schedule Line"."Item Code")
            {
            }
            column(ItemDescription; "Production Schedule Line"."Item Description")
            {
            }
            column(CustomerName; "Production Schedule Line"."Customer Name")
            {
            }
            column(PllannedDeckleSize; "Production Schedule Line"."Planned Deckle Size(mm)")
            {
            }
            column(NoOfPly; "Production Schedule Line"."No. Of Ply")
            {
            }
            column(TopColor; "Production Schedule Line"."Top Colour")
            {
            }
            column(BoardLength; "Production Schedule Line"."Board Length(mm)")
            {
            }
            column(BoardWidth; "Production Schedule Line"."Board Width(mm)")
            {
            }
            column(CalculatedWeight; "Production Schedule Line"."Qty to Schedule Net Weight")
            {
            }
            column(EstimateNo; "Production Schedule Line"."Product Design No.")
            {
            }
            column(PriorityBySystem; "Production Schedule Line"."Priority By System")
            {
            }
            column(ModifiedPriority; "Production Schedule Line"."Modified Priority")
            {
            }
            column(GSMIdentifier; "Production Schedule Line"."GSM Identifier")
            {
            }
            column(ExtraTrim; "Production Schedule Line"."Extra Trim(mm)")
            {
            }
            column(Possible; "Production Schedule Line".Possible)
            {
            }
            column(TrimPercent; "Production Schedule Line"."Trim %")
            {
            }
            column(Flute; "Production Schedule Line".Flute)
            {
            }
            column(LinearLength; "Production Schedule Line"."Linear Length(Mtr)")
            {
            }
            column(BoxLength; BoxLength)
            {
            }
            column(BoxHeight; BoxHeight)
            {
            }
            column(BoxWidth; BoxWidth)
            {
            }
            column(FG_GSM; "Production Schedule Line"."FG GSM")
            {
            }
            column(UtiLizeDeckleSize; "Production Schedule Line"."Board Width(mm)" * "Production Schedule Line"."Calculated No. of Ups")
            {
            }
            column(NetPaperWeight; NetPaperWeight)
            {
            }
            column(TrimWeight; "Production Schedule Line"."Trim Weight")
            {
            }
            column(DL; "Production Schedule Line"."DB Paper")
            {
            }
            column(M1; "Production Schedule Line"."1M Paper")
            {
            }
            column(L1; "Production Schedule Line"."1L Paper")
            {
            }
            column(M2; "Production Schedule Line"."2M Paper")
            {
            }
            column(L2; "Production Schedule Line"."2L Paper")
            {
            }
            column(sys_date; WorkDate)
            {
            }
            column(Noofups; "Production Schedule Line"."Calculated No. of Ups")
            {
            }
            column(FGItemDesc; FGItemDesc)
            {
            }
            column(ScheduleDate; "Production Schedule Line"."Schedule Date")
            {
            }
            column(ExtraTrimWeight_line; "Production Schedule Line"."Extra Trim Weight")
            {
            }
            column(Extra_Trim_Actual; "Extra Trim Actual")
            {

            }
            column(Extra_Trim_Wt__Actual; "Extra Trim Wt. Actual")
            {

            }
            column(Trim_line; "Production Schedule Line"."Trim (mm)")
            {
            }
            column(BoardWidthMM; "Production Schedule Line"."Board Width(mm)")
            {
            }
            column(ActualGSM; FG_GSM)
            {
            }
            column(CalculatedGSM; CalculatedGSM)
            {
            }
            column(BoxQtyToSchedule; "Production Schedule Line"."Box Quantity to Schedule")
            {
            }
            column(DLWT; DL)
            {
            }
            column(M1WT; M1)
            {
            }
            column(L1WT; L1)
            {
            }
            column(M2WT; M2)
            {
            }
            column(L2WT; L2)
            {
            }
            column(Printing_desc; Printing_desc)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CompInfo.Get;

                FGItem := '';
                Items.Reset;
                Items.SetRange(Items."No.", "Item Code");
                if Items.FindFirst then begin
                    FGItem := Items."FG Item No.";
                    BoxLength := '';
                    BoxHeight := '';
                    BoxWidth := '';
                    FG_GSM := '';
                    FGItemDesc := '';

                    Items1.Reset;
                    Items1.SetRange(Items1."No.", FGItem);
                    if Items1.FindFirst then begin
                        //   BoxLength:=Items1."Box Length";
                        //   BoxHeight:=Items1."Box Height";
                        //   BoxWidth:=Items1."Box Width";
                        FG_GSM := Items1."FG GSM";
                        FGItemDesc := Items1.Description;
                        //MESSAGE(FGItem);
                    end;
                end;
                RollWidth := 0;
                EstimateHeader.Reset;
                EstimateHeader.SetRange(EstimateHeader."Product Design No.", "Product Design No.");
                if EstimateHeader.FindFirst then begin
                    RollWidth := EstimateHeader."Roll Width (mm)";
                    CalculatedGSM := EstimateHeader.Grammage;
                    BoxLength := Format(EstimateHeader."Box Length (mm)- L (OD)");
                    BoxHeight := Format(EstimateHeader."Box Height (mm) - D (OD)");
                    BoxWidth := Format(EstimateHeader."Box Width (mm)- W (OD)");
                end;

                NetPaperWeight := 0;
                ProdOrdComp.Reset;
                ProdOrdComp.SetRange(ProdOrdComp."Prod. Order No.", "Prod. Order No.");
                ProdOrdComp.SetRange(ProdOrdComp."Prod. Order Line No.", "Prod. Order Line No.");
                ProdOrdComp.SetRange(ProdOrdComp."Product Design No.", "Product Design No.");
                ProdOrdComp.SetRange(ProdOrdComp."Prod Schedule No.", "Schedule No.");
                ProdOrdComp.SetRange(ProdOrdComp."Schedule Component", true);
                if ProdOrdComp.FindFirst then begin
                    repeat
                        NetPaperWeight := NetPaperWeight + ProdOrdComp."Expected Quantity";
                    until ProdOrdComp.Next = 0;
                end;

                //Trim Weght Calculation
                TrimWeight := 0;
                EstimateLine.Reset;
                EstimateLine.SetRange(EstimateLine."Product Design No.", "Product Design No.");
                if EstimateLine.FindFirst then begin
                    repeat
                        TrimWeight := TrimWeight + EstimateLine."Extra Trim Weight (KG)";
                    until EstimateLine.Next = 0;
                end;

                ProductionSchedule.Reset;
                ProductionSchedule.SetRange(ProductionSchedule."Schedule No.", "Schedule No.");
                if ProductionSchedule.FindFirst then begin
                    SHIFT_CODE := ProductionSchedule."Shift Code";
                end;

                /*
                //User Name
                USERS.RESET;
                USERS.SETRANGE(USERS."User Name","User ID");
                IF USERS.FINDFIRST THEN BEGIN
                  USER_NAME := USERS."Full Name";
                END;
                //MESSAGE(USER_NAME);
                 */
                DL := 0;
                ProdOrderComponent.Reset;
                ProdOrderComponent.SetRange(ProdOrderComponent."Prod Schedule No.", "Schedule No.");
                ProdOrderComponent.SetRange(ProdOrderComponent."Prod. Order No.", "Prod. Order No.");
                ProdOrderComponent.SetRange(ProdOrderComponent."Prod. Order Line No.", "Prod. Order Line No.");
                ProdOrderComponent.SetRange(ProdOrderComponent."Item Category Code", 'PAPER');
                ProdOrderComponent.SetFilter(ProdOrderComponent."Paper Position", 'Liner1');
                if ProdOrderComponent.FindFirst then begin
                    DL := ProdOrderComponent."Quantity per"
                end;

                M1 := 0;

                ProdOrderComponent.Reset;
                ProdOrderComponent.SetRange(ProdOrderComponent."Prod. Order No.", "Prod. Order No.");
                ProdOrderComponent.SetRange(ProdOrderComponent."Prod. Order Line No.", "Prod. Order Line No.");
                ProdOrderComponent.SetRange(ProdOrderComponent."Prod Schedule No.", "Schedule No.");
                ProdOrderComponent.SetRange(ProdOrderComponent."Item Category Code", 'PAPER');
                ProdOrderComponent.SetFilter(ProdOrderComponent."Paper Position", ' Flute1');
                if ProdOrderComponent.FindFirst then begin
                    M1 := ProdOrderComponent."Quantity per"
                end;

                L1 := 0;
                ProdOrderComponent.Reset;
                ProdOrderComponent.SetRange(ProdOrderComponent."Prod. Order No.", "Prod. Order No.");
                ProdOrderComponent.SetRange(ProdOrderComponent."Prod. Order Line No.", "Prod. Order Line No.");
                ProdOrderComponent.SetRange(ProdOrderComponent."Prod Schedule No.", "Schedule No.");
                ProdOrderComponent.SetRange(ProdOrderComponent."Item Category Code", 'PAPER');
                ProdOrderComponent.SetFilter(ProdOrderComponent."Paper Position", ' Liner2');
                if ProdOrderComponent.FindFirst then begin
                    L1 := ProdOrderComponent."Quantity per"
                end;

                M2 := 0;
                ProdOrderComponent.Reset;
                ProdOrderComponent.SetRange(ProdOrderComponent."Prod. Order No.", "Prod. Order No.");
                ProdOrderComponent.SetRange(ProdOrderComponent."Prod. Order Line No.", "Prod. Order Line No.");
                ProdOrderComponent.SetRange(ProdOrderComponent."Prod Schedule No.", "Schedule No.");
                ProdOrderComponent.SetRange(ProdOrderComponent."Item Category Code", 'PAPER');
                ProdOrderComponent.SetFilter(ProdOrderComponent."Paper Position", 'Flute2');
                if ProdOrderComponent.FindFirst then begin
                    M2 := ProdOrderComponent."Quantity per"
                end;

                L2 := 0;
                ProdOrderComponent.Reset;
                ProdOrderComponent.SetRange(ProdOrderComponent."Prod. Order No.", "Prod. Order No.");
                ProdOrderComponent.SetRange(ProdOrderComponent."Prod. Order Line No.", "Prod. Order Line No.");
                ProdOrderComponent.SetRange(ProdOrderComponent."Prod Schedule No.", "Schedule No.");
                ProdOrderComponent.SetRange(ProdOrderComponent."Item Category Code", 'PAPER');
                ProdOrderComponent.SetFilter(ProdOrderComponent."Paper Position", ' Liner3');
                if ProdOrderComponent.FindFirst then begin
                    L2 := ProdOrderComponent."Quantity per";
                end;

                MachineDesc := '';

                MachineCenter.Reset;
                MachineCenter.SetRange(MachineCenter."No.", "Machine No.");
                if MachineCenter.FindFirst then begin
                    MachineDesc := MachineCenter.Name;
                end;


                Printing_desc := '';
                ProdOrderRoutingLine.Reset;
                ProdOrderRoutingLine.SetRange(ProdOrderRoutingLine."Prod. Order No.", "Prod. Order No.");
                if ProdOrderRoutingLine.FindFirst then begin
                    if ProdOrderRoutingLine."Routing Link Code" <> '' then
                        Printing_desc := ProdOrderRoutingLine.Description;
                end;

            end;

            trigger OnPreDataItem()
            begin
                AllFilters := "Production Schedule Line".GetFilters;
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
        Items: Record Item;
        BoxLength: Code[10];
        BoxHeight: Code[10];
        BoxWidth: Code[10];
        FG_GSM: Code[10];
        RollWidth: Decimal;
        EstimateHeader: Record "Product Design Header";
        ProdOrdComp: Record "Prod. Order Component";
        NetPaperWeight: Decimal;
        EstimateLine: Record "Product Design Line";
        TrimWeight: Decimal;
        CompInfo: Record "Company Information";
        FGItem: Code[20];
        Items1: Record Item;
        Noofcuts: Decimal;
        FGItemDesc: Text[250];
        ProdCompLine: Record "Prod. Order Component";
        PaperWeight: Decimal;
        USERS: Record User;
        USER_NAME: Text[100];
        AllFilters: Text[100];
        CalculatedGSM: Decimal;
        ProductionSchedule: Record "Production Schedule";
        SHIFT_CODE: Code[30];
        ProdOrderComponent: Record "Prod. Order Component";
        DL: Decimal;
        M1: Decimal;
        L1: Decimal;
        M2: Decimal;
        L2: Decimal;
        MachineCenter: Record "Machine Center";
        MachineDesc: Text;
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        Printing_desc: Text;
}

