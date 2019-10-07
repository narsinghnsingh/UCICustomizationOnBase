page 50139 "Sales Dispatch Order"
{
    // version Sales Dispatch

    Caption = 'Sales Dispatch Order';
    DeleteAllowed = false;
    PageType = Document;
    UsageCategory = Tasks;
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = WHERE ("Document Type" = FILTER (Order),
                            "Short Closed Document" = CONST (false),
                            Status = CONST (Released));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    Importance = Promoted;
                    Visible = DocNoVisible;

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    Importance = Promoted;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Sell-to Contact No."; "Sell-to Contact No.")
                {
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        if GetFilter("Sell-to Contact No.") = xRec."Sell-to Contact No." then
                            if "Sell-to Contact No." <> xRec."Sell-to Contact No." then
                                SetRange("Sell-to Contact No.");
                    end;
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                    QuickEntry = false;
                }
                field("Sell-to Address"; "Sell-to Address")
                {
                    Importance = Additional;
                }
                field("Sell-to Address 2"; "Sell-to Address 2")
                {
                    Importance = Additional;
                }
                field("Sell-to Post Code"; "Sell-to Post Code")
                {
                    Importance = Additional;
                }
                field("Sell-to City"; "Sell-to City")
                {
                    QuickEntry = false;
                }
                field("Sell-to Contact"; "Sell-to Contact")
                {
                    Importance = Additional;
                }
                field("No. of Archived Versions"; "No. of Archived Versions")
                {
                    Importance = Additional;
                }
                field("Posting Date"; "Posting Date")
                {
                    QuickEntry = false;
                }
                field("Order Date"; "Order Date")
                {
                    Importance = Promoted;
                    QuickEntry = false;
                }
                field("Document Date"; "Document Date")
                {
                    QuickEntry = false;
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                }
                field("Promised Delivery Date"; "Promised Delivery Date")
                {
                    Importance = Additional;
                }
                field("Quote No."; "Quote No.")
                {
                    Importance = Additional;
                }
                field("External Document No."; "External Document No.")
                {
                    Importance = Promoted;
                    ShowMandatory = ExternalDocNoMandatory;
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        SalespersonCodeOnAfterValidate;
                    end;
                }
                field("Driver Name"; "Driver Name")
                {
                }
                field("Vehicle No."; "Vehicle No.")
                {
                }
                field("Campaign No."; "Campaign No.")
                {
                    Importance = Additional;
                }
                field("Opportunity No."; "Opportunity No.")
                {
                    Importance = Additional;
                }
                field("Shipping No."; "Shipping No.")
                {
                }
                field("Posting No."; "Posting No.")
                {
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    Importance = Additional;
                }
                field("Assigned User ID"; "Assigned User ID")
                {
                    Importance = Additional;
                }
                field("Job Queue Status"; "Job Queue Status")
                {
                    Importance = Additional;
                }
                field(Status; Status)
                {
                    Importance = Promoted;
                    QuickEntry = false;
                }
            }
            part(SalesLines; "Sales Invoicing Sub Form")
            {
                Editable = DynamicEditable;
                SubPageLink = "Document No." = FIELD ("No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        BilltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Bill-to Contact No."; "Bill-to Contact No.")
                {
                    Importance = Additional;
                }
                field("Bill-to Name"; "Bill-to Name")
                {
                }
                field("Bill-to Address"; "Bill-to Address")
                {
                    Importance = Additional;
                }
                field("Bill-to Address 2"; "Bill-to Address 2")
                {
                    Importance = Additional;
                }
                field("Bill-to Post Code"; "Bill-to Post Code")
                {
                    Importance = Additional;
                }
                field("Bill-to City"; "Bill-to City")
                {
                }
                field("Bill-to Contact"; "Bill-to Contact")
                {
                    Importance = Additional;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    Importance = Promoted;
                }
                field("Due Date Calculated By Month"; "Due Date Calculated By Month")
                {
                }
                field("Due Date"; "Due Date")
                {
                    Importance = Promoted;
                }
                field("Payment Discount %"; "Payment Discount %")
                {
                }
                field("Pmt. Discount Date"; "Pmt. Discount Date")
                {
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                }
                field("Direct Debit Mandate ID"; "Direct Debit Mandate ID")
                {
                }
                field("Prices Including VAT"; "Prices Including VAT")
                {

                    trigger OnValidate()
                    begin
                        PricesIncludingVATOnAfterValid;
                    end;
                }
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
                }
                // field(GetCreditcardNumber;GetCreditcardNumber)
                // {
                //     Caption = 'Cr. Card Number (Last 4 Digits)';
                // }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code"; "Ship-to Code")
                {
                    Importance = Promoted;
                }
                field("Ship-to Name"; "Ship-to Name")
                {
                }
                field("Ship-to Address"; "Ship-to Address")
                {
                    Importance = Additional;
                }
                field("Ship-to Address 2"; "Ship-to Address 2")
                {
                    Importance = Additional;
                }
                field("Ship-to Post Code"; "Ship-to Post Code")
                {
                    Importance = Promoted;
                }
                field("Ship-to City"; "Ship-to City")
                {
                }
                field("Ship-to Contact"; "Ship-to Contact")
                {
                    Importance = Additional;
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Outbound Whse. Handling Time"; "Outbound Whse. Handling Time")
                {
                    Importance = Additional;
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                    Importance = Additional;
                }
                field("Shipping Agent Service Code"; "Shipping Agent Service Code")
                {
                    Importance = Additional;
                }
                field("Shipping Time"; "Shipping Time")
                {
                }
                field("Late Order Shipping"; "Late Order Shipping")
                {
                    Importance = Additional;
                }
                field("Package Tracking No."; "Package Tracking No.")
                {
                    Importance = Additional;
                }
                field("Shipment Date"; "Shipment Date")
                {
                    Importance = Promoted;
                }
                field("Shipping Advice"; "Shipping Advice")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        if "Shipping Advice" <> xRec."Shipping Advice" then
                            if not Confirm(Text001, false, FieldCaption("Shipping Advice")) then
                                Error(Text002);
                    end;
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code"; "Currency Code")
                {
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        Clear(ChangeExchangeRate);
                        if "Posting Date" <> 0D then
                            ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", "Posting Date")
                        else
                            ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", WorkDate);
                        if ChangeExchangeRate.RunModal = ACTION::OK then begin
                            Validate("Currency Factor", ChangeExchangeRate.GetParameter);
                            CurrPage.Update;
                        end;
                        Clear(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                        SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0, Rec);
                    end;
                }
            }
            group("Order Copy")
            {
                Caption = 'Order Copy';
                field(Picture; Picture)
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control1903720907; "Sales Hist. Sell-to FactBox")
            {
                SubPageLink = "No." = FIELD ("Sell-to Customer No.");
                Visible = true;
            }
            part(Control1902018507; "Customer Statistics FactBox")
            {
                SubPageLink = "No." = FIELD ("Bill-to Customer No.");
                Visible = false;
            }
            part(Control1900316107; "Customer Details FactBox")
            {
                SubPageLink = "No." = FIELD ("Sell-to Customer No.");
                Visible = false;
            }
            part(Control1906127307; "Sales Line FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "Document Type" = FIELD ("Document Type"),
                              "Document No." = FIELD ("Document No."),
                              "Line No." = FIELD ("Line No.");
                Visible = true;
            }
            part(Control39; "Pallets ListPart")
            {
                Provider = SalesLines;
                SubPageLink = "Delivery Order No." = FIELD ("Document No.");
                Visible = true;
            }
            part(Control1901314507; "Item Invoicing FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "No." = FIELD ("No.");
                Visible = false;
            }
            part(Control1906354007; "Approval FactBox")
            {
                SubPageLink = "Table ID" = CONST (36),
                              "Document Type" = FIELD ("Document Type"),
                              "Document No." = FIELD ("No.");
                Visible = false;
            }
            part(Control1907012907; "Resource Details FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "No." = FIELD ("No.");
                Visible = false;
            }
            part(Control1901796907; "Item Warehouse FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "No." = FIELD ("No.");
                Visible = false;
            }
            part(Control1907234507; "Sales Hist. Bill-to FactBox")
            {
                SubPageLink = "No." = FIELD ("Bill-to Customer No.");
                Visible = false;
            }
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("O&rder")
            {
                Caption = 'O&rder';
                Image = "Order";
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD ("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Print Bundle Tag")
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        SalesHeader.Reset;
                        SalesHeader.SetRange(SalesHeader."No.", "No.");
                        REPORT.RunModal(REPORT::"JobWise Costing", true, true, SalesHeader);
                    end;
                }
                action("Estimate Additional Cost")
                {
                    Caption = 'Estimate Additional Cost';
                    Image = CalculateCost;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SalesHeaderN: Record "Sales Header";
                        SalesLineN: Record "Sales Line";
                        SalesLineNew: Record "Sales Line";
                        TempLineNo: Integer;
                        EstimateCostLine: Record "Product Design Special Descrip";
                        StandardSalesCode: Record "Standard Sales Code";
                        AddnCostSalesLine: Record "Sales Line";
                        AdditionalCostPosted: Boolean;
                        AdditionalCostInserted: Boolean;
                        PostedSalesInvoice: Record "Sales Invoice Line";
                    begin
                        // Lines added By Deepak Kumar
                        SalesHeaderN.Reset;
                        SalesHeaderN.SetRange(SalesHeaderN."Document Type", "Document Type");
                        SalesHeaderN.SetRange(SalesHeaderN."No.", "No.");
                        if SalesHeaderN.FindFirst then begin
                            SalesHeaderN.Status := SalesHeaderN.Status::Open;
                            SalesHeaderN.Modify(true);
                            SalesLineN.Reset;
                            SalesLineN.SetRange(SalesLineN."Document Type", SalesHeaderN."Document Type");
                            SalesLineN.SetRange(SalesLineN."Document No.", SalesHeaderN."No.");
                            SalesLineN.SetRange(SalesLineN.Type, SalesLineN.Type::Item);
                            //SalesLineN.SETRANGE(SalesLineN."Estimate Additional Cost",FALSE);
                            if SalesLineN.FindFirst then begin
                                // SalesLineNew.RESET;
                                // SalesLineNew.SETRANGE(SalesLineNew."Document Type",SalesHeaderN."Document Type");
                                // SalesLineNew.SETRANGE(SalesLineNew."Document No.",SalesHeaderN."No.");
                                // SalesLineNew.SETRANGE(SalesLineNew."Estimate Additional Cost",TRUE);
                                // IF SalesLineNew.FINDFIRST THEN
                                //    SalesLineNew.DELETEALL(TRUE);

                                SalesLineNew.Reset;
                                repeat
                                    TempLineNo := SalesLineN."Line No.";
                                    EstimateCostLine.Reset;
                                    EstimateCostLine.SetRange(EstimateCostLine."No.", SalesLineN."Estimation No.");
                                    EstimateCostLine.SetRange(EstimateCostLine.Category, EstimateCostLine.Category::Cost);
                                    if EstimateCostLine.FindFirst then begin
                                        repeat
                                            //---Check if the cost is already posted for this Estimate
                                            AdditionalCostInserted := false;
                                            AdditionalCostPosted := false;
                                            if EstimateCostLine.Occurrence = EstimateCostLine.Occurrence::Once then begin
                                                PostedSalesInvoice.Reset;
                                                PostedSalesInvoice.SetRange(PostedSalesInvoice."Estimation No.", EstimateCostLine."No.");
                                                PostedSalesInvoice.SetRange(PostedSalesInvoice."Estimate Additional Cost", true);
                                                PostedSalesInvoice.SetRange(PostedSalesInvoice.Type, PostedSalesInvoice.Type::"G/L Account");
                                                PostedSalesInvoice.SetFilter(PostedSalesInvoice."Cross-Reference No.", EstimateCostLine."Cost Code");
                                                if PostedSalesInvoice.FindFirst then begin
                                                    AdditionalCostPosted := true;
                                                end;
                                            end;
                                            //---Check if already inserted in this Sales Invoice for this Estimate
                                            AddnCostSalesLine.Reset;
                                            AddnCostSalesLine.SetRange(AddnCostSalesLine."Document Type", "Document Type");
                                            AddnCostSalesLine.SetRange(AddnCostSalesLine."Document No.", "No.");
                                            AddnCostSalesLine.SetRange(AddnCostSalesLine."Estimate Additional Cost", true);
                                            AddnCostSalesLine.SetRange(AddnCostSalesLine."Estimation No.", SalesLineN."Estimation No.");
                                            AddnCostSalesLine.SetRange(AddnCostSalesLine."Cross-Reference No.", EstimateCostLine."Cost Code");
                                            if AddnCostSalesLine.FindFirst then
                                                AdditionalCostInserted := true;

                                            if (AdditionalCostPosted = false) and (AdditionalCostInserted = false) and (SalesLineN."Qty. to Ship" > 0) then begin
                                                TempLineNo := TempLineNo + 1000;
                                                SalesLineNew.Init;
                                                SalesLineNew."Document Type" := SalesLineN."Document Type";
                                                SalesLineNew."Document No." := SalesLineN."Document No.";
                                                SalesLineNew."Line No." := TempLineNo;
                                                SalesLineNew."Sell-to Customer No." := SalesLineN."Sell-to Customer No.";
                                                SalesLineNew.Type := SalesLineNew.Type::"G/L Account";
                                                StandardSalesCode.Reset;
                                                StandardSalesCode.SetRange(StandardSalesCode.Code, EstimateCostLine."Cost Code");
                                                if StandardSalesCode.FindFirst then begin
                                                    StandardSalesCode.TestField(StandardSalesCode."G/L Account");
                                                    SalesLineNew.Validate("No.", StandardSalesCode."G/L Account");
                                                end else begin
                                                    Error('The cost master %1 not found in the list', EstimateCostLine."Cost Code");
                                                end;
                                                SalesLineNew.Description := '   ' + EstimateCostLine."Cost Description";
                                                SalesLineNew.Validate("Unit Price", EstimateCostLine.Amount);
                                                SalesLineNew."Estimate Additional Cost" := true;
                                                SalesLineNew."Estimation No." := SalesLineN."Estimation No.";
                                                SalesLineNew."Cross-Reference No." := EstimateCostLine."Cost Code";
                                                SalesLineNew."System-Created Entry" := true;
                                                SalesLineNew.Insert(true);
                                                SalesLineNew.Validate(SalesLineNew.Quantity, 1);
                                                SalesLineNew.Modify(true);
                                            end;
                                        until EstimateCostLine.Next = 0;
                                    end;
                                until SalesLineN.Next = 0;
                            end;
                            SalesHeaderN.Status := SalesHeaderN.Status::Released;
                            SalesHeaderN.Modify(true);
                        end;
                    end;
                }
                action("Get Sub-Component Line")
                {
                    Caption = 'Get Sub-Component Line';
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SalesHeaderN: Record "Sales Header";
                        SalesLineN: Record "Sales Line";
                        SalesLineNew: Record "Sales Line";
                        TempLineNo: Integer;
                        EstimateCostLine: Record "Product Design Special Descrip";
                        StandardSalesCode: Record "Standard Sales Code";
                        AddnCostSalesLine: Record "Sales Line";
                        AdditionalCostPosted: Boolean;
                        AdditionalCostInserted: Boolean;
                        PostedSalesInvoice: Record "Sales Invoice Line";
                        EstimateHeader: Record "Product Design Header";
                    begin
                        // Lines added By Deepak Kumar
                        SalesHeaderN.Reset;
                        SalesHeaderN.SetRange(SalesHeaderN."Document Type", "Document Type");
                        SalesHeaderN.SetRange(SalesHeaderN."No.", "No.");
                        if SalesHeaderN.FindFirst then begin
                            SalesHeaderN.Status := SalesHeaderN.Status::Open;
                            SalesHeaderN.Modify(true);
                            SalesLineN.Reset;
                            SalesLineN.SetRange(SalesLineN."Document Type", SalesHeaderN."Document Type");
                            SalesLineN.SetRange(SalesLineN."Document No.", SalesHeaderN."No.");
                            SalesLineN.SetRange(SalesLineN.Type, SalesLineN.Type::Item);
                            SalesLineN.SetRange(SalesLineN."Sub Component Item", false);
                            if SalesLineN.FindFirst then begin

                                SalesLineNew.Reset;
                                repeat
                                    TempLineNo := SalesLineN."Line No.";
                                    EstimateHeader.Reset;
                                    EstimateHeader.SetRange(EstimateHeader."Product Design No.", SalesLineN."Estimation No.");
                                    EstimateHeader.SetRange(EstimateHeader."Separate Sales Lines", true);
                                    if EstimateHeader.FindFirst then begin
                                        repeat
                                            TempLineNo := TempLineNo + 1000;
                                            SalesLineNew.Init;
                                            SalesLineNew."Document Type" := SalesLineN."Document Type";
                                            SalesLineNew."Document No." := SalesLineN."Document No.";
                                            SalesLineNew."Line No." := TempLineNo;
                                            SalesLineNew."Sell-to Customer No." := SalesLineN."Sell-to Customer No.";
                                            SalesLineNew.Type := SalesLineNew.Type::Item;
                                            SalesLineNew.Validate("No.", EstimateHeader."Item Code");
                                            SalesLineNew.Description := '   ' + EstimateHeader."Item Description";
                                            SalesLineNew.Validate("Unit Price", 0);
                                            SalesLineNew."Sub Component Item" := true;
                                            SalesLineNew."Estimation No." := SalesLineN."Estimation No.";
                                            SalesLineNew."Cross-Reference No." := Format(SalesLineN."Line No.");
                                            SalesLineNew."System-Created Entry" := true;
                                            SalesLineNew.Insert(true);
                                            SalesLineNew.Validate(SalesLineNew.Quantity, EstimateHeader."Quantity Per FG" * SalesLineN.Quantity);
                                            SalesLineNew.Modify(true);
                                        until EstimateHeader.Next = 0;
                                    end;

                                until SalesLineN.Next = 0;
                            end;
                            SalesHeaderN.Status := SalesHeaderN.Status::Released;
                            SalesHeaderN.Modify(true);
                            Message('Completed');
                        end;
                    end;
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                action("S&hipments")
                {
                    Caption = 'S&hipments';
                    Image = Shipment;
                    RunObject = Page "Posted Sales Shipments";
                    RunPageLink = "Order No." = FIELD ("No.");
                    RunPageView = SORTING ("Order No.");
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;

                action("Preview Posting")
                {
                    Caption = 'Preview Posting';
                    Ellipsis = true;
                    Image = ViewPostedOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SalesPostYesNo: Codeunit "Sales-Post (Yes/No)";
                    begin
                        SalesPostYesNo.Preview(Rec);
                    end;
                }
                action(Posts)
                {
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        // Lines addded By Deepak Kumar
                        ValidateCreditLimit();
                        SubsMgmt.GetAdditionalCostValidation(Rec);
                        Post(CODEUNIT::"Sales-Post (Yes/No)");
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Ellipsis = true;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        // Lines addded By Deepak Kumar
                        ValidateCreditLimit();
                        SubsMgmt.GetAdditionalCostValidation(Rec);

                        Post(CODEUNIT::"Sales-Post + Print");
                    end;
                }
                action("Post and Email")
                {
                    Caption = 'Post and Email';
                    Ellipsis = true;
                    Image = PostMail;

                    trigger OnAction()
                    var
                        SalesPostPrint: Codeunit "Sales-Post + Print";
                    begin
                        // Lines addded By Deepak Kumar
                        ValidateCreditLimit();
                        SubsMgmt.GetAdditionalCostValidation(Rec);

                        SalesPostPrint.PostAndEmail(Rec);
                    end;
                }

                action(Invoices)
                {
                    Caption = 'Invoices';
                    Image = Invoice;
                    RunObject = Page "Posted Sales Invoices";
                    RunPageLink = "Order No." = FIELD ("No.");
                    RunPageView = SORTING ("Order No.");
                }
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintSalesHeader(Rec);
                    end;
                }
                action("Proforma Invoice")
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        SalesHeader.Reset;
                        SalesHeader.SetCurrentKey("No.");
                        SalesHeader.SetRange(SalesHeader."No.", "No.");

                        if SalesHeader.FindFirst then
                            REPORT.RunModal(REPORT::"Proforma Inv", true, false, SalesHeader);
                    end;
                }
            }
            group("&Order Confirmation")
            {
                Caption = '&Order Confirmation';
                Image = Email;
                action("Email Confirmation")
                {
                    Caption = 'Email Confirmation';
                    Ellipsis = true;
                    Image = Email;

                    trigger OnAction()
                    begin
                        DocPrint.EmailSalesHeader(Rec);
                    end;
                }
                action("Print Confirmation")
                {
                    Caption = 'Print Confirmation';
                    Ellipsis = true;
                    Image = Print;

                    trigger OnAction()
                    begin
                        DocPrint.PrintSalesOrder(Rec, Usage::"Order Confirmation");
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        DynamicEditable := CurrPage.Editable;
    end;

    trigger OnAfterGetRecord()
    begin
        JobQueueVisible := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
        SetExtDocNoMandatoryCondition;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(ConfirmDeletion);
    end;

    trigger OnInit()
    begin
        SetExtDocNoMandatoryCondition;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CheckCreditMaxBeforeInsert;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Responsibility Center" := UserMgt.GetSalesFilter;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetSalesFilter <> '' then begin
            FilterGroup(2);
            SetRange("Responsibility Center", UserMgt.GetSalesFilter);
            FilterGroup(0);
        end;

        SetRange("Date Filter", 0D, WorkDate - 1);

        SetDocNoVisible;
    end;

    var
        Text000: Label 'Unable to run this function while in View mode.';
        CopySalesDoc: Report "Copy Sales Document";
        MoveNegSalesLines: Report "Move Negative Sales Lines";

        ReportPrint: Codeunit "Test Report-Print";
        DocPrint: Codeunit "Document-Print";
        ArchiveManagement: Codeunit ArchiveManagement;
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
        ChangeExchangeRate: Page "Change Exchange Rate";
        UserMgt: Codeunit "User Setup Management";
        Usage: Option "Order Confirmation","Work Order","Pick Instruction";
        [InDataSet]
        JobQueueVisible: Boolean;
        Text001: Label 'Do you want to change %1 in all related records in the warehouse?';
        Text002: Label 'The update has been interrupted to respect the warning.';
        DynamicEditable: Boolean;
        DocNoVisible: Boolean;
        ExternalDocNoMandatory: Boolean;
        SalesHeader: Record "Sales Header";
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        SalesLine: Record "Sales Line";
        SalesPost: Codeunit "Sales-Post";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        SubsMgmt: Codeunit CodeunitSubscriber;

    local procedure Post(PostingCodeunitID: Integer)
    begin
        SendToPosting(PostingCodeunitID);
        if "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting" then
            CurrPage.Close;
        CurrPage.Update(false);
    end;

    procedure UpdateAllowed(): Boolean
    begin
        if CurrPage.Editable = false then
            Error(Text000);
        exit(true);
    end;

    local procedure ApproveCalcInvDisc()
    begin
        CurrPage.SalesLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure SelltoCustomerNoOnAfterValidat()
    begin
        if GetFilter("Sell-to Customer No.") = xRec."Sell-to Customer No." then
            if "Sell-to Customer No." <> xRec."Sell-to Customer No." then
                SetRange("Sell-to Customer No.");
        CurrPage.Update;
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
        CurrPage.SalesLines.PAGE.UpdateForm(true);
    end;

    local procedure BilltoCustomerNoOnAfterValidat()
    begin
        CurrPage.Update;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.Update;
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.Update;
    end;

    local procedure PricesIncludingVATOnAfterValid()
    begin
        CurrPage.Update;
    end;

    local procedure Prepayment37OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::Order, "No.");
    end;

    local procedure SetExtDocNoMandatoryCondition()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get;
        ExternalDocNoMandatory := SalesReceivablesSetup."Ext. Doc. No. Mandatory"
    end;

    local procedure ValidateCreditLimit()
    begin
        // Lines adde by Deepak Kumar
        CustCheckCreditLimit.SalesHeaderCheck(Rec);
    end;
}

