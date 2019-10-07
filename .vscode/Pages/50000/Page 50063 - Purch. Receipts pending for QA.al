page 50063 "Purch. Receipts pending for QA"
{
    // version Samadhan Quality

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    RefreshOnActivate = true;
    SourceTable = "Purch. Rcpt. Line";
    SourceTableView = SORTING ("Document No.", "Line No.")
                      ORDER(Ascending)
                      WHERE (Type = CONST (Item),
                            "QA Enabled" = CONST (true),
                            "QA Processed" = CONST (false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; "Posting Date")
                {
                    Editable = false;
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    Editable = false;
                }
                field("Document No."; "Document No.")
                {
                    Editable = false;
                }
                field("Line No."; "Line No.")
                {
                    Editable = false;
                }
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("Location Code"; "Location Code")
                {
                    Editable = false;
                }
                field("Expected Receipt Date"; "Expected Receipt Date")
                {
                    Editable = false;
                }
                field("Roll Quality Entered"; "Roll Quality Entered")
                {
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Editable = false;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                }
                field("Accepted Qty."; "Accepted Qty.")
                {

                    trigger OnValidate()
                    begin
                        Item.Get("No.");
                        if Item."Roll ID Applicable" then
                            Error('Please enter Quantity in Roll Master');
                    end;
                }
                field("Rejected Qty."; "Rejected Qty.")
                {
                }
                field("Order No."; "Order No.")
                {
                    Editable = false;
                }
                field("Order Line No."; "Order Line No.")
                {
                    Editable = false;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    Editable = false;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    Editable = false;
                }
                field("Item Category Code"; "Item Category Code")
                {
                    Editable = false;
                }
                // field("Product Group Code";"Product Group Code")
                // {
                //     Editable = false;
                // }
                field("Paper Type"; "Paper Type")
                {
                }
                field("Paper GSM"; "Paper GSM")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Quality Lines")
            {
                Image = SalesPurchaseTeam;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Insp. Sheet Purchase";
                RunPageLink = "Source Type" = FILTER ("Purchase Receipt"),
                              "Source Document No." = FIELD (FILTER ("Document No.")),
                              "Source Document Line No." = FIELD (FILTER ("Line No.")),
                              "Item No." = FIELD (FILTER ("No."));
                RunPageView = SORTING ("Entry No.")
                              ORDER(Ascending);
            }
            action("Roll Entry QA")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Item Variants";
                RunPageLink = "Purchase Receipt No." = FIELD ("Document No."),
                              "Purch. Receipt Line No." = FIELD ("Line No.");
                RunPageView = SORTING ("Item No.", Code)
                              ORDER(Ascending)
                              WHERE (Status = CONST (PendingforQA));
            }
            action(Post)
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //SETFILTER("Quality Entered",'=%1',TRUE);
                    TestField("Roll Quality Entered");

                    if not FindFirst then
                        Error('No Purchase Receipt Lines with Quality data entered is available');
                    repeat
                        PurchInspPost.Run(Rec);
                    until Next = 0;
                end;
            }
        }
    }

    var
        PurchInspPost: Codeunit "Purch. Inspection Post N";
        Item: Record Item;
}

