page 50015 "Eastimate Sales Line Details"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    ShowFilter = false;
    SourceTable = "Sales Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; "Document No.")
                {
                    StyleExpr = StyleTxt;
                }
                field("No."; "No.")
                {
                    StyleExpr = StyleTxt;
                }
                field("Location Code"; "Location Code")
                {
                    StyleExpr = StyleTxt;
                }
                field(Description; Description)
                {
                    StyleExpr = StyleTxt;
                }
                field("Description 2"; "Description 2")
                {
                    StyleExpr = StyleTxt;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    StyleExpr = StyleTxt;
                }
                field(Quantity; Quantity)
                {
                    StyleExpr = StyleTxt;
                }
                field("Outstanding Quantity"; "Outstanding Quantity")
                {
                    StyleExpr = StyleTxt;
                }
                field("Quantity Shipped"; "Quantity Shipped")
                {
                }
                field("Unit Price"; "Unit Price")
                {
                    StyleExpr = StyleTxt;
                }
                field("Estimation No."; "Estimation No.")
                {
                    StyleExpr = StyleTxt;
                }
                field("Estimate Price"; "Estimate Price")
                {
                    StyleExpr = StyleTxt;
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                    StyleExpr = StyleTxt;
                }
                field("Prod. Order Line No."; "Prod. Order Line No.")
                {
                    StyleExpr = StyleTxt;
                }
                field("Line Amount"; "Line Amount")
                {
                    StyleExpr = StyleTxt;
                }
                field("Cust. Name"; "Cust. Name")
                {
                    StyleExpr = StyleTxt;
                }
                field("Profit Margin Per unit"; "Profit Margin Per unit")
                {
                    StyleExpr = StyleTxt;
                }
                field("Profit Margin %"; "Profit Margin %")
                {
                    StyleExpr = StyleTxt;
                }
                field("Order Quantity (Weight)"; "Order Quantity (Weight)")
                {
                    CaptionML = ENU = 'Order Quantity (Weight in KG)';
                }
                field("Outstanding  Quantity (Weight)"; "Outstanding  Quantity (Weight)")
                {
                    CaptionML = ENU = 'Outstanding  Quantity (Weight In KG)';
                }
                field("Gross Weight"; "Gross Weight")
                {
                    CaptionML = ENU = 'Gross Weight (in Gm)';
                }
                field("Net Weight"; "Net Weight")
                {
                    CaptionML = ENU = 'Net Weight (in Gm)';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Card)
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // Lines added bY Deepak Kumar
                    if "Document Type" = "Document Type"::Quote then begin
                        SaleHeader.Reset;
                        SaleHeader.SetRange(SaleHeader."Document Type", SaleHeader."Document Type"::Quote);
                        SaleHeader.SetRange(SaleHeader."No.", "Document No.");
                        SalesQuotepage.SetTableView(SaleHeader);
                        SalesQuotepage.Run;

                    end;

                    if "Document Type" = "Document Type"::Order then begin
                        SaleHeader.Reset;
                        SaleHeader.SetRange(SaleHeader."Document Type", SaleHeader."Document Type"::Order);
                        SaleHeader.SetRange(SaleHeader."No.", "Document No.");
                        SalesOrderPage.SetTableView(SaleHeader);
                        SalesOrderPage.Run;

                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //Deepak
        StyleTxt := SetStyle;
    end;

    var
        SaleHeader: Record "Sales Header";
        SalesQuotepage: Page "Sales Quote";
        SalesOrderPage: Page "Sales Order";
        "Customer Name": Text[150];
        StyleTxt: Text;

    procedure SetStyle(): Text
    begin
        // Lines added By Deepak Kumar
        if "Profit Margin %" < 0 then
            exit('unFavorable');

        if ("Profit Margin %" > 0) and ("Profit Margin %" <= 10) then
            exit('Strong');

        if ("Profit Margin %" > 10) and ("Profit Margin %" <= 20) then
            exit('StrongAccent');

        if ("Profit Margin %" > 20) then
            exit('Favorable');










    end;
}

