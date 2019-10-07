page 50235 "Update Page"
{
    PageType = Card;
    SourceTable = "Company Information";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Name; Name)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Delete Image")
            {

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    PurchaseHeader: Record "Purchase Header";
                    ProductDesignHeader: Record "Product Design Header";
                    SalesShipmentHeader: Record "Sales Invoice Header";
                begin
                    // Lines added By Deepak Kumar
                    /*SalesHeader.RESET;
                    IF SalesHeader.FINDFIRST THEN BEGIN
                      REPEAT
                        SalesHeader.CALCFIELDS(SalesHeader.Picture);
                        CLEAR(SalesHeader.Picture);
                        SalesHeader.MODIFY(TRUE);
                      UNTIL SalesHeader.NEXT=0;
                      MESSAGE('Compete');
                    END;
                         */

                    SalesShipmentHeader.Reset;
                    if SalesShipmentHeader.FindFirst then begin
                        repeat
                            SalesShipmentHeader.CalcFields(SalesShipmentHeader."Document Receiving Image");
                            Clear(SalesShipmentHeader."Document Receiving Image");
                            SalesShipmentHeader.Modify(true);
                        until SalesShipmentHeader.Next = 0;
                        Message('Complete');
                    end;

                end;
            }
            action("Update PD Header")
            {

                trigger OnAction()
                var
                    ProductDesignHeader: Record "Product Design Header";
                begin
                    // Lines added By Deepak Kumar
                    ProductDesignHeader.Reset;
                    ProductDesignHeader.SetRange(ProductDesignHeader."Product Design Type", ProductDesignHeader."Product Design Type"::Main);
                    ProductDesignHeader.SetRange(ProductDesignHeader.Status, ProductDesignHeader.Status::Approved);
                    if ProductDesignHeader.FindFirst then begin
                        repeat
                            ProductDesignHeader.UpdateGSMIdentifier(ProductDesignHeader."Product Design No.");
                        until ProductDesignHeader.Next = 0;
                        Message('true');
                    end;
                end;
            }
            action("Update Customer VAT Reg")
            {

                trigger OnAction()
                var
                    Customer: Record Customer;
                begin
                    Customer.Reset;
                    if Customer.FindFirst then begin
                        repeat
                            Customer."VAT Registration No." := Customer."VAT TRN NO.";
                            Customer.Modify(true);
                        until Customer.Next = 0;
                        Message('Complete');
                    end;
                end;
            }
            action("Update Vendor VAT Reg")
            {

                trigger OnAction()
                var
                    Vendor: Record Vendor;
                begin
                    Vendor.Reset;
                    if Vendor.FindFirst then begin
                        repeat
                            Vendor."VAT Registration No." := Vendor."VAT TRN NO.";
                            Vendor.Modify(true);
                        until Vendor.Next = 0;
                        Message('Khush Raho');
                    end;
                end;
            }
            action("Update Customer No In Fixed Asset")
            {

                trigger OnAction()
                var
                    FixedAsset: Record "Fixed Asset";
                    Customer: Record Customer;
                begin
                    // Lines added By Sadaf
                    FixedAsset.Reset;
                    if FixedAsset.FindFirst then begin
                        repeat
                            Customer.Reset;
                            Customer.SetRange(Customer.Name, FixedAsset."Customer's Name");
                            if Customer.FindFirst then begin
                                FixedAsset."Customer Code" := Customer."No.";
                                FixedAsset.Modify(true);
                            end;
                        until FixedAsset.Next = 0;
                        Message('Complete');
                    end;
                end;
            }
            action("Update Die No. In CLE")
            {

                trigger OnAction()
                var
                    ProductDesignHeader: Record "Product Design Header";
                    CapacityLedgerEntry: Record "Capacity Ledger Entry";
                begin
                    ProductDesignHeader.Reset;
                    if ProductDesignHeader.FindFirst then begin
                        repeat
                            CapacityLedgerEntry.Reset;
                            CapacityLedgerEntry.SetRange(CapacityLedgerEntry."Item No.", ProductDesignHeader."Item Code");
                            CapacityLedgerEntry.SetRange(CapacityLedgerEntry."Work Center No.", 'WC0002');
                            if CapacityLedgerEntry.FindFirst then begin
                                repeat
                                    CapacityLedgerEntry."Die Number" := ProductDesignHeader."Die Number";
                                    CapacityLedgerEntry.Modify(true);
                                until CapacityLedgerEntry.Next = 0;
                            end;
                        until ProductDesignHeader.Next = 0;
                        Message('Complete');
                    end;
                end;
            }
            action("Update Plate No. In CLE")
            {
                CaptionML = ENU = 'Update Plate No. In CLE';

                trigger OnAction()
                var
                    ProductDesignHeader: Record "Product Design Header";
                    CapacityLedgerEntry: Record "Capacity Ledger Entry";
                begin
                    ProductDesignHeader.Reset;
                    if ProductDesignHeader.FindFirst then begin
                        repeat
                            CapacityLedgerEntry.Reset;
                            CapacityLedgerEntry.SetRange(CapacityLedgerEntry."Item No.", ProductDesignHeader."Item Code");
                            CapacityLedgerEntry.SetRange(CapacityLedgerEntry."Work Center No.", 'WC0002');
                            if CapacityLedgerEntry.FindFirst then begin
                                repeat
                                    CapacityLedgerEntry."Plate Item" := ProductDesignHeader."Plate Item No.";
                                    CapacityLedgerEntry."Plate Item No. 2" := ProductDesignHeader."Plate Item No. 2";
                                    CapacityLedgerEntry.Modify(true);
                                until CapacityLedgerEntry.Next = 0;
                            end;
                        until ProductDesignHeader.Next = 0;
                        Message('Complete');
                    end;
                end;
            }
            action("Update Estimate Number In Plate Card")
            {
                CaptionML = ENU = 'Update Estimate Number In Plate Card';

                trigger OnAction()
                var
                    Item: Record Item;
                    ProductDesignHeader: Record "Product Design Header";
                    ItemPlate: Record Item;
                begin
                    // Lines added By Deepak Kumar
                    ItemPlate.Reset;
                    ItemPlate.SetRange(ItemPlate."Plate Item", true);
                    ItemPlate.SetFilter(ItemPlate."Estimate No.", '');
                    if ItemPlate.FindFirst then begin
                        repeat
                            ProductDesignHeader.Reset;
                            ProductDesignHeader.SetRange(ProductDesignHeader."Item Code", ItemPlate."FG Item No.");
                            if ProductDesignHeader.FindFirst then begin
                                ItemPlate."Estimate No." := ProductDesignHeader."Product Design No.";
                                ItemPlate.Modify(true);
                            end;
                        until ItemPlate.Next = 0;
                        Message('complete');
                    end;
                end;
            }
            action("Update Cust on All Plate Itm")
            {

                trigger OnAction()
                var
                    iTem: Record Item;
                begin
                    iTem.Reset;
                    iTem.SetRange(iTem."Item Category Code", 'PLATE_FILM');
                    if iTem.FindFirst then begin
                        repeat
                            EstimateHeader.Reset;
                            EstimateHeader.SetRange(EstimateHeader."Item Code", iTem."FG Item No.");
                            if EstimateHeader.FindFirst then begin
                                iTem."Customer No." := EstimateHeader.Customer;
                                iTem."Customer Name" := EstimateHeader.Name;
                                iTem.Modify(true);
                            end;
                        until iTem.Next = 0;
                        Message('Complete');
                    end;
                end;
            }
            action("Update Ply")
            {

                trigger OnAction()
                var
                    ItemAttributeEntry1: Record "Item Attribute Entry";
                begin
                    Item.Reset;
                    Item.SetRange(Item."Item Category Code", 'FG');
                    if Item.FindFirst then begin
                        repeat
                            ItemAttributeEntry1.Reset;
                            ItemAttributeEntry1.SetRange(ItemAttributeEntry1."Item No.", Item."No.");
                            ItemAttributeEntry1.SetRange(ItemAttributeEntry1."Item Attribute Code", 'PLY');
                            if ItemAttributeEntry1.FindFirst then begin
                                ItemAttributeEntry1.CalcFields(ItemAttributeEntry1."Item Attribute Value NUm");
                                if ItemAttributeEntry1."Item Attribute Value NUm" = 2 then
                                    Item."No. of Ply" := 1;
                                if ItemAttributeEntry1."Item Attribute Value NUm" = 3 then
                                    Item."No. of Ply" := 2;
                                if ItemAttributeEntry1."Item Attribute Value NUm" = 5 then
                                    Item."No. of Ply" := 3;
                                if ItemAttributeEntry1."Item Attribute Value NUm" = 7 then
                                    Item."No. of Ply" := 4;

                                Item.Modify(true);
                            end;
                        until Item.Next = 0;
                        Message('Complete');
                    end;
                end;
            }
        }
    }

    var
        Item: Record Item;
        GLEntry: Record "G/L Entry";
        LineNUmber: Integer;
        ProductionOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        SalesLines: Record "Sales Line";
        EstimateHeader: Record "Product Design Header";
        ItemAttributeEntry: Record "Product Design Component Table";
        AttributeValue: Record "Material / Process Link Code";
        LineCount: Integer;
        ChangeLogentry: Record "Change Log Entry";
        EstimateLine: Record "Product Design Line";
        EstimateCodeUnit: Codeunit "Purch. Inspection Post N";
        ItemLedEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        ProdOrderComp: Record "Prod. Order Component";
        CapLedEntry: Record "Capacity Ledger Entry";
        PurchaseLine: Record "Purchase Line";
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        SalesInvLine: Record "Sales Invoice Line";
        SalesInvHeader: Record "Sales Invoice Header";
        SAM001: Label '<>''''';
        SaleShipmentLine: Record "Sales Shipment Line";
        PackingListLine: Record "Packing List Line";
        MfgSetup: Record "Manufacturing Setup";
}

