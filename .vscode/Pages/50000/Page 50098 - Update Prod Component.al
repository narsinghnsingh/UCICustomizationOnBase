page 50098 "Update Prod Component"
{
    // version Samadhan|DK

    CaptionML = ENU = 'Update Production Components';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    ShowFilter = false;
    SourceTable = "Production Order";
    SourceTableView = WHERE (Status = CONST (Released));

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General';
                field("No."; "No.")
                {
                    Editable = false;
                    Importance = Promoted;
                    Lookup = false;

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field(Description; Description)
                {
                    Editable = false;
                    Importance = Promoted;
                    QuickEntry = false;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Schedule No."; "Schedule No.")
                {
                    Importance = Promoted;
                }
                field("Requisition No."; "Requisition No.")
                {
                    Importance = Promoted;
                }
                part(ProdOrderLines; "Released Prod. Order Lines")
                {
                    Editable = false;
                    SubPageLink = "Prod. Order No." = FIELD ("No.");
                }
            }
            group("Update Production Components")
            {
                CaptionML = ENU = 'Update Production Components';
                part(AllComponets; "Prod. Order Components New")
                {
                    Provider = ProdOrderLines;
                    SubPageLink = Status = FIELD (Status),
                                  "Prod. Order No." = FIELD ("Prod. Order No."),
                                  "Prod. Order Line No." = FIELD ("Line No.");
                }
            }
        }
    }

    actions
    {
    }

    var
        CopyProdOrderDoc: Report "Copy Production Order Document";
        ManuPrintReport: Codeunit "Manu. Print Report";
        Text000: Label 'Inbound Whse. Requests are created.';
        Text001: Label 'No Inbound Whse. Request is created.';
        Text002: Label 'Inbound Whse. Requests have already been created.';

    trigger OnOpenPage()
    begin
        "Schedule No." := '';
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.ProdOrderLines.PAGE.UpdateForm(true);
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.ProdOrderLines.PAGE.UpdateForm(true);
    end;
}

