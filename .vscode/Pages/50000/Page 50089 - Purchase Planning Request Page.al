page 50089 "Purchase Planning Request Page"
{
    // version Samadhan Purchase Planing

    PageType = StandardDialog;
    SourceTable = "Planning Line Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group("Purchase Planning Request Page")
            {
                field("Item Category Code";"Item Category Code")
                {
                }
                field("Prod. Group Code";"Prod. Group Code")
                {
                }
                field("Suggest Quantity to Order";"Suggest Quantity to Order")
                {
                }
                field("Calculate Sales Requirement";"Calculate Sales Requirement")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          "Worksheet Template Name":='req.';
          "Journal Batch Name":='Default';
          Insert;
        end;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        // Lines added BY Deepak kumar
        ExitType:=Format(CloseAction);
        if ExitType = 'OK' then
          RequistionLine.CalcPlan("Worksheet Template Name","Journal Batch Name","Item Category Code","Prod. Group Code","Suggest Quantity to Order","Calculate Sales Requirement");
    end;

    var
        ExitType: Text[20];
        RequistionLine: Record "Requisition Line";
}

