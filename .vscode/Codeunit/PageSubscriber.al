codeunit 50014 PageSubscriber
{
    [EventSubscriber(ObjectType::Page, Page::"Released Production Order", 'OnBeforeActionEvent', 'Change &Status', false, false)]
    local procedure RPO_OnBeforeActionEvent(VAR Rec: Record "Production Order")
    var
        ProdOrderStatusMgt: Codeunit "Prod. Order Status Management";
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgerEntries: Page "Item Ledger Entries";
    begin
        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetRange("Order Type", ItemLedgerEntry."Order Type"::Production);
        ItemLedgerEntry.SetRange("Order No.", Rec."No.");
        if ItemLedgerEntry.FindSet then begin
            Clear(ItemLedgerEntries);
            ItemLedgerEntries.SetTableView(ItemLedgerEntry);
            ItemLedgerEntries.SetRecord(ItemLedgerEntry);
            if ItemLedgerEntries.RunModal = ACTION::OK then begin

            end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnAfterActionEvent', 'Reopen', false, false)]
    local procedure Page42_Reopen(VAR Rec: Record "Sales Header")
    var
        salesorder: Page "Sales Order";
    begin
        if Rec.Status = Rec.Status::Open then begin
            salesorder.SetRecord(Rec);
            salesorder.Editable := True;
            salesorder.Update();
        end else
            salesorder.Editable := false;
    END;

    [EventSubscriber(ObjectType::Page, Page::"Customer Card", 'OnBeforeActionEvent', 'SendApprovalRequest', false, false)]
    local procedure Page21_SendApprovalRequest(VAR Rec: Record Customer)
    begin
        with Rec do begin
            TESTFIELD(Name);
            TESTFIELD("Credit Limit (LCY)");
            TESTFIELD("Salesperson Code");
            TESTFIELD("Customer Segment");
            TESTFIELD(Address);
            TESTFIELD(City);
            TESTFIELD("Post code");
            TESTFIELD("Country/Region Code");
            TESTFIELD("Name");
            TESTFIELD("Phone No.");
            TESTFIELD("E-Mail");
            TESTFIELD("Trade License No.");
            TESTFIELD("Payment Terms Code");
            TESTFIELD("Location Code");
            TESTFIELD("Gen. Bus. Posting Group");
            TESTFIELD("VAT Bus. Posting Group");
            TESTFIELD("Customer Posting Group");
            TestField("Expiry Date of Trade Lic");
        end;
    end;
}