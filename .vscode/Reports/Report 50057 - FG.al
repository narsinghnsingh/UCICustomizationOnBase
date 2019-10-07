report 50057 FG
{
    Caption = 'FG';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = SORTING (Status, "No.") ORDER(Ascending);
            RequestFilterFields = "Source No.";
            column(SourceNo_ProductionOrder; "Production Order"."Source No.")
            {
            }
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = "Prod. Order No." = FIELD ("No.");
                column(ProdOrderNo_ProdOrderLine; "Prod. Order Line"."Prod. Order No.")
                {
                }
                column(Description_ProdOrderLine; "Prod. Order Line".Description)
                {
                }
                column(UnitofMeasureCode_ProdOrderLine; "Prod. Order Line"."Unit of Measure Code")
                {
                }
                column(ProductDesignNo_ProdOrderLine; "Prod. Order Line"."Product Design No.")
                {
                }
                column(Quantity_ProdOrderLine; "Prod. Order Line".Quantity)
                {
                }
                dataitem("Prod. Order Component"; "Prod. Order Component")
                {
                    DataItemLink = "Prod. Order No." = FIELD ("Prod. Order No."), "Prod. Order Line No." = FIELD ("Line No.");
                    column(ProductDesignType_ProdOrderComponent; "Prod. Order Component"."Product Design Type")
                    {
                    }
                    column(ItemNo_ProdOrderComponent; "Prod. Order Component"."Item No.")
                    {
                    }
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
}

