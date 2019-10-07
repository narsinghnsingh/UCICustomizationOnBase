page 50114 "All Plate Status"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    RefreshOnActivate = true;
    SourceTable = Item;
    SourceTableView = SORTING ("No.")
                      ORDER(Ascending)
                      WHERE ("Plate Item" = CONST (true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("No. 2"; "No. 2")
                {
                }
                field(Description; Description)
                {
                }
                field("Printing Threshold Limit"; "Printing Threshold Limit")
                {
                }
                field("Repeat Prod. Order(Plate)"; "Repeat Prod. Order(Plate)")
                {
                    CaptionML = ENU = 'Repeat Job';
                }
                field("Customer Item Code"; "Customer Item Code")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Curr Prod. Order Desc."; "Curr Prod. Order Desc.")
                {
                    CaptionML = ENU = 'Job Description';
                }
                field("FG Item No."; "FG Item No.")
                {
                }
                field("Ready for Print"; "Ready for Print")
                {
                }
                field("Artwork Availabe"; "Artwork Availabe")
                {
                }
                field("Replace Plate"; "Replace Plate")
                {
                }
                field("Estimate No."; "Estimate No.")
                {
                }
                field("Req. For Purchase"; "Req. For Purchase")
                {
                }
                field("Negotiated Rate"; "Negotiated Rate")
                {
                }

                field("Vendor No."; "Vendor No.")
                {
                }
                field("Last Purch. Order No."; "Last Purch. Order No.")
                {
                }
                field("Qty. on Purch. Order"; "Qty. on Purch. Order")
                {
                }
                field("Output Qty"; "Output Qty")
                {
                }
                field("Last Purchase Inv Price"; "Last Purchase Inv Price")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control24; "Plate Variants")
            {
                SubPageLink = "Item No." = FIELD ("No.");
                SubPageView = SORTING ("Item No.", Code)
                              ORDER(Ascending);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("New Item")
            {
                CaptionML = ENU = 'New Item';
                Image = NewItem;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Item Wizard";

                trigger OnAction()
                var
                    ItemsByLocation: Page "Items by Location";
                begin
                end;
            }
            action("Create Purchase Order")
            {
                Image = "Order";
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PlateItemMaster: Record Item;
                    PurchaseHeader: Record "Purchase Header";
                    PurchaseLine: Record "Purchase Line";
                    TempVendorNo: Code[50];
                    TempLineNumber: Integer;
                    PlateVariants: Record "Item Variant";
                    ActiveVariant: Code[20];
                    noofcount: Integer;
                    NewPlateVariant: Record "Item Variant";
                begin
                    // Lines added BY Deepak kumar
                    TempVendorNo := '';
                    PlateItemMaster.Reset;
                    PlateItemMaster.SetCurrentKey("Vendor No.");
                    PlateItemMaster.SetRange(PlateItemMaster."Plate Item", true);
                    PlateItemMaster.SetRange(PlateItemMaster."Req. For Purchase", true);
                    if PlateItemMaster.FindFirst then begin
                        repeat
                            // Checks for the fields necessary for purchase order creation
                            PlateItemMaster.TestField(PlateItemMaster."Vendor No.");
                            PlateItemMaster.TestField(PlateItemMaster."Ready for Print", false);
                            PlateItemMaster.TestField(PlateItemMaster.Blocked, false);
                            PlateItemMaster.TestField(PlateItemMaster."Item Category Code");
                            PlateItemMaster.TestField(PlateItemMaster."Gen. Prod. Posting Group");
                            PlateItemMaster.TestField(PlateItemMaster."Inventory Posting Group");
                            //    PlateItemMaster.TESTFIELD(PlateItemMaster."New Job Number(Temp)");
                            //    PlateItemMaster."Mother Job No.":=PlateItemMaster."New Job Number(Temp)";
                            if PlateItemMaster."Replace Plate" then begin
                                PlateVariants.Reset;
                                PlateVariants.SetCurrentKey(Code);
                                PlateVariants.SetRange(PlateVariants."Item No.", PlateItemMaster."No.");
                                if PlateVariants.FindLast then begin

                                    //Insert New Variant
                                    noofcount := PlateVariants.Count;
                                    //MESSAGE(FORMAT(noofcount));
                                    NewPlateVariant.Init;
                                    NewPlateVariant."Item No." := "No.";
                                    NewPlateVariant.Description := Description;
                                    NewPlateVariant.Code := '000' + Format(noofcount + 1);
                                    NewPlateVariant."Active Variant" := true;
                                    //            NewPlateVariant."Mother Job No.":=PlateItemMaster."New Job Number(Temp)";
                                    NewPlateVariant.Insert(true);
                                    //Block Old Variant
                                    PlateVariants."Active Variant" := false;
                                    PlateVariants.Modify(true);
                                end else begin
                                    //Insert New Variant
                                    NewPlateVariant.Init;
                                    NewPlateVariant."Item No." := "No.";
                                    NewPlateVariant.Description := Description;
                                    NewPlateVariant.Code := '0001';
                                    NewPlateVariant."Active Variant" := true;
                                    //            NewPlateVariant."Mother Job No.":=PlateItemMaster."New Job Number(Temp)";
                                    NewPlateVariant.Insert(true);
                                end;
                            end;

                            //Assigning Active Variant
                            PlateVariants.Reset;
                            PlateVariants.SetRange(PlateVariants."Item No.", "No.");
                            PlateVariants.SetRange(PlateVariants."Active Variant", true);
                            if PlateVariants.FindFirst then
                                ActiveVariant := PlateVariants.Code;

                            if TempVendorNo <> PlateItemMaster."Vendor No." then begin
                                //MESSAGE('In Header Section');
                                PurchaseHeader.Init;
                                PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
                                PurchaseSetup.Get;
                                NoSeriesMgt.InitSeries(PurchaseSetup."Order Nos.", '', WorkDate, PurchaseHeader."No.", PurchaseHeader."No. Series");
                                PurchaseHeader.Insert(true);
                                Message(PurchaseHeader."No.");
                                PurchaseHeader.Validate("Buy-from Vendor No.", PlateItemMaster."Vendor No.");
                                PurchaseHeader."Order Date" := WorkDate;
                                PurchaseHeader."Posting Date" := WorkDate;
                                PurchaseHeader."Type Of Transaction" := PurchaseHeader."Type Of Transaction"::" ";
                                PurchaseHeader."Posting Description" := UserId + ' ' + Format(WorkDate) + Format(Time);
                                PurchaseHeader.Modify(true);
                                TempLineNumber := 10000;
                                TempVendorNo := PlateItemMaster."Vendor No.";
                            end;
                            PurchaseLine.Init;
                            TempLineNumber := TempLineNumber + 10000;
                            PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
                            PurchaseLine."Document No." := PurchaseHeader."No.";
                            PurchaseLine."Line No." := TempLineNumber;
                            PurchaseLine.Insert(true);
                            PurchaseLine.Type := PurchaseLine.Type::Item;
                            PurchaseLine.Validate("No.", PlateItemMaster."No.");
                            PurchaseLine."Plate Item" := true;
                            PurchaseLine.Validate(PurchaseLine."Variant Code", ActiveVariant);
                            PurchaseLine.Validate(PurchaseLine."Receiving Location", PurchaseSetup."Printing Plate Location Code");
                            PurchaseLine.Validate(Quantity, 1);
                            PurchaseLine.Validate("Direct Unit Cost", "Negotiated Rate");
                            PurchaseLine.Modify(true);
                            PlateItemMaster."Req. For Purchase" := false;
                            PlateItemMaster.Modify(true);
                        until PlateItemMaster.Next = 0;
                    end
                    else
                        Message('No Plate Items found for purchase !');
                end;
            }
            action("Approve Item")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    UserSetup: Record "User Setup";
                    Answer: Boolean;
                begin
                    // lines added by deepak kUmar
                    UserSetup.Reset;
                    UserSetup.SetRange(UserSetup."User ID", UserId);
                    UserSetup.SetRange(UserSetup.Item, true);
                    UserSetup.SetRange(UserSetup."Approval Authority Item", true);
                    if UserSetup.FindFirst then begin
                        Answer := DIALOG.Confirm('Do you want to approve Item', true, "No.");
                        if Answer = true then begin
                            Blocked := false;
                            Status := 1;
                            Modify(true);
                            Message('Approved')
                        end;
                    end else begin
                        Error('You are not authorised for "Item", Please contact your system administrator');
                    end;
                end;
            }
            action("Plate Card")
            {
                Image = Item;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Plate Item Card";
                RunPageLink = "No." = FIELD ("No.");
            }
            action("Upload Artwork")
            {
                Image = Picture;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Item Picture";
                RunPageLink = "No." = FIELD ("No.");
                RunPageView = SORTING ("No.");
            }
            action("Update Plate-in-ProdOrder")
            {

                trigger OnAction()
                begin
                    PlateItem.Reset;
                    PlateItem.SetRange(PlateItem."Plate Item", true);
                    if PlateItem.FindFirst then begin
                        repeat
                            ItemVariant.Reset;
                            ItemVariant.SetRange(ItemVariant."Item No.", PlateItem."No.");
                            ItemVariant.SetRange(ItemVariant."Active Variant", true);
                            if ItemVariant.FindFirst then;

                            RPO.Reset;
                            RPO.SetRange(RPO.Status, RPO.Status::Released);
                            RPO.SetRange(RPO."Source No.", PlateItem."FG Item No.");
                            if RPO.FindFirst then begin
                                repeat
                                    RPO."Plate Item No." := PlateItem."No.";
                                    //     RPO."Plate Item Variant":=  ItemVariant.Code  ;
                                    RPO.Modify(true);
                                until RPO.Next = 0;
                            end;
                        until PlateItem.Next = 0;
                    end;
                    Message('Update Complete');
                end;
            }
            action("Update Product Design Number")
            {

                trigger OnAction()
                var
                    ProductDesignHeader: Record "Product Design Header";
                begin
                    // Lines added By Deepak Kumar
                    SetRange("Plate Item", true);
                    if FindFirst then begin
                        repeat
                            ProductDesignHeader.Reset;
                            ProductDesignHeader.SetRange(ProductDesignHeader."Plate Item No.", "No.");
                            if ProductDesignHeader.FindFirst then begin
                                "Estimate No." := ProductDesignHeader."Product Design No.";
                                Modify(true);
                            end;
                        until Next = 0;
                        Message('complete');
                    end;
                end;
            }
        }
    }

    var
        VendorNo: Record Vendor;
        NegotiatedRate: Decimal;
        "Approved Yes/ No": Boolean;
        "Approved Date": Date;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurchaseSetup: Record "Purchases & Payables Setup";
        RPO: Record "Production Order";
        PlateItem: Record Item;
        ItemVariant: Record "Item Variant";
}

