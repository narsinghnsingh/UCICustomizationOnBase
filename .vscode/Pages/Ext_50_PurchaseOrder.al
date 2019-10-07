pageextension 50016 Ext_50_PurchaseOrder extends "Purchase Order"
{
    layout
    {
        // Add changes to page layout here
        addafter("No. of Archived Versions")
        {
            field("Posting No."; "Posting No.")
            {

            }

        }
        addafter("Job Queue Status")
        {
            field("VAT Registration No."; "VAT Registration No.")
            {
                Editable = false;
            }
        }
        addafter("Pmt. Discount Date")
        {
            field("LC No."; "LC No.")
            {

            }
        }
        addafter(Prepayment)
        {
            group(Requisition)
            {
                CaptionML = ENU = 'Requisition';

                field("Requisition No."; "Requisition No.")
                {
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
            }

        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("F&unctions")
        {
            action("Short Close")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Close;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    // Lines added By Deepak Kumar
                    ShortCloseDocument("Document Type"::Order, "No.");
                end;
            }
        }
        addafter(MoveNegativeLines)
        {
            action("Get Requisition Line")
            {
                ApplicationArea = All;
                Promoted = true;
                Image = RefreshLines;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    // Lines added BY Deepak Kumar
                    GetReqLine(Rec);
                end;
            }
            action("Update PO")
            {
                //Visible = false;
                ApplicationArea = All;
                Promoted = true;
                Image = PostedPayableVoucher;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    PurchLine: Record "Purchase Line";
                    PurchRcptLine: Record "Purch. Rcpt. Line";
                    PRQty: Decimal;
                    PRQtyRcvNInv: Decimal;
                    Currency: Record Currency;
                begin
                    IF Currency.GET("Currency Code") THEN;
                    PurchLine.reset;
                    PurchLine.SetRange("Document Type", "Document Type");
                    PurchLine.SetRange("Document No.", "No.");
                    PurchLine.SetRange("For Location Roll Entry", PurchLine."For Location Roll Entry"::Mother);
                    if PurchLine.FindSet then
                        repeat
                            PRQty := 0;
                            PRQtyRcvNInv := 0;
                            PurchRcptLine.Reset();
                            PurchRcptLine.SetRange("Order No.", PurchLine."Document No.");
                            PurchRcptLine.SetRange("No.", PurchLine."No.");
                            PurchRcptLine.Setfilter(Quantity, '<>%1', 0);
                            if PurchRcptLine.FindSet then
                                repeat
                                    PRQty += PurchRcptLine.Quantity;
                                    PRQtyRcvNInv += PurchRcptLine."Qty. Rcd. Not Invoiced";
                                until PurchRcptLine.Next = 0;
                            PurchLine."Quantity Received" := PRQty;
                            PurchLine."Qty. Received (Base)" := PRQty;
                            PurchLine."Outstanding Quantity" := PurchLine.Quantity - PurchLine."Quantity Received";
                            PurchLine."Outstanding Qty. (Base)" := PurchLine.Quantity - PurchLine."Quantity Received";
                            PurchLine."Qty. Rcd. Not Invoiced" := PRQtyRcvNInv;
                            PurchLine."Qty. Rcd. Not Invoiced (Base)" := PRQtyRcvNInv;
                            PurchLine.VALIDATE("Outstanding Amount",
                                ROUND(
                                PurchLine."Amount Including VAT" * PurchLine."Outstanding Quantity" / PurchLine.Quantity,
                                Currency."Amount Rounding Precision"));
                            PurchLine.VALIDATE("Amt. Rcd. Not Invoiced",
                            ROUND(
                                PurchLine."Amount Including VAT" * PurchLine."Qty. Rcd. Not Invoiced" / PurchLine.Quantity,
                                Currency."Amount Rounding Precision"));
                            PurchLine.MODIFY(TRUE);
                        until PurchLine.Next = 0;
                    Message('Done');
                END;
            }
        }
        addbefore("Prepa&yment")
        {
            action("Roll Label Print")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = LogSetup;
                trigger OnAction()
                begin
                    ItemVariant.RESET;
                    ItemVariant.SETCURRENTKEY(ItemVariant."Document No.");
                    ItemVariant.SETRANGE(ItemVariant."Document No.", "No.");
                    RollLebel.SETTABLEVIEW(ItemVariant);
                    RollLebel.RUN;
                end;
            }
        }
    }

    var

        RollLebel: Report 50005;
        ItemVariant: Record "Item Variant";

}