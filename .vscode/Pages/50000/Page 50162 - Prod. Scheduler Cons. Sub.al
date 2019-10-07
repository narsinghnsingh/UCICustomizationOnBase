page 50162 "Prod. Scheduler Cons. Sub"
{
    // version Prod. Schedule

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Cons. Prod. Order Selection";
    SourceTableView = SORTING("Marked for Consumption Post")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line Counter";"Line Counter")
                {
                }
                field("Item Code";"Item Code")
                {
                    Visible = false;
                }
                field("Variant Code/ Reel Number";"Variant Code/ Reel Number")
                {
                    Visible = false;
                }
                field("Paper Position";"Paper Position")
                {
                    StyleExpr = ProdExtraConsumption;
                }
                field("Supplementary Line";"Supplementary Line")
                {
                }
                field("Prod. Order No.";"Prod. Order No.")
                {
                    StyleExpr = ProdExtraConsumption;
                }
                field("No. Of Ply";"No. Of Ply")
                {
                }
                field("Prod. Order Line No";"Prod. Order Line No")
                {
                    StyleExpr = ProdExtraConsumption;
                }
                field("Actual Output Quantity";"Actual Output Quantity")
                {
                    StyleExpr = ProdExtraConsumption;
                }
                field("Expected Consumption";"Expected Consumption")
                {
                    StyleExpr = ProdExtraConsumption;
                }
                field("Abs(""Posted Consumption"")";Abs("Posted Consumption"))
                {
                    CaptionML = ENU = '"Posted Consumption(Kg)"';
                    StyleExpr = ProdExtraConsumption;
                }
                field("Marked for Consumption Post";"Marked for Consumption Post")
                {
                    StyleExpr = ProdExtraConsumption;
                }
                field("Quantity Per";"Quantity Per")
                {
                    StyleExpr = ProdExtraConsumption;
                }
                field("Consumption Ratio";"Consumption Ratio")
                {
                    CaptionML = ENU = 'Consumption Ratio %';
                    StyleExpr = ProdExtraConsumption;
                }
                field("Qty to be Post";"Qty to be Post")
                {
                    CaptionML = ENU = 'Qty to be Posted(Kg)';
                    StyleExpr = ProdExtraConsumption;
                }
                field("Cumulative Quantity to Post";"Cumulative Quantity to Post")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Total Exp. Consumption";"Total Exp. Consumption")
                {
                }
                field("Extra Consumtpion Quantity";"Extra Consumtpion Quantity")
                {
                    StyleExpr = ProdExtraConsumption;
                }
                field("Extra Consumtion Variation(%)";"Extra Consumtion Variation(%)")
                {
                    StyleExpr = ProdExtraConsumption;
                }
                field("Extra Quantity Approval";"Extra Quantity Approval")
                {
                    StyleExpr = ProdExtraConsumption;
                }
                field("Extra Quantity Approved By";"Extra Quantity Approved By")
                {
                    StyleExpr = ProdExtraConsumption;
                }
                field("Paper Position(Item)";"Paper Position(Item)")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin

        // Lines added BY Deepak Kumar
        if "Extra Consumtion Variation(%)" > 0 then
          ProdExtraConsumption:='Unfavorable'
        else
          ProdExtraConsumption:='';
    end;

    var
        ProdExtraConsumption: Text;
        FilterDes: Text;
}

