codeunit 50006 "Letter of Credit"
{
    // version LC Detail


    trigger OnRun()
    begin
    end;

    var
        LCADetails: Record "LC Amended Details";
        Text13700: Label 'Do you want to Release?';
        Text13701: Label 'The LC has been Released.';
        Text13702: Label 'The LC is already Released.';
        Text13703: Label 'Do you want to Amend this Document ?';
        Text13704: Label 'Without releasing the previous amendment you cannot Amend again.';
        Text13705: Label 'You cannot Amended without releasing the document.';
        Text13706: Label 'Cannot Amend LC %1. Status is closed.';
        Text13707: Label 'The LC has been closed.';
        Text13708: Label 'The LC is already closed.';
        Text13709: Label 'Do you want to close LC ?';
        LCADetails1: Record "LC Amended Details";
        LCAmendedDetails: Page "LC Amended Details";
        Text13710: Label 'The LC Amendment has been Released.';
        Text50006: Label 'The LC Amendment is already Released.';
        Text13712: Label 'Do you want to Release Amendment?';

    procedure LCRelease(LCDetail: Record "LC Detail")
    begin
        with LCDetail do begin
            if Confirm(Text13700) then
                if not Released then begin
                    TestField("LC Value");
                    TestField("LC No.");
                    TestField("Expiry Date");
                    Validate("LC Value");
                    if "Type of LC" = "Type of LC"::Foreign then
                        TestField("Currency Code");
                    if "Type of Credit Limit" = "Type of Credit Limit"::Revolving then
                        TestField("Revolving Cr. Limit Types");
                    Released := true;
                    Modify;
                    //LCTerms.SETRANGE("LC No.","No.");
                    //IF LCTerms.FINDFIRST THEN BEGIN
                    //  LCTerms.Released := TRUE;
                    //  LCTerms.MODIFY;
                    //END;
                    Message(Text13701);
                end else
                    Message(Text13702)
            else
                exit;
        end;
    end;

    procedure LCAmendments(LCDetail: Record "LC Detail")
    begin
        with LCDetail do begin
            if Released then begin
                Clear(LCAmendedDetails);
                if Closed then
                    Error(Text13706, "LC No.");
                if Confirm(Text13703) then begin
                    LCADetails.SetRange("LC No.", "No.");
                    if not LCADetails.Find('-') then begin
                        LCADetails1.Init;
                        LCADetails1."No." := '';
                        LCADetails1."LC No." := "No.";
                        LCADetails1.Insert(true);
                        LCADetails1.Description := Description;
                        LCADetails1."Transaction Type" := "Transaction Type";
                        LCADetails1."Issued To/Received From" := "Issued To/Received From";
                        LCADetails1."Issuing Bank" := "Issuing Bank";
                        LCADetails1."Date of Issue" := "Date of Issue";
                        LCADetails1."Expiry Date" := "Expiry Date";
                        LCADetails1."Type of LC" := "Type of LC";
                        LCADetails1."Type of Credit Limit" := "Type of Credit Limit";
                        LCADetails1."Revolving Cr. Limit Types" := "Revolving Cr. Limit Types";
                        LCADetails1."Currency Code" := "Currency Code";
                        LCADetails1."Previous LC Value" := "LC Value";
                        LCADetails1."Previous Expiry Date" := "Expiry Date";
                        LCADetails1."LC Value" := "LC Value";
                        LCADetails1."Exchange Rate" := "Exchange Rate";
                        LCADetails1."LC Value LCY" := "LC Value LCY";
                        LCADetails1."LC Amended Date" := WorkDate;
                        LCADetails1."Bank LC No." := "LC No.";
                        LCADetails1."Receiving Bank" := "Receiving Bank";
                        LCADetails1.Modify;
                        Commit;
                    end else begin
                        LCADetails.Find('+');
                        if not LCADetails.Released then
                            Error(Text13704);
                        LCADetails1.Init;
                        LCADetails1."No." := '';
                        LCADetails1."LC No." := LCADetails."LC No.";
                        LCADetails1.Insert(true);
                        LCADetails1.Description := LCADetails.Description;
                        LCADetails1."Transaction Type" := LCADetails."Transaction Type";
                        LCADetails1."Issued To/Received From" := LCADetails."Issued To/Received From";
                        LCADetails1."Issuing Bank" := LCADetails."Issuing Bank";
                        LCADetails1."Date of Issue" := LCADetails."Date of Issue";
                        LCADetails1."Expiry Date" := LCADetails."Expiry Date";
                        LCADetails1."Type of Credit Limit" := LCADetails."Type of Credit Limit";
                        LCADetails1."Type of LC" := LCADetails."Type of LC";
                        LCADetails1."Currency Code" := LCADetails."Currency Code";
                        LCADetails1."LC Value" := LCADetails."LC Value";
                        LCADetails1."Previous LC Value" := LCADetails."LC Value";
                        LCADetails1."Previous Expiry Date" := LCADetails."Expiry Date";
                        LCADetails1."Exchange Rate" := LCADetails."Exchange Rate";
                        LCADetails1."LC Value LCY" := LCADetails."LC Value LCY";
                        LCADetails1."LC Amended Date" := WorkDate;
                        LCADetails1."Bank LC No." := "LC No.";
                        LCADetails1."Receiving Bank" := LCADetails."Receiving Bank";
                        LCADetails1.Modify;
                        Commit;
                    end;
                    LCAmendedDetails.SetTableView(LCADetails1);
                    LCAmendedDetails.SetRecord(LCADetails1);
                    LCAmendedDetails.LookupMode(true);
                    if LCAmendedDetails.RunModal = ACTION::LookupOK then begin
                        LCAmendedDetails.GetRecord(LCADetails1);
                        Clear(LCAmendedDetails);
                    end;
                end else
                    exit;
            end else
                Message(Text13705);
        end;
    end;

    procedure LCClose(LCDetail: Record "LC Detail")
    begin
        with LCDetail do begin
            if Confirm(Text13709) then
                if not Closed then begin
                    TestField(Released);
                    Closed := true;
                    Modify;
                    LCADetails.SetRange("LC No.", "No.");
                    if LCADetails.Find('-') then
                        repeat
                            LCADetails.Closed := true;
                            LCADetails.Modify;
                        until LCADetails.Next = 0;
                    //LCTerms.SETRANGE("LC No.","No.");
                    //IF LCTerms.FINDFIRST THEN BEGIN
                    //  LCTerms.Released := TRUE;
                    //  LCTerms.MODIFY;
                    //END;
                    Message(Text13707);
                end else
                    Message(Text13708)
            else
                exit;
        end;
    end;

    procedure LCAmendmentRelease(LCAmendments: Record "LC Amended Details")
    begin
        with LCAmendments do begin
            if Confirm(Text13712) then
                if not Released then begin
                    TestField("Bank Amended No.");
                    Validate("LC Value");
                    Released := true;
                    Modify;
                    Message(Text13710);
                end else
                    Message(Text50006)
            else
                exit;
        end;
    end;
}

