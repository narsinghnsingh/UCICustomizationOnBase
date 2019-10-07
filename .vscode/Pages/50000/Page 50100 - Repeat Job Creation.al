page 50100 "Repeat Job Creation"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    UsageCategory = Tasks;
    SourceTable = "Sales Line";
    SourceTableView = SORTING ("Document Type", "Document No.", "Line No.")
                      ORDER(Ascending)
                      WHERE (Type = FILTER (Item),
                            "Document Type" = CONST (Order),
                            "Outstanding Quantity" = FILTER (<> 0));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; "Document No.")
                {
                    Editable = false;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field(CustName; CustName)
                {
                    Caption = 'Customer Name';
                    Editable = false;
                }
                field("External Doc. No."; "External Doc. No.")
                {
                    Caption = 'LPO No';
                    Editable = false;
                }
                field("No."; "No.")
                {
                    Editable = false;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field("Estimation No."; "Estimation No.")
                {
                    Editable = false;
                }
                field("Marked for Prod. Order"; "Marked for Prod. Order")
                {
                }
                field("Old Job No."; "Old Job No.")
                {
                }
                field("New Prod. Order No."; "New Prod. Order No.")
                {
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                    Editable = false;
                }
                field("Prod. Order Line No."; "Prod. Order Line No.")
                {
                }
                field("Repeat Job"; "Repeat Job")
                {
                }
                field("Repeat Job Details"; "Repeat Job Details")
                {
                }
                field("Documnet Date"; "Documnet Date")
                {
                }
                field("Order Date"; "Order Date")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Create Prod. Order")
            {
                Image = CreatePutawayPick;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ProdCompLine: Record "Prod. Order Component";
                begin
                    ValidateSalesLine;
                    CreateRepeatJob;
                end;
            }
            action("Update Estimate")
            {
                Image = DocumentEdit;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";
                    Estimate: Record "Product Design Header";
                    LineCounter: Integer;
                begin
                    // Lines added BY Deepak Kumar
                    if DIALOG.Confirm(Text01, false) then begin
                        SalesLine.Reset;
                        SalesLine.SetRange(SalesLine."Document Type", SalesLine."Document Type"::Order);
                        SalesLine.SetFilter(SalesLine."Estimation No.", '');
                        if SalesLine.FindFirst then begin
                            repeat
                                Estimate.Reset;
                                Estimate.SetRange(Estimate."Item Code", SalesLine."No.");
                                Estimate.SetRange(Estimate.Status, Estimate.Status::Approved);
                                if Estimate.FindFirst then begin
                                    SalesLine."Estimation No." := Estimate."Product Design No.";
                                    SalesLine.Modify(true);
                                    LineCounter := LineCounter + 1;

                                end;
                            until SalesLine.Next = 0;
                            Message('Complete %1', LineCounter);
                        end;
                    end;
                end;
            }
            action("Update Last Job")
            {
                Image = EndingText;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    UpdateLastProductionOrder;
                end;
            }
            action("Prod. Order Card")
            {
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added bY Deepak Kumar
                    TestField("Prod. Order No.");
                    ReleasedProdOrderTable.Reset;
                    ReleasedProdOrderTable.SetRange(ReleasedProdOrderTable.Status, ReleasedProdOrderTable.Status::Released);
                    ReleasedProdOrderTable.SetRange(ReleasedProdOrderTable."No.", "Prod. Order No.");
                    ReleasedProdOrder.SetTableView(ReleasedProdOrderTable);
                    ReleasedProdOrder.Run;
                end;
            }
            action("Estimate Card")
            {
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added By Deepak Kumar
                    TestField("Estimation No.");
                    EstimateHeader.Reset;
                    EstimateHeader.SetRange(EstimateHeader."Product Design Type", EstimateHeader."Product Design Type"::Main);
                    EstimateHeader.SetRange(EstimateHeader."Product Design No.", "Estimation No.");
                    EstimateCard.SetTableView(EstimateHeader);
                    EstimateCard.Run;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // Lines added BY Deepak Kumar
        SalesHeader.Reset;
        SalesHeader.SetRange(SalesHeader."Document Type", "Document Type");
        SalesHeader.SetRange(SalesHeader."No.", "Document No.");
        if SalesHeader.FindFirst then begin
            CustName := SalesHeader."Bill-to Name";
        end else begin
            CustName := '';
        end;
    end;

    trigger OnOpenPage()
    begin
        //UpdateLastProductionOrder;
    end;

    var
        ProdOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        ProdOrderRouting: Record "Prod. Order Routing Line";
        NewProdOrder: Record "Production Order";
        NewProdOrderLine: Record "Prod. Order Line";
        NewProdOrderComp: Record "Prod. Order Component";
        NewProdOrderRouting: Record "Prod. Order Routing Line";
        ManSetup: Record "Manufacturing Setup";
        NoSeriesMngmt: Codeunit NoSeriesManagement;
        NewNo: Code[20];
        PlateItem: Record Item;
        ItemTable: Record Item;
        RefreshProdOrder: Codeunit "Refresh Production Order";
        ReleasedProdOrder: Page "Released Production Order";
        ReleasedProdOrderTable: Record "Production Order";
        SalesLines: Record "Sales Line";
        LastLineNo: Integer;
        SalesLinesNew: Record "Sales Line";
        Items: Record Item;
        MfgSetup: Record "Manufacturing Setup";
        EstimateHeader: Record "Product Design Header";
        SalesHeader: Record "Sales Header";
        ProdOrderLineSam: Record "Prod. Order Line";
        ExistProdOrder: Record "Production Order";
        Text01: Label 'Do you want to update ?';
        CustName: Text[250];
        EstimateCard: Page "Product Design Card";
        ProductDesignHeader: Record "Product Design Header";

    procedure ValidateSalesLine()
    begin
        // Lines Added By Deepak Kumar
        SalesLines.Reset;
        SalesLines.SetRange(SalesLines."Document Type", SalesLines."Document Type"::Order);
        SalesLines.SetRange(SalesLines."Marked for Prod. Order", true);
        if SalesLines.FindFirst then begin
            repeat
                SalesLines.TestField(SalesLines."Estimation No.");
                if (SalesLines."Prod. Order No." <> '') then
                    Error('Production Order %1 is already created for Sales Order %2 , LPO No. %3', SalesLines."Prod. Order No.", SalesLines."Document No.", SalesLines."External Doc. No.");

                if (SalesLines."Prod. Order No." <> '') and (SalesLines."Prod. Order No." <> SalesLines."New Prod. Order No.") then
                    Error('The Production Order %1 is already created for this Sales Order', SalesLines."Prod. Order No.");

                EstimateHeader.Get(0, SalesLines."Estimation No.");

                ExistProdOrder.Reset;
                ExistProdOrder.SetRange(ExistProdOrder."No.", SalesLines."New Prod. Order No.");
                if ExistProdOrder.FindFirst then
                    Error('The Production Order %1 already exists', SalesLines."New Prod. Order No.");

            until SalesLines.Next = 0;
        end;
    end;

    procedure CreateRepeatJob()
    begin
        // Lines added By Deepak kumar
        ManSetup.Get;
        SalesLines.Reset;
        SalesLines.SetRange(SalesLines."Document Type", SalesLines."Document Type"::Order);
        SalesLines.SetRange(SalesLines."Marked for Prod. Order", true);
        if SalesLines.FindFirst then begin
            repeat
                NewNo := '';
                ProdOrder.Reset;
                ProdOrder.SetRange(ProdOrder."No.", SalesLines."Old Job No.");
                if ProdOrder.FindFirst then begin

                    //Insert Production Order Header
                    NewProdOrder.Init;
                    NewProdOrder := ProdOrder;

                    ProductDesignHeader.RESET;
                    ProductDesignHeader.SETRANGE(ProductDesignHeader."Product Design No.", SalesLines."Estimation No.");
                    IF ProductDesignHeader.FINDFIRST THEN BEGIN
                        IF NOT (ProductDesignHeader.Status = ProductDesignHeader.Status::Approved) THEN
                            ERROR('PDI %1 on Sales line with FG %2 is not approved, Kindly check', ProductDesignHeader."Product Design No.", SalesLines."No.")
                        ELSE
                            NewProdOrder."Estimate Code" := SalesLines."Estimation No.";
                    END;

                    if SalesLines."New Prod. Order No." = '' then
                        NoSeriesMngmt.InitSeries(ManSetup."Released Order Nos.", ManSetup."Released Order Nos.", Today, NewNo, ManSetup."Released Order Nos.")
                    else
                        NewNo := SalesLines."New Prod. Order No.";

                    NewProdOrder."Sales Order No." := SalesLines."Document No.";
                    NewProdOrder."Sales Order Line No." := SalesLines."Line No.";

                    SalesHeader.Reset;
                    SalesHeader.SetRange(SalesHeader."No.", NewProdOrder."Sales Order No.");
                    if SalesHeader.FindFirst then begin
                        NewProdOrder."Customer Name" := SalesHeader."Bill-to Name";
                        NewProdOrder."Salesperson Code" := SalesHeader."Salesperson Code";
                    end;

                    NewProdOrder."Sales Requested Delivery Date" := SalesLines."Requested Delivery Date";
                    // NewProdOrder.VALIDATE("Due Date",SalesLines."Requested Delivery Date");
                    NewProdOrder.Validate("Due Date", WorkDate);
                    //  NewProdOrder.VALIDATE("Ending Date",WORKDATE);
                    NewProdOrder."No." := NewNo;
                    NewProdOrder.Status := NewProdOrder.Status::Released;
                    NewProdOrder."Prev. Job No." := SalesLines."Old Job No.";
                    NewProdOrder."Repeat Job" := true;
                    NewProdOrder.Quantity := SalesLines.Quantity;
                    NewProdOrder."Finished Date" := 0D;
                    NewProdOrder."Eliminate in Prod. Schedule" := false;
                    NewProdOrder."Allowed Extra Consumption" := false;
                    NewProdOrder."Allowed Extra Consumption By" := '';
                    NewProdOrder.Insert(true);
                    //Mpower
                    ProductDesignHeader.Reset;
                    ProductDesignHeader.SetRange(ProductDesignHeader."Product Design No.", ProdOrder."Estimate Code");
                    if ProductDesignHeader.FindFirst then begin
                        ProductDesignHeader."Production Order No." := NewProdOrder."No.";
                        //ProductDesignHeader.Quantity := NewProdOrder.Quantity;
                        ProductDesignHeader.Modify;
                    end;

                    if ManSetup."Printing Plate Active" then begin
                        IF (ProductDesignHeader."Plate Required") AND (ProductDesignHeader."Plate Item No." <> '') THEN BEGIN
                            ItemTable.GET(NewProdOrder."Source No.");
                            IF PlateItem.GET(ItemTable."Plate Item No.") THEN BEGIN
                                PlateItem.VALIDATE(PlateItem."Curr Prod. Order No.", NewProdOrder."No.");
                                PlateItem.MODIFY(TRUE);
                            END;
                        END;
                    end;

                    RefreshProdOrder.Run(NewProdOrder);
                end;
                SalesLines."Marked for Prod. Order" := false;
                SalesLines."New Prod. Order No." := '';
                SalesLines."Prod. Order No." := NewProdOrder."No.";
                SalesLines."Prod. Order Line No." := 10000;
                SalesLines."Repeat Job" := true;
                SalesLines."Repeat Job Details" := 'Previous Job ' + SalesLines."Old Job No." + ' Current job ' + NewProdOrder."No.";

                SalesLines.Modify(true);

                /*
                  ReleasedProdOrderTable.RESET;
                  ReleasedProdOrderTable.SETRANGE(ReleasedProdOrderTable.Status,ReleasedProdOrderTable.Status::Released);
                  ReleasedProdOrderTable.SETRANGE(ReleasedProdOrderTable."No.",NewNo);
                  ReleasedProdOrder.SETTABLEVIEW(ReleasedProdOrderTable);
                  ReleasedProdOrder.RUN;*/
            until SalesLines.Next = 0;
            Message('Complete');
        end;

    end;

    local procedure UpdateLastProductionOrder()
    begin
        // Lines added By Deepak Kumar
        SalesLines.Reset;
        SalesLines.SetRange("Document Type", SalesLines."Document Type"::Order);
        SalesLines.SetRange(SalesLines.Type, SalesLines.Type::Item);
        SalesLines.SetFilter(SalesLines."Prod. Order No.", '');
        SalesLines.SetFilter("Outstanding Quantity", '<>%1', 0);
        if SalesLines.FindSET then begin
            repeat
                ProdOrder.Reset;
                ProdOrder.SetRange(ProdOrder."Source Type", ProdOrder."Source Type"::Item);
                ProdOrder.SetRange(ProdOrder."Source No.", SalesLines."No.");
                if ProdOrder.FindLast then begin
                    SalesLines."Old Job No." := ProdOrder."No.";
                    SalesLines.Modify(true);
                end;
            until SalesLines.Next = 0;
        end;
    end;
}

