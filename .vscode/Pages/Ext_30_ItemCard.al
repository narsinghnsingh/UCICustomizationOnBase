pageextension 50010 Ext_30_ItemCard extends "Item Card"
{
    layout
    {
        moveafter("Base Unit of Measure"; InventoryGrp)
        moveafter(Blocked; "Shelf No.")
        moveafter("Shelf No."; "Automatic Ext. Texts")
        moveafter("Automatic Ext. Texts"; "Item Category Code")
        moveafter("Item Category Code"; "Service Item Group")
        moveafter("Service Item Group"; "Search Description")
        moveafter("Search Description"; GTIN)
        moveafter(GTIN; "Created From Nonstock Item")
        movebefore(InventoryGrp; "Common Item No.")
        moveafter("Common Item No."; "Net Weight")
        moveafter("Net Weight"; "Gross Weight")
        moveafter("Gross Weight"; "Unit Volume")
        modify("Net Weight")
        {
            Editable = false;
        }
        modify("Gross Weight")
        {
            Editable = false;
        }

        // Add changes to page layout here
        addafter(Description)
        {
            field("Description 2"; "Description 2")
            {

            }
        }
        addafter(Item)
        {
            group("Corrugation Specific")
            {
                CaptionML = ENU = 'Corrugation Specific';
                field("Paper GSM"; "Paper GSM")
                {

                }
                field("Paper Type"; "Paper Type")
                {

                }
                field("FSC Category"; "FSC Category")
                {

                }
                field(Supplier; Supplier)
                {

                }
                field("Model No"; "Model No")
                {

                }
                field("Model Description"; "Model Description")
                {

                }
                field("Roll ID Applicable"; "Roll ID Applicable")
                {

                }
                field("Bursting factor(BF)"; "Bursting factor(BF)")
                {

                }
                field("Deckle Size (mm)"; "Deckle Size (mm)")
                {

                }
                field("No. of Ply"; "No. of Ply")
                {

                }
                field("Percentage of Paper Wt."; "Percentage of Paper Wt.")
                {

                }
                field("PO Quantity Variation %"; "PO Quantity Variation %")
                {

                }
                field("Quality Spec ID"; "Quality Spec ID")
                {

                }
                field("QA Enable"; "QA Enable")
                {

                }
                field("Paper Origin"; "Paper Origin")
                {

                }
                field("Quantity Per Pallet"; "Quantity Per Pallet")
                {

                }
                field("Heigth of Pallet (cm)"; "Heigth of Pallet (cm)")
                {

                }
                field("Plate Item No."; "Plate Item No.")
                {

                }
                field("Flute Type"; "Flute Type")
                {

                }
                field("Flute 1"; "Flute 1")
                {

                }
                field("Flute 2"; "Flute 2")
                {

                }
                field("Flute 3"; "Flute 3")
                {

                }
                field("Estimate No."; "Estimate No.")
                {

                }
                field("Box Length"; "Box Length")
                {

                }
                field("Box Height"; "Box Height")
                {

                }
                field("Box Width"; "Box Width")
                {

                }
                field("Color Code"; "Color Code")
                {

                }
                field("FG GSM"; "FG GSM")
                {

                }
                field("Board Length"; "Board Length")
                {

                }
                field("Board Width"; "Board Width")
                {

                }
                field("Plate Item"; "Plate Item")
                {
                    Editable = true;
                }
                field("Die Number"; "Die Number")
                {

                }
                field("Marked For Enq/Quote"; "Marked For Enq/Quote")
                {

                }
                field("Pallet Height(mtr)"; "Pallet Height(mtr)")
                {

                }
                field("Inventory as per Filter"; "Inventory as per Filter")
                {

                }
                field("Item UID Code"; "Item UID Code")
                {

                }
            }
        }
        addlast(Item)
        {
            field(Picture; Picture)
            {

            }
            field("Customer No."; "Customer No.")
            {

            }
            field("Customer Name"; "Customer Name")
            {

            }
            field("FG Item No."; "FG Item No.")
            {

            }




        }

    }

    actions
    {
        // Add changes to page actions here
        addlast(Item)
        {
            action("Action134")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Approve';
                Promoted = true;
                PromotedIsBig = true;
                Image = Approve;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    // lines added by deepak Kumar
                    ApproveItem;
                end;
            }
            action(Block)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Block';
                Promoted = true;
                PromotedIsBig = true;
                Image = ClearLog;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    BlockItem;
                end;
            }
            action("Additional Cost Report")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Additional Cost Report';
                RunObject = Report "Additional Cost ChargeAssignmt";
                Promoted = true;
                PromotedIsBig = true;
                Image = Report;
                PromotedCategory = Report;
                trigger OnAction()
                begin

                end;
            }
        }
        addlast("F&unctions")
        {
            action("Update Item Description")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = UpdateDescription;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";
                    ProdOrderLine: Record "Prod. Order Line";
                    ProductionOrder: Record "Production Order";
                    ProdOrderComponent: Record "Prod. Order Component";
                    ProductDesignLine: Record "Product Design Line";
                    ProductDesignHeader: Record "Product Design Header";
                    Sam001: TextConst ENU = 'Do you want to update Item %1  Description? It is Update on Outstanding Sales Order Line, Product Design Header & Line, Production Order Header & Line, and Prod. Order Component Line.';
                    Question: Text;
                    Answer: Boolean;
                    LineCounter: ARRAY[10] OF Integer;
                begin
                    UpdateItemDescription;
                end;
            }
        }
    }

    var
        PlateItem: Record Item;

    PROCEDURE UpdateItemDescription();

    VAR
        SalesLine: Record "Sales Line";
        ProdOrderLine: Record "Prod. Order Line";
        ProductionOrder: Record "Production Order";
        ProdOrderComponent: Record "Prod. Order Component";
        ProductDesignLine: Record "Product Design Line";
        ProductDesignHeader: Record "Product Design Header";
        Question: Text;
        Answer: Boolean;
        LineCounter: ARRAY[10] OF Integer;
        Sam001: TextConst ENU = 'Do you want to update Item %1  Description? It is Update on Outstanding Sales Order Line, Product Design Header & Line, Production Order Header & Line, and Prod. Order Component Line.';
        ProductDesignComponent: Record "Product Design Component Table";
    BEGIN

        // Lines added By Deepak kumarcon
        Question := Sam001;
        Answer := DIALOG.CONFIRM(Question, TRUE, "No.");
        IF Answer = TRUE THEN BEGIN
            SalesLine.RESET;
            SalesLine.SETRANGE(SalesLine."Document Type", SalesLine."Document Type"::Order);
            SalesLine.SETRANGE(SalesLine.Type, SalesLine.Type::Item);
            SalesLine.SETRANGE(SalesLine."No.", "No.");
            //SalesLine.SETRANGE(SalesLine."Completely Shipped",FALSE);
            SalesLine.SETFILTER(SalesLine."Quantity Shipped", '0');
            IF SalesLine.FINDFIRST THEN BEGIN
                REPEAT
                    SalesLine.Description := Description;
                    SalesLine.MODIFY(TRUE);
                    LineCounter[1] := LineCounter[1] + 1;
                UNTIL SalesLine.NEXT = 0;
            END;
            ProdOrderLine.RESET;
            ProdOrderLine.SETRANGE(ProdOrderLine.Status, ProdOrderLine.Status::Released);
            ProdOrderLine.SETRANGE(ProdOrderLine."Item No.", "No.");
            IF ProdOrderLine.FINDFIRST THEN BEGIN
                REPEAT
                    ProdOrderLine.Description := Description;
                    ProdOrderLine.MODIFY(TRUE);
                    LineCounter[2] := LineCounter[2] + 1;
                UNTIL ProdOrderLine.NEXT = 0;
            END;
            ProductionOrder.RESET;
            ProductionOrder.SETRANGE(ProductionOrder.Status, ProductionOrder.Status::Released);
            ProductionOrder.SETRANGE(ProductionOrder."Source Type", ProductionOrder."Source Type"::Item);
            ProductionOrder.SETRANGE(ProductionOrder."Source No.", "No.");
            IF ProductionOrder.FINDFIRST THEN BEGIN
                REPEAT
                    ProductionOrder.Description := Description;
                    ProductionOrder.MODIFY(TRUE);
                    LineCounter[3] := LineCounter[3] + 1;
                UNTIL ProductionOrder.NEXT = 0;
            END;
            ProdOrderComponent.RESET;
            ProdOrderComponent.SETRANGE(ProdOrderComponent.Status, ProdOrderComponent.Status::Released);
            ProdOrderComponent.SETRANGE(ProdOrderComponent."Item No.", "No.");
            IF ProdOrderComponent.FINDFIRST THEN BEGIN
                REPEAT
                    ProdOrderComponent.Description := Description;
                    ProdOrderComponent.MODIFY(TRUE);
                    LineCounter[4] := LineCounter[4] + 1;
                UNTIL ProdOrderComponent.NEXT = 0;
            END;
            ProductDesignHeader.RESET;
            ProductDesignHeader.SETRANGE(ProductDesignHeader."Item Code", "No.");
            IF ProductDesignHeader.FINDFIRST THEN BEGIN
                REPEAT
                    //      ProductDesignHeader.TESTFIELD(ProductDesignHeader.Status,ProductDesignHeader.Status::Open);
                    ProductDesignHeader."Item Description" := Description;
                    ProductDesignHeader.MODIFY(TRUE);
                    ProductDesignComponent.RESET;
                    ProductDesignComponent.SETRANGE(ProductDesignComponent."Product Design Type", ProductDesignHeader."Product Design Type");
                    ProductDesignComponent.SETRANGE(ProductDesignComponent."Product Design No.", ProductDesignHeader."Product Design No.");
                    IF ProductDesignComponent.FINDFIRST THEN BEGIN
                        REPEAT
                            UpdateSubItemDescription(ProductDesignComponent."Item No.");
                        UNTIL ProductDesignComponent.NEXT = 0;
                    END;
                    LineCounter[5] := LineCounter[5] + 1;
                UNTIL ProductDesignHeader.NEXT = 0;
            END;
            ProductDesignLine.RESET;
            ProductDesignLine.SETRANGE(ProductDesignLine.Type, ProductDesignLine.Type::Item);
            ProductDesignLine.SETRANGE(ProductDesignLine."No.", "No.");
            IF ProductDesignLine.FINDFIRST THEN BEGIN
                ProductDesignLine.Description := Description;
                ProductDesignLine.MODIFY(TRUE);
                LineCounter[6] := LineCounter[6] + 1;
            END;
            PlateItem.RESET;
            PlateItem.SETRANGE(PlateItem."FG Item No.", "No.");
            IF PlateItem.FINDFIRST THEN BEGIN
                PlateItem."Curr Prod. Order Desc." := Description;
                PlateItem.MODIFY;
            END;
            MESSAGE('%1 Sales Line, %2 Prod. Order Line, %3 Production Order, %4 Prod. Order Component, %5 Product Design,  %6 Product Design Line Updated', LineCounter[1], LineCounter[2], LineCounter[3], LineCounter[4], LineCounter[5], LineCounter[6]);

        END;
    END;

    PROCEDURE UpdateSubItemDescription(ItemCode: Code[50]);

    VAR
        SalesLine: Record "Sales Line";
        ProdOrderLine: Record "Prod. Order Line";
        ProductionOrder: Record "Production Order";
        ProdOrderComponent: Record "Prod. Order Component";
        ProductDesignLine: Record "Product Design Line";
        ProductDesignHeader: Record "Product Design Header";
        Question: Text;
        Answer: Boolean;
        LineCounter: ARRAY[10] OF Integer;
        Sam001: TextConst ENU = 'Do you want to update Item %1  Description? It is Update on Outstanding Sales Order Line, Product Design Header & Line, Production Order Header & Line, and Prod. Order Component Line.';
    BEGIN

        // Lines added By Deepak kumarcon
        SalesLine.RESET;
        SalesLine.SETRANGE(SalesLine."Document Type", SalesLine."Document Type"::Order);
        SalesLine.SETRANGE(SalesLine.Type, SalesLine.Type::Item);
        SalesLine.SETRANGE(SalesLine."No.", ItemCode);
        //SalesLine.SETRANGE(SalesLine."Completely Shipped",FALSE);
        SalesLine.SETFILTER(SalesLine."Quantity Shipped", '0');
        IF SalesLine.FINDFIRST THEN BEGIN
            REPEAT
                SalesLine.Description := Description;
                SalesLine.MODIFY(TRUE);
                LineCounter[1] := LineCounter[1] + 1;
            UNTIL SalesLine.NEXT = 0;
        END;
        ProdOrderLine.RESET;
        ProdOrderLine.SETRANGE(ProdOrderLine.Status, ProdOrderLine.Status::Released);
        ProdOrderLine.SETRANGE(ProdOrderLine."Item No.", ItemCode);
        IF ProdOrderLine.FINDFIRST THEN BEGIN
            REPEAT
                ProdOrderLine.Description := Description;
                ProdOrderLine.MODIFY(TRUE);
                LineCounter[2] := LineCounter[2] + 1;
            UNTIL ProdOrderLine.NEXT = 0;
        END;
        ProductionOrder.RESET;
        ProductionOrder.SETRANGE(ProductionOrder.Status, ProductionOrder.Status::Released);
        ProductionOrder.SETRANGE(ProductionOrder."Source Type", ProductionOrder."Source Type"::Item);
        ProductionOrder.SETRANGE(ProductionOrder."Source No.", ItemCode);
        IF ProductionOrder.FINDFIRST THEN BEGIN
            REPEAT
                ProductionOrder.Description := Description;
                ProductionOrder.MODIFY(TRUE);
                LineCounter[3] := LineCounter[3] + 1;
            UNTIL ProductionOrder.NEXT = 0;
        END;
        ProdOrderComponent.RESET;
        ProdOrderComponent.SETRANGE(ProdOrderComponent.Status, ProdOrderComponent.Status::Released);
        ProdOrderComponent.SETRANGE(ProdOrderComponent."Item No.", ItemCode);
        IF ProdOrderComponent.FINDFIRST THEN BEGIN
            REPEAT
                ProdOrderComponent.Description := Description;
                ProdOrderComponent.MODIFY(TRUE);
                LineCounter[4] := LineCounter[4] + 1;
            UNTIL ProdOrderComponent.NEXT = 0;
        END;
        ProductDesignHeader.RESET;
        ProductDesignHeader.SETRANGE(ProductDesignHeader."Item Code", ItemCode);
        IF ProductDesignHeader.FINDFIRST THEN BEGIN
            REPEAT
                //      ProductDesignHeader.TESTFIELD(ProductDesignHeader.Status,ProductDesignHeader.Status::Open);
                ProductDesignHeader."Item Description" := Description;
                ProductDesignHeader.MODIFY(TRUE);
                LineCounter[5] := LineCounter[5] + 1;
            UNTIL ProductDesignHeader.NEXT = 0;
        END;
        ProductDesignLine.RESET;
        ProductDesignLine.SETRANGE(ProductDesignLine.Type, ProductDesignLine.Type::Item);
        ProductDesignLine.SETRANGE(ProductDesignLine."No.", ItemCode);
        IF ProductDesignLine.FINDFIRST THEN BEGIN
            ProductDesignLine.Description := Description;
            ProductDesignLine.MODIFY(TRUE);
            LineCounter[6] := LineCounter[6] + 1;
        END;
    END;
}