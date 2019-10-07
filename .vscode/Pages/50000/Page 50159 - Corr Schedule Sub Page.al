page 50159 "Corr Schedule Sub Page"
{
    // version Prod. Schedule

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Production Schedule Line";
    SourceTableView = SORTING("Schedule No.","No. Of Ply",Flute,"GSM Identifier")
                      ORDER(Ascending)
                      WHERE("Schedule Line"=CONST(true));

    layout
    {
        area(content)
        {
            repeater(Control24)
            {
                ShowCaption = false;
                field("FG GSM";"FG GSM")
                {
                }
                field("Schedule No.";"Schedule No.")
                {
                }
                field("No. Of Ply";"No. Of Ply")
                {
                }
                field(Flute;Flute)
                {
                }
                field("GSM Identifier";"GSM Identifier")
                {
                }
                field("Customer Name";"Customer Name")
                {
                }
                field("Item Code";"Item Code")
                {
                }
                field("Item Description";"Item Description")
                {
                }
                field("Quantity To Schedule";"Quantity To Schedule")
                {
                }
                field("RPO Finished Quantity";"RPO Finished Quantity")
                {
                }
                field("RPO Remaining Quantity";"RPO Remaining Quantity")
                {
                }
                field("Available Quantity to Schedule";"Available Quantity to Schedule")
                {
                }
                field("Quantity in Other Schedules";"Quantity in Other Schedules")
                {
                }
                field("Prod. Order No.";"Prod. Order No.")
                {
                }
                field("Board Width(mm)";"Board Width(mm)")
                {
                }
                field("Prod. Order Quanity";"Prod. Order Quanity")
                {
                }
                field("Prod. Order Line No.";"Prod. Order Line No.")
                {
                }
                field("Requested Delivery Date";"Requested Delivery Date")
                {
                }
                field("Planned Deckle Size(mm)";"Planned Deckle Size(mm)")
                {
                }
                field("Deckle Size Schedule(mm)";"Deckle Size Schedule(mm)")
                {
                }
                field("Top Colour";"Top Colour")
                {
                }
                field("Priority By System";"Priority By System")
                {
                }
                field("Product Design No.";"Product Design No.")
                {
                }
                field("Estimation Sub Job No.";"Estimation Sub Job No.")
                {
                }
                field("Modified Priority";"Modified Priority")
                {

                    trigger OnValidate()
                    var
                        TempProdLine: Record "Production Schedule Line";
                    begin
                        // Lines added bY Deepak Kumar
                        if xRec."Modified Priority" = "Modified Priority" then
                          exit;
                        TempProdLine.Reset;
                        TempProdLine.SetRange(TempProdLine."Schedule No.","Schedule No.");
                        TempProdLine.SetRange(TempProdLine."Deckle Size Schedule(mm)","Deckle Size Schedule(mm)");
                        TempProdLine.SetRange(TempProdLine."Modified Priority","Modified Priority");
                        if TempProdLine.FindFirst then begin
                          TempProdLine."Modified Priority":=xRec."Modified Priority";
                          TempProdLine.Modify(true);
                        end;

                    end;
                }
                field("Trim (mm)";"Trim (mm)")
                {
                }
                field("Trim Weight";"Trim Weight")
                {
                }
                field("Extra Trim(mm)";"Extra Trim(mm)")
                {
                }
                field("Extra Trim Weight";"Extra Trim Weight")
                {
                }
                field("Trim %";"Trim %")
                {
                    CaptionML = ENU = 'Total Trim %';
                }
                field("Linear Length(Mtr)";"Linear Length(Mtr)")
                {
                }
                field("Calculated No. of Ups";"Calculated No. of Ups")
                {
                }
                field("No. of Ups (Estimated)";"No. of Ups (Estimated)")
                {
                }
                field("Marked for Publication";"Marked for Publication")
                {

                    trigger OnValidate()
                    begin
                        // lines added By Deepak Kumar

                        if "Marked for Publication" = true then
                          "Force Schedule by":=UserId
                        else
                          "Force Schedule by":='';
                    end;
                }
                field("Force Schedule by";"Force Schedule by")
                {
                }
                field("Ideal Deckle Size";"Ideal Deckle Size")
                {
                }
                field("Qty to Schedule Net Weight";"Qty to Schedule Net Weight")
                {
                }
                field("Qty to Schedule M2 Weight";"Qty to Schedule M2 Weight")
                {
                }
                field("Box Quantity to Schedule";"Box Quantity to Schedule")
                {
                }
            }
        }
    }

    actions
    {
    }
}

