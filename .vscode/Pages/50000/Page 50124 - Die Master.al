page 50124 "Die Master"
{
    // version Die

    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Fixed Asset";
    SourceTableView = SORTING ("No.")
                      ORDER(Ascending)
                      WHERE (Die = CONST (true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Die; Die)
                {
                }
                field(Size; Size)
                {
                }
                field("Customer Item Code"; "Customer Item Code")
                {
                }
                field("Ready to Use"; "Ready to Use")
                {
                }
                field("Customer's Name"; "Customer's Name")
                {
                }
                field("Curr Prod. Order Desc."; "Curr Prod. Order Desc.")
                {
                }
                field("Mother Job Quantity"; "Mother Job Quantity")
                {
                }
                field("Mother Job No."; "Mother Job No.")
                {
                }
                field("Replace Die/Plate"; "Replace Die/Plate")
                {
                }
                field("Vendor Die"; "Vendor Die")
                {
                }
                field("Die/Plate Ready Date"; "Die/Plate Ready Date")
                {
                }
                field(KLD; KLD)
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
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Create Purchase Order")
            {
                Image = "Order";
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DieMaster: Record "Fixed Asset";
                    PurchaseHeader: Record "Purchase Header";
                    PurchaseLine: Record "Purchase Line";
                    TempVendorNo: Code[50];
                    TempLineNumber: Integer;
                    noofcount: Integer;
                    PurchaseSetup: Record "Purchases & Payables Setup";
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                    ItemMaster: Record Item;
                    FAMaster: Record "Fixed Asset";
                    Fasetup: Record "FA Setup";
                    TempItemCode: Code[20];
                    TempItemCod1: Code[20];
                begin
                    // Lines added BY Deepak kumar
                    TempVendorNo := '';

                    DieMaster.Reset;
                    DieMaster.SetCurrentKey("Vendor No.");
                    DieMaster.SetRange(DieMaster.Die, true);
                    DieMaster.SetRange(DieMaster."Req. For Purchase", true);
                    DieMaster.SetRange(DieMaster.Inactive, false);
                    DieMaster.SetRange(DieMaster.Blocked, false);
                    if DieMaster.FindFirst then begin
                        repeat
                            DieMaster.TestField(DieMaster."Vendor No.");
                            DieMaster.TestField(DieMaster."Req. For Purchase");

                            if TempVendorNo <> DieMaster."Vendor No." then begin
                                PurchaseHeader.Init;
                                PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
                                PurchaseSetup.Get;
                                NoSeriesMgt.InitSeries(PurchaseSetup."Order Nos.", '', WorkDate, PurchaseHeader."No.", PurchaseHeader."No. Series");
                                PurchaseHeader.Insert(true);
                                Message(PurchaseHeader."No.");
                                PurchaseHeader.Validate("Buy-from Vendor No.", DieMaster."Vendor No.");
                                PurchaseHeader."Order Date" := WorkDate;
                                PurchaseHeader."Posting Date" := WorkDate;
                                PurchaseHeader."Type Of Transaction" := PurchaseHeader."Type Of Transaction"::" ";
                                PurchaseHeader."Posting Description" := UserId + ' ' + Format(WorkDate) + Format(Time);
                                PurchaseHeader.Modify(true);
                                TempLineNumber := 10000;
                                TempVendorNo := DieMaster."Vendor No.";
                            end;

                            // Lines added for create new FA
                            ItemMaster.Reset;
                            ItemMaster.SetRange(ItemMaster."No.", DieMaster."FG Item Number");
                            if ItemMaster.FindFirst then begin
                                FAMaster.Init;
                                Fasetup.Get;
                                Fasetup.TestField(Fasetup."Fixed Asset Nos.");
                                NoSeriesMgt.InitSeries(Fasetup."Fixed Asset Nos.", '', 0D, TempItemCode, TempItemCod1);
                                FAMaster."No." := TempItemCode;
                                FAMaster."FG Item Number" := ItemMaster."No.";
                                FAMaster.Description := 'Die ' + ItemMaster."No. 2";
                                FAMaster.Die := true;
                                FAMaster."Ready to Use" := false;
                                FAMaster."Replace Die/Plate" := false;
                                FAMaster.Insert(true);
                                ItemMaster."Die Number" := TempItemCode;
                                ItemMaster.Modify(true);
                                DieMaster.Blocked := true;
                                DieMaster.Inactive := true;
                                DieMaster.Modify(true);
                            end;

                            PurchaseLine.Init;
                            TempLineNumber := TempLineNumber + 10000;
                            PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
                            PurchaseLine."Document No." := PurchaseHeader."No.";
                            PurchaseLine."Line No." := TempLineNumber;
                            PurchaseLine.Insert(true);
                            PurchaseLine.Type := PurchaseLine.Type::"Fixed Asset";
                            PurchaseLine.Validate("No.", TempItemCode);
                            PurchaseLine.Validate(Quantity, 1);
                            PurchaseLine.Validate(PurchaseLine."Direct Unit Cost", DieMaster."Negotiated Rate");
                            PurchaseLine.Modify(true);
                            DieMaster."Req. For Purchase" := false;
                            DieMaster.Modify(true);

                        until DieMaster.Next = 0;
                    end
                    else
                        Message('No Line found for purchase !');
                end;
            }
            action("Upload Artwork")
            {
                CaptionML = ENU = 'Upload KLD';
                Image = Picture;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Fixed Asset Picture";
                RunPageLink = "No." = FIELD ("No.");
                RunPageView = SORTING ("No.");
            }
        }
    }
}

