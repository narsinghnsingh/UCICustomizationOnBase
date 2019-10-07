page 50106 "Work Center Status"
{
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Work Center";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("No."; "No.")
                {
                }
                field(Name; Name)
                {
                }
            }
            part(Control1000000006; "Work Cen Process Stat ListPart")
            {
                SubPageLink = "Work Center No." = FIELD ("No.");
                SubPageView = SORTING (Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.")
                              ORDER(Ascending)
                              WHERE (Status = CONST (Released));
            }
        }
        area(factboxes)
        {
            part(Control1000000005; "Production Status")
            {
                Provider = Control1000000006;
                SubPageLink = Status = FIELD (Status),
                              "No." = FIELD ("Prod. Order No.");
                SubPageView = SORTING (Status, "No.")
                              ORDER(Ascending);
            }
        }
    }

    actions
    {
    }
}

