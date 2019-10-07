page 50157 "Sub Form Paper GSM"
{
    // version Prod. Schedule

    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Schedule Base Table 3";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Deckle Size"; "Deckle Size")
                {
                    StyleExpr = SetStyleFormat;
                }
                field("Paper Type"; "Paper Type")
                {
                    StyleExpr = SetStyleFormat;
                }
                field("Paper GSM"; "Paper GSM")
                {
                    StyleExpr = SetStyleFormat;
                }
                field("Available Inventory (kg)"; "Available Inventory (kg)")
                {
                    StyleExpr = SetStyleFormat;
                }
                field("Total Requirement (kg)"; "Total Requirement (kg)")
                {
                    StyleExpr = SetStyleFormat;
                }
                field("Item Exists"; "Item Exists")
                {
                    StyleExpr = SetStyleFormat;
                }
                field("Shortage Quantity"; "Shortage Quantity")
                {
                    CaptionML = ENU = 'Shortage Quantity';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Roll Detail")
            {
                RunObject = Page "Roll Details for Prod. Scdule";
                //RunPageLink = "Deckle Size (mm)"=FIELD("Deckle Size"),
                //              "Paper Type"=FIELD("Paper Type"),
                //              "Paper GSM"=FIELD("Paper GSM");
                RunPageView = SORTING (Code)
                              ORDER(Ascending);
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetStyleFormat := SetStyle;

        CalcFields("Available Inventory (kg)");
        "Shortage Quantity" := 0;
        if "Total Requirement (kg)" > "Available Inventory (kg)" then begin
            "Shortage Quantity" := "Available Inventory (kg)" - "Total Requirement (kg)";
            SetStyleFormat := 'Unfavorable';
        end;

        // Lines added BY Deepak Kumar
    end;

    var
        SetStyleFormat: Text;
        "Shortage Quantity": Decimal;

    procedure SetStyle(): Text
    begin
        // Lines added By Deepak Kumar

        if "Item Exists" = false then begin
            exit('Unfavorable');
        end;

        /*
           EXIT('Unfavorable');
          EXIT('StandardAccent');
          EXIT('Favorable');
           */

    end;
}

