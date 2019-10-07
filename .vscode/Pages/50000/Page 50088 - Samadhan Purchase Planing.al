page 50088 "Samadhan Purchase Planing"
{
    // version Samadhan Purchase Planing

    AutoSplitKey = true;
    CaptionML = ENU = 'Samadhan Purchase Planing';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = Worksheet;
    UsageCategory = Tasks;
    RefreshOnActivate = true;
    SaveValues = true;
    SourceTable = "Requisition Line";

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                CaptionML = ENU = 'Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    ReqJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    ReqJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        ReqJnlManagement.GetDescriptionAndRcptName(Rec, Description2, BuyFromVendorName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Accept Action Message"; "Accept Action Message")
                {
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field("Description 2"; "Description 2")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    Editable = false;
                }
                field("Vendor No."; "Vendor No.")
                {

                    trigger OnValidate()
                    begin
                        ReqJnlManagement.GetDescriptionAndRcptName(Rec, Description2, BuyFromVendorName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field(Inventory; Inventory)
                {
                }
                field("Cons. Reported last Month"; "Cons. Reported last Month")
                {
                    CaptionML = ENU = 'Consumption Reported last Month';
                }
                field("Cons. Rep. last Three Month"; "Cons. Rep. last Three Month")
                {
                    CaptionML = ENU = 'Consumption Reported in Last Three Month';
                }
                field("Cons. Rep. Curr Month"; "Cons. Rep. Curr Month")
                {
                    CaptionML = ENU = 'Consumption reported in Current Month';
                }
                field("Expected Cons.(Curr Month)"; "Expected Cons.(Curr Month)")
                {
                    CaptionML = ENU = 'Expected Consumption Current Month';
                }
                field("Re-Order  Quantity"; "Re-Order  Quantity")
                {
                }
                field("Safety Stock"; "Safety Stock")
                {
                }
                field("Maximum Order Quantity"; "Maximum Order Quantity")
                {
                }
                field("Minimum Order Quantity"; "Minimum Order Quantity")
                {
                }
                field("Requisition Quantity"; "Requisition Quantity")
                {
                }
                field("Suggested Order Quantity"; "Suggested Order Quantity")
                {
                    Style = Unfavorable;
                    StyleExpr = TRUE;
                }
                field("Req From Sales Order"; "Req From Sales Order")
                {
                }
                field(Quantity; Quantity)
                {
                    CaptionML = ENU = 'Quantity to Order';
                }
                field("Last Purchase Date"; "Last Purchase Date")
                {
                }
                field("Last Purchase Price"; "Last Purchase Price")
                {
                }
                field("Average Purchase Price"; "Average Purchase Price")
                {
                }
                field("Lead Time"; "Lead Time")
                {
                }
                field("Expected Purchase Value"; "Expected Purchase Value")
                {
                }
                field("Qty. On Purchase Order"; "Qty. On Purchase Order")
                {
                }
            }
            group(Control20)
            {
                ShowCaption = false;
                fixed(Control1901776201)
                {
                    ShowCaption = false;
                    group(Control1902759801)
                    {
                        CaptionML = ENU = 'Description';
                        field(Description2; Description2)
                        {
                            Editable = false;
                        }
                    }
                    group("Buy-from Vendor Name")
                    {
                        CaptionML = ENU = 'Buy-from Vendor Name';
                        field(BuyFromVendorName; BuyFromVendorName)
                        {
                            CaptionML = ENU = 'Buy-from Vendor Name';
                            Editable = false;
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            part(Control1903326807; "Item Replenishment FactBox")
            {
                SubPageLink = "No." = FIELD ("No.");
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                CaptionML = ENU = '&Line';
                Image = Line;
                action(Card)
                {
                    CaptionML = ENU = 'Card';
                    Image = EditLines;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;
                    RunObject = Codeunit "Req. Wksh.-Show Card";
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions';
                Image = "Action";
                action(CalculatePlan)
                {
                    CaptionML = ENU = 'Calculate Plan';
                    Ellipsis = true;
                    Image = CalculatePlan;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    //RunPageMode = Create;

                    trigger OnAction()
                    begin

                        // Lines added by Deepak kUmar
                        PlanningLineBuffer.Reset;
                        PlanningLineBuffer.SetRange(PlanningLineBuffer."Worksheet Template Name", 'Req');
                        PlanningLineBuffer.SetRange(PlanningLineBuffer."Journal Batch Name", CurrentJnlBatchName);
                        "Purchase Planning Request Page".SetTableView(PlanningLineBuffer);
                        "Purchase Planning Request Page".RunModal;
                    end;
                }
                action(CarryOutActionMessage)
                {
                    CaptionML = ENU = 'Carry &Out Action Message';
                    Ellipsis = true;
                    Image = CarryOutActionMessage;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PerformAction: Report "Carry Out Action Msg. - Req.";
                    begin
                        PerformAction.SetReqWkshLine(Rec);
                        PerformAction.RunModal;
                        PerformAction.GetReqWkshLine(Rec);
                        CurrentJnlBatchName := GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Inventory Availability")
            {
                CaptionML = ENU = 'Inventory Availability';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory Availability";
            }
            action(Status)
            {
                CaptionML = ENU = 'Status';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report Status;
            }
            action("Inventory - Availability Plan")
            {
                CaptionML = ENU = 'Inventory - Availability Plan';
                Image = ItemAvailability;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory - Availability Plan";
            }
            action("Inventory Order Details")
            {
                CaptionML = ENU = 'Inventory Order Details';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Inventory Order Details";
            }
            action("Inventory Purchase Orders")
            {
                CaptionML = ENU = 'Inventory Purchase Orders';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory Purchase Orders";
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ReqJnlManagement.GetDescriptionAndRcptName(Rec, Description2, BuyFromVendorName);
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        "Accept Action Message" := false;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ReqJnlManagement.SetUpNewLine(Rec, xRec);
        Clear(ShortcutDimCode);
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        OpenedFromBatch := ("Journal Batch Name" <> '') and ("Worksheet Template Name" = '');
        if OpenedFromBatch then begin
            CurrentJnlBatchName := "Journal Batch Name";
            ReqJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        ReqJnlManagement.TemplateSelection(PAGE::"Req. Worksheet", false, 0, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        ReqJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
    end;

    var
        SalesHeader: Record "Sales Header";
        ChangeExchangeRate: Page "Change Exchange Rate";
        SalesOrder: Page "Sales Order";
        GetSalesOrder: Report "Get Sales Orders";
        CalculatePlan: Report "Calculate Plan - Req. Wksh.";
        ReqJnlManagement: Codeunit ReqJnlManagement;
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        CurrentJnlBatchName: Code[10];
        Description2: Text[250];
        BuyFromVendorName: Text[250];
        ShortcutDimCode: array[8] of Code[20];
        OpenedFromBatch: Boolean;
        "--Samadhan": Integer;
        RequestForm: Record "Planning Line Buffer";
        "Purchase Planning Request Page": Page "Purchase Planning Request Page";
        PlanningLineBuffer: Record "Planning Line Buffer";

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        ReqJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;
}

