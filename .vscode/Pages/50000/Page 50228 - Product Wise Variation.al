page 50228 "Product Wise Variation "
{
    // version Prod. Variation

    Caption = 'Product Wise Variation ';
    PageType = Worksheet;
    SourceTable = "Production Variation Report";

    layout
    {
        area(content)
        {
            field("From Date"; "From Date")
            {
            }
            field("To Date"; "To Date")
            {
            }
            repeater(Control23)
            {
                Editable = false;
                ShowCaption = false;
                field("Prod. Order No."; "Prod. Order No.")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Prod. Order Line No."; "Prod. Order Line No.")
                {
                    StyleExpr = TRUE;
                }
                field("Item Code"; "Item Code")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("LPO No."; "LPO No.")
                {
                }
                field("Order Quantity"; "Order Quantity")
                {
                }
                field("Board Order Quantity"; "Board Order Quantity")
                {
                }
                field("Finished Order Quantity"; "Finished Order Quantity")
                {
                }
                field("Variation in Produces Quantity"; "Variation in Produces Quantity")
                {
                    StyleExpr = ProdQtyVariation;
                }
                field("Customer Code"; "Customer Code")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Product Design Type"; "Product Design Type")
                {
                    Visible = false;
                }
                field("Product Design No."; "Product Design No.")
                {
                }
                field("Sub Comp No."; "Sub Comp No.")
                {
                    Visible = false;
                }
                field("Job Creation Date"; "Job Creation Date")
                {
                }
                field("Customer Weight (Kg)"; "Customer Weight (Kg)")
                {
                }
                field("Planed Weight (Kg)"; "Planed Weight (Kg)")
                {
                }
                field("Actual Weight (Kg)"; "Actual Weight (Kg)")
                {
                }
                field("Variation Planed vs Actual (%)"; "Variation Planed vs Actual (%)")
                {
                    StyleExpr = ProdWeightVariation;
                }
                field("Planed Cost Process (Amt)"; "Planed Cost Process (Amt)")
                {
                }
                field("Planed Cost Material (Amt)"; "Planed Cost Material (Amt)")
                {
                }
                field("Actual Cost Process (Amt)"; "Actual Cost Process (Amt)")
                {
                }
                field("Actual Cost Material (Amt)"; "Actual Cost Material (Amt)")
                {
                }
                field("Variation in Cost (%)"; "Variation in Cost (%)")
                {
                    StyleExpr = ProdCostVariation;
                }
                field("Scrap Weight (Kg)"; "Scrap Weight (Kg)")
                {
                    StyleExpr = ScrapFormat;
                }
                field("Scrap Quantity"; "Scrap Quantity")
                {
                    StyleExpr = ScrapFormat;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calculate Details")
            {
                Caption = 'Calculate Details';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added By Deepak Kumar
                    TestField("To Date");
                    TestField("From Date");
                    ProductionOrder.Reset;
                    ProductionOrder.SetRange(ProductionOrder."Creation Date", "From Date", "To Date");
                    //ProductionOrder.SETRANGE(ProductionOrder.Status,ProductionOrder.Status::Finished);
                    if ProductionOrder.FindFirst then begin
                        ProgressWindow.Open('Production Order No. #1#######');
                        repeat
                            ProgressWindow.Update(1, ProductionOrder."No.");
                            ProdVariationCalculation.OrderWiseVariationDetails(ProductionOrder);
                        until ProductionOrder.Next = 0;
                        ProgressWindow.Close;
                        Message('Complete');
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // Lines added by Deepak Kumar
        if "Variation in Produces Quantity" > 0 then
            ProdQtyVariation := 'Unfavorable'
        else
            ProdQtyVariation := '';

        if "Variation Planed vs Actual (%)" > 0 then
            ProdWeightVariation := 'Unfavorable'
        else
            ProdWeightVariation := '';

        if "Variation in Cost (%)" > 0 then
            ProdCostVariation := 'Unfavorable'
        else
            ProdCostVariation := '';

        if "Variation in Produces Quantity" < -10 then
            ProdQtyVariation := 'AttentionAccent';

        if "Variation Planed vs Actual (%)" < -10 then
            ProdWeightVariation := 'AttentionAccent';

        if "Variation in Cost (%)" < -10 then
            ProdCostVariation := 'AttentionAccent';

        if "Scrap Weight (Kg)" > 0 then
            ScrapFormat := 'Unfavorable'
        else
            ScrapFormat := '';
    end;

    var
        ProdVariationCalculation: Codeunit "Prod.Variation Calculation";
        ProductionOrder: Record "Production Order";
        ProdQtyVariation: Text;
        ProdWeightVariation: Text;
        ProdCostVariation: Text;
        ScrapFormat: Text;
        ProgressWindow: Dialog;
}

