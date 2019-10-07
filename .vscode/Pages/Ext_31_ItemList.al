pageextension 50011 Ext_31_ItemList extends "Item List"
{

    layout
    {
        addafter("No.")
        {
            field("No. 2"; "No. 2")
            {

            }
        }
        // Add changes to page layout here
        addlast(Item)
        {
            field("Net Weight"; "Net Weight")
            {
                CaptionML = ENU = 'Net Weight (Gms) Customer';
            }
            field("Gross Weight"; "Gross Weight")
            {
                CaptionML = ENU = 'Gross Weight  (Gms)';
            }
            field("Estimate No."; "Estimate No.")
            {

            }
            field("No. of Ply"; "No. of Ply")
            {

            }
            field("Customer Name"; "Customer Name")
            {

            }
            field("Available in Estimate Line"; "Available in Estimate Line")
            {

            }
            // field(Inventory; Inventory)
            // {

            // }
            field("Net Change"; "Net Change")
            {

            }
            field("FG Item No."; "FG Item No.")
            {

            }
            field("Inventory Value Zero"; "Inventory Value Zero")
            {

            }
        }

    }

    actions
    {
        // Add changes to page actions here

        addfirst(Item)
        {
            group(Action31)
            {
                CaptionML = ENU = 'New';
                Image = Item;
                action(Action26)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'New Item';
                    RunPageMode = Edit;
                    RunObject = Page 50014;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = NewItem;
                    trigger OnAction()
                    var
                        ItemsByLocation: Page "Items by Location";
                    begin

                    end;
                }
                action(Action3)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Update Item';
                    RunObject = Page 50117;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = UpdateDescription;
                    trigger OnAction()
                    var
                        ItemsByLocation: Page "Items by Location";
                    begin

                    end;
                }
                action("Update item category")
                {
                    trigger OnAction()
                    var
                        Item: Record Item;
                        ItemVariant: Record "Item Variant";
                    begin
                        Item.reset;
                        Item.SetRange("Item Category Code", 'PAPER');
                        IF item.FindSet then
                            repeat
                                ItemVariant.Reset();
                                ItemVariant.SetRange("Item No.", Item."No.");
                                IF ItemVariant.FindSet() then
                                    ItemVariant.ModifyAll("Item Category Code", Item."Item Category Code");
                            until Item.Next = 0;
                        Message('Done');
                    end;
                }
                action("Update Paper Type")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Update Paper Type';
                    AccessByPermission = tabledata "Item Ledger Entry" = M;
                    Promoted = true;
                    PromotedIsBig = true;
                    Visible = false;
                    Image = UpdateDescription;
                    trigger OnAction()
                    var
                        Item: Record Item;
                        ILE: Record "Item Ledger Entry";
                        ProgressWindow: Dialog;
                    begin
                        Item.reset;
                        Item.SetRange("Item Category Code", 'PAPER');
                        IF item.FindSet then begin
                            ProgressWindow.Open('Item update..\\' + 'Item No. #1##########\' + 'Entry No. #2##########');
                            repeat
                                ProgressWindow.Update(1, Item."No.");
                                ILE.RESET;
                                ILE.SetRange("Item No.", Item."No.");
                                ILE.SetFilter("Paper Type", '<>%1', Item."Paper Type");
                                IF ILE.FindSet() then begin
                                    repeat
                                        ProgressWindow.Update(2, ILE."Entry No.");
                                        ILE."Paper Type" := Item."Paper Type";
                                        ILE.Modify();
                                    until ILE.next = 0;
                                END;
                            until Item.Next = 0;
                            ProgressWindow.Close;
                        END;
                        Message('Done');
                    end;
                }
            }
        }
        addafter(Reports)
        {
            // group(Reports)
            // {

            // }
            group(Action100)
            {
                CaptionML = ENU = 'Report List';
                Image = Report;
            }
        }
        addafter(Costing)
        {
            action(Action83)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Job Wise Material Status';
                RunObject = Report "Jobwise material status";
                Promoted = true;
                PromotedIsBig = true;
                Image = Report;
                PromotedCategory = Report;
                trigger OnAction()
                begin

                end;
            }
            action("Job Wise Material Status Summary")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Job Wise Material Status Summary';
                RunObject = Report "Jobwise material statusSummar";
                Promoted = true;
                PromotedIsBig = true;
                Image = Report;
                PromotedCategory = Report;
                trigger OnAction()
                begin

                end;
            }
            action(Action86)
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
            action(Action87)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'FG unit Cost Report';
                RunObject = Report 50057;
                Promoted = true;
                PromotedIsBig = true;
                Image = Report;
                PromotedCategory = Report;
                trigger OnAction()
                begin

                end;
            }
            action(Action88)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Additional Cost Report New';
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
    }

    trigger OnOpenPage()
    begin
        CalcFields(Inventory);
    end;

    trigger OnAfterGetRecord()
    begin
        CalcFields(Inventory);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CalcFields(Inventory);
    end;
}