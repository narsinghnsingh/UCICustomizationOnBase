page 50171 "LPO Detail for Production"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Sales Line";
    SourceTableView = SORTING ("Document Type", "Document No.", "Line No.")
                      ORDER(Ascending)
                      WHERE ("Document Type" = CONST (Order),
                            Quantity = FILTER (<> 0),
                            "Outstanding Quantity" = FILTER (<> 0));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; "Document No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Outstanding Quantity"; "Outstanding Quantity")
                {
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                }
                field("External Doc. No."; "External Doc. No.")
                {
                    CaptionML = ENU = 'LPO Number';
                }
                field("Cust. Name"; "Cust. Name")
                {
                }
                field("Estimation No."; "Estimation No.")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control27; "Sales Comment Sheet ListPart")
            {
                SubPageLink = "No." = FIELD ("Document No.");
                Visible = true;
            }
            systempart(Control17; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("LPO Copy")
            {
                Image = SendElectronicDocument;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Sales Order Scan Copy";
                RunPageLink = "Document Type" = FIELD ("Document Type"),
                              "No." = FIELD ("Document No.");
            }
        }
    }
}

