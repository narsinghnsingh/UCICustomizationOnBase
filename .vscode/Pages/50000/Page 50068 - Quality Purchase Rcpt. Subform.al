page 50068 "Quality Purchase Rcpt. Subform"
{
    // version Samadhan Quality

    AutoSplitKey = true;
    CaptionML = ENU = 'Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    Permissions = TableData "Purch. Rcpt. Line"=rimd;
    RefreshOnActivate = true;
    SourceTable = "Purch. Rcpt. Line";
    SourceTableView = SORTING("Document No.","Line No.")
                      ORDER(Ascending)
                      WHERE(Quantity=FILTER(<>0));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date";"Posting Date")
                {
                    Editable = false;
                }
                field("Buy-from Vendor No.";"Buy-from Vendor No.")
                {
                    Editable = false;
                }
                field("Document No.";"Document No.")
                {
                    Editable = false;
                }
                field("Line No.";"Line No.")
                {
                    Editable = false;
                }
                field("No.";"No.")
                {
                    Editable = false;
                }
                field("Location Code";"Location Code")
                {
                    Editable = false;
                }
                field("Receiving Location";"Receiving Location")
                {
                }
                field("Expected Receipt Date";"Expected Receipt Date")
                {
                    Editable = false;
                }
                field("Roll Quality Entered";"Roll Quality Entered")
                {
                }
                field(Description;Description)
                {
                    Editable = false;
                }
                field("Variant Code";"Variant Code")
                {
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    Editable = false;
                }
                field(Quantity;Quantity)
                {
                    Editable = false;
                }
                field("Accepted Qty.";"Accepted Qty.")
                {

                    trigger OnValidate()
                    begin
                        Item.Get("No.");
                        if Item."Roll ID Applicable"  then
                          Error('Please enter Quantity in Roll Master');
                    end;
                }
                field("Acpt. Under Dev.";"Acpt. Under Dev.")
                {
                }
                field("Rejected Qty.";"Rejected Qty.")
                {
                }
                field("Order No.";"Order No.")
                {
                    Editable = false;
                }
                field("Order Line No.";"Order Line No.")
                {
                    Editable = false;
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    Editable = false;
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    Editable = false;
                }
                field("Item Category Code";"Item Category Code")
                {
                    Editable = false;
                }
                // field("Product Group Code";"Product Group Code")
                // {
                //     Editable = false;
                // }
                field(Paper;Paper)
                {
                }
                field("Paper Type";"Paper Type")
                {
                }
                field("Paper GSM";"Paper GSM")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Receipt")
            {
                CaptionML = ENU = '&Receipt';
                Image = Receipt;
            }
            action(Dimensions)
            {
                CaptionML = ENU = 'Dimensions';
                Image = Dimensions;
                ShortCutKey = 'Shift+Ctrl+D';

                trigger OnAction()
                begin
                    ShowDimensions;
                end;
            }
            action("Co&mments")
            {
                CaptionML = ENU = 'Co&mments';
                Image = ViewComments;

                trigger OnAction()
                begin
                    ShowLineComments;
                end;
            }
            action("Item Invoice &Lines")
            {
                CaptionML = ENU = 'Item Invoice &Lines';
                Image = ItemInvoice;

                trigger OnAction()
                begin
                    ShowItemPurchInvLines;
                end;
            }
        }
    }

    var
        Item: Record Item;

    procedure ShowTracking()
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        TrackingForm: Page "Order Tracking";
    begin
        TestField(Type,Type::Item);
        if "Item Rcpt. Entry No." <> 0 then begin
          ItemLedgEntry.Get("Item Rcpt. Entry No.");
          TrackingForm.SetItemLedgEntry(ItemLedgEntry);
        end else
          TrackingForm.SetMultipleItemLedgEntries(TempItemLedgEntry,
            DATABASE::"Purch. Rcpt. Line",0,"Document No.",'',0,"Line No.");

        TrackingForm.RunModal;
    end;

    procedure UndoReceiptLine()
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        PurchRcptLine.Copy(Rec);
        CurrPage.SetSelectionFilter(PurchRcptLine);
        CODEUNIT.Run(CODEUNIT::"Undo Purchase Receipt Line",PurchRcptLine);
    end;

    procedure ShowItemPurchInvLines()
    begin
        TestField(Type,Type::Item);
        ShowItemPurchInvLines;
    end;
}

