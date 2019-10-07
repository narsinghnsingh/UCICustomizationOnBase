page 50169 "Prod. Order fact Box"
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Production Schedule Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Schedule No.";"Schedule No.")
                {
                }
                field("Schedule Date";"Schedule Date")
                {
                }
                field("Prod. Order Line No.";"Prod. Order Line No.")
                {
                }
                field("Quantity To Schedule";"Quantity To Schedule")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Actions")
            {
                CaptionML = ENU = 'Actions';
                Image = "Action";
            }
            action("Schedule Components")
            {
                CaptionML = ENU = 'Schedule Components';
                Image = BOM;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ProdOrderComp.SetRange("Prod. Order No.","Prod. Order No.");
                    ProdOrderComp.SetRange("Prod. Order Line No.","Prod. Order Line No.");
                    // Line added By Deepak Kumar
                    ProdOrderComp.SetRange(ProdOrderComp."Prod Schedule No.","Schedule No.");
                    ProdOrderComp.SetRange(ProdOrderComp."Schedule Component",true);
                    PAGE.Run(PAGE::"Prod. Order Components",ProdOrderComp);
                end;
            }
        }
    }

    var
        ProdOrderComp: Record "Prod. Order Component";
}

