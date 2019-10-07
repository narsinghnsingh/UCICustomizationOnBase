page 50080 "Issue List"
{
    // version Saamdhan Issue List

    CardPageID = "Issue Card";
    DeleteAllowed = false;
    InsertAllowed = true;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Issue Log";
    SourceTableView = SORTING ("Issue Type", "No.", Code)
                      ORDER(Ascending)
                      WHERE ("Issue Type" = CONST (Internal));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Code)
                {
                }
                field("Issue Title"; "Issue Title")
                {
                }
                field(Description; Description)
                {
                }
                field("Open by"; "Open by")
                {
                }
                field("Open Date"; "Open Date")
                {
                }
                field(Department; Department)
                {
                }
                field(Status; Status)
                {
                }
                field(Closed; Closed)
                {
                }
                field(Priority; Priority)
                {
                }
            }
        }
    }

    actions
    {
    }
}

