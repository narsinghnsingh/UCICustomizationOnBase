codeunit 50011 CodeunitSubscriber
{
    Permissions = TableData "Item Ledger Entry" = m;

    var
        GLSetupShortcutDimCode: array[8] of Code[20];
        HasGotGLSetup: Boolean;
        TouchedItemLedgerEntries: Record "Item Ledger Entry";
        MfgSetup: Record "Manufacturing Setup";
        Location: Record Location;
        Rec_ILE: Record "Item Ledger Entry";
        Estimate: Record "Product Design Header";
        SOrderLine: Record "Sales Line";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::LogInManagement, 'OnAfterCompanyOpen', '', false, false)]
    local procedure CU40_OnAfterCompanyOpen()
    var
        UserSetup: Record "User Setup";
    begin
        // Lines added by Deepak
        UserSetup.RESET;
        UserSetup.SETRANGE(UserSetup."User ID", USERID);
        IF UserSetup.FINDFIRST THEN BEGIN
            IF UserSetup."Conditional User" = TRUE THEN BEGIN
                UserSetup."New Posting From" := (WORKDATE - 2);
                UserSetup."New Posting To" := TODAY;
                UserSetup."Allow Posting To" := TODAY;
                UserSetup.MODIFY(TRUE);
            END ELSE BEGIN
                UserSetup."New Posting To" := TODAY;
                UserSetup."Allow Posting To" := TODAY;
                UserSetup.MODIFY(TRUE);
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, 11, 'OnBeforeDateNotAllowed', '', false, false)]
    local procedure CU11_OnBeforeDateNotAllowed(GenJnlLine: Record "Gen. Journal Line"; var DateCheckDone: Boolean)
    var
        GenJournalNarration: Record "Gen. Journal Narration";
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get;
        if (GLSetup."Narration Mandatory") and (GenJnlLine."System-Created Entry" = false) and (GenJnlLine."Post Dated Cheque" = false) then begin
            GenJournalNarration.Reset;
            GenJournalNarration.SetRange(GenJournalNarration."Journal Template Name", GenJnlLine."Journal Template Name");
            GenJournalNarration.SetRange(GenJournalNarration."Journal Batch Name", GenJnlLine."Journal Batch Name");
            GenJournalNarration.SetRange(GenJournalNarration."Document No.", GenJnlLine."Document No.");
            if not GenJournalNarration.FindFirst then
                Error('Narration is mandatory as per company policy, please update narration in document no. %1 ', GenJnlLine."Document No.");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterInitGLEntry', '', false, false)]
    local procedure CU12_OnAfterInitGLEntry(VAR GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        // Lines added By Deepak kumar
        GLEntry."Parking No." := GenJournalLine."Parking No.";
        GLEntry."LC No." := GenJournalLine."LC No.";
        GLEntry."Cheque No." := GenJournalLine."Cheque No.";
        GLEntry."Cheque Date" := GenJournalLine."Cheque Date";
        GLEntry."PDC Type" := GenJournalLine."PDC Type";
        GLEntry."Post Dated Cheque" := GenJournalLine."Post Dated Cheque";
        //End;
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterInitCustLedgEntry', '', false, false)]
    local procedure CU12_OnAfterInitCustLedgEntry(VAR CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        // Lines added by Deepak Kumar
        IF GenJournalLine."Post Dated Cheque" = TRUE THEN BEGIN
            IF GenJournalLine."PDC Type" = 1 THEN BEGIN
                CustLedgerEntry."Post Dated Cheque" := GenJournalLine."Post Dated Cheque";
                CustLedgerEntry."PDC Detail" := GenJournalLine."Cheque No." + ' ' + FORMAT(GenJournalLine."Cheque Date");
                ;
            END;
        END;

    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterInitVendLedgEntry', '', false, false)]
    local procedure CU12_OnAfterInitVendLedgEntry(VAR VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        Rec_Vendor: Record Vendor;
    begin
        // Lines added by Deepak Kumar
        IF GenJournalLine."Post Dated Cheque" = TRUE THEN BEGIN
            IF GenJournalLine."PDC Type" = 1 THEN BEGIN
                VendorLedgerEntry."Post Dated Cheque" := GenJournalLine."Post Dated Cheque";
                VendorLedgerEntry."PDC Detail" := GenJournalLine."Cheque No." + ' ' + FORMAT(GenJournalLine."Cheque Date");
            END;
        END;
        IF Rec_Vendor.GET(VendorLedgerEntry."Vendor No.") THEN
            VendorLedgerEntry."Vendor Segment" := Rec_Vendor."Vendor Segment";
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterInitBankAccLedgEntry', '', false, false)]
    local procedure CU12_OnAfterInitBankAccLedgEntry(VAR BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        // Lines added By Deepak Kumar
        BankAccountLedgerEntry."Cheque No." := GenJournalLine."Cheque No.";
        BankAccountLedgerEntry."Cheque Date" := GenJournalLine."Cheque Date";

    end;

    local procedure InitPostedNarration(var GenJnlLine: Record "Gen. Journal Line"; GLEntry: Record "G/L Entry")
    var
        PostedNarration: Record "Posted Narration";
        GenJnlNarration: Record "Gen. Journal Narration";
        DocumentNo: Code[20];
    begin
        DocumentNo := GenJnlLine."Parking No.";
        // Lines added by Deepak Kumar
        if (GenJnlLine."Journal Template Name" = '') and (GenJnlLine."Journal Batch Name" = '') then
            exit;
        GenJnlNarration.Reset;
        GenJnlNarration.Reset;
        GenJnlNarration.SetFilter(GenJnlNarration."Journal Template Name", GenJnlLine."Journal Template Name");
        GenJnlNarration.SetFilter(GenJnlNarration."Journal Batch Name", GenJnlLine."Journal Batch Name");
        GenJnlNarration.SetFilter(GenJnlNarration."Document No.", DocumentNo);
        GenJnlNarration.SetFilter(GenJnlNarration."Line No.", '<>%1', 0);
        GenJnlNarration.SetRange(GenJnlNarration."Gen. Journal Line No.", 0);
        if GenJnlNarration.FindFirst then begin
            PostedNarration.Reset;
            PostedNarration.SetCurrentKey("Transaction No.");
            PostedNarration.SetRange("Transaction No.", GLEntry."Transaction No.");
            if not PostedNarration.FindFirst then begin
                if GenJnlNarration.FindSet then
                    repeat
                        InsertPostedNarrationVouchersSam(GenJnlNarration, GLEntry);
                    until GenJnlNarration.Next = 0;
            end;

        end;
        GenJnlNarration.Reset;
        GenJnlNarration.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
        GenJnlNarration.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
        GenJnlNarration.SetRange("Document No.", DocumentNo);
        GenJnlNarration.SetFilter("Line No.", '<>%1', 0);
        GenJnlNarration.SetRange("Gen. Journal Line No.", GenJnlLine."Line No.");
        if GenJnlNarration.FindFirst then begin
            PostedNarration.Reset;
            PostedNarration.SetRange(PostedNarration."Entry No.", GLEntry."Entry No.");
            if not PostedNarration.FindFirst then begin
                if GenJnlNarration.FindSet then
                    repeat
                        InsertPostedNarrationLinesSam(GLEntry);
                    until GenJnlNarration.Next = 0;
            end;
        end;
    end;

    local procedure InsertPostedNarrationVouchersSam(GenJnlNarration: record "Gen. Journal Narration"; GLEntry: Record "G/L Entry")
    var
        PostedNarration: Record "Posted Narration";
    begin
        //Lines added BY Deepak Kumar
        PostedNarration.Init;
        PostedNarration."Entry No." := 0;
        PostedNarration."Transaction No." := GLEntry."Transaction No.";
        PostedNarration."Line No." := GenJnlNarration."Line No.";
        PostedNarration."Posting Date" := GLEntry."Posting Date";
        PostedNarration."Document Type" := GLEntry."Document Type";
        PostedNarration."Document No." := GLEntry."Document No.";
        PostedNarration.Narration := GenJnlNarration.Narration;
        PostedNarration.Insert;
    end;

    local procedure InsertPostedNarrationLinesSam(GLEntry: Record "G/L Entry")
    var
        PostedNarration: Record "Posted Narration";
        GenJnlNarration: Record "Gen. Journal Narration";
    begin
        //Lines added BY Deepak Kumar
        PostedNarration.Init;
        PostedNarration."Entry No." := GLEntry."Entry No.";
        PostedNarration."Transaction No." := GLEntry."Transaction No.";
        PostedNarration."Line No." := GenJnlNarration."Line No.";
        PostedNarration."Posting Date" := GLEntry."Posting Date";
        PostedNarration."Document Type" := GLEntry."Document Type";
        PostedNarration."Document No." := GLEntry."Document No.";
        PostedNarration.Narration := GenJnlNarration.Narration;
        PostedNarration.Insert(true);
    end;


    procedure UpdateJournalLineforReverse(DocumentNo: Code[50])
    var
        GLEntry: Record "G/L Entry";
    begin
        // Lines added By Deepak Kumar
        GLEntry.Reset;
        GLEntry.SetRange(GLEntry."Document No.", DocumentNo);
        if GLEntry.FindFirst then begin
            repeat
                GLEntry."Journal Batch Name" := 'Default';
                GLEntry.Modify(true);
            until GLEntry.Next = 0;
            Message('Lines marked for reversal');
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforeInsertGLEntryBuffer', '', false, false)]
    local procedure CU12_OnBeforeInsertGLEntryBuffer(VAR TempGLEntryBuf: Record "G/L Entry"; VAR GenJournalLine: Record "Gen. Journal Line"; VAR BalanceCheckAmount: Decimal; VAR BalanceCheckAmount2: Decimal; VAR BalanceCheckAddCurrAmount: Decimal; var BalanceCheckAddCurrAmount2: Decimal)
    begin
        InitPostedNarration(GenJournalLine, TempGLEntryBuf);
    end;

    //CodeUnit 13 -
    procedure IdentifyCashAccount(GenJnlLine2: Record "Gen. Journal Line"; CashVoucherType: Option "Cash Receipt Book","Cash Payment Book")
    var
        VoucherAcc: Record "Voucher Account";
        GenJnlLine3: Record "Gen. Journal Line";
        Text16500: Label 'Account No. %1 is not defined as cash account for the Voucher Sub Type %2 and Document No.%3.';
        Text16501: Label 'Account No. %1 is not defined as bank account for the Voucher Sub Type %2 and Document No.%3.';
        Text16502: Label 'Account Type or Bal. Account Type can only be G/L Account or Bank Account for Sub Voucher Type %1 and Document No.%2.';
        Text16503: Label 'Cash Account No. %1 should not be used for Sub Voucher Type %2 and Document No.%3.';
        Text16504: Label 'Bal. Account Type should not be Bank Account for Document No.%1.';
        Text16505: Label 'Cash Account No. %1 cannot be credited for the Voucher Type %2 and Document No.%3.';
        Text16506: Label 'Account Type should not be Bank Account for Document No.%1.';
        Text16507: Label 'Cash Account No. %1 cannot be debited for the Voucher Type %2 and Document No.%3.';
    begin
        with GenJnlLine2 do begin
            GenJnlLine3.Reset();
            GenJnlLine3.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Document No.");
            GenJnlLine3.SetRange("Journal Template Name", "Journal Template Name");
            GenJnlLine3.SetRange("Journal Batch Name", "Journal Batch Name");
            GenJnlLine3.SetRange("Document No.", "Document No.");
            GenJnlLine3.SetFilter(Amount, '<>%1', 0);

            if CashVoucherType = CashVoucherType::"Cash Receipt Book" then begin
                if GenJnlLine3.FindSet then
                    repeat
                        if GenJnlLine3.Amount > 0 then begin
                            if GenJnlLine3."Account No." <> '' then begin
                                GenJnlLine3.TestField("Account Type", GenJnlLine3."Account Type"::"G/L Account");
                                VoucherAcc.SetRange("Sub Type", VoucherAcc."Sub Type"::"Cash Receipt Voucher");
                                VoucherAcc.SetRange("Account Type", GenJnlLine3."Account Type"::"G/L Account");
                                VoucherAcc.SetRange("Account No.", GenJnlLine3."Account No.");
                                if not VoucherAcc.FindFirst then
                                    Error(Text16500, GenJnlLine3."Account No.", CashVoucherType, GenJnlLine3."Document No.");
                            end;

                            if GenJnlLine3."Bal. Account Type" = GenJnlLine3."Bal. Account Type"::"Bank Account" then
                                Error(Text16504, GenJnlLine3."Document No.");

                            if GenJnlLine3."Bal. Account Type" = GenJnlLine3."Bal. Account Type"::"G/L Account" then begin
                                VoucherAcc.SetFilter("Sub Type", '%1|%2', VoucherAcc."Sub Type"::"Cash Receipt Voucher",
                                  VoucherAcc."Sub Type"::"Cash Payment Voucher");
                                VoucherAcc.SetRange("Account Type", GenJnlLine3."Bal. Account Type"::"G/L Account");
                                VoucherAcc.SetRange("Account No.", GenJnlLine3."Bal. Account No.");
                                if VoucherAcc.FindFirst then
                                    Error(Text16505, GenJnlLine3."Account No.", CashVoucherType, GenJnlLine3."Document No.");
                            end;
                        end;
                        if GenJnlLine3.Amount < 0 then begin
                            if GenJnlLine3."Bal. Account No." <> '' then begin
                                GenJnlLine3.TestField("Bal. Account Type", GenJnlLine3."Account Type"::"G/L Account");
                                VoucherAcc.SetRange("Sub Type", VoucherAcc."Sub Type"::"Cash Receipt Voucher");
                                VoucherAcc.SetRange("Account Type", GenJnlLine3."Bal. Account Type"::"G/L Account");
                                VoucherAcc.SetRange("Account No.", GenJnlLine3."Bal. Account No.");
                                if not VoucherAcc.FindFirst then
                                    Error(Text16500, GenJnlLine3."Bal. Account No.", CashVoucherType, GenJnlLine3."Document No.");
                            end;

                            if GenJnlLine3."Account Type" = GenJnlLine3."Account Type"::"Bank Account" then
                                Error(Text16506, GenJnlLine3."Document No.");

                            if GenJnlLine3."Account Type" = GenJnlLine3."Account Type"::"G/L Account" then begin
                                VoucherAcc.SetFilter("Sub Type", '%1|%2', VoucherAcc."Sub Type"::"Cash Receipt Voucher",
                                  VoucherAcc."Sub Type"::"Cash Payment Voucher");
                                VoucherAcc.SetRange("Account Type", GenJnlLine3."Account Type"::"G/L Account");
                                VoucherAcc.SetRange("Account No.", GenJnlLine3."Account No.");
                                if VoucherAcc.FindFirst then
                                    Error(Text16505, GenJnlLine3."Account No.", CashVoucherType, GenJnlLine3."Document No.");
                            end;
                        end;
                    until GenJnlLine3.Next = 0;
            end;
            if CashVoucherType = CashVoucherType::"Cash Payment Book" then begin
                if GenJnlLine3.FindSet then
                    repeat
                        if GenJnlLine3.Amount < 0 then begin
                            if GenJnlLine3."Account No." <> '' then begin
                                GenJnlLine3.TestField("Account Type", GenJnlLine3."Account Type"::"G/L Account");
                                VoucherAcc.SetFilter("Sub Type", '%1', VoucherAcc."Sub Type"::"Cash Payment Voucher");
                                VoucherAcc.SetRange("Account Type", GenJnlLine3."Account Type"::"G/L Account");
                                VoucherAcc.SetRange("Account No.", GenJnlLine3."Account No.");
                                if not VoucherAcc.FindFirst then
                                    Error(Text16500, GenJnlLine3."Account No.", CashVoucherType, GenJnlLine3."Document No.");
                            end;

                            if GenJnlLine3."Bal. Account Type" = GenJnlLine3."Bal. Account Type"::"Bank Account" then
                                Error(Text16504, GenJnlLine3."Document No.");

                            if GenJnlLine3."Bal. Account Type" = GenJnlLine3."Bal. Account Type"::"G/L Account" then begin
                                VoucherAcc.SetFilter("Sub Type", '%1|%2', VoucherAcc."Sub Type"::"Cash Receipt Voucher",
                                  VoucherAcc."Sub Type"::"Cash Payment Voucher");
                                VoucherAcc.SetRange("Account Type", GenJnlLine3."Bal. Account Type"::"G/L Account");
                                VoucherAcc.SetRange("Account No.", GenJnlLine3."Bal. Account No.");
                                if VoucherAcc.FindFirst then
                                    Error(Text16507, GenJnlLine3."Account No.", CashVoucherType, GenJnlLine3."Document No.");
                            end;
                        end;
                        if GenJnlLine3.Amount > 0 then begin
                            if GenJnlLine3."Bal. Account No." <> '' then begin
                                GenJnlLine3.TestField("Bal. Account Type", GenJnlLine3."Account Type"::"G/L Account");
                                VoucherAcc.SetRange("Sub Type", VoucherAcc."Sub Type"::"Cash Payment Voucher");
                                VoucherAcc.SetRange("Account Type", GenJnlLine3."Bal. Account Type"::"G/L Account");
                                VoucherAcc.SetRange("Account No.", GenJnlLine3."Bal. Account No.");
                                if not VoucherAcc.FindFirst then
                                    Error(Text16500, GenJnlLine3."Bal. Account No.", CashVoucherType, GenJnlLine3."Document No.");
                            end;

                            if GenJnlLine3."Account Type" = GenJnlLine3."Account Type"::"Bank Account" then
                                Error(Text16506, GenJnlLine3."Document No.");

                            if GenJnlLine3."Account Type" = GenJnlLine3."Account Type"::"G/L Account" then begin
                                VoucherAcc.SetFilter("Sub Type", '%1|%2', VoucherAcc."Sub Type"::"Cash Receipt Voucher",
                                  VoucherAcc."Sub Type"::"Cash Payment Voucher");
                                VoucherAcc.SetRange("Account Type", GenJnlLine3."Account Type"::"G/L Account");
                                VoucherAcc.SetRange("Account No.", GenJnlLine3."Account No.");
                                if VoucherAcc.FindFirst then
                                    Error(Text16507, GenJnlLine3."Account No.", CashVoucherType, GenJnlLine3."Document No.");
                            end;
                        end;
                    until GenJnlLine3.Next = 0;
            end;
        end;
    end;

    procedure IdentifyBankAccount(GenJnlLine2: Record "Gen. Journal Line"; BankVoucherType: Option "Bank Receipt Book","Bank Payment Book")
    var
        VoucherAcc: Record "Voucher Account";
        GenJnlLine3: Record "Gen. Journal Line";
        Text16500: Label 'Account No. %1 is not defined as cash account for the Voucher Sub Type %2 and Document No.%3.';
        Text16501: Label 'Account No. %1 is not defined as bank account for the Voucher Sub Type %2 and Document No.%3.';
        Text16504: Label 'Bal. Account Type should not be Bank Account for Document No.%1.';
        Text16505: Label 'Cash Account No. %1 cannot be credited for the Voucher Type %2 and Document No.%3.';
        Text16506: Label 'Account Type should not be Bank Account for Document No.%1.';
        Text16507: Label 'Cash Account No. %1 cannot be debited for the Voucher Type %2 and Document No.%3.';
    begin
        with GenJnlLine2 do begin
            GenJnlLine3.Reset;
            GenJnlLine3.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Document No.");
            GenJnlLine3.SetRange("Journal Template Name", "Journal Template Name");
            GenJnlLine3.SetRange("Journal Batch Name", "Journal Batch Name");
            GenJnlLine3.SetRange("Document No.", "Document No.");
            GenJnlLine3.SetFilter(Amount, '<>%1', 0);

            if BankVoucherType = BankVoucherType::"Bank Receipt Book" then begin
                if GenJnlLine3.FindSet then
                    repeat
                        if GenJnlLine3.Amount > 0 then begin
                            if GenJnlLine3."Account No." <> '' then begin
                                GenJnlLine3.TestField("Account Type", GenJnlLine3."Account Type"::"Bank Account");
                                VoucherAcc.SetRange("Sub Type", VoucherAcc."Sub Type"::"Bank Receipt Voucher");
                                VoucherAcc.SetRange("Account Type", GenJnlLine3."Account Type"::"Bank Account");
                                VoucherAcc.SetRange("Account No.", GenJnlLine3."Account No.");
                                if not VoucherAcc.FindFirst then
                                    Error(Text16501, GenJnlLine3."Account No.", BankVoucherType, GenJnlLine3."Document No.");
                            end;

                            if GenJnlLine3."Bal. Account Type" = GenJnlLine3."Bal. Account Type"::"G/L Account" then begin
                                VoucherAcc.SetFilter("Sub Type", '%1|%2', VoucherAcc."Sub Type"::"Cash Receipt Voucher",
                                  VoucherAcc."Sub Type"::"Cash Payment Voucher");
                                VoucherAcc.SetRange("Account Type", GenJnlLine3."Bal. Account Type"::"G/L Account");
                                VoucherAcc.SetRange("Account No.", GenJnlLine3."Bal. Account No.");
                                if VoucherAcc.FindFirst then
                                    Error(Text16505, GenJnlLine3."Bal. Account No.", BankVoucherType, GenJnlLine3."Document No.");
                            end;

                            if GenJnlLine3."Bal. Account Type" = GenJnlLine3."Bal. Account Type"::"Bank Account" then
                                Error(Text16504, GenJnlLine3."Document No.");
                        end;
                        if GenJnlLine3.Amount < 0 then begin
                            if GenJnlLine3."Bal. Account No." <> '' then begin
                                GenJnlLine3.TestField("Bal. Account Type", GenJnlLine3."Bal. Account Type"::"Bank Account");
                                VoucherAcc.SetFilter("Sub Type", '%1', VoucherAcc."Sub Type"::"Bank Receipt Voucher");
                                VoucherAcc.SetRange("Account Type", GenJnlLine3."Bal. Account Type"::"Bank Account");
                                VoucherAcc.SetRange("Account No.", GenJnlLine3."Bal. Account No.");
                                if not VoucherAcc.FindFirst then
                                    Error(Text16501, GenJnlLine3."Bal. Account No.", BankVoucherType, GenJnlLine3."Document No.");
                            end;

                            if GenJnlLine3."Account Type" = GenJnlLine3."Account Type"::"G/L Account" then begin
                                VoucherAcc.SetFilter("Sub Type", '%1|%2', VoucherAcc."Sub Type"::"Cash Receipt Voucher",
                                  VoucherAcc."Sub Type"::"Cash Payment Voucher");
                                VoucherAcc.SetRange("Account Type", GenJnlLine3."Account Type"::"G/L Account");
                                VoucherAcc.SetRange("Account No.", GenJnlLine3."Account No.");
                                if VoucherAcc.FindFirst then
                                    Error(Text16505, GenJnlLine3."Bal. Account No.", BankVoucherType, GenJnlLine3."Document No.");
                            end;

                            if GenJnlLine3."Account Type" = GenJnlLine3."Account Type"::"Bank Account" then
                                Error(Text16506, GenJnlLine3."Document No.");
                        end;
                    until GenJnlLine3.Next = 0;
            end;
            if BankVoucherType = BankVoucherType::"Bank Payment Book" then begin
                if GenJnlLine3.FindSet then
                    repeat
                        if GenJnlLine3.Amount < 0 then begin
                            if GenJnlLine3."Account No." <> '' then begin
                                GenJnlLine3.TestField("Account Type", GenJnlLine3."Account Type"::"Bank Account");
                                VoucherAcc.SetRange("Sub Type", VoucherAcc."Sub Type"::"Bank Payment Voucher");
                                VoucherAcc.SetRange("Account Type", GenJnlLine3."Account Type"::"Bank Account");
                                VoucherAcc.SetRange("Account No.", GenJnlLine3."Account No.");
                                if not VoucherAcc.FindFirst then
                                    Error(Text16501, GenJnlLine3."Account No.", BankVoucherType, GenJnlLine3."Document No.");
                            end;

                            if GenJnlLine3."Bal. Account Type" = GenJnlLine3."Bal. Account Type"::"G/L Account" then begin
                                VoucherAcc.SetFilter("Sub Type", '%1|%2', VoucherAcc."Sub Type"::"Cash Receipt Voucher",
                                  VoucherAcc."Sub Type"::"Cash Payment Voucher");
                                VoucherAcc.SetRange("Account Type", GenJnlLine3."Bal. Account Type"::"G/L Account");
                                VoucherAcc.SetRange("Account No.", GenJnlLine3."Bal. Account No.");
                                if VoucherAcc.FindFirst then
                                    Error(Text16507, GenJnlLine3."Bal. Account No.", BankVoucherType, GenJnlLine3."Document No.");
                            end;

                            if GenJnlLine3."Bal. Account Type" = GenJnlLine3."Bal. Account Type"::"Bank Account" then
                                Error(Text16504, GenJnlLine3."Document No.");
                        end;
                        if GenJnlLine3.Amount > 0 then begin
                            if GenJnlLine3."Bal. Account No." <> '' then begin
                                GenJnlLine3.TestField("Bal. Account Type", GenJnlLine3."Bal. Account Type"::"Bank Account");
                                VoucherAcc.SetRange("Sub Type", VoucherAcc."Sub Type"::"Bank Payment Voucher");
                                VoucherAcc.SetRange("Account Type", GenJnlLine3."Bal. Account Type"::"Bank Account");
                                VoucherAcc.SetRange("Account No.", GenJnlLine3."Bal. Account No.");
                                if not VoucherAcc.FindFirst then
                                    Error(Text16501, GenJnlLine3."Bal. Account No.", BankVoucherType, GenJnlLine3."Document No.");
                            end;

                            if GenJnlLine3."Account Type" = GenJnlLine3."Account Type"::"G/L Account" then begin
                                VoucherAcc.SetFilter("Sub Type", '%1|%2', VoucherAcc."Sub Type"::"Cash Receipt Voucher",
                                  VoucherAcc."Sub Type"::"Cash Payment Voucher");
                                VoucherAcc.SetRange("Account Type", GenJnlLine3."Account Type"::"G/L Account");
                                VoucherAcc.SetRange("Account No.", GenJnlLine3."Account No.");
                                if VoucherAcc.FindFirst then
                                    Error(Text16507, GenJnlLine3."Bal. Account No.", BankVoucherType, GenJnlLine3."Document No.");
                            end;

                            if GenJnlLine3."Account Type" = GenJnlLine3."Account Type"::"Bank Account" then
                                Error(Text16506, GenJnlLine3."Document No.");
                        end;
                    until GenJnlLine3.Next = 0;
            end;
        end;
    end;

    procedure IdentifyContraAccount(GenJnlLine2: Record "Gen. Journal Line")
    var
        VoucherAcc: Record "Voucher Account";
        GenJnlLine3: Record "Gen. Journal Line";
        Text16500: Label 'Account No. %1 is not defined as cash account for the Voucher Sub Type %2 and Document No.%3.';
        Text16501: Label 'Account No. %1 is not defined as bank account for the Voucher Sub Type %2 and Document No.%3.';
        Text16502: Label 'Account Type or Bal. Account Type can only be G/L Account or Bank Account for Sub Voucher Type %1 and Document No.%2.';
    begin
        with GenJnlLine2 do begin
            GenJnlLine3.Reset;
            GenJnlLine3.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Document No.");
            GenJnlLine3.SetRange("Journal Template Name", "Journal Template Name");
            GenJnlLine3.SetRange("Journal Batch Name", "Journal Batch Name");
            GenJnlLine3.SetRange("Document No.", "Document No.");
            GenJnlLine3.SetFilter(Amount, '<>%1', 0);
            if GenJnlLine3.FindSet then
                repeat
                    if GenJnlLine3."Bal. Account No." <> '' then begin
                        if GenJnlLine3."Bal. Account Type" = GenJnlLine3."Bal. Account Type"::"Bank Account" then begin
                            VoucherAcc.SetFilter("Sub Type", '%1|%2', VoucherAcc."Sub Type"::"Bank Payment Voucher",
                              VoucherAcc."Sub Type"::"Bank Receipt Voucher");
                            VoucherAcc.SetRange("Account Type", GenJnlLine3."Bal. Account Type"::"Bank Account");
                            VoucherAcc.SetRange("Account No.", GenJnlLine3."Bal. Account No.");
                            if not VoucherAcc.FindFirst then
                                Error(Text16501, GenJnlLine3."Bal. Account No.", 'Contra', GenJnlLine3."Document No.");
                        end
                        else
                            if GenJnlLine3."Bal. Account Type" = GenJnlLine3."Bal. Account Type"::"G/L Account" then begin
                                VoucherAcc.SetFilter("Sub Type", '%1|%2', VoucherAcc."Sub Type"::"Cash Receipt Voucher",
                                  VoucherAcc."Sub Type"::"Cash Payment Voucher");
                                VoucherAcc.SetRange("Account Type", GenJnlLine3."Bal. Account Type"::"G/L Account");
                                VoucherAcc.SetRange("Account No.", GenJnlLine3."Bal. Account No.");
                                if not VoucherAcc.FindFirst then
                                    Error(Text16500, GenJnlLine3."Bal. Account No.", 'Contra', GenJnlLine3."Document No.");
                            end else
                                Error(Text16502, 'Contra', GenJnlLine3."Document No.");
                    end;

                    if GenJnlLine3."Account No." <> '' then begin
                        if GenJnlLine3."Account Type" = GenJnlLine3."Account Type"::"Bank Account" then begin
                            VoucherAcc.SetFilter("Sub Type", '%1|%2', VoucherAcc."Sub Type"::"Bank Payment Voucher",
                              VoucherAcc."Sub Type"::"Bank Receipt Voucher");
                            VoucherAcc.SetRange("Account Type", GenJnlLine3."Account Type"::"Bank Account");
                            VoucherAcc.SetRange("Account No.", GenJnlLine3."Account No.");
                            if not VoucherAcc.FindFirst then
                                Error(Text16501, GenJnlLine3."Account No.", 'Contra', GenJnlLine3."Document No.");
                        end
                        else
                            if GenJnlLine3."Account Type" = GenJnlLine3."Account Type"::"G/L Account" then begin
                                VoucherAcc.SetFilter("Sub Type", '%1|%2', VoucherAcc."Sub Type"::"Cash Receipt Voucher",
                                  VoucherAcc."Sub Type"::"Cash Payment Voucher");
                                VoucherAcc.SetRange("Account Type", GenJnlLine3."Account Type"::"G/L Account");
                                VoucherAcc.SetRange("Account No.", GenJnlLine3."Account No.");
                                if not VoucherAcc.FindFirst then
                                    Error(Text16500, GenJnlLine3."Account No.", 'Contra', GenJnlLine3."Document No.");
                            end else
                                Error(Text16502, 'Contra', GenJnlLine3."Document No.");
                    end;
                until GenJnlLine3.Next = 0;
        end;
    end;

    procedure IdentifyJournalAccount(GenJnlLine2: Record "Gen. Journal Line")
    var
        VoucherAcc: Record "Voucher Account";
        GenJnlLine3: Record "Gen. Journal Line";
        Text16503: Label 'Cash Account No. %1 should not be used for Sub Voucher Type %2 and Document No.%3.';
        Text16504: Label 'Bal. Account Type should not be Bank Account for Document No.%1.';
        Text16506: Label 'Account Type should not be Bank Account for Document No.%1.';
    begin
        with GenJnlLine2 do begin
            GenJnlLine3.Reset;
            GenJnlLine3.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Document No.");
            GenJnlLine3.SetRange("Journal Template Name", "Journal Template Name");
            GenJnlLine3.SetRange("Journal Batch Name", "Journal Batch Name");
            GenJnlLine3.SetRange("Document No.", "Document No.");
            GenJnlLine3.SetFilter(Amount, '<>%1', 0);
            if GenJnlLine3.FindSet then
                repeat
                    if GenJnlLine3."Bal. Account No." <> '' then begin
                        if GenJnlLine3."Bal. Account Type" = GenJnlLine3."Bal. Account Type"::"Bank Account" then
                            Error(Text16504, GenJnlLine3."Document No.");
                        if GenJnlLine3."Bal. Account Type" = GenJnlLine3."Bal. Account Type"::"G/L Account" then begin
                            VoucherAcc.SetFilter("Sub Type", '%1|%2', VoucherAcc."Sub Type"::"Cash Receipt Voucher",
                              VoucherAcc."Sub Type"::"Cash Payment Voucher");
                            VoucherAcc.SetRange("Account Type", GenJnlLine3."Bal. Account Type"::"G/L Account");
                            VoucherAcc.SetRange("Account No.", GenJnlLine3."Bal. Account No.");
                            if VoucherAcc.FindFirst then
                                Error(Text16503, GenJnlLine3."Bal. Account No.", 'Journal', GenJnlLine3."Document No.");
                        end;
                    end;

                    if GenJnlLine3."Account No." <> '' then begin
                        if GenJnlLine3."Account Type" = GenJnlLine3."Account Type"::"Bank Account" then
                            Error(Text16506, GenJnlLine3."Document No.");
                        if GenJnlLine3."Account Type" = GenJnlLine3."Account Type"::"G/L Account" then begin
                            VoucherAcc.SetFilter("Sub Type", '%1|%2', VoucherAcc."Sub Type"::"Cash Receipt Voucher",
                              VoucherAcc."Sub Type"::"Cash Payment Voucher");
                            VoucherAcc.SetRange("Account Type", GenJnlLine3."Account Type"::"G/L Account");
                            VoucherAcc.SetRange("Account No.", GenJnlLine3."Account No.");
                            if VoucherAcc.FindFirst then
                                Error(Text16503, GenJnlLine3."Account No.", 'Journal', GenJnlLine3."Document No.");
                        end;
                    end;
                until GenJnlLine3.Next = 0;
        end;
    end;

    local procedure DeleteGenJournalNarration(var GenJnlLine2: Record "Gen. Journal Line")
    var
        GenJournalNarration: Record "Gen. Journal Narration";
    begin
        with GenJournalNarration do begin
            SetRange("Journal Template Name", GenJnlLine2."Journal Template Name");
            SetRange("Journal Batch Name", GenJnlLine2."Journal Batch Name");
            DeleteAll;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 13, 'OnBeforeCheckBalance', '', false, false)]
    local procedure CU13_OnBeforeCheckBalance(GenJnlTemplate: Record "Gen. Journal Template"; GenJnlLine: Record "Gen. Journal Line"; CurrentBalance: Decimal; CurrentBalanceReverse: Decimal; CurrencyBalance: Decimal; StartLineNo: Integer; StartLineNoReverse: Integer; LastDocType: Option ""; LastDocNo: Code[20]; LastDate: Date; LastCurrencyCode: Code[10]; CommitIsSuppressed: Boolean)
    var
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        GenJnlBatch.GET(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
        // Lines added bY deepak Kumar
        IF (GenJnlLine."Journal Template Name" <> '') AND (GenJnlLine."Journal Batch Name" <> '') AND
           (GenJnlBatch."Sub Type" <> GenJnlBatch."Sub Type"::" ")
        THEN BEGIN
            IF GenJnlBatch."Sub Type" = GenJnlBatch."Sub Type"::"Cash Receipt Voucher" THEN
                IdentifyCashAccount(GenJnlLine, 0);
            IF GenJnlBatch."Sub Type" = GenJnlBatch."Sub Type"::"Cash Payment Voucher" THEN
                IdentifyCashAccount(GenJnlLine, 1);
            IF GenJnlBatch."Sub Type" = GenJnlBatch."Sub Type"::"Bank Receipt Voucher" THEN
                IdentifyBankAccount(GenJnlLine, 0);
            IF GenJnlBatch."Sub Type" = GenJnlBatch."Sub Type"::"Bank Payment Voucher" THEN
                IdentifyBankAccount(GenJnlLine, 1);
            IF GenJnlBatch."Sub Type" = GenJnlBatch."Sub Type"::"Contra Voucher" THEN
                IdentifyContraAccount(GenJnlLine);
            IF GenJnlBatch."Sub Type" = GenJnlBatch."Sub Type"::"Journal Voucher" THEN
                IdentifyJournalAccount(GenJnlLine);
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, 13, 'OnAfterGetPostingTypeFilter', '', false, false)]
    local procedure CU13_OnAfterGetPostingTypeFilter(VAR GenJournalLine4: Record "Gen. Journal Line"; VAR GenJournalLine6: Record "Gen. Journal Line"; CheckBalAcount: Boolean)
    begin
        //Mpower --
        IF CheckBalAcount THEN BEGIN
            CASE GenJournalLine4."Bal. Account Type" OF
                GenJournalLine4."Bal. Account Type"::Customer:
                    GenJournalLine6.SETRANGE("Bal. Gen. Posting Type", GenJournalLine6."Bal. Gen. Posting Type"::Sale);
                GenJournalLine4."Bal. Account Type"::Vendor:
                    GenJournalLine6.SETRANGE("Bal. Gen. Posting Type", GenJournalLine6."Bal. Gen. Posting Type"::Purchase);
            END;
        END;


        CASE GenJournalLine4."Account Type" OF
            GenJournalLine4."Account Type"::Customer:
                GenJournalLine6.SETRANGE("Gen. Posting Type", GenJournalLine6."Gen. Posting Type"::Sale);
            GenJournalLine4."Account Type"::Vendor:
                GenJournalLine6.SETRANGE("Gen. Posting Type", GenJournalLine6."Gen. Posting Type"::Purchase);
        END;
        //Mpower ++
    End;

    //CodeUnit 13 +

    procedure StoreResIndDocument(var ResIndHeader: Record "Recruitment Header"; InteractionExist: Boolean)
    var
        ResIndHeaderArchive: Record "Recruitment Header Archive";
    begin

        ResIndHeaderArchive.Init;
        ResIndHeaderArchive.TransferFields(ResIndHeader);
        ResIndHeaderArchive."Archived By" := UserId;
        ResIndHeaderArchive."Date Archived" := WorkDate;
        ResIndHeaderArchive."Time Archived" := Time();
        ResIndHeaderArchive."Version No." := GetNextVersionNoHRP(
          DATABASE::"Recruitment Header Archive", ResIndHeaderArchive."Recruitment Policy No.", ResIndHeaderArchive."Doc. No. Occurrence");
        ResIndHeaderArchive.Insert;
    end;

    procedure GetNextVersionNoHRP(TableId: Integer; DocNo: Code[20]; DocNoOccurrence: Integer): Integer
    var
        ResourceIndentArchive: Record "Recruitment Header Archive";
    begin
        case TableId of
            DATABASE::"Recruitment Header Archive":
                begin
                    ResourceIndentArchive.LockTable;
                    ResourceIndentArchive.SetRange("Recruitment Policy No.", DocNo);
                    ResourceIndentArchive.SetRange("Doc. No. Occurrence", DocNoOccurrence);
                    if ResourceIndentArchive.FindLast then
                        exit(ResourceIndentArchive."Version No." + 1);

                    exit(1);
                end;
        end;
    end;

    procedure GetNextOccurrenceNoHRP(TableId: Integer; DocNo: Code[20]): Integer
    var
        ResArchive: Record "Recruitment Header Archive";
    begin
        case TableId of
            DATABASE::"Recruitment Header":
                begin
                    ResArchive.LockTable;
                    ResArchive.SetRange("Recruitment Policy No.", DocNo);
                    if ResArchive.FindLast then
                        exit(ResArchive."Doc. No. Occurrence" + 1);

                    exit(1);
                end;
        end;
    end;

    procedure LookupUserID(VAR UserName: Code[50])
    var
        sid: Guid;
    begin
        sid := SID;
        LookupUser(UserName, sid);
    end;

    procedure LookupUser(VAR UserName: Code[50]; VAR SID: Guid): Boolean
    var
        User: Record User;
    begin
        ;
        User.RESET;
        User.SETCURRENTKEY("User Name");
        User."User Name" := UserName;
        IF User.FIND('=><') THEN;
        IF PAGE.RUNMODAL(PAGE::Users, User) = ACTION::LookupOK THEN BEGIN
            UserName := User."User Name";
            SID := User."User Security ID";
            EXIT(TRUE);
        END;

        EXIT(FALSE);
    end;

    procedure BranchesLookupUserID(var UserName: Code[50])
    var
        SID: Guid;
    begin
        //EXIT(BranchesLookupUser(UserID,WindowsSID,TRUE,Name)); old code
        BranchesLookupUser(UserName, SID);
    end;

    procedure BranchesLookupUser(var UserName: Code[50]; var SID: Guid): Boolean
    var
        User: Record User;
    begin
        User.Reset;
        User.SetCurrentKey("User Name");
        User."User Name" := UserName;
        if User.Find('=><') then;
        if PAGE.RunModal(PAGE::Users, User) = ACTION::LookupOK then begin
            UserName := User."User Name";
            SID := User."User Security ID";
            exit(true);
        end;

        exit(false);
    end;

    procedure ResHeirLookupUserID(var UserName: Code[50])
    var
        SID: Guid;
    begin
        ResHeirLookupUser(UserName, SID);
    end;

    procedure ResHeirLookupUser(var UserName: Code[50]; var SID: Guid): Boolean
    var
        User: Record User;
        B2BEmpGRec: Record Employee_B2B;
        LocWiseMiscGCU: Codeunit "Payroll Branch wise Misc.";
    begin
        User.Reset;
        User.SetCurrentKey("User Name");
        User."User Name" := UserName;
        if User.Find('=><') then;
        if User.FindFirst then begin
            User.ClearMarks;
            repeat
                B2BEmpGRec.Reset;
                B2BEmpGRec.SetRange("User ID", User."User Name");
                B2BEmpGRec.SetRange("Location Code", LocWiseMiscGCU.ReturnUserLocationCode());
                if B2BEmpGRec.FindFirst then
                    User.Mark(true);
            until User.Next = 0;
            User.MarkedOnly(true);
        end;
        if PAGE.RunModal(PAGE::Users, User) = ACTION::LookupOK then begin
            UserName := User."User Name";
            SID := User."User Security ID";
            exit(true);
        end;

        exit(false);
    end;

    //CodeUnit 21 -
    [EventSubscriber(ObjectType::Codeunit, 21, 'OnAfterCheckItemJnlLine', '', false, false)]
    local procedure CU21_OnAfterCheckItemJnlLine(VAR ItemJnlLine: Record "Item Journal Line")
    var
        ItemVariant: Record "Item Variant";
        Rec_Item: Record Item;
        MachineCenter: Record "Machine Center";
    begin
        Rec_Item.Get(ItemJnlLine."Item No.");
        if Rec_Item."Item Category Code" = 'PAPER' then begin
            if (ItemJnlLine."Journal Batch Name" <> '') and (ItemJnlLine."Journal Template Name" <> '') then begin
                ItemVariant.Get(ItemJnlLine."Item No.", ItemJnlLine."Variant Code");
                ItemVariant.Status := ItemVariant.Status::Open;
                ItemVariant.Accepted := true;
                ItemVariant.Modify;
            end;
        end;
        // Lines added By Deepak Kumar
        if (ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::Output) and (ItemJnlLine."Journal Batch Name" <> '')
        AND (ItemJnlLine."Swap Output" = false) AND (ItemJnlLine.Quantity > 0) then begin
            ItemJnlLine.TestField("Run Time");
            if ItemJnlLine.Type = ItemJnlLine.Type::"Machine Center" then begin
                MachineCenter.Get(ItemJnlLine."No.");
                if MachineCenter."Work Center Category" = MachineCenter."Work Center Category"::Corrugation then
                    ItemJnlLine.TestField(ItemJnlLine."Schedule Doc. No.");
            end;
        end;
    end;
    //CodeUnit 21 +

    //CodeUnit 22 -
    [EventSubscriber(ObjectType::Codeunit, 22, 'OnPostOutputOnAfterUpdateAmounts', '', false, false)]
    local procedure CU22_OnPostOutputOnAfterUpdateAmounts(VAR ItemJournalLine: Record "Item Journal Line")
    var
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
    begin
        // Lines added by Deepak Kumar
        if (ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Output) then
            ProdOrderRoutingLine.UpdateWIPQuantity(ItemJournalLine."Order No.", ItemJournalLine."Order Line No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnBeforePostItemJnlLine', '', false, false)]
    local procedure CU22_OnBeforePostItemJnlLine(VAR ItemJournalLine: Record "Item Journal Line")
    var
        Item: Record Item;
    begin
        // Lines added By Deepak Kumar
        Item.Get(ItemJournalLine."Item No.");
        with Item
          do begin
            SetRange(Item."Variant Filter", ItemJournalLine."Variant Code");
            SetRange(Item."Date Filter", 0D, ItemJournalLine."Posting Date");
            SetRange(Item."Location Filter", ItemJournalLine."Location Code");
            CalcFields(Inventory, "Net Change");
        end;

        if (ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Consumption) or (ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Sale)
          or (ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::"Negative Adjmt.") then begin
            if ((ItemJournalLine.Quantity > Item."Net Change") or (ItemJournalLine.Quantity > Item.Inventory)) and (ItemJournalLine.Quantity > 0) then
                Error('Insufficient Inventory %3 of Item No %1 at Location %2 for current quantity %4. Inventory as on date %5 = %6',
              ItemJournalLine."Item No.", ItemJournalLine."Location Code", Item."Net Change", ItemJournalLine.Quantity, ItemJournalLine."Posting Date", Item.Inventory);
        end;
        //End Deepak
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterPostItemJnlLine', '', false, false)]
    local procedure CU22_OnAfterPostItemJnlLine(VAR ItemJournalLine: Record "Item Journal Line"; ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        //B2BPLM2.00.00  Added by ADSK1.0
        IF ItemJournalLine."Post Worksheet" THEN
            PostWHJnlLine(ItemJournalLine, ItemJournalLine.Quantity, ItemJournalLine."Quantity (Base)");
        //B2BPLM2.00.00  Added by ADSK1.0

    end;
    //Needs to check with 2 subscriber
    [EventSubscriber(ObjectType::Codeunit, 22, 'OnBeforeInsertCapLedgEntry', '', false, false)]
    local procedure CU22_OnBeforeInsertCapLedgEntry(VAR CapLedgEntry: Record "Capacity Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    var
        ProdOrderLineD: Record "Prod. Order Line";
        ProdOrder: Record "Production Order";

    begin
        with ItemJournalLine do begin
            //B2BPLM <<
            CapLedgEntry."Machine Id" := "Machine Id";//B2BPLM
                                                      //B2BPLM >>
                                                      //Samadhan// Lines added by Deepak kUmar
            CapLedgEntry."Schedule Doc. No." := "Schedule Doc. No.";
            CapLedgEntry."Employee Code" := "Employee Code";
            CapLedgEntry."Employee Name" := "Employee Name";
            CapLedgEntry."Additional Output" := "Additional Output";
            CapLedgEntry."Plate Item" := "Plate Item";
            CapLedgEntry."Plate Item No. 2" := "Plate Item No. 2";
            CapLedgEntry."Plate Variant" := "Plate Variant";
            CapLedgEntry."Plate Variant 2" := "Plate Variant 2";
            CapLedgEntry."Die Number" := "Die Number";
            CapLedgEntry."Part Code" := "Part Code";
            CapLedgEntry."Subcontracting Order No." := "Subcontracting Order No.";

            ProdOrder.Get(ProdOrder.Status::Released, "Order No.");

            ProdOrderLineD.Get(ProdOrder.Status::Released, "Order No.", "Order Line No.");
            Estimate.Reset;
            Estimate.SetRange(Estimate."Product Design Type", ProdOrderLineD."Product Design Type");
            Estimate.SetRange(Estimate."Product Design No.", ProdOrderLineD."Product Design No.");
            Estimate.SetRange(Estimate."Sub Comp No.", ProdOrderLineD."Sub Comp No.");
            if Estimate.FindFirst then begin
                CapLedgEntry."Scrap Weight (Kg)" := ("Scrap Quantity" * Estimate."Per Box Weight (Gms)") / 1000;
                CapLedgEntry."Output Weight (Kg)" := ("Output Quantity" * Estimate."Per Box Weight (Gms)") / 1000;
                CapLedgEntry."Estimate No." := Estimate."Product Design No.";
            end;
            //Deepak
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnBeforePostFlushedConsumpItemJnlLine', '', false, false)]
    local procedure CU22_OnBeforePostFlushedConsumpItemJnlLine(VAR ItemJournalLine: Record "Item Journal Line")
    var
        ILE_Rem: Decimal;
        ProdOrderComp: Record "Prod. Order Component";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
    begin
        // WITH ProdOrderComp DO BEGIN
        //     SETRANGE(Status, Status::Released);
        //     SETRANGE("Prod. Order No.", ItemJournalLine."Order No.");
        //     SETRANGE("Prod. Order Line No.", ItemJournalLine."Order Line No.");
        //     IF FINDSET THEN BEGIN
        //Mpower --
        CLEAR(ILE_Rem);
        Rec_ILE.RESET;
        //  Rec_ILE.SETRANGE(Rec_ILE."Entry Type",Rec_ILE."Entry Type"::Output);
        Rec_ILE.SETRANGE(Rec_ILE.Open, TRUE);
        Rec_ILE.SETRANGE(Rec_ILE.Positive, TRUE);
        Rec_ILE.SETRANGE(Rec_ILE."Item No.", ItemJournalLine."Item No.");
        Rec_ILE.SETRANGE(Rec_ILE."Order No.", ItemJournalLine."Order No.");
        IF Rec_ILE.FINDSET THEN
            REPEAT
                ILE_Rem += Rec_ILE."Remaining Quantity";
            UNTIL Rec_ILE.NEXT = 0;
        IF ItemJournalLine.Quantity > ILE_Rem THEN
            ERROR('You cannot produce more FGS Items %1 then available Sheet in this Job %2', ItemJournalLine.Quantity, ILE_Rem);
        //Mpower ++
    End;
    //END;
    //end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterApplyItemLedgEntrySetFilters', '', false, false)]
    local procedure CU22_OnAfterApplyItemLedgEntrySetFilters(VAR ItemLedgerEntry2: Record "Item Ledger Entry"; ItemLedgerEntry: Record "Item Ledger Entry")
    var
        ItemMaster: Record Item;
    begin
        // Lines added BY Deepak Kumar for Item Application Sales
        IF ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Sale THEN BEGIN
            //ItemLedgEntry2.SETRANGE(ItemLedgEntry2."Order Type",ItemLedgEntry2."Order Type"::Production); //Mpower
            ItemLedgerEntry2.SETRANGE(ItemLedgerEntry2."Order No.", ItemLedgerEntry."Prod. Order (Sale)");
        END;
        //Deepak Marked For Item Application
        //Binay 01/12/17  Begin
        ItemMaster.RESET;
        ItemMaster.SETRANGE(ItemMaster."No.", ItemLedgerEntry."Item No.");
        IF ItemMaster.FINDFIRST THEN BEGIN
            IF (ItemMaster."Replenishment System" = ItemMaster."Replenishment System"::"Prod. Order")
               AND (ItemLedgerEntry."Order No." <> '') THEN
                ItemLedgerEntry2.SETRANGE(ItemLedgerEntry2."Order No.", ItemLedgerEntry."Order No.");
        END;
        //Binay 01/12/17  Begin
    end;
    //Needs to check with 2 subscriber
    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure CU22_OnAfterInitItemLedgEntry(VAR NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; VAR ItemLedgEntryNo: Integer)
    var
        ItemMaster: Record Item;
        ProdOrderLineD: Record "Prod. Order Line";
        ProdOrder: Record "Production Order";
    begin
        // Lines added by Deepak kumar//Samadhan
        NewItemLedgEntry."Schedule Doc. No." := ItemJournalLine."Schedule Doc. No.";
        NewItemLedgEntry."Employee Code" := ItemJournalLine."Employee Code";
        NewItemLedgEntry."Employee Name" := ItemJournalLine."Employee Name";
        NewItemLedgEntry."Quantity In PCS" := ItemJournalLine."Quantity In PCS";
        NewItemLedgEntry."Make Ready Qty" := ItemJournalLine."Make Ready Qty";
        NewItemLedgEntry."Additional Output" := ItemJournalLine."Additional Output";
        NewItemLedgEntry."Paper Position" := ItemJournalLine."Paper Position";
        NewItemLedgEntry."Subcontracting Order No." := ItemJournalLine."Subcontracting Order No.";
        ItemMaster.GET(ItemJournalLine."Item No.");
        NewItemLedgEntry."Paper Type" := ItemMaster."Paper Type";
        NewItemLedgEntry."Paper GSM" := FORMAT(ItemMaster."Paper GSM");
        NewItemLedgEntry."Deckle Size (mm)" := ItemMaster."Deckle Size (mm)";
        NewItemLedgEntry."Scrap Code" := ItemJournalLine."Scrap Code"; //Firoz 16-07-16
        NewItemLedgEntry."Paper Position" := ItemJournalLine."Paper Position";
        NewItemLedgEntry."Take Up" := ItemJournalLine."Take Up";
        NewItemLedgEntry."Flute Type" := ItemJournalLine."Flute Type";
        //  ItemLedgEntry.ORIGIN:=  ItemD.ORIGIN;
        //  ItemLedgEntry."Duplex Length":=ItemD."Duplex Length (CM)";
        //  ItemLedgEntry."Duplex Width":=ItemD."Duplex Width (CM)";
        IF (ItemJournalLine."Production Order Sam" <> '') AND (ItemJournalLine."Order No." = '') THEN
            NewItemLedgEntry."Order No." := ItemJournalLine."Production Order Sam";
        //    ItemLedgEntry."Order Line No." := "Prod. Order Line No. Sam";
        //Mpower --
        NewItemLedgEntry."Salesperson Code" := ItemJournalLine."Salesperson Code";
        NewItemLedgEntry."Sales Order No." := ItemJournalLine."Sales Order No.";
        //Mpower ++
        IF ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Output THEN BEGIN
            ProdOrderLineD.GET(ProdOrder.Status::Released, ItemJournalLine."Order No.", ItemJournalLine."Order Line No.");
            Estimate.RESET;
            Estimate.SETRANGE(Estimate."Product Design Type", ProdOrderLineD."Product Design Type");
            Estimate.SETRANGE(Estimate."Product Design No.", ProdOrderLineD."Product Design No.");
            Estimate.SETRANGE(Estimate."Sub Comp No.", ProdOrderLineD."Sub Comp No.");
            IF Estimate.FINDFIRST THEN BEGIN
                NewItemLedgEntry."Standard Output Weight" := (ItemJournalLine."Output Quantity" * Estimate."Per Box Weight (Gms)") / 1000;
            END;
        END;
        //Deepak
        NewItemLedgEntry."Old Production Order No." := ItemJournalLine."Old Production Order No.";
        NewItemLedgEntry."Old Prod. Order Line No." := ItemJournalLine."Old Prod. Order Line No.";
        NewItemLedgEntry."Old Prod. Order Item No." := ItemJournalLine."Old Prod. Order Item No.";
        NewItemLedgEntry."Other Consumption Type" := ItemJournalLine."Other Consumption Type";//Deepak
        NewItemLedgEntry."Requisition No." := ItemJournalLine."Requisition No.";
        NewItemLedgEntry."Requisition Line No." := ItemJournalLine."Requisition Line No.";
        NewItemLedgEntry."Origin Purch. Rcpt No." := ItemJournalLine."Origin Purch. Rcpt No.";
        NewItemLedgEntry."Origin Purch. Rcpt L No." := ItemJournalLine."Origin Purch. Rcpt L No.";
        NewItemLedgEntry."Final Location" := ItemJournalLine."Final Location";
        NewItemLedgEntry."Prod. Order (Sale)" := ItemJournalLine."Production Order Sam";
        //End Deepak
        // Stop   B2BPLM1.00.00 - 01
        NewItemLedgEntry."Machine Id" := ItemJournalLine."Machine Id";
        // Stop   B2BPLM1.00.00 - 01
        NewItemLedgEntry.TestField("Posting Date");
        NewItemLedgEntry.TestField("Document No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnBeforeInsertItemLedgEntry', '', false, false)]
    local procedure CU22_OnBeforeInsertItemLedgEntry(VAR ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        ProductionOrder: Record "Production Order";
        ReturnReceiptHeader: Record "Return Receipt Header";
        RequisitionLineSAM: Record 50033;
        POComponent: Record 5407;
    begin
        //Mpower
        SalesShipmentHeader.RESET;
        SalesShipmentHeader.SETRANGE(SalesShipmentHeader."No.", ItemLedgerEntry."Document No.");
        IF SalesShipmentHeader.FINDFIRST THEN BEGIN
            ItemLedgerEntry."Sales Order No." := SalesShipmentHeader."Order No.";
            ItemLedgerEntry."Salesperson Code" := SalesShipmentHeader."Salesperson Code";
        END;

        ReturnReceiptHeader.RESET;
        ReturnReceiptHeader.SETRANGE(ReturnReceiptHeader."No.", ItemLedgerEntry."Document No.");
        IF ReturnReceiptHeader.FINDFIRST THEN BEGIN
            ItemLedgerEntry."Sales Order No." := ReturnReceiptHeader."Return Order No.";
            ItemLedgerEntry."Salesperson Code" := ReturnReceiptHeader."Salesperson Code";
        END;

        //Mpower
        ProductionOrder.RESET;
        ProductionOrder.SETRANGE("No.", ItemLedgerEntry."Order No.");
        IF ProductionOrder.FINDFIRST THEN BEGIN
            ItemLedgerEntry."Sales Order No." := ProductionOrder."Sales Order No.";
            ItemLedgerEntry."Salesperson Code" := ProductionOrder."Salesperson Code";
        END;
        IF (ItemLedgerEntry."Entry Type" IN [ItemLedgerEntry."Entry Type"::Consumption]) AND (ItemLedgerEntry."Requisition No." <> '') THEN BEGIN
            RequisitionLineSAM.SETRANGE("Requisition No.", ItemLedgerEntry."Requisition No.");
            RequisitionLineSAM.SETRANGE("Requisition Line No.", ItemLedgerEntry."Requisition Line No.");
            RequisitionLineSAM.SETRANGE("Item No.", ItemLedgerEntry."Item No.");
            IF RequisitionLineSAM.FINDFIRST THEN BEGIN
                ItemLedgerEntry."Paper Position" := RequisitionLineSAM."Paper Position";
                POComponent.RESET;
                POComponent.SETRANGE(POComponent."Prod. Order No.", ItemLedgerEntry."Order No.");
                POComponent.SETRANGE(POComponent."Prod. Order Line No.", ItemLedgerEntry."Order Line No.");
                POComponent.SETRANGE(POComponent."Item No.", ItemLedgerEntry."Item No.");
                POComponent.SETRANGE(POComponent."Paper Position", RequisitionLineSAM."Paper Position");
                IF POComponent.FINDFIRST THEN BEGIN
                    ItemLedgerEntry."Take Up" := POComponent."Take Up";
                    ItemLedgerEntry."Flute Type" := POComponent."Flute Type";
                END;
            END;
        END;
        //Mpower

    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterInsertItemLedgEntry', '', false, false)]
    local procedure CU22_OnAfterInsertItemLedgEntry(VAR ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    var
        RequisitionLineSamadhan: Record "Requisition Line SAM";
    begin
        // Lines added By Deepak Kumar
        IF (ItemLedgerEntry."Requisition No." <> '') AND (ItemLedgerEntry."Requisition Line No." <> 0) THEN BEGIN
            RequisitionLineSamadhan.GET(ItemLedgerEntry."Requisition No.", ItemLedgerEntry."Requisition Line No.");
            RequisitionLineSamadhan.UpdateQuantity();
            RequisitionLineSamadhan.MODIFY(TRUE);
        END;
    end;

    // [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterInsertCapLedgEntry', '', false, false)]
    // local procedure CU22_OnAfterInsertCapLedgEntry(VAR CapLedgEntry: Record "Capacity Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    // var
    //     Item: Record Item;
    //     CapQty: Decimal;
    // begin
    //     InsertEquipmentLedgEntry(EquipLedgEntry, ItemJournalLine."Stop Time", ItemJournalLine."Stop Time", ItemJournalLine, CapLedgEntry."Last Output Line");
    //     InsertEquLedgEntryMacenters(EquipLedgEntry, ItemJournalLine."Stop Time", ItemJournalLine."Stop Time", ItemJournalLine, CapLedgEntry."Last Output Line");
    //     MfgSetup.Get();

    //     with ItemJournalLine do begin
    //         if "Unit Cost Calculation" = "Unit Cost Calculation"::Time then begin
    //             if MfgSetup."Cost Incl. Setup" then
    //                 CapQty := "Setup Time" + "Run Time"
    //             else
    //                 CapQty := "Run Time";
    //         end else
    //             CapQty := Quantity + "Scrap Quantity";
    //     end;
    //     if ItemJournalLine.Subcontracting then begin
    //         InsertEquipmentLedgEntry(EquipLedgEntry, ItemJournalLine.Quantity, ItemJournalLine."Invoiced Quantity", ItemJournalLine, CapLedgEntry."Last Output Line");
    //         InsertEquLedgEntryMacenters(EquipLedgEntry, ItemJournalLine.Quantity, ItemJournalLine."Invoiced Quantity", ItemJournalLine, CapLedgEntry."Last Output Line");
    //     end else begin
    //         InsertEquipmentLedgEntry(EquipLedgEntry, CapQty, CapQty, ItemJournalLine, CapLedgEntry."Last Output Line");
    //         InsertEquLedgEntryMacenters(EquipLedgEntry, CapQty, CapQty, ItemJournalLine, CapLedgEntry."Last Output Line");
    //     end;
    // end;

    // local procedure InsertEquipmentLedgEntry(var EquipmentLedgerEntry: Record "Equipment Ledger Entry"; Qty: Decimal; InvdQty: Decimal; ItemJnlLine: Record "Item Journal Line"; LastOperation: Boolean)
    // var
    //     Machine: Record Equipment;
    //     EquipmentLedgerEntryNo: Integer;
    //     WorkCenter: Record "Work Center";
    // begin
    //     WorkCenter.Reset;
    //     WorkCenter.SetRange("No.", ItemJnlLine."No.");
    //     if WorkCenter.FindFirst then begin
    //         Machine.SetRange(Type, Machine.Type::"Work Center");
    //         Machine.SetRange("M/W No.", WorkCenter."No.");
    //         Machine.SetRange("Is In Use", true);
    //         if Machine.FindFirst then begin
    //             repeat
    //                 if EquipmentLedgerEntryNo = 0 then begin
    //                     EquipmentLedgerEntry.LockTable;
    //                     if EquipmentLedgerEntry.FindLast then
    //                         EquipmentLedgerEntryNo := EquipmentLedgerEntry."Entry No.";
    //                 end;
    //                 EquipmentLedgerEntryNo := EquipmentLedgerEntryNo + 1;

    //                 EquipmentLedgerEntry.Init;
    //                 EquipmentLedgerEntry."Entry No." := EquipmentLedgerEntryNo;
    //                 EquipmentLedgerEntry."Operation No." := ItemJnlLine."Operation No.";
    //                 EquipmentLedgerEntry.Type := ItemJnlLine.Type;
    //                 EquipmentLedgerEntry."No." := ItemJnlLine."No.";
    //                 //B2BPLM <<
    //                 EquipmentLedgerEntry."Machine Id" := ItemJnlLine."Machine Id";//B2BPLM
    //                                                                               //B2BPLM >>
    //                 EquipmentLedgerEntry.Description := ItemJnlLine.Description;
    //                 EquipmentLedgerEntry."Work Center No." := ItemJnlLine."Work Center No.";
    //                 EquipmentLedgerEntry."Work Center Group Code" := ItemJnlLine."Work Center Group Code";
    //                 EquipmentLedgerEntry.Subcontracting := ItemJnlLine.Subcontracting;

    //                 EquipmentLedgerEntry.Quantity := Qty;
    //                 EquipmentLedgerEntry."Invoiced Quantity" := InvdQty;
    //                 EquipmentLedgerEntry."Completely Invoiced" := EquipmentLedgerEntry."Invoiced Quantity" = EquipmentLedgerEntry.Quantity;

    //                 EquipmentLedgerEntry."Setup Time" := ItemJnlLine."Setup Time";
    //                 EquipmentLedgerEntry."Run Time" := ItemJnlLine."Run Time";
    //                 EquipmentLedgerEntry."Stop Time" := ItemJnlLine."Stop Time";

    //                 if ItemJnlLine."Unit Cost Calculation" = ItemJnlLine."Unit Cost Calculation"::Time then begin
    //                     EquipmentLedgerEntry."Cap. Unit of Measure Code" := ItemJnlLine."Cap. Unit of Measure Code";
    //                     EquipmentLedgerEntry."Qty. per Cap. Unit of Measure" := ItemJnlLine."Qty. per Cap. Unit of Measure";
    //                 end;

    //                 EquipmentLedgerEntry."Item No." := ItemJnlLine."Item No.";
    //                 EquipmentLedgerEntry."Variant Code" := ItemJnlLine."Variant Code";
    //                 EquipmentLedgerEntry."Output Quantity" := ItemJnlLine."Output Quantity";
    //                 EquipmentLedgerEntry."Scrap Quantity" := ItemJnlLine."Scrap Quantity";
    //                 EquipmentLedgerEntry."Unit of Measure Code" := ItemJnlLine."Unit of Measure Code";
    //                 EquipmentLedgerEntry."Qty. per Unit of Measure" := ItemJnlLine."Qty. per Unit of Measure";

    //                 EquipmentLedgerEntry."Prod. Order No." := ItemJnlLine."Order No.";
    //                 EquipmentLedgerEntry."Prod. Order Line No." := ItemJnlLine."Order Line No.";
    //                 EquipmentLedgerEntry."Routing No." := ItemJnlLine."Routing No.";
    //                 EquipmentLedgerEntry."Routing Reference No." := ItemJnlLine."Routing Reference No.";
    //                 EquipmentLedgerEntry."Operation No." := ItemJnlLine."Operation No.";

    //                 EquipmentLedgerEntry."Posting Date" := ItemJnlLine."Posting Date";
    //                 EquipmentLedgerEntry."Document Date" := ItemJnlLine."Document Date";
    //                 EquipmentLedgerEntry."Document No." := ItemJnlLine."Document No.";
    //                 EquipmentLedgerEntry."External Document No." := ItemJnlLine."External Document No.";

    //                 EquipmentLedgerEntry."Starting Time" := ItemJnlLine."Starting Time";
    //                 EquipmentLedgerEntry."Ending Time" := ItemJnlLine."Ending Time";
    //                 EquipmentLedgerEntry."Concurrent Capacity" := ItemJnlLine."Concurrent Capacity";
    //                 EquipmentLedgerEntry."Work Shift Code" := ItemJnlLine."Work Shift Code";

    //                 EquipmentLedgerEntry."Stop Code" := ItemJnlLine."Stop Code";
    //                 EquipmentLedgerEntry."Scrap Code" := ItemJnlLine."Scrap Code";
    //                 EquipmentLedgerEntry."Last Output Line" := LastOperation;

    //                 EquipmentLedgerEntry."Global Dimension 1 Code" := ItemJnlLine."Shortcut Dimension 1 Code";
    //                 EquipmentLedgerEntry."Global Dimension 2 Code" := ItemJnlLine."Shortcut Dimension 2 Code";
    //                 EquipmentLedgerEntry."Machine Id" := Machine."No.";
    //                 EquipmentLedgerEntry.Insert;
    //             until Machine.Next = 0;
    //         end;
    //     end;
    // end;

    // local procedure InsertEquLedgEntryMacenters(var EquipmentLedgerEntry: Record "Equipment Ledger Entry"; Qty: Decimal; InvdQty: Decimal; ItemJnlLine: Record "Item Journal Line"; LastOperation: Boolean)
    // var
    //     Machine: Record Equipment;
    //     EquipmentLedgerEntryNo: Integer;
    //     MachineCenter: Record "Machine Center";
    // begin
    //     MachineCenter.Reset;
    //     MachineCenter.SetRange("No.", ItemJnlLine."No.");
    //     if MachineCenter.FindFirst then begin
    //         Machine.SetRange(Type, Machine.Type::"Machine Center");
    //         Machine.SetRange("M/W No.", MachineCenter."No.");
    //         Machine.SetRange("Is In Use", true);
    //         if Machine.FindFirst then begin
    //             repeat
    //                 if EquipmentLedgerEntryNo = 0 then begin
    //                     EquipmentLedgerEntry.LockTable;
    //                     if EquipmentLedgerEntry.FindLast then
    //                         EquipmentLedgerEntryNo := EquipmentLedgerEntry."Entry No.";
    //                 end;
    //                 EquipmentLedgerEntryNo := EquipmentLedgerEntryNo + 1;

    //                 EquipmentLedgerEntry.Init;
    //                 EquipmentLedgerEntry."Entry No." := EquipmentLedgerEntryNo;
    //                 EquipmentLedgerEntry."Operation No." := ItemJnlLine."Operation No.";
    //                 EquipmentLedgerEntry.Type := ItemJnlLine.Type;
    //                 EquipmentLedgerEntry."No." := ItemJnlLine."No.";
    //                 //B2BPLM <<
    //                 EquipmentLedgerEntry."Machine Id" := ItemJnlLine."Machine Id";//B2BPLM
    //                                                                               //B2BPLM >>
    //                 EquipmentLedgerEntry.Description := ItemJnlLine.Description;
    //                 EquipmentLedgerEntry."Work Center No." := ItemJnlLine."Work Center No.";
    //                 EquipmentLedgerEntry."Work Center Group Code" := ItemJnlLine."Work Center Group Code";
    //                 EquipmentLedgerEntry.Subcontracting := ItemJnlLine.Subcontracting;

    //                 EquipmentLedgerEntry.Quantity := Qty;
    //                 EquipmentLedgerEntry."Invoiced Quantity" := InvdQty;
    //                 EquipmentLedgerEntry."Completely Invoiced" := EquipmentLedgerEntry."Invoiced Quantity" = EquipmentLedgerEntry.Quantity;

    //                 EquipmentLedgerEntry."Setup Time" := ItemJnlLine."Setup Time";
    //                 EquipmentLedgerEntry."Run Time" := ItemJnlLine."Run Time";
    //                 EquipmentLedgerEntry."Stop Time" := ItemJnlLine."Stop Time";

    //                 if ItemJnlLine."Unit Cost Calculation" = ItemJnlLine."Unit Cost Calculation"::Time then begin
    //                     EquipmentLedgerEntry."Cap. Unit of Measure Code" := ItemJnlLine."Cap. Unit of Measure Code";
    //                     EquipmentLedgerEntry."Qty. per Cap. Unit of Measure" := ItemJnlLine."Qty. per Cap. Unit of Measure";
    //                 end;

    //                 EquipmentLedgerEntry."Item No." := ItemJnlLine."Item No.";
    //                 EquipmentLedgerEntry."Variant Code" := ItemJnlLine."Variant Code";
    //                 EquipmentLedgerEntry."Output Quantity" := ItemJnlLine."Output Quantity";
    //                 EquipmentLedgerEntry."Scrap Quantity" := ItemJnlLine."Scrap Quantity";
    //                 EquipmentLedgerEntry."Unit of Measure Code" := ItemJnlLine."Unit of Measure Code";
    //                 EquipmentLedgerEntry."Qty. per Unit of Measure" := ItemJnlLine."Qty. per Unit of Measure";

    //                 EquipmentLedgerEntry."Prod. Order No." := ItemJnlLine."Order No.";
    //                 EquipmentLedgerEntry."Prod. Order Line No." := ItemJnlLine."Order Line No.";
    //                 EquipmentLedgerEntry."Routing No." := ItemJnlLine."Routing No.";
    //                 EquipmentLedgerEntry."Routing Reference No." := ItemJnlLine."Routing Reference No.";
    //                 EquipmentLedgerEntry."Operation No." := ItemJnlLine."Operation No.";

    //                 EquipmentLedgerEntry."Posting Date" := ItemJnlLine."Posting Date";
    //                 EquipmentLedgerEntry."Document Date" := ItemJnlLine."Document Date";
    //                 EquipmentLedgerEntry."Document No." := ItemJnlLine."Document No.";
    //                 EquipmentLedgerEntry."External Document No." := ItemJnlLine."External Document No.";

    //                 EquipmentLedgerEntry."Starting Time" := ItemJnlLine."Starting Time";
    //                 EquipmentLedgerEntry."Ending Time" := ItemJnlLine."Ending Time";
    //                 EquipmentLedgerEntry."Concurrent Capacity" := ItemJnlLine."Concurrent Capacity";
    //                 EquipmentLedgerEntry."Work Shift Code" := ItemJnlLine."Work Shift Code";

    //                 EquipmentLedgerEntry."Stop Code" := ItemJnlLine."Stop Code";
    //                 EquipmentLedgerEntry."Scrap Code" := ItemJnlLine."Scrap Code";
    //                 EquipmentLedgerEntry."Last Output Line" := LastOperation;

    //                 EquipmentLedgerEntry."Global Dimension 1 Code" := ItemJnlLine."Shortcut Dimension 1 Code";
    //                 EquipmentLedgerEntry."Global Dimension 2 Code" := ItemJnlLine."Shortcut Dimension 2 Code";
    //                 EquipmentLedgerEntry."Machine Id" := Machine."No.";
    //                 EquipmentLedgerEntry.Insert;
    //             until Machine.Next = 0;
    //         end;
    //     end;
    // end;

    procedure PostWHJnlLine(ItemJnlLine: Record "Item Journal Line"; OriginalQuantity: Decimal; OriginalQuantityBase: Decimal)
    var
        WhseJnlLine: Record "Warehouse Journal Line";
        TempWhseJnlLine2: Record "Warehouse Journal Line" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        TempHandlingSpecification: Record "Tracking Specification" temporary;
        ItemJnlTemplate: Record "Item Journal Template";
        WMSMgmt: Codeunit "WMS Management";
        WhseJnlPostLine: Codeunit "Whse. Jnl.-Register Line";

    begin
        //B2BPLM2.00.00  Added by ADSK1.0
        with ItemJnlLine do begin
            Quantity := OriginalQuantity;
            "Quantity (Base)" := OriginalQuantityBase;
            GetLocation("Location Code");
            if ("Entry Type" in ["Entry Type"::"Negative Adjmt."]) then
                if Location."Bin Mandatory" then
                    if WMSMgmt.CreateWhseJnlLine(ItemJnlLine, ItemJnlTemplate.Type, WhseJnlLine, false) then begin
                        ItemTrackingMgt.SplitWhseJnlLine(WhseJnlLine, TempWhseJnlLine2, TempHandlingSpecification, false);
                        if TempWhseJnlLine2.FindSet then
                            repeat
                                WMSMgmt.CheckWhseJnlLine(TempWhseJnlLine2, 1, 0, false);
                                WhseJnlPostLine.Run(TempWhseJnlLine2);
                            until TempWhseJnlLine2.Next = 0;
                    end;
        end;
        //B2BPLM2.00.00  Added by ADSK1.0
    end;

    procedure "Un-Apply&Apply"(ItemFilter: Text[250]; LocationFilter: Text[250]; DocumentFilter: Text[250]; ItemCategoryFilter: Text[250])
    var
        ILE: Record "Item Ledger Entry";
        InventoryPeriod: Record "Inventory Period";
        InventoryOpenedFrom: Date;
        ItemApplEntry: Record "Item Application Entry";
        IJNL_Post_Line: Codeunit "Item Jnl.-Post Line";
        Applied_ILE: Record "Item Ledger Entry";
    begin
        ILE.Reset;
        if ItemFilter <> '' then
            ILE.SetRange(ILE."Item No.", ItemFilter);
        InventoryPeriod.IsValidDate(InventoryOpenedFrom);
        if InventoryOpenedFrom <> 0D then
            ILE.SetFilter(ILE."Posting Date", '%1..', CalcDate('<+1D>', InventoryOpenedFrom));

        if LocationFilter <> '' then
            ILE.SetRange(ILE."Location Code", LocationFilter);

        if DocumentFilter <> '' then
            ILE.SetRange(ILE."Document No.", DocumentFilter);

        if ItemCategoryFilter <> '' then
            ILE.SetRange(ILE."Item Category Code", ItemCategoryFilter);

        ILE.SetRange(ILE.Positive, true);
        ILE.SetRange(ILE."Exception D", false);
        if ILE.FindFirst then begin
            repeat
                ItemApplEntry.Reset;
                ItemApplEntry.SetRange(ItemApplEntry."Inbound Item Entry No.", ILE."Entry No.");
                ItemApplEntry.SetFilter(ItemApplEntry."Outbound Item Entry No.", '<>%1', 0);
                if ItemApplEntry.FindFirst then
                    repeat
                        Applied_ILE.Get(ItemApplEntry."Outbound Item Entry No.");
                        ItemApplEntry."Outbound Posting Date" := Applied_ILE."Posting Date";
                        ItemApplEntry.Modify(true);
                    until ItemApplEntry.Next = 0;

                ItemApplEntry.Reset;
                ItemApplEntry.SetRange(ItemApplEntry."Inbound Item Entry No.", ILE."Entry No.");
                ItemApplEntry.SetFilter(ItemApplEntry."Outbound Item Entry No.", '<>%1', 0);
                ItemApplEntry.SetFilter(ItemApplEntry."Outbound Posting Date", '%1..', CalcDate('<+1D>', InventoryOpenedFrom));
                if ItemApplEntry.FindFirst then
                    repeat
                        IJNL_Post_Line.UnApply(ItemApplEntry);
                    until ItemApplEntry.Next = 0;
            until ILE.Next = 0;
        end;
        ILE.Reset;
        if ItemFilter <> '' then
            ILE.SetRange(ILE."Item No.", ItemFilter);

        InventoryPeriod.IsValidDate(InventoryOpenedFrom);
        if InventoryOpenedFrom <> 0D then
            ILE.SetFilter(ILE."Posting Date", '%1..', CalcDate('<+1D>', InventoryOpenedFrom));

        if LocationFilter <> '' then
            ILE.SetRange(ILE."Location Code", LocationFilter);

        if DocumentFilter <> '' then
            ILE.SetRange(ILE."Document No.", DocumentFilter);

        if ItemCategoryFilter <> '' then
            ILE.SetRange(ILE."Item Category Code", ItemCategoryFilter);

        ILE.SetRange(ILE.Open, true);
        //ILE.SETRANGE(ILE."Mark for Re-Application",TRUE);
        ILE.SetRange(ILE."Exception D", false);
        if ILE.FindFirst then begin
            repeat
                if ILE."Remaining Quantity" <> ILE.Quantity then begin
                    ILE."Remaining Quantity" := ILE.Quantity;
                    ILE.Modify(true);
                end;
                ILE."Mark for Re-Application" := false;
                ILE.Modify(true);
                TouchEntryNew(ILE."Entry No.");
            until ILE.Next = 0;
            IJNL_Post_Line.RedoApplications;
            IJNL_Post_Line.CostAdjust;
        end;
        MESSAGE('Complete');

    end;

    procedure Mark_for_Application(Category_Code: Code[20])
    var
        ItemCat: Record "Item Category";
        ItemApplEntry: Record "Item Application Entry";
        ILE_Sam: Record "Item Ledger Entry";
        ILE_Inbound: Record "Item Ledger Entry";
        ILE_Outbound: Record "Item Ledger Entry";
        Item_Sam: Record "Item Ledger Entry";
        InventoryPeriod: Record "Inventory Period";
        InventoryOpenedFrom: Date;
    begin



        ItemCat.Reset;
        ItemCat.SetRange(ItemCat.Code, Category_Code);
        ItemCat.SetRange(ItemCat."Def. Replenishment System", ItemCat."Def. Replenishment System"::"Prod. Order");
        if ItemCat.FindFirst then begin
            //1. Update Item Category, Inbound & Outbound Order No
            ILE_Sam.Reset;
            ILE_Sam.SetRange(ILE_Sam."Item Category Code", ItemCat.Code);
            ILE_Sam.SetRange(ILE_Sam.Positive, false);
            if ILE_Sam.FindFirst then begin
                repeat
                    ItemApplEntry.Reset;
                    ItemApplEntry.SetRange(ItemApplEntry."Item Ledger Entry No.", ILE_Sam."Entry No.");
                    if ItemApplEntry.FindFirst then begin
                        repeat
                            ItemApplEntry."Item Category Code" := ILE_Sam."Item Category Code";
                            if (ItemApplEntry."Inbound Item Entry No." <> 0) then
                                ILE_Inbound.Get(ItemApplEntry."Inbound Item Entry No.");
                            ItemApplEntry."Inbound Order No." := ILE_Inbound."Order No.";

                            ILE_Outbound.Get(ItemApplEntry."Outbound Item Entry No.");
                            ItemApplEntry."Outbound Order No." := ILE_Outbound."Order No.";

                            ItemApplEntry.Modify(true);
                        until ItemApplEntry.Next = 0;
                    end;
                until ILE_Sam.Next = 0;
            end;

            //2. Mark ILE where Item Application Entry Inbound Order No <> Outbound Order No
            ItemApplEntry.Reset;
            ItemApplEntry.SetRange(ItemApplEntry."Item Category Code", ItemCat.Code);
            if ItemApplEntry.FindFirst then begin
                repeat
                    if ItemApplEntry."Inbound Order No." <> ItemApplEntry."Outbound Order No." then begin
                        ILE_Inbound.Get(ItemApplEntry."Inbound Item Entry No.");
                        ILE_Inbound."Mark for Re-Application" := true;
                        ILE_Inbound.Modify(true);

                        ILE_Sam.Reset;
                        InventoryPeriod.IsValidDate(InventoryOpenedFrom);
                        if InventoryOpenedFrom <> 0D then
                            ILE_Sam.SetFilter(ILE_Sam."Posting Date", '%1..', CalcDate('<+1D>', InventoryOpenedFrom));

                        ILE_Sam.SetRange(ILE_Sam."Item No.", ILE_Inbound."Item No.");
                        if ILE_Sam.FindFirst then
                            ILE_Sam.ModifyAll(ILE_Sam."Mark for Re-Application", true);
                    end;
                until ItemApplEntry.Next = 0;
            end;
        end;

    end;

    procedure TransferToNegativePositive(ItemFilter: Text[250]; LocationFilter: Text[250]; DocumentFilter: Text[250]; ItemCategoryFilter: Text[250])
    var
        ILE: Record "Item Ledger Entry";
        InventoryPeriod: Record "Inventory Period";
        InventoryOpenedFrom: Date;
        ItemApplEntry: Record "Item Application Entry";
        IJNL_Post_Line: Codeunit "Item Jnl.-Post Line";
        Applied_ILE: Record "Item Ledger Entry";
        ILE2: Record "Item Ledger Entry";
    begin
        ILE.Reset;
        if ItemFilter <> '' then
            ILE.SetRange(ILE."Item No.", ItemFilter);
        InventoryPeriod.IsValidDate(InventoryOpenedFrom);
        if InventoryOpenedFrom <> 0D then
            ILE.SetFilter(ILE."Posting Date", '%1..', CalcDate('<+1D>', InventoryOpenedFrom));


        ILE.SetRange(ILE."Entry Type", ILE."Entry Type"::Transfer);
        if ILE.FindFirst then begin
            repeat
                if ILE.Positive then begin
                    ItemApplEntry.Reset;
                    ItemApplEntry.SetRange(ItemApplEntry."Item Ledger Entry No.", ILE."Entry No.");
                    if ItemApplEntry.FindFirst then begin
                        ILE."Transfer From Entry No D" := ItemApplEntry."Transferred-from Entry No.";
                        ILE."OutBound Entry No" := ItemApplEntry."Outbound Item Entry No.";
                        ItemApplEntry."Cost Application" := false;
                        ILE.Modify(true);
                        ItemApplEntry."Transferred-from Entry No." := 0;
                        ItemApplEntry.Modify(true);
                    end;
                end;

                ILE."Entry Type D" := ILE."Entry Type";
                if ILE.Positive = true then begin
                    ILE."Entry Type" := ILE."Entry Type"::"Positive Adjmt.";
                end else begin
                    ILE."Entry Type" := ILE."Entry Type"::"Negative Adjmt.";
                end;

                ILE.Modify(true);
            until ILE.Next = 0;
        end;

        ILE.Reset;
        if ItemFilter <> '' then
            ILE.SetRange(ILE."Item No.", ItemFilter);
        InventoryPeriod.IsValidDate(InventoryOpenedFrom);
        if InventoryOpenedFrom <> 0D then
            ILE.SetFilter(ILE."Posting Date", '%1..', CalcDate('<+1D>', InventoryOpenedFrom));
        if ILE.FindFirst then begin
            repeat
                ItemApplEntry.Reset;
                ItemApplEntry.SetRange(ItemApplEntry."Item Ledger Entry No.", ILE."Entry No.");
                if ItemApplEntry.FindFirst then begin
                    ItemApplEntry."Cost Application" := false;
                    ItemApplEntry.Modify(true);
                end;
            until ILE.Next = 0;
        end;






        ILE.Reset;
        if ItemFilter <> '' then
            ILE.SetRange(ILE."Item No.", ItemFilter);
        InventoryPeriod.IsValidDate(InventoryOpenedFrom);
        if InventoryOpenedFrom <> 0D then
            ILE.SetFilter(ILE."Posting Date", '%1..', CalcDate('<+1D>', InventoryOpenedFrom));
        if ILE.FindFirst then begin
            repeat
                ILE."Exception D" := false;
                ILE.Modify(true);
            until ILE.Next = 0;
        end;

        ILE.Reset;
        if ItemFilter <> '' then
            ILE.SetRange(ILE."Item No.", ItemFilter);
        InventoryPeriod.IsValidDate(InventoryOpenedFrom);
        if InventoryOpenedFrom <> 0D then
            ILE.SetFilter(ILE."Posting Date", '%1..', CalcDate('<+1D>', InventoryOpenedFrom));
        ILE.SetRange(ILE.Correction, true);
        if ILE.FindFirst then begin
            repeat

                ILE2.Reset;
                ILE2.SetRange(ILE2."Entry No.", ILE."Applies-to Entry");
                if ILE2.FindFirst then begin
                    ILE2."Exception D" := true;
                    ILE2.Modify(true);
                end;
                ILE."Exception D" := true;
                ILE.Modify(true);
            until ILE.Next = 0;
        end;

        //MESSAGE('Complete');
    end;

    procedure NegativePositiveTransfer(ItemFilter: Text[250]; LocationFilter: Text[250]; DocumentFilter: Text[250]; ItemCategoryFilter: Text[250])
    var
        ILE: Record "Item Ledger Entry";
        InventoryPeriod: Record "Inventory Period";
        InventoryOpenedFrom: Date;
        ItemApplEntry: Record "Item Application Entry";
        IJNL_Post_Line: Codeunit "Item Jnl.-Post Line";
        Applied_ILE: Record "Item Ledger Entry";
    begin
        ILE.Reset;
        if ItemFilter <> '' then
            ILE.SetRange(ILE."Item No.", ItemFilter);
        InventoryPeriod.IsValidDate(InventoryOpenedFrom);
        if InventoryOpenedFrom <> 0D then
            ILE.SetFilter(ILE."Posting Date", '%1..', CalcDate('<+1D>', InventoryOpenedFrom));


        ILE.SetRange(ILE."Entry Type D", ILE."Entry Type D"::Transfer);
        if ILE.FindFirst then begin
            repeat

                ILE."Entry Type" := ILE."Entry Type"::Transfer;
                if ILE.Positive then begin
                    ItemApplEntry.Reset;
                    ItemApplEntry.SetRange(ItemApplEntry."Item Ledger Entry No.", ILE."Entry No.");
                    if ItemApplEntry.FindFirst then begin
                        ItemApplEntry."Transferred-from Entry No." := ILE."Transfer From Entry No D";
                        ItemApplEntry."Outbound Item Entry No." := ILE."OutBound Entry No";
                        ItemApplEntry."Cost Application" := true;
                        ItemApplEntry.Modify(true);
                    end;
                end else begin
                    ItemApplEntry.Reset;
                    ItemApplEntry.SetRange(ItemApplEntry."Item Ledger Entry No.", ILE."Entry No.");
                    if ItemApplEntry.FindFirst then begin
                        ItemApplEntry."Cost Application" := true;
                        ItemApplEntry.Modify(true);
                        ILE."Applies-to Entry" := ItemApplEntry."Inbound Item Entry No.";
                        ILE."Applied Entry to Adjust" := true;
                        ILE.Modify(true);
                    end;
                end;
                ILE."Shipped Qty. Not Returned" := 0;
                ILE.Modify(true);
            until ILE.Next = 0;
        end;

        ILE.Reset;
        if ItemFilter <> '' then
            ILE.SetRange(ILE."Item No.", ItemFilter);
        InventoryPeriod.IsValidDate(InventoryOpenedFrom);
        if InventoryOpenedFrom <> 0D then
            ILE.SetFilter(ILE."Posting Date", '%1..', CalcDate('<+1D>', InventoryOpenedFrom));
        ILE.SetRange(ILE."Entry Type", ILE."Entry Type"::Consumption);
        ILE.SetRange(ILE.Positive, false);
        if ILE.FindFirst then begin
            repeat

                ItemApplEntry.Reset;
                ItemApplEntry.SetRange(ItemApplEntry."Item Ledger Entry No.", ILE."Entry No.");
                if ItemApplEntry.FindFirst then begin
                    // ItemApplEntry."Cost Application":=TRUE;
                    ItemApplEntry."Cost Application" := false;
                    ItemApplEntry.Modify(true);
                    //            ILE."Applies-to Entry":=ItemApplEntry."Inbound Item Entry No.";
                    ILE."Applies-to Entry" := 0;
                    //            ILE."Applied Entry to Adjust":=TRUE;
                    ILE."Applied Entry to Adjust" := false;
                    ILE.Modify(true);
                end;



            until ILE.Next = 0;
        end;



        //MESSAGE('Complete');
    end;

    procedure UpdateTransferEntryNumber(ItemFilter: Text[250]; LocationFilter: Text[250]; DocumentFilter: Text[250]; ItemCategoryFilter: Text[250])
    var
        ILE: Record "Item Ledger Entry";
        InventoryPeriod: Record "Inventory Period";
        InventoryOpenedFrom: Date;
        ItemApplEntry: Record "Item Application Entry";
        IJNL_Post_Line: Codeunit "Item Jnl.-Post Line";
        Applied_ILE: Record "Item Ledger Entry";
    begin
        ILE.Reset;
        if ItemFilter <> '' then
            ILE.SetRange(ILE."Item No.", ItemFilter);
        InventoryPeriod.IsValidDate(InventoryOpenedFrom);
        if InventoryOpenedFrom <> 0D then
            ILE.SetFilter(ILE."Posting Date", '%1..', CalcDate('<+1D>', InventoryOpenedFrom));

        ILE.SetRange("Entry Type D", ILE."Entry Type D"::Transfer);
        if ILE.FindFirst then begin
            repeat
                if ILE.Positive then begin
                    ItemApplEntry.Reset;
                    ItemApplEntry.SetRange(ItemApplEntry."Item Ledger Entry No.", ILE."OutBound Entry No");
                    if ItemApplEntry.FindFirst then begin

                        ILE."Transfer From Entry No D" := ItemApplEntry."Inbound Item Entry No.";
                        ILE.Modify(true);
                    end;
                    ItemApplEntry.Reset;
                    ItemApplEntry.SetRange(ItemApplEntry."Item Ledger Entry No.", ILE."Entry No.");
                    if ItemApplEntry.FindFirst then begin

                        ItemApplEntry."Outbound Item Entry No." := ILE."OutBound Entry No";
                        ItemApplEntry.Modify(true);
                    end;
                end;


            until ILE.Next = 0;
        end;
        //MESSAGE('Complete');
    end;

    procedure TouchEntryNew(EntryNo: Integer)
    var
        TouchedItemLedgEntry: Record "Item Ledger Entry";
    begin
        TouchedItemLedgEntry.Get(EntryNo);
        TouchedItemLedgerEntries := TouchedItemLedgEntry;
        if not TouchedItemLedgerEntries.Insert then;
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Clear(Location)
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;
    //CodeUnit 22 +

    //Codeunit 57 -
    [EventSubscriber(ObjectType::Codeunit, 57, 'OnAfterPurchaseLineSetFilters', '', false, false)]
    local procedure CU57_OnAfterPurchaseLineSetFilters(VAR TotalPurchaseLine: Record "Purchase Line"; PurchaseLine: Record "Purchase Line")
    begin
        if TotalPurchaseLine."Document Type" IN [TotalPurchaseLine."Document Type"::Order,
            TotalPurchaseLine."Document Type"::Quote] then
            TotalPurchaseLine.SETRANGE("For Location Roll Entry", TotalPurchaseLine."For Location Roll Entry"::Mother);
    end;
    //Codeunit 57 +

    //CodeUnit 80 -
    [EventSubscriber(ObjectType::Codeunit, 80, 'OnUpdateBlanketOrderLineOnBeforeInitOutstanding', '', false, false)]
    local procedure CU80_OnUpdateBlanketOrderLineOnBeforeInitOutstanding(VAR BlanketOrderSalesLine: Record "Sales Line"; SalesLine: Record "Sales Line")
    var
        ExtraAllowedQty: Decimal;
        SRSetup: Record "Sales & Receivables Setup";
        BlanketOrderQuantityGreaterThanErr: Label 'in the associated blanket order must not be greater than %1';
        BlanketOrderQuantityReducedErr: Label 'in the associated blanket order must not be reduced';

    begin
        SRSetup.GET;
        ExtraAllowedQty := (BlanketOrderSalesLine.Quantity * SRSetup."Sales Variation Allowed %") / 100;

        BlanketOrderSalesLine.InitOutstanding;
        BlanketOrderSalesLine.InitOutstanding;
        IF ((BlanketOrderSalesLine.Quantity + ExtraAllowedQty) * BlanketOrderSalesLine."Quantity Shipped" < 0) OR
        (ABS(BlanketOrderSalesLine.Quantity + ExtraAllowedQty) < ABS(BlanketOrderSalesLine."Quantity Shipped"))
        THEN
            BlanketOrderSalesLine.FIELDERROR(
            "Quantity Shipped", STRSUBSTNO(
            BlanketOrderQuantityGreaterThanErr,
            BlanketOrderSalesLine.FIELDCAPTION(Quantity)));

        IF (BlanketOrderSalesLine."Quantity (Base)" * BlanketOrderSalesLine."Qty. Shipped (Base)" < 0) OR
        (ABS(BlanketOrderSalesLine."Quantity (Base)") + ExtraAllowedQty < ABS(BlanketOrderSalesLine."Qty. Shipped (Base)"))
        THEN
            BlanketOrderSalesLine.FIELDERROR(
            "Qty. Shipped (Base)",
            STRSUBSTNO(
            BlanketOrderQuantityGreaterThanErr,
            BlanketOrderSalesLine.FIELDCAPTION("Quantity (Base)")));

        BlanketOrderSalesLine.CALCFIELDS("Reserved Qty. (Base)");
        IF ABS(BlanketOrderSalesLine."Outstanding Qty. (Base)" + ExtraAllowedQty) < ABS(BlanketOrderSalesLine."Reserved Qty. (Base)") THEN
            BlanketOrderSalesLine.FIELDERROR(
            "Reserved Qty. (Base)", BlanketOrderQuantityReducedErr);

        BlanketOrderSalesLine."Qty. to Invoice" :=
        BlanketOrderSalesLine.Quantity - BlanketOrderSalesLine."Quantity Invoiced";
        BlanketOrderSalesLine."Qty. to Ship" :=
        BlanketOrderSalesLine.Quantity - BlanketOrderSalesLine."Quantity Shipped";
        BlanketOrderSalesLine."Qty. to Invoice (Base)" :=
        BlanketOrderSalesLine."Quantity (Base)" - BlanketOrderSalesLine."Qty. Invoiced (Base)";
        BlanketOrderSalesLine."Qty. to Ship (Base)" :=
        BlanketOrderSalesLine."Quantity (Base)" - BlanketOrderSalesLine."Qty. Shipped (Base)";

        BlanketOrderSalesLine.MODIFY;
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforePostSalesDoc', '', false, false)]
    local procedure CU80_OnBeforePostSalesDoc(VAR SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    var
        ItemLederEntryD: Record "Item Ledger Entry";
        AvalInventory: Decimal;
        SalesLineD: Record "Sales Line";
        TempQty: Decimal;
        ReturnReason: Record "Return Reason";
        SalesComment: Record "Sales Comment Line";
        SalesSetup: Record "Sales & Receivables Setup";
        Sam001: Label 'The Prescribed enclosure have not been updated , Please update before Posting. Document Name %1';
    begin

        // Lines added by Deepak Kumar
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN BEGIN
            SalesHeader.TESTFIELD(SalesHeader."Driver Name");
            SalesHeader.TESTFIELD(SalesHeader."Vehicle No.");
        END;
        SOrderLine.RESET;
        SOrderLine.SETRANGE(SOrderLine."Document No.", SalesHeader."No.");
        SOrderLine.SETRANGE(SOrderLine."Document Type", SalesHeader."Document Type");
        SOrderLine.SETRANGE(SOrderLine.Type, SOrderLine.Type::Item);
        IF SOrderLine.FINDFIRST THEN BEGIN
            REPEAT
                SOrderLine.TESTFIELD(SOrderLine.Quantity);
                TempQty := 0;
                // Lines updated By Deepak Kumar
                IF (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") THEN BEGIN
                    SOrderLine.TESTFIELD(SOrderLine."Return Reason Code");

                    SalesSetup.GET();
                    ReturnReason.GET(SOrderLine."Return Reason Code");
                    IF ReturnReason."Quality Not Required" = FALSE THEN BEGIN
                        IF (SalesSetup."Quality for Sale Return" = SalesSetup."Quality for Sale Return"::"Before Return Receipt") AND (SalesHeader.Receive) THEN
                            SOrderLine.TESTFIELD(SOrderLine."Quality Inspection Sheet");

                        //              IF (SalesSetup."Quality for Sale Return" = SalesSetup."Quality for Sale Return" ::"After Return Receipt") AND Invoice THEN
                        //                SOrderLine.TESTFIELD(SOrderLine."Quality Inspection Sheet");
                        //MPOWER 260918
                    END;
                END;
                // MESSAGE('Ship %1 Invoice %2 Receive %3',Ship,Invoice,Receive);
                SalesLineD.RESET;
                SalesLineD.SETRANGE(SalesLineD."Document Type", SOrderLine."Document Type");
                SalesLineD.SETRANGE(SalesLineD."Document No.", SOrderLine."Document No.");
                SalesLineD.SETRANGE(SalesLineD.Type, SOrderLine.Type);
                SalesLineD.SETRANGE(SalesLineD."No.", SOrderLine."No.");
                SalesLineD.SETRANGE(SalesLineD."Location Code", SOrderLine."Location Code");
                SalesLineD.SETRANGE(SalesLineD."Variant Code", SOrderLine."Variant Code");
                SalesLineD.SETRANGE(SalesLineD."Prod. Order No.", SOrderLine."Prod. Order No.");
                IF SalesLineD.FINDFIRST THEN BEGIN
                    REPEAT
                        TempQty += SalesLineD."Qty. to Ship";
                    UNTIL SalesLineD.NEXT = 0;
                END;

                // Lines updated BY Deepak Kumar
                IF SOrderLine.Type = SOrderLine.Type::Item THEN BEGIN
                    AvalInventory := 0;
                    ItemLederEntryD.RESET;
                    ItemLederEntryD.SETRANGE(ItemLederEntryD."Item No.", SOrderLine."No.");
                    ItemLederEntryD.SETRANGE(ItemLederEntryD."Location Code", SOrderLine."Location Code");
                    ItemLederEntryD.SETRANGE(ItemLederEntryD."Variant Code", SOrderLine."Variant Code");
                    IF SalesHeader."Overlook Prod. Order No." = FALSE THEN
                        ItemLederEntryD.SETRANGE(ItemLederEntryD."Order No.", SOrderLine."Prod. Order No.");
                    IF ItemLederEntryD.FINDFIRST THEN BEGIN
                        REPEAT
                            AvalInventory += ItemLederEntryD."Remaining Quantity";
                        UNTIL ItemLederEntryD.NEXT = 0;
                    END;
                    IF TempQty > AvalInventory THEN
                        ERROR('Only %1 Quantity is available to Ship, Identification field and values are Prod. Order No. %2 Item No %3 Item Variant Code %4'
                        , AvalInventory, SOrderLine."Prod. Order No.", SOrderLine."No.", SOrderLine."Variant Code");
                END;
            UNTIL SOrderLine.NEXT = 0;
        END;

        SalesComment.RESET;
        SalesComment.SETRANGE(SalesComment."Document Type", SalesComment."Document Type"::"Delivery Order"); //Deepak
        SalesComment.SETRANGE(SalesComment."No.", SalesHeader."No.");
        SalesComment.SETRANGE(SalesComment.Mandatory, TRUE);
        IF SalesComment.FINDFIRST THEN BEGIN
            REPEAT
                IF SalesComment.Attached = FALSE THEN
                    ERROR(Sam001, SalesComment.Description);
            UNTIL SalesComment.NEXT = 0;
        END;
        // End;
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Delivery Order" then
            SalesHeader.Receive := FALSE;
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterResetTempLines', '', false, false)]
    local procedure CU80_OnAfterResetTempLines(VAR TempSalesLineLocal: Record "Sales Line" TEMPORARY)
    begin
        IF TempSalesLineLocal."Document Type" = TempSalesLineLocal."Document Type"::"Delivery Order" THEN // Deepak
            TempSalesLineLocal.SETFILTER("Qty. to Ship", '<>0');

    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterUpdatePostingNos', '', false, false)]
    local procedure CU80_OnAfterUpdatePostingNos(VAR SalesHeader: Record "Sales Header"; VAR NoSeriesMgt: Codeunit NoSeriesManagement; CommitIsSuppressed: Boolean)
    begin
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::"Delivery Order")
                 THEN BEGIN
            SalesHeader.TESTFIELD("Shipping No. Series");
            SalesHeader."Shipping No." := NoSeriesMgt.GetNextNo(SalesHeader."Shipping No. Series", SalesHeader."Posting Date", TRUE);
        END;

    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforeSalesShptHeaderInsert', '', false, false)]
    local procedure CU80_OnBeforeSalesShptHeaderInsert(VAR SalesShptHeader: Record "Sales Shipment Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesLine: Record "Sales Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        SalesShptLine: Record "Sales Shipment Line";
    begin
        SalesSetup.Get();

        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR (SalesHeader."Document Type" = SalesHeader."Document Type"::"Delivery Order") OR//Deepak
           ((SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) AND SalesSetup."Shipment on Invoice")
            //IF (SalesHeader."Document Type" = SalesHeader."Document Type"::"Delivery Order") AND (SalesSetup."Shipment on Invoice")
            THEN BEGIN
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
            SalesLine.SETRANGE("Document No.", SalesHeader."No.");
            SalesLine.SETFILTER("Purch. Order Line No.", '<>0');
            IF NOT SalesLine.ISEMPTY THEN BEGIN
                PurchRcptHeader.LOCKTABLE;
                PurchRcptLine.LOCKTABLE;
                SalesShptHeader.LOCKTABLE;
                SalesShptLine.LOCKTABLE;
            END;
            // Lines added By Deepak Kumar
            SalesShptHeader."Vehicle No." := SalesHeader."Vehicle No.";
            SalesShptHeader."Driver Name" := SalesHeader."Driver Name";
            SalesShptHeader."Posting Time" := Time;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforeSalesInvHeaderInsert', '', false, false)]
    local procedure CU80_OnBeforeSalesInvHeaderInsert(VAR SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean)
    begin
        SalesInvHeader."Posting Time" := TIME;
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforeSalesShptLineInsert', '', false, false)]
    local procedure CU80_OnBeforeSalesShptLineInsert(VAR SalesShptLine: Record "Sales Shipment Line"; SalesShptHeader: Record "Sales Shipment Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean)
    var
        items: Record Item;
    begin
        //Lines added By Deepak Kumar
        IF SalesLine."Document Type" = SalesLine."Document Type"::"Delivery Order" THEN BEGIN  // Deepak
            SalesShptLine."Order No." := SalesLine."Ref. Sales Order No.";
            SalesShptLine."Order Line No." := SalesLine."Ref. Sales Order Line No.";
        END;

        IF SalesLine."Document Type" = SalesLine."Document Type"::Order THEN BEGIN  // Deepak
            SalesShptLine."Order No." := SalesLine."Document No.";
            SalesShptLine."Order Line No." := SalesLine."Line No.";
        END;

        // Lines updated by deepak Kumar
        IF (SalesLine.Type = SalesLine.Type::Item) THEN BEGIN
            items.RESET;
            items.GET(SalesLine."No.");
            SalesShptLine."Shipment Weight" := ROUND((SalesShptLine.Quantity * items."Net Weight"), 0.0001) / 1000;
            SalesShptLine."Net Weight" := ROUND((SalesShptLine.Quantity * items."Net Weight"), 0.0001) / 1000;
            SalesShptLine."Gross Weight" := ROUND((SalesShptLine.Quantity * items."Net Weight"), 0.0001) / 1000;

        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterSalesShptLineInsert', '', false, false)]
    local procedure CU80_OnAfterSalesShptLineInsert(VAR SalesShipmentLine: Record "Sales Shipment Line"; SalesLine: Record "Sales Line"; ItemShptLedEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean)
    var
        PackingListLine: Record "Packing List Line";
    begin
        //// Updated by Deepak
        // BY Delivery Order
        PackingListLine.RESET;
        PackingListLine.SETRANGE(PackingListLine."Sales Order No.", SalesLine."Ref. Sales Order No.");
        PackingListLine.SETRANGE(PackingListLine."Item No.", SalesLine."No.");
        PackingListLine.SETRANGE(PackingListLine."Select for Shipment", TRUE);
        PackingListLine.SETRANGE(PackingListLine.Posted, FALSE);
        IF PackingListLine.FINDFIRST THEN BEGIN
            REPEAT
                PackingListLine."Sales Shipment No." := SalesShipmentLine."Document No.";
                PackingListLine.Posted := TRUE;
                PackingListLine.MODIFY(TRUE);
            UNTIL PackingListLine.NEXT = 0;
        END;
        // By Sales Order
        PackingListLine.RESET;
        PackingListLine.SETRANGE(PackingListLine."Sales Order No.", SalesLine."Document No.");
        PackingListLine.SETRANGE(PackingListLine."Item No.", SalesLine."No.");
        PackingListLine.SETRANGE(PackingListLine."Select for Shipment", TRUE);
        PackingListLine.SETRANGE(PackingListLine.Posted, FALSE);
        IF PackingListLine.FINDFIRST THEN BEGIN
            REPEAT
                PackingListLine."Sales Shipment No." := SalesShipmentLine."Document No.";
                PackingListLine.Posted := TRUE;
                PackingListLine.MODIFY(TRUE);
            UNTIL PackingListLine.NEXT = 0;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforeSalesInvLineInsert', '', false, false)]
    local procedure CU80_OnBeforeSalesInvLineInsert(VAR SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean)
    var
        items: Record Item;
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
        //weight
        IF (SalesLine.Type = SalesLine.Type::Item) THEN BEGIN
            items.GET(SalesLine."No.");
            SalesInvLine."Net Weight" := ROUND((SalesLine."Qty. to Invoice" * items."Net Weight"), 0.0001) / 1000;
            SalesInvLine."Gross Weight" := ROUND((SalesLine."Qty. to Invoice" * items."Net Weight"), 0.0001) / 1000;
        END;
        // Lines added BY Deepak Kumar
        SalesInvLine."LPO(Order) Date" := SalesHeader."Order Date";
        SalesInvLine."Shipment No." := SalesHeader."Shipping No.";
        SalesInvLine."Shipment Line No." := SalesLine."Shipment Line No."; //Firoz 28-11-15
                                                                           ///"Posting Date";
                                                                           //end//deepak
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnRunOnBeforeFinalizePosting', '', false, false)]
    local procedure CU80_OnRunOnBeforeFinalizePosting(VAR SalesHeader: Record "Sales Header"; VAR SalesShipmentHeader: Record "Sales Shipment Header"; VAR SalesInvoiceHeader: Record "Sales Invoice Header"; VAR SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; CommitIsSuppressed: Boolean)
    var
        LCDetail: Record "LC Detail";
        LCOrder: Record "LC Orders";
        CFactor: Decimal;
        Text13700: Label 'The LC which you have attached is expired.';
        Text13701: Label 'The order value %1 cannot be greater than the LC remaining value %2.';
    begin
        with SalesHeader do begin
            // Lines added By Deepak Kumar'
            IF ("LC No." <> '') AND Ship THEN BEGIN
                IF "Currency Factor" <> 0 THEN
                    CFactor := "Currency Factor"
                ELSE
                    CFactor := 1;

                LCDetail.GET("LC No.");
                IF "Shipment Date" > LCDetail."Expiry Date" THEN
                    ERROR(Text13700);
                CALCFIELDS("Amount to Customer");
                LCDetail.CALCFIELDS("Value Utilised");
                LCOrder.SETRANGE("LC No.", "LC No.");
                LCOrder.SETRANGE("Order No.", "No.");
                IF NOT LCOrder.FINDFIRST THEN BEGIN
                    IF ("Amount to Customer" / CFactor) > LCDetail."Latest Amended Value" - LCDetail."Value Utilised" THEN
                        ERROR(Text13701, "Amount to Customer" / CFactor, (LCDetail."Latest Amended Value" - LCDetail."Value Utilised"));
                    LCOrder.INIT;
                    LCOrder."LC No." := LCDetail."No.";
                    LCOrder."Transaction Type" := LCDetail."Transaction Type";
                    LCOrder."Issued To/Received From" := LCDetail."Issued To/Received From";
                    LCOrder."Order No." := "No.";
                    LCOrder."Shipment Date" := "Shipment Date";
                    LCOrder."Order Value" := "Amount to Customer" / CFactor;
                    LCOrder.INSERT;
                END;
            END;
        end;
        //end//Depak
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterUpdateBlanketOrderLine', '', false, false)]
    local procedure CU80_OnAfterUpdateBlanketOrderLine(VAR BlanketOrderSalesLine: Record "Sales Line"; SalesLine: Record "Sales Line"; Ship: Boolean; Receive: Boolean; Invoice: Boolean)
    begin
        UpdateRefSalesOrder(SalesLine, Ship, Receive, Invoice);//Deepak
                                                               // Lines added By Deepak Kumar
        SalesLine.SETFILTER("Ref. Sales Order No.", '<>0');
        IF SalesLine.FINDSET THEN
            REPEAT
                UpdateRefSalesOrder(SalesLine, Ship, Receive, Invoice);
            UNTIL SalesLine.NEXT = 0;
        SalesLine.SETRANGE("Ref. Sales Order No.");
        //End Deepak

    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforeDeleteAfterPosting', '', false, false)]
    local procedure CU80_OnBeforeDeleteAfterPosting(VAR SalesHeader: Record "Sales Header"; VAR SalesInvoiceHeader: Record "Sales Invoice Header"; VAR SalesCrMemoHeader: Record "Sales Cr.Memo Header"; VAR SkipDelete: Boolean; CommitIsSuppressed: Boolean)
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            SkipDelete := true;
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterCopyItemJnlLineFromSalesHeader', '', false, false)]
    local procedure CU80_OnAfterCopyItemJnlLineFromSalesHeader(VAR ItemJnlLine: Record "Item Journal Line"; SalesHeader: Record "Sales Header")
    begin
        //Mpower --
        ItemJnlLine."Salesperson Code" := SalesHeader."Salesperson Code";
        ItemJnlLine."Sales Order No." := SalesHeader."No.";
        //Mpower ++
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterCopyItemJnlLineFromSalesLine', '', false, false)]
    local procedure CU80_OnAfterCopyItemJnlLineFromSalesLine(VAR ItemJnlLine: Record "Item Journal Line"; SalesLine: Record "Sales Line")
    begin
        // Lines added bY Deepak Kumar
        ItemJnlLine."Production Order Sam" := SalesLine."Prod. Order No.";
        ItemJnlLine."Prod. Order Line No. Sam" := SalesLine."Prod. Order Line No.";
        // Deepak//End
    end;

    procedure UpdateRefSalesOrder(SalesLine: Record "Sales Line"; Ship: Boolean; Receive: Boolean; Invoice: Boolean)
    var
        RefOrderSalesLine: Record "Sales Line";
        ModifyLine: Boolean;
        Sign: Decimal;
    begin
        // Lines added by Deepak Kumar
        // It is Suspended Bcoz  we Decided we will not the Delivery Order//Deepak Kumar
        /*
        IF SalesLine."Document Type" IN [SalesLine."Document Type"::"Return Order",SalesLine."Document Type"::"Credit Memo"] THEN
          EXIT;
        
        
        IF (SalesLine."Ref. Sales Order No." <> '') AND (SalesLine."Ref. Sales Order Line No." <> 0) AND
           ((Ship AND (SalesLine."Qty. to Ship" <> 0)) OR
            (Receive AND (SalesLine."Return Qty. to Receive" <> 0)) OR
            (Invoice AND (SalesLine."Qty. to Invoice" <> 0)))
        THEN
          IF RefOrderSalesLine.GET(
               RefOrderSalesLine."Document Type"::Order,SalesLine."Ref. Sales Order No.",
               SalesLine."Ref. Sales Order Line No.")
          THEN BEGIN
            RefOrderSalesLine.TESTFIELD(Type,SalesLine.Type);
            RefOrderSalesLine.TESTFIELD("No.",SalesLine."No.");
            RefOrderSalesLine.TESTFIELD("Sell-to Customer No.",SalesLine."Sell-to Customer No.");
        
            ModifyLine := FALSE;
            CASE SalesLine."Document Type" OF
              SalesLine."Document Type"::"Delivery Order",
              SalesLine."Document Type"::Invoice:
                Sign := 1;
              SalesLine."Document Type"::"Return Order",
              SalesLine."Document Type"::"Credit Memo":
                Sign := -1;
            END;
            IF Ship AND (SalesLine."Shipment No." = '') THEN BEGIN
              IF RefOrderSalesLine."Qty. per Unit of Measure" =
                 SalesLine."Qty. per Unit of Measure"
              THEN
                RefOrderSalesLine."Quantity Shipped" :=
                  RefOrderSalesLine."Quantity Shipped" + Sign * SalesLine."Qty. to Ship"
              ELSE
                RefOrderSalesLine."Quantity Shipped" :=
                  RefOrderSalesLine."Quantity Shipped" +
                  Sign *
                  ROUND(
                    (SalesLine."Qty. per Unit of Measure" /
                     RefOrderSalesLine."Qty. per Unit of Measure") *
                    SalesLine."Qty. to Ship",0.00001);
              RefOrderSalesLine."Qty. Shipped (Base)" :=
                RefOrderSalesLine."Qty. Shipped (Base)" + Sign * SalesLine."Qty. to Ship (Base)";
              ModifyLine := TRUE;
            END;
            IF Receive AND (SalesLine."Return Receipt No." = '') THEN BEGIN
              IF RefOrderSalesLine."Qty. per Unit of Measure" =
                 SalesLine."Qty. per Unit of Measure"
              THEN
                RefOrderSalesLine."Quantity Shipped" :=
                  RefOrderSalesLine."Quantity Shipped" + Sign * SalesLine."Return Qty. to Receive"
              ELSE
                RefOrderSalesLine."Quantity Shipped" :=
                  RefOrderSalesLine."Quantity Shipped" +
                  Sign *
                  ROUND(
                    (SalesLine."Qty. per Unit of Measure" /
                     RefOrderSalesLine."Qty. per Unit of Measure") *
                    SalesLine."Return Qty. to Receive",0.00001);
              RefOrderSalesLine."Qty. Shipped (Base)" :=
                RefOrderSalesLine."Qty. Shipped (Base)" + Sign * SalesLine."Return Qty. to Receive (Base)";
              ModifyLine := TRUE;
            END;
            IF Invoice THEN BEGIN
              IF RefOrderSalesLine."Qty. per Unit of Measure" =
                 SalesLine."Qty. per Unit of Measure"
              THEN
                RefOrderSalesLine."Quantity Invoiced" :=
                  RefOrderSalesLine."Quantity Invoiced" + Sign * SalesLine."Qty. to Invoice"
              ELSE
                RefOrderSalesLine."Quantity Invoiced" :=
                  RefOrderSalesLine."Quantity Invoiced" +
                  Sign *
                  ROUND(
                    (SalesLine."Qty. per Unit of Measure" /
                     RefOrderSalesLine."Qty. per Unit of Measure") *
                    SalesLine."Qty. to Invoice",0.00001);
              RefOrderSalesLine."Qty. Invoiced (Base)" :=
                RefOrderSalesLine."Qty. Invoiced (Base)" + Sign * SalesLine."Qty. to Invoice (Base)";
              ModifyLine := TRUE;
            END;
        
            ManSetup.GET();
            VarQty:=(ManSetup."Output Tolerance %" * RefOrderSalesLine.Quantity)/100;
        
            IF ModifyLine THEN BEGIN
              RefOrderSalesLine.InitOutstanding;
              IF ((RefOrderSalesLine.Quantity +VarQty) * RefOrderSalesLine."Quantity Shipped" < 0) OR //Pulak 19-04-15
                 (ABS(RefOrderSalesLine.Quantity+VarQty) < ABS(RefOrderSalesLine."Quantity Shipped")) //Pulak 19-04-15
              THEN
                RefOrderSalesLine.FIELDERROR(
                  "Quantity Shipped",STRSUBSTNO(
                    Text018,
                    RefOrderSalesLine.FIELDCAPTION(Quantity)));
        
              IF ((RefOrderSalesLine."Quantity (Base)" + VarQty) *
                  RefOrderSalesLine."Qty. Shipped (Base)" < 0) OR
                 (ABS(RefOrderSalesLine."Quantity (Base)"+VarQty) <
                  ABS(RefOrderSalesLine."Qty. Shipped (Base)"))
              THEN
                RefOrderSalesLine.FIELDERROR(
                  "Qty. Shipped (Base)",
                  STRSUBSTNO(
                    Text018,
                    RefOrderSalesLine.FIELDCAPTION("Quantity (Base)")));
        
              RefOrderSalesLine.CALCFIELDS("Reserved Qty. (Base)");
              IF ABS(RefOrderSalesLine."Outstanding Qty. (Base)") <
                 ABS(RefOrderSalesLine."Reserved Qty. (Base)")
              THEN
                RefOrderSalesLine.FIELDERROR(
                  "Reserved Qty. (Base)",
                  Text019);
        
        
              RefOrderSalesLine."Qty. to Invoice" :=
                RefOrderSalesLine.Quantity - RefOrderSalesLine."Quantity Invoiced";
              RefOrderSalesLine."Qty. to Ship" :=
                RefOrderSalesLine.Quantity - RefOrderSalesLine."Quantity Shipped";
              RefOrderSalesLine."Qty. to Invoice (Base)" :=
                RefOrderSalesLine."Quantity (Base)" - RefOrderSalesLine."Qty. Invoiced (Base)";
              RefOrderSalesLine."Qty. to Ship (Base)" :=
                RefOrderSalesLine."Quantity (Base)" - RefOrderSalesLine."Qty. Shipped (Base)";
        
              RefOrderSalesLine.MODIFY;
        
        
            END;
          END;
         */

    end;

    procedure GetAdditionalCostValidation(SalesHeader: Record "Sales Header")
    var
        SalesHeaderN: Record "Sales Header";
        SalesLineN: Record "Sales Line";
        SalesLineNew: Record "Sales Line";
        TempLineNo: Integer;
        EstimateCostLine: Record "Product Design Special Descrip";
        StandardSalesCode: Record "Standard Sales Code";
        AdditionalCostPosted: Boolean;
        AdditionalCostInserted: Boolean;
        PostedSalesInvoice: Record "Sales Invoice Line";
    begin
        // Lines added BY Deepak Kumar
        SalesHeaderN.Reset;
        SalesHeaderN.SetRange(SalesHeaderN."Document Type", SalesHeader."Document Type");
        SalesHeaderN.SetRange(SalesHeaderN."No.", SalesHeader."No.");
        if SalesHeaderN.FindFirst then begin
            SalesLineN.Reset;
            SalesLineN.SetRange(SalesLineN."Document Type", SalesHeaderN."Document Type");
            SalesLineN.SetRange(SalesLineN."Document No.", SalesHeaderN."No.");
            SalesLineN.SetRange(SalesLineN.Type, SalesLineN.Type::Item);
            SalesLineN.SetFilter(SalesLineN."Qty. to Ship", '>0');
            //SalesLineN.SETRANGE(SalesLineN."Estimate Additional Cost",FALSE);
            if SalesLineN.FindFirst then begin
                repeat
                    EstimateCostLine.Reset;
                    EstimateCostLine.SetRange(EstimateCostLine."No.", SalesLineN."Estimation No.");
                    EstimateCostLine.SetRange(EstimateCostLine.Category, EstimateCostLine.Category::Cost);
                    if EstimateCostLine.FindFirst then begin
                        repeat

                            AdditionalCostPosted := false;
                            if EstimateCostLine.Occurrence = EstimateCostLine.Occurrence::Once then begin
                                PostedSalesInvoice.Reset;
                                PostedSalesInvoice.SetRange(PostedSalesInvoice."Estimation No.", EstimateCostLine."No.");
                                PostedSalesInvoice.SetRange(PostedSalesInvoice."Estimate Additional Cost", true);
                                PostedSalesInvoice.SetFilter(PostedSalesInvoice."Cross-Reference No.", EstimateCostLine."Cost Code");
                                PostedSalesInvoice.SetRange(PostedSalesInvoice.Type, PostedSalesInvoice.Type::"G/L Account");
                                if PostedSalesInvoice.FindFirst then begin
                                    AdditionalCostPosted := true;
                                end;
                                if AdditionalCostPosted = false then begin
                                    SalesLineNew.Reset;
                                    SalesLineNew.SetRange(SalesLineNew."Document Type", SalesHeaderN."Document Type");
                                    SalesLineNew.SetRange(SalesLineNew."Document No.", SalesHeaderN."No.");
                                    SalesLineNew.SetRange(SalesLineNew."Cross-Reference No.", EstimateCostLine."Cost Code");
                                    SalesLineNew.SetRange(SalesLineNew."Estimate Additional Cost", true);
                                    SalesLineNew.SetRange(SalesLineNew."Estimation No.", SalesLineN."Estimation No.");

                                    if not SalesLineNew.FindFirst then begin
                                        Error('Please add Additional Cost , Cost Component %1', EstimateCostLine."Cost Description");
                                    end else begin
                                        SalesLineNew.TestField(SalesLineNew."Qty. to Ship");

                                    end;
                                end else begin
                                    IF AdditionalCostPosted = true then begin
                                        SalesLineNew."Qty. to Ship" := 0;
                                        SalesLineNew."Qty. to Ship (Base)" := 0;
                                        SalesLineNew."Qty. to Invoice" := 0;
                                        SalesLineNew."Qty. to Invoice (Base)" := 0;
                                    end;
                                END;
                            END;
                            if EstimateCostLine.Occurrence = EstimateCostLine.Occurrence::"Every Invoice" then begin
                                SalesLineNew.Reset;
                                SalesLineNew.SetRange(SalesLineNew."Document Type", SalesHeaderN."Document Type");
                                SalesLineNew.SetRange(SalesLineNew."Document No.", SalesHeaderN."No.");
                                SalesLineNew.SetRange(SalesLineNew."Cross-Reference No.", EstimateCostLine."Cost Code");
                                SalesLineNew.SetRange(SalesLineNew."Estimate Additional Cost", true);
                                SalesLineNew.SetRange(SalesLineNew."Estimation No.", SalesLineN."Estimation No.");
                                if not SalesLineNew.FindFirst then begin
                                    Error('Please add Additional Cost , Cost Component %1', EstimateCostLine."Cost Description");
                                end else begin
                                    SalesLineNew.TestField(SalesLineNew."Qty. to Ship");
                                end;
                            end;
                        until EstimateCostLine.Next = 0;
                    end;
                until SalesLineN.Next = 0;
            end;
        end;
    end;

    procedure ValidateVATEntries(DocumentNo: Code[50])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        // Lines added BY Deepak Kumar
        SalesHeader.Reset;
        SalesHeader.SetRange(SalesHeader."No.", DocumentNo);
        if SalesHeader.FindFirst then begin
            if SalesHeader."Posting Date" >= 20180101D then begin
                SalesLine.Reset;
                SalesLine.SetRange(SalesLine."Document Type", SalesHeader."Document Type");
                SalesLine.SetRange(SalesLine."Document No.", SalesHeader."No.");
                if SalesLine.FindFirst then begin
                    repeat
                        if (SalesLine."Document Type" = SalesLine."Document Type"::Order) or (SalesLine."Document Type" = SalesLine."Document Type"::"Return Order") then begin
                            if SalesLine."Qty. to Invoice" <> 0 then begin
                                SalesLine.TestField(SalesLine."VAT Bus. Posting Group");
                                SalesLine.TestField(SalesLine."VAT Prod. Posting Group");
                                VATPostingSetup.Get(SalesLine."VAT Bus. Posting Group", SalesLine."VAT Prod. Posting Group");
                                if VATPostingSetup."VAT %" <> 0 then begin
                                    if ((SalesLine."Amount Including VAT" - SalesLine.Amount) = 0) then
                                        Error('VAT Amount must not be Zero');
                                end;
                            end;
                        end else begin
                            if SalesLine.Quantity <> 0 then begin
                                SalesLine.TestField(SalesLine."VAT Bus. Posting Group");
                                SalesLine.TestField(SalesLine."VAT Prod. Posting Group");
                                VATPostingSetup.Get(SalesLine."VAT Bus. Posting Group", SalesLine."VAT Prod. Posting Group");
                                if VATPostingSetup."VAT %" <> 0 then begin
                                    if ((SalesLine."Amount Including VAT" - SalesLine.Amount) = 0) then
                                        Error('VAT Amount must not be Zero');
                                end;
                            end;
                        end;
                    until SalesLine.Next = 0;
                end;
            end else begin
                SalesLine.Reset;
                SalesLine.SetRange(SalesLine."Document Type", SalesHeader."Document Type");
                SalesLine.SetRange(SalesLine."Document No.", SalesHeader."No.");
                if SalesLine.FindFirst then begin
                    repeat
                        if (SalesLine."Document Type" = SalesLine."Document Type"::Order) or (SalesLine."Document Type" = SalesLine."Document Type"::"Return Order") then begin
                            if SalesLine."Qty. to Invoice" <> 0 then begin
                                SalesLine.TestField(SalesLine."VAT Bus. Posting Group");
                                SalesLine.TestField(SalesLine."VAT Prod. Posting Group");
                                if ((SalesLine."Amount Including VAT" - SalesLine.Amount) <> 0) then
                                    Error('VAT Amount must be Zero');
                            end;
                        end else begin
                            if SalesLine.Quantity <> 0 then begin
                                SalesLine.TestField(SalesLine."VAT Bus. Posting Group");
                                SalesLine.TestField(SalesLine."VAT Prod. Posting Group");
                                if ((SalesLine."Amount Including VAT" - SalesLine.Amount) <> 0) then
                                    Error('VAT Amount must be Zero');
                            end;
                        end;
                    until SalesLine.Next = 0;
                end;

            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnPostSalesLineOnAfterTestUpdatedSalesLine', '', false, false)]
    local procedure CU80_OnPostSalesLineOnAfterTestUpdatedSalesLine(VAR SalesLine: Record "Sales Line"; VAR EverythingInvoiced: Boolean)
    begin
        EverythingInvoiced := false;
    ENd;
    //CodeUnit 80 +

    //CodeUnit 81 -
    [EventSubscriber(ObjectType::Codeunit, 81, 'OnBeforeConfirmSalesPost', '', false, false)]
    local procedure CU81_OnBeforeConfirmSalesPost(VAR SalesHeader: Record "Sales Header"; VAR HideDialog: Boolean; VAR IsHandled: Boolean)
    var
        Selection: Integer;
        Sam001: Label '&Ship';
    begin
        IF SalesHeader."Document Type" <> SalesHeader."Document Type"::"Delivery Order" then
            IsHandled := false
        else begin
            HideDialog := true;
            // Lines added BY Deepak Kumar
            WITH SalesHeader DO BEGIN
                CASE "Document Type" OF
                    "Document Type"::"Delivery Order":
                        begin
                            Selection := StrMenu(Sam001, 1);
                            if Selection = 0 then
                                IsHandled := true;
                            Ship := Selection in [1, 3];
                            Invoice := Selection in [2, 3];
                        end;
                END;
            end;
        end;
    end;
    //CodeUnit 81 +
    //CodeUnit 91 -
    [EventSubscriber(ObjectType::Codeunit, 91, 'OnBeforeConfirmPost', '', false, false)]
    local procedure CU91_OnBeforeConfirmPost(VAR PurchaseHeader: Record "Purchase Header"; VAR HideDialog: Boolean; VAR IsHandled: Boolean; VAR DefaultOption: Integer)
    var
        Selection: Integer;
        Text0001: Label '&Receive';
    begin
        IF PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Order then
            IsHandled := false
        else begin
            HideDialog := true;
            // Lines added BY Deepak Kumar
            WITH PurchaseHeader DO BEGIN
                CASE "Document Type" OF
                    "Document Type"::Order:
                        begin
                            Selection := StrMenu(Text0001, 1);
                            if Selection = 1 then
                                //    IsHandled := true;
                                Receive := Selection in [1, 3];
                            //Invoice := Selection in [2, 3];
                        end;
                END;
            end;
        end;
    end;
    //CodeUnit 91 +
    //CodeUnit 82 -
    [EventSubscriber(ObjectType::Codeunit, 82, 'OnBeforeConfirmPost', '', false, false)]
    local procedure CU81_OnBeforeConfirmPost(VAR SalesHeader: Record "Sales Header"; VAR HideDialog: Boolean; VAR IsHandled: Boolean)
    var
        Selection: Integer;
        ShipInvoiceQst: Label ',,Ship &and Invoice';
        ReceiveInvoiceQst: Label '&Receive,&Invoice,Receive &and Invoice';
        ConfirmManagement: Codeunit "Confirm Management";
        PostAndPrintQst: Label 'Do you want to post and print the %1?';
        PostAndEmailQst: Label 'Do you want to post and email the %1?';
    begin
        WITH SalesHeader DO BEGIN
            CASE "Document Type" OF
                "Document Type"::Order:
                    BEGIN
                        Selection := STRMENU(ShipInvoiceQst, 3);
                        IF Selection = 0 THEN
                            IsHandled := true;
                        Ship := Selection IN [1, 3];
                        Invoice := Selection IN [2, 3];
                    END;
                "Document Type"::"Return Order":
                    BEGIN
                        Selection := STRMENU(ReceiveInvoiceQst, 3);
                        IF Selection = 0 THEN
                            IsHandled := true;
                        Receive := Selection IN [1, 3];
                        Invoice := Selection IN [2, 3];
                    END
                ELSE
                    IsHandled := false;
            END;
            "Print Posted Documents" := TRUE;
        END;
    end;

    //CodeUnit 82 +
    //CodeUnit 87 -
    [EventSubscriber(ObjectType::Codeunit, 87, 'OnBeforeInsertSalesOrderHeader', '', false, false)]
    local procedure CU87_OnBeforeInsertSalesOrderHeader(VAR SalesOrderHeader: Record "Sales Header"; BlanketOrderSalesHeader: Record "Sales Header")
    begin
        SalesOrderHeader."Blanket Order No." := BlanketOrderSalesHeader."No.";//deepak
    end;
    //CodeUnit 87 +
    //Codeunit 90 -
    procedure UpdateRollWiseLocation(PurcDocNo: Code[30]; LineNumber: Integer)
    var
        PurcHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        RollMaster: Record "Item Variant";
        sAM001: Label '<>0';
        TempPurcLine: Record "Purchase Line";
        LastLineNumber: Integer;
        NewPurcLine: Record "Purchase Line";
        QASetup: Record "Manufacturing Setup";
    begin
        // Lines added BY Deepak Kumar

        PurcHeader.Reset;
        PurcHeader.SetRange(PurcHeader."Document Type", PurcHeader."Document Type"::Order);
        PurcHeader.SetRange(PurcHeader."No.", PurcDocNo);
        if PurcHeader.FindFirst then begin
            PurchLine.Reset;
            PurchLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
            PurchLine.SetRange(PurchLine."Document Type", PurchLine."Document Type"::Order);
            PurchLine.SetRange(PurchLine."Document No.", PurcHeader."No.");
            PurchLine.SetRange(PurchLine."Line No.", LineNumber);
            PurchLine.SetRange(PurchLine."For Location Roll Entry", PurchLine."For Location Roll Entry"::Mother);
            if PurchLine.FindFirst then begin
                repeat
                    TempPurcLine.Reset;
                    TempPurcLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
                    TempPurcLine.SetRange(TempPurcLine."Document Type", TempPurcLine."Document Type"::Order);
                    TempPurcLine.SetRange(TempPurcLine."Document No.", PurcHeader."No.");
                    if TempPurcLine.FindLast then
                        LastLineNumber := TempPurcLine."Line No.";

                    RollMaster.Reset;
                    RollMaster.SetRange(RollMaster."Document No.", PurchLine."Document No.");
                    RollMaster.SetRange(RollMaster."Document Line No.", PurchLine."Line No.");
                    RollMaster.SetRange(RollMaster.Status, RollMaster.Status::" ");
                    if RollMaster.FindFirst then begin
                        repeat
                            //   RollMaster.TESTFIELD(RollMaster."Location after QA");
                            LastLineNumber := LastLineNumber + 10;
                            NewPurcLine.Reset;
                            NewPurcLine.SetRange(NewPurcLine."Document Type", NewPurcLine."Document Type"::Order);
                            NewPurcLine.SetRange(NewPurcLine."Document No.", PurchLine."Document No.");
                            NewPurcLine.SetRange(NewPurcLine."Line Ref. No", PurchLine."Line No.");
                            NewPurcLine.SetRange(NewPurcLine."No.", PurchLine."No.");
                            NewPurcLine.SetRange(NewPurcLine."Variant Code", RollMaster.Code);
                            if NewPurcLine.FindFirst then begin
                                NewPurcLine.Validate(NewPurcLine.Quantity, RollMaster."Roll Weight");
                                NewPurcLine.Description := NewPurcLine.Description + ' ' + RollMaster.Code;
                                NewPurcLine.Validate("Qty. to Receive", RollMaster."Roll Weight");
                                ;
                                // Lines added BY Deepak Kumar
                                QASetup.Get();
                                if (TempPurcLine.Paper) and (TempPurcLine."QA Enabled") then begin
                                    NewPurcLine."Location Code" := QASetup."Quality Inspection Location";
                                end;

                                NewPurcLine."Receiving Location" := RollMaster."Location after QA";
                                NewPurcLine.Modify(true);
                                Commit;
                            end else begin
                                NewPurcLine.Init;
                                NewPurcLine := PurchLine;
                                NewPurcLine."Line No." := LastLineNumber;

                                NewPurcLine."Qty. Rcd. Not Invoiced" := 0;
                                NewPurcLine."Quantity Received" := 0;
                                NewPurcLine."Quantity Invoiced" := 0;
                                NewPurcLine."Quantity (Base)" := 0;
                                NewPurcLine."Outstanding Qty. (Base)" := 0;
                                //NewPurcLine."Qty. to Invoice (Base)":=0;
                                //NewPurcLine."Qty. to Receive (Base)":=0;
                                NewPurcLine."Qty. Rcd. Not Invoiced (Base)" := 0;
                                NewPurcLine."Qty. Received (Base)" := 0;
                                NewPurcLine."Qty. Invoiced (Base)" := 0;

                                // Lines added BY Deepak Kumar
                                QASetup.Get();
                                if (TempPurcLine.Paper) and (TempPurcLine."QA Enabled") then begin
                                    NewPurcLine."Location Code" := QASetup."Quality Inspection Location";
                                end;


                                NewPurcLine.Description := NewPurcLine.Description + ' ' + RollMaster.Code;
                                NewPurcLine."Receiving Location" := RollMaster."Location after QA";

                                NewPurcLine."Variant Code" := RollMaster.Code;
                                NewPurcLine."For Location Roll Entry" := NewPurcLine."For Location Roll Entry"::Child;
                                NewPurcLine."Line Ref. No" := PurchLine."Line No.";
                                NewPurcLine.Insert(true);

                                NewPurcLine.Validate(NewPurcLine.Quantity, RollMaster."Roll Weight");
                                NewPurcLine.Validate(NewPurcLine."Qty. to Receive", RollMaster."Roll Weight");
                                NewPurcLine.Modify(true);
                                Commit;
                            end;
                        until RollMaster.Next = 0;
                    end;
                    //      PurchLine.VALIDATE("Qty. to Receive",0);
                    //      PurchLine.MODIFY(TRUE);
                until PurchLine.Next = 0;
            end;
        end;
    end;

    procedure UpdatePaperRollonPurchRcpt(OrderNumber: Code[20]; PurRcptHead: Record "Purch. Rcpt. Header"; PurRcptLine: Record "Purch. Rcpt. Line")
    var
        RollEntry: Record "Item Variant";
    begin

        // Lines added By Deepak Kuamr
        RollEntry.Reset;
        RollEntry.SetRange(RollEntry."Document No.", PurRcptLine."Order No.");
        RollEntry.SetRange(RollEntry."Document Line No.", PurRcptLine."Order Line No.");
        RollEntry.SetRange(RollEntry.Status, 0);
        RollEntry.SetFilter(RollEntry."Roll Weight", '>%1', 0);
        if RollEntry.FindFirst then begin
            repeat
                RollEntry.Status := 1;
                RollEntry."Purchase Receipt No." := PurRcptHead."No.";
                RollEntry."Vendor Shipment No." := PurRcptHead."Vendor Shipment No.";
                RollEntry."Purchase Price" := PurRcptLine."Direct Unit Cost";
                RollEntry.Modify(true);
            until RollEntry.Next = 0;
        end;
    end;



    // procedure WorkSheetInsert(PurchInvLine: Record "Purch. Inv. Line")
    // var
    //     WorkSheetRec: Record "Work Sheet";
    // begin
    //     WorkSheetRec.Reset;
    //     WorkSheetRec.SetRange("Job Card No.", PurchInvLine."Job Card No.");
    //     WorkSheetRec.SetRange("Machine ID", PurchInvLine."Machine Id");
    //     WorkSheetRec.SetRange("Line Type", 'SERVICE');
    //     if WorkSheetRec.FindFirst then begin
    //         if (WorkSheetRec."Unit Cost" <> PurchInvLine."Direct Unit Cost") or
    //             (WorkSheetRec.Quantity <> PurchInvLine.Quantity) or
    //              (WorkSheetRec.Amount <> PurchInvLine."Line Amount") then begin
    //             WorkSheetRec.Validate("Unit Cost", PurchInvLine."Direct Unit Cost");
    //             WorkSheetRec.Validate(Quantity, PurchInvLine.Quantity);
    //             WorkSheetRec.Validate(Amount, PurchInvLine."Line Amount");
    //             WorkSheetRec.Modify(true);
    //         end;
    //     end;
    // end;

    procedure CheckVATAmount(DocumentNo: Code[50])
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        VATPostingSetup: Record "VAT Posting Setup";
    begin

        // Lines added BY Deepak Kumar
        PurchaseHeader.Reset;
        PurchaseHeader.SetRange(PurchaseHeader."No.", DocumentNo);
        if PurchaseHeader.FindFirst then begin
            if PurchaseHeader."Posting Date" >= 20180101D then begin
                PurchaseLine.Reset;
                PurchaseLine.SetRange(PurchaseLine."Document Type", PurchaseHeader."Document Type");
                PurchaseLine.SetRange(PurchaseLine."Document No.", PurchaseHeader."No.");
                if PurchaseLine.FindFirst then begin
                    repeat
                        if (PurchaseLine."Document Type" = PurchaseLine."Document Type"::Order) or (PurchaseLine."Document Type" = PurchaseLine."Document Type"::"Return Order") then begin
                            if PurchaseLine."Qty. to Invoice" <> 0 then begin
                                PurchaseLine.TestField(PurchaseLine."VAT Bus. Posting Group");
                                PurchaseLine.TestField(PurchaseLine."VAT Prod. Posting Group");
                                VATPostingSetup.Get(PurchaseLine."VAT Bus. Posting Group", PurchaseLine."VAT Prod. Posting Group");
                                if (VATPostingSetup."VAT %" <> 0) and (VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Normal VAT") then begin
                                    if ((PurchaseLine."Amount Including VAT" - PurchaseLine.Amount) = 0) then
                                        Error('VAT Amount must not be Zero');
                                end;
                            end;
                        end else begin
                            if PurchaseLine.Quantity <> 0 then begin
                                PurchaseLine.TestField(PurchaseLine."VAT Bus. Posting Group");
                                PurchaseLine.TestField(PurchaseLine."VAT Prod. Posting Group");
                                VATPostingSetup.Get(PurchaseLine."VAT Bus. Posting Group", PurchaseLine."VAT Prod. Posting Group");
                                if (VATPostingSetup."VAT %" <> 0) and (VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Normal VAT") then begin
                                    if ((PurchaseLine."Amount Including VAT" - PurchaseLine.Amount) = 0) then
                                        Error('VAT Amount must not be Zero');
                                end;
                            end;
                        end;
                    until PurchaseLine.Next = 0;
                end;
            end else begin
                PurchaseLine.Reset;
                PurchaseLine.SetRange(PurchaseLine."Document Type", PurchaseHeader."Document Type");
                PurchaseLine.SetRange(PurchaseLine."Document No.", PurchaseHeader."No.");
                if PurchaseLine.FindFirst then begin
                    repeat
                        if (PurchaseLine."Document Type" = PurchaseLine."Document Type"::Order) or (PurchaseLine."Document Type" = PurchaseLine."Document Type"::"Return Order") then begin
                            if PurchaseLine."Qty. to Invoice" <> 0 then begin
                                PurchaseLine.TestField(PurchaseLine."VAT Bus. Posting Group");
                                PurchaseLine.TestField(PurchaseLine."VAT Prod. Posting Group");
                                VATPostingSetup.Get(PurchaseLine."VAT Bus. Posting Group", PurchaseLine."VAT Prod. Posting Group");
                                if (VATPostingSetup."VAT %" <> 0) and (VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Normal VAT") then begin
                                    if ((PurchaseLine."Amount Including VAT" - PurchaseLine.Amount) <> 0) then
                                        Error('VAT Amount must be Zero');
                                end;
                            end;
                        end else begin
                            if PurchaseLine.Quantity <> 0 then begin
                                PurchaseLine.TestField(PurchaseLine."VAT Bus. Posting Group");
                                PurchaseLine.TestField(PurchaseLine."VAT Prod. Posting Group");
                                if ((PurchaseLine."Amount Including VAT" - PurchaseLine.Amount) <> 0) then
                                    Error('VAT Amount must be Zero');
                            end;
                        end;
                    until PurchaseLine.Next = 0;
                end;

            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterUpdatePostingNos', '', false, false)]
    local procedure CU90_OnAfterUpdatePostingNos(VAR PurchaseHeader: Record "Purchase Header"; VAR NoSeriesMgt: Codeunit NoSeriesManagement; CommitIsSupressed: Boolean)
    begin
        if PurchaseHeader."Posting No." <> '' then
            MESSAGE('The Invoice No %1 is getting posted', PurchaseHeader."Posting No."); // Deepak
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePurchRcptHeaderInsert', '', false, false)]
    local procedure CU90_OnBeforePurchRcptHeaderInsert(VAR PurchRcptHeader: Record "Purch. Rcpt. Header"; VAR PurchaseHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    var
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        PurchSetup.Get();
        PurchSetup.TESTFIELD(PurchSetup."Default Qty. to Receive", PurchSetup."Default Qty. to Receive"::Blank);
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforeFinalizePosting', '', false, false)]
    local procedure CU90_OnBeforeFinalizePosting(VAR PurchaseHeader: Record "Purchase Header"; VAR TempPurchLineGlobal: Record "Purchase Line" TEMPORARY; VAR EverythingInvoiced: Boolean; CommitIsSupressed: Boolean)
    var
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        // Lines added BY Deepak Kumar
        IF (TempPurchLineGlobal."Qty. to Invoice" + TempPurchLineGlobal."Quantity Invoiced" = TempPurchLineGlobal."Qty. to Receive" + TempPurchLineGlobal."Quantity Received") AND
           (TempPurchLineGlobal."Qty. to Invoice" + TempPurchLineGlobal."Quantity Invoiced" >= TempPurchLineGlobal.Quantity) AND (PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Order)
           AND (PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::"Return Order")  // Pulak 02-04-15
           THEN
            EverythingInvoiced := true
        else
            EverythingInvoiced := false;
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePurchRcptLineInsert', '', false, false)]
    local procedure CU90_OnBeforePurchRcptLineInsert(VAR PurchRcptLine: Record "Purch. Rcpt. Line"; VAR PurchRcptHeader: Record "Purch. Rcpt. Header"; VAR PurchLine: Record "Purchase Line"; CommitIsSupressed: Boolean)
    var
        PurchSetup: Record "Purchases & Payables Setup";
        QAItem: Record Item;
    begin
        // Lines added BY Deepak Kumar
        PurchRcptLine."Machine Id." := PurchLine."Machine Id";
        PurchRcptLine."Job Card No." := PurchLine."Job Card No.";
        //Lines added BY Deepak Kumar
        if PurchLine.Type = PurchLine.Type::Item then begin
            QAItem.GET(PurchLine."No.");
            PurchRcptLine."QA Enabled" := QAItem."QA Enable";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterPurchRcptLineInsert', '', false, false)]
    local procedure CU90_OnAfterPurchRcptLineInsert(PurchaseLine: Record "Purchase Line"; PurchRcptLine: Record "Purch. Rcpt. Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean)
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        PurchRcptHeader.Get(PurchRcptLine."Document No.");
        UpdatePaperRollonPurchRcpt(PurchaseLine."Document No.", PurchRcptHeader, PurchRcptLine);//Deepak
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterFinalizePostingOnBeforeCommit', '', false, false)]
    local procedure CU90_OnAfterFinalizePostingOnBeforeCommit(VAR PurchHeader: Record "Purchase Header"; VAR PurchRcptHeader: Record "Purch. Rcpt. Header"; VAR PurchInvHeader: Record "Purch. Inv. Header"; VAR PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var ReturnShptHeader: Record "Return Shipment Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean)
    var
        LCDetail: Record "LC Detail";
        CFactor: Decimal;
        LCOrder: Record "LC Orders";
        Text13701: Label 'The LC which you have attached is expired.';
        Text13702: Label 'The order value %1 cannot be greater than the LC remaining value %2.';
    begin
        // Lines added bY Deepak Kumar
        IF (PurchHeader."LC No." <> '') AND PurchHeader.Receive THEN BEGIN
            IF PurchHeader."Currency Factor" <> 0 THEN
                CFactor := PurchHeader."Currency Factor"
            ELSE
                CFactor := 1;
            LCDetail.GET(PurchHeader."LC No.");
            IF PurchHeader."Expected Receipt Date" > LCDetail."Expiry Date" THEN
                ERROR(Text13701);
            PurchHeader.CALCFIELDS("Amount to Vendor");
            LCDetail.CALCFIELDS("Value Utilised");
            LCOrder.SETRANGE("LC No.", PurchHeader."LC No.");
            LCOrder.SETRANGE("Order No.", PurchHeader."No.");
            IF NOT LCOrder.FINDFIRST THEN BEGIN
                IF ((ROUND((PurchHeader."Amount to Vendor" / CFactor), 0.01)) > (LCDetail."Latest Amended Value" - LCDetail."Value Utilised")) THEN //FIROZ 13-0417
                    ERROR(Text13702, PurchHeader."Amount to Vendor" / CFactor, (LCDetail."Latest Amended Value" - LCDetail."Value Utilised"));
                LCOrder.INIT;
                LCOrder."LC No." := LCDetail."No.";
                LCOrder."Transaction Type" := LCDetail."Transaction Type";
                LCOrder."Issued To/Received From" := LCDetail."Issued To/Received From";
                LCOrder."Order No." := PurchHeader."No.";
                LCOrder."Shipment Date" := PurchHeader."Expected Receipt Date";
                LCOrder."Order Value" := PurchHeader."Amount to Vendor" / CFactor;
                LCOrder.INSERT;
            END;
        END;
        //End Deepak

    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforeDeleteAfterPosting', '', false, false)]
    local procedure CU90_OnBeforeDeleteAfterPosting(VAR PurchaseHeader: Record "Purchase Header"; VAR PurchInvHeader: Record "Purch. Inv. Header"; VAR PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; VAR SkipDelete: Boolean; CommitIsSupressed: Boolean)
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then
            SkipDelete := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterFilter_SumPurchLine2', '', false, false)]
    local procedure CU90_OnAfterFilter_SumPurchLine2(VAR OldPurchLine: Record "Purchase Line")
    begin
        IF OldPurchLine."Document Type" = OldPurchLine."Document Type"::Order THEN
            OldPurchLine.SETRANGE(OldPurchLine."For Location Roll Entry", OldPurchLine."For Location Roll Entry"::Mother);
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnUpdatePurchLineQty', '', false, false)]
    local procedure CU90_OnUpdatePurchLineQty(VAR PurchLine: Record "Purchase Line"; VAR PurchLineQty: Decimal)
    begin
        PurchLine.CALCFIELDS("Roll Quantity to Receive");
        IF PurchLine."Document Type" IN [PurchLine."Document Type"::"Return Order", PurchLine."Document Type"::"Credit Memo"] THEN
            PurchLineQty := PurchLine."Return Qty. to Ship"
        ELSE
            PurchLineQty := PurchLine."Roll Quantity to Receive"
    END;

    //Codeunit 90 +

    //Codeunit 312 -
    [EventSubscriber(ObjectType::Table, 36, 'OnCustomerCreditLimitExceeded', '', false, false)]
    local procedure TAB36_OnCustomerCreditLimitExceeded(VAR Sender: Record "Sales Header")
    var
        SaleRecSetup: Record "Sales & Receivables Setup";
        Text001: Label 'The update has been interrupted to respect the force credit policy.';
        Customer: Record Customer;
    begin
        // lines added bY Deepka Kumar
        SaleRecSetup.Get;
        Customer.Get(Sender."Bill-to Customer No.");
        if (SaleRecSetup."Force Credit Limit") and (Customer."Credit Limit Override" = false) then
            Error(Text001);
    end;
    //Codeunit 312 +

    //Codeunit 5407 -
    procedure UpdateFGWeight(ProdOrder: Record "Production Order")
    var
        ProdOrderLine: Record "Prod. Order Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TempTotalWeight: Decimal;
        OutputLedgerEntry: Record "Item Ledger Entry";
        ItemApplicationEntry: Record "Item Application Entry";
        BoardOutputLines: Record "Item Ledger Entry";
        TempBoardOutputQty: Decimal;
        TempBoardOutputWeight: Decimal;
    begin
        // Lines added By Deepak kUmar
        ProdOrderLine.Reset;
        ProdOrderLine.SetCurrentKey(Status, "Prod. Order No.", "Planning Level Code");
        ProdOrderLine.Ascending(false);
        ProdOrderLine.SetRange(Status, ProdOrder.Status);
        ProdOrderLine.SetRange("Prod. Order No.", ProdOrder."No.");
        if ProdOrderLine.FindSet then begin
            repeat
                //MESSAGE(FORMAT(ProdOrderLine."Planning Level Code"));
                TempTotalWeight := 0;
                ItemLedgerEntry.Reset;
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Entry Type", ItemLedgerEntry."Entry Type"::Consumption);
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Order Type", ItemLedgerEntry."Order Type"::Production);
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Order No.", ProdOrderLine."Prod. Order No.");
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Order Line No.", ProdOrderLine."Line No.");
                if ItemLedgerEntry.FindFirst then begin
                    repeat
                        // MESSAGE('%1 %2 %3 %4',ItemLedgerEntry."Entry Type",ItemLedgerEntry."Item No.",ItemLedgerEntry.Quantity,ItemLedgerEntry."Actual Weight");
                        if ItemLedgerEntry."Item Category Code" = 'PAPER' then begin
                            TempTotalWeight := TempTotalWeight + Abs(ItemLedgerEntry.Quantity);
                        end;
                        if ItemLedgerEntry."Item Category Code" = 'BOARD' then begin
                            BoardOutputLines.Reset;
                            BoardOutputLines.SetRange(BoardOutputLines."Entry Type", BoardOutputLines."Entry Type"::Output);
                            BoardOutputLines.SetRange(BoardOutputLines."Order Type", ItemLedgerEntry."Order Type");
                            BoardOutputLines.SetRange(BoardOutputLines."Order No.", ItemLedgerEntry."Order No.");
                            BoardOutputLines.SetRange(BoardOutputLines."Item No.", ItemLedgerEntry."Item No.");
                            if BoardOutputLines.FindFirst then begin
                                repeat
                                    TempBoardOutputQty += BoardOutputLines.Quantity;
                                    TempBoardOutputWeight += BoardOutputLines."Actual Output Weight";
                                until BoardOutputLines.Next = 0;
                            end;
                            if TempBoardOutputQty > 0 then
                                TempTotalWeight := TempTotalWeight + ((TempBoardOutputWeight * Abs(ItemLedgerEntry.Quantity)) / TempBoardOutputQty)
                            else
                                TempTotalWeight := TempTotalWeight + ((TempBoardOutputWeight * Abs(ItemLedgerEntry.Quantity)) / 1);
                        end;

                    until ItemLedgerEntry.Next = 0;
                end;
                if ProdOrderLine."Finished Quantity" > 1 then
                    ProdOrderLine."Actual Per Unit Weight" := TempTotalWeight / ProdOrderLine."Finished Quantity"
                else
                    ProdOrderLine."Actual Per Unit Weight" := TempTotalWeight / 1;

                ProdOrderLine.Modify();
                OutputLedgerEntry.Reset;
                OutputLedgerEntry.SetRange(OutputLedgerEntry."Entry Type", OutputLedgerEntry."Entry Type"::Output);
                OutputLedgerEntry.SetRange(OutputLedgerEntry."Order Type", OutputLedgerEntry."Order Type"::Production);
                OutputLedgerEntry.SetRange(OutputLedgerEntry."Order No.", ProdOrderLine."Prod. Order No.");
                OutputLedgerEntry.SetRange(OutputLedgerEntry."Order Line No.", ProdOrderLine."Line No.");
                if OutputLedgerEntry.FindFirst then begin
                    repeat
                        OutputLedgerEntry."Actual Output Weight" := OutputLedgerEntry.Quantity * ProdOrderLine."Actual Per Unit Weight";
                        OutputLedgerEntry.Modify(true);
                    until OutputLedgerEntry.Next = 0;
                end;
            until ProdOrderLine.Next = 0;
        end;
        //MESSAGE('Complete');
    end;

    procedure CheckOutstandingQuantity(ProductionOrder: Record "Production Order")
    var
        ProdOrderLine: Record "Prod. Order Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        Sam001: Label 'Item No %1  %2 not consumed completely, remaining Quantity is %3, Please complete the consumption/ Scrap entry.';
    begin
        // Lines added By Deepak Kumar
        ProdOrderLine.Reset;
        ProdOrderLine.SetRange(ProdOrderLine.Status, ProductionOrder.Status);
        ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", ProductionOrder."No.");
        ProdOrderLine.SetFilter(ProdOrderLine."Planning Level Code", '>0');
        if ProdOrderLine.FindFirst then begin
            repeat
                ItemLedgerEntry.Reset;
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Order Type", ItemLedgerEntry."Order Type"::Production);
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Order No.", ProdOrderLine."Prod. Order No.");
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Item No.", ProdOrderLine."Item No.");
                if ItemLedgerEntry.FindFirst then begin
                    repeat
                        if ItemLedgerEntry."Remaining Quantity" > 0 then
                            Error(Sam001, ItemLedgerEntry."Item No.", ItemLedgerEntry.Description, ItemLedgerEntry."Remaining Quantity");
                    until ItemLedgerEntry.Next = 0;
                end;
            until ProdOrderLine.Next = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 5407, 'OnBeforeChangeStatusOnProdOrder', '', false, false)]
    local procedure CU5407_OnBeforeChangeStatusOnProdOrder(VAR ProductionOrder: Record "Production Order"; NewStatus: Option Quote,Planned,"Firm Planned",Released,Finished)
    begin
        IF NewStatus = NewStatus::Finished THEN
            CheckOutstandingQuantity(ProductionOrder);//Deepak
    end;

    [EventSubscriber(ObjectType::Codeunit, 5407, 'OnAfterChangeStatusOnProdOrder', '', false, false)]
    local procedure CU5407_OOnAfterChangeStatusOnProdOrder(VAR ProdOrder: Record "Production Order"; VAR ToProdOrder: Record "Production Order")
    begin
        IF ProdOrder.Status = ProdOrder.Status::Finished THEN
            UpdateFGWeight(ProdOrder);//Deepak
    end;
    //Codeunit 5407 +
    //Codeunit 5407 +
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterPostUpdateOrderLine', '', false, false)]
    local procedure CU90_OnAfterPostUpdateOrderLine(VAR PurchaseLine: Record "Purchase Line"; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean)
    var
        TempPurchLineD: Record "Purchase Line";
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader.get(PurchaseLine."Document Type", PurchaseLine."Document No.");
        IF PurchaseLine.Quantity <> 0 THEN BEGIN
            IF PurchHeader.Receive THEN BEGIN
                // Lines added By Depak Kumar
                IF PurchaseLine."For Location Roll Entry" = PurchaseLine."For Location Roll Entry"::Child THEN BEGIN
                    TempPurchLineD.RESET;
                    TempPurchLineD.SETRANGE(TempPurchLineD."Document Type", PurchaseLine."Document Type");
                    TempPurchLineD.SETRANGE(TempPurchLineD."Document No.", PurchaseLine."Document No.");
                    TempPurchLineD.SETRANGE(TempPurchLineD."Line No.", PurchaseLine."Line Ref. No");
                    IF TempPurchLineD.FINDFIRST THEN BEGIN
                        TempPurchLineD."Roll Quantity to Receive" := 0;
                        TempPurchLineD."Quantity Received" := TempPurchLineD."Quantity Received" + PurchaseLine."Qty. to Receive";
                        TempPurchLineD."Qty. Received (Base)" := TempPurchLineD."Qty. Received (Base)" + PurchaseLine."Qty. to Receive (Base)";
                        TempPurchLineD."Outstanding Quantity" := TempPurchLineD.Quantity - TempPurchLineD."Quantity Received";
                        TempPurchLineD."Outstanding Qty. (Base)" := TempPurchLineD."Outstanding Quantity";
                        TempPurchLineD.MODIFY(TRUE);
                    END;
                END;
                //End//Deepak
            End;//Deepak                
        end;
    End;

    [EventSubscriber(ObjectType::Codeunit, 5813, 'OnAfterUpdateOrderLine', '', false, false)]
    local procedure CU5813_OnAfterUpdateOrderLine(VAR PurchRcptLine: Record "Purch. Rcpt. Line"; VAR PurchLine: Record "Purchase Line")
    var
        TempPurchLineD: Record "Purchase Line";
    begin
        TempPurchLineD.Reset;
        TempPurchLineD.SetRange(TempPurchLineD."Document Type", PurchLine."Document Type");
        TempPurchLineD.SetRange(TempPurchLineD."Document No.", PurchLine."Document No.");
        TempPurchLineD.SetRange(TempPurchLineD."Line No.", PurchLine."Line Ref. No");
        if TempPurchLineD.FindFirst then begin
            TempPurchLineD."Roll Quantity to Receive" := 0;
            TempPurchLineD."Quantity Received" := TempPurchLineD."Quantity Received" - PurchRcptLine.Quantity;
            TempPurchLineD."Qty. Received (Base)" := TempPurchLineD."Qty. Received (Base)" - PurchRcptLine."Quantity (Base)";
            TempPurchLineD."Outstanding Quantity" := TempPurchLineD.Quantity - TempPurchLineD."Quantity Received";
            TempPurchLineD.Modify(true);
        end;
    end;
    //Codeunit 5407 +
    //Codeunit 5836 -
    [EventSubscriber(ObjectType::Table, 5407, 'OnGetNeededQtyAfterCalcCompQtyBase', '', false, false)]
    local procedure TAB5407_OnGetNeededQtyAfterCalcCompQtyBase(VAR ProdOrderLine: Record "Prod. Order Line"; VAR ProdOrderComp: Record "Prod. Order Component"; VAR CompQtyBase: Decimal)
    var
        CostCalculationManagement: Codeunit "Cost Calculation Management";
        CompQtyBasePerMfgQtyBase: Decimal;
        OutputQtyBase: Decimal;
        CapLedgEntry: Record "Capacity Ledger Entry";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        OperationNo: Code[20];

    begin
        // ProdOrderLine.Get(ProdOrderComp.Status, ProdOrderComp."Prod. Order No.", ProdOrderComp."Prod. Order Line No.");
        // CompQtyBasePerMfgQtyBase := ProdOrderComp."Quantity (Base)" / ProdOrderLine."Qty. per Unit of Measure";
        // ProdOrderRoutingLine.Reset;
        // ProdOrderRoutingLine.SetRange(ProdOrderRoutingLine.Status, ProdOrderRoutingLine.Status::Released);
        // ProdOrderRoutingLine.SetRange(ProdOrderRoutingLine."Prod. Order No.", ProdOrderComp."Prod. Order No.");
        // ProdOrderRoutingLine.SetRange(ProdOrderRoutingLine."Routing Reference No.", ProdOrderComp."Prod. Order Line No.");
        // ProdOrderRoutingLine.SetRange(ProdOrderRoutingLine."Routing Link Code", ProdOrderComp."Routing Link Code");
        // if ProdOrderRoutingLine.FindFirst then begin
        //     if (ProdOrderRoutingLine."Die Cut Ups" > 1) or (ProdOrderRoutingLine."No of Joints" > 1) then begin
        //         CompQtyBasePerMfgQtyBase := 1 / ProdOrderLine."Qty. per Unit of Measure";
        //         OperationNo := ProdOrderRoutingLine."Operation No.";
        //     end else begin
        //         CompQtyBasePerMfgQtyBase := ProdOrderComp."Quantity (Base)" / ProdOrderLine."Qty. per Unit of Measure";
        //     end;
        // end;
        CompQtyBasePerMfgQtyBase := ProdOrderComp."Quantity (Base)" / ProdOrderLine."Qty. per Unit of Measure";

        if ProdOrderComp.Status in [ProdOrderComp.Status::Released, ProdOrderComp.Status::Finished] then begin
            CapLedgEntry.SetCurrentKey("Order Type", "Order No.", "Order Line No.");
            CapLedgEntry.SetRange("Order Type", CapLedgEntry."Order Type"::Production);
            CapLedgEntry.SetRange("Order No.", ProdOrderComp."Prod. Order No.");
            CapLedgEntry.SetRange("Order Line No.", ProdOrderComp."Prod. Order Line No.");
            CapLedgEntry.SetRange("Operation No.", OperationNo);
            if CapLedgEntry.Find('-') then
                repeat
                    OutputQtyBase := OutputQtyBase + CapLedgEntry."Output Quantity" + CapLedgEntry."Scrap Quantity";
                until CapLedgEntry.Next = 0;

            CompQtyBase := CostCalculationManagement.CalcQtyAdjdForBOMScrap(OutputQtyBase * CompQtyBasePerMfgQtyBase, ProdOrderComp."Scrap %")
        end;
    end;
    //Codeunit 5836 +

    procedure TemplateSelectionForVouchers(PageID: Integer; RecurringJnl: Boolean; SubType: Option " ","Cash Receipt Voucher","Cash Payment Voucher","Bank Receipt Voucher","Bank Payment Voucher","Contra Voucher","Journal Voucher"; var GenJnlLine: Record "Gen. Journal Line"; var JnlSelected: Boolean)
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        Text16501: Label 'CASH RCPT';
        Text001: Label '%1 journal';
        Text002: Label 'RECURRING';
        Text003: Label 'Recurring General Journal';
    begin
        JnlSelected := true;
        GenJnlTemplate.Reset;
        GenJnlTemplate.SetRange("Page ID", PageID);
        GenJnlTemplate.SetRange(Recurring, RecurringJnl);
        if not RecurringJnl then
            GenJnlTemplate.SetRange(Type, 0);
        GenJnlTemplate.SetRange("Sub Type", SubType);
        case GenJnlTemplate.Count of
            0:
                begin
                    GenJnlTemplate.Init;
                    GenJnlTemplate.Type := 0;
                    GenJnlTemplate."Sub Type" := SubType;
                    GenJnlTemplate.Recurring := RecurringJnl;
                    if not RecurringJnl then begin
                        if GenJnlTemplate."Sub Type" = GenJnlTemplate."Sub Type"::"Cash Receipt Voucher" then
                            GenJnlTemplate.Name := Format(Text16501, MaxStrLen(GenJnlTemplate.Name))
                        else
                            GenJnlTemplate.Name := Format(GenJnlTemplate."Sub Type", MaxStrLen(GenJnlTemplate.Name));
                        GenJnlTemplate.Description := StrSubstNo(Text001, GenJnlTemplate.Type);
                    end else begin
                        GenJnlTemplate.Name := Text002;
                        GenJnlTemplate.Description := Text003;
                    end;
                    GenJnlTemplate.Validate(Type);
                    GenJnlTemplate.Validate("Sub Type");
                    GenJnlTemplate.Insert;
                    GenJnlTemplate.TestField("Source Code");
                    Commit;
                end;
            1:
                GenJnlTemplate.Find('-');
            else
                JnlSelected := PAGE.RunModal(0, GenJnlTemplate) = ACTION::LookupOK;
        end;
        if JnlSelected then begin
            GenJnlLine.FilterGroup := 2;
            GenJnlLine.SetRange("Journal Template Name", GenJnlTemplate.Name);
            GenJnlLine.FilterGroup := 0;
        end;
    end;

    procedure CalcTotDebitTotCreditAmount(var GenJnlLine: Record "Gen. Journal Line"; var TotalDebitAmount: Decimal; var TotalCreditAmount: Decimal; Post: Boolean)
    var
        TempGenJnlLine: Record "Gen. Journal Line";
    begin
        TotalDebitAmount := 0;
        TotalCreditAmount := 0;
        TempGenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
        TempGenJnlLine.CopyFilters(GenJnlLine);
        if TempGenJnlLine.FindSet then
            repeat
                if TempGenJnlLine."Debit Amount" > 0 then
                    TotalDebitAmount += TempGenJnlLine."Debit Amount";
                if TempGenJnlLine."Credit Amount" > 0 then
                    TotalCreditAmount += TempGenJnlLine."Credit Amount";

                if TempGenJnlLine."Bal. Account No." <> '' then begin
                    if TempGenJnlLine."Debit Amount" > 0 then
                        TotalCreditAmount += TempGenJnlLine."Debit Amount";
                    if TempGenJnlLine."Credit Amount" > 0 then
                        TotalDebitAmount += TempGenJnlLine."Credit Amount";
                end;
            until TempGenJnlLine.Next = 0;
    end;

    [EventSubscriber(ObjectType::Table, 203, 'OnAfterCopyFromResJnlLine', '', false, false)]
    local procedure TAB203_OnAfterCopyFromResJnlLine(VAR ResLedgerEntry: Record "Res. Ledger Entry"; ResJournalLine: Record "Res. Journal Line")
    begin
        // Start  B2BPLM1.00.00 - 01
        ResLedgerEntry."Machine Id" := ResJournalLine."Machine Id";
        // Stop  B2BPLM1.00.00 - 01
    end;

    //99000773 -
    [EventSubscriber(ObjectType::Codeunit, 99000773, 'OnAfterTransferRoutingLine', '', false, false)]
    local procedure CU99000773_OnAfterTransferRoutingLine(VAR ProdOrderLine: Record "Prod. Order Line"; VAR RoutingLine: Record "Routing Line"; VAR ProdOrderRoutingLine: Record "Prod. Order Routing Line")
    var
        PrintPlate: Record Item;
        MC: Record 99000758;
    begin
        // lines added BY Deepak Kumar
        PrintPlate.RESET;
        PrintPlate.SETRANGE(PrintPlate."Plate Item", TRUE);
        IF PrintPlate.FINDFIRST THEN
            ProdOrderRoutingLine."Printing Plate" := PrintPlate."No.";
        IF RoutingLine.Type = RoutingLine.Type::"Machine Center" THEN BEGIN
            MC.GET(RoutingLine."No.");
            ProdOrderRoutingLine."Printing Plate Applicable" := MC."Printing Plate Applicable";
        END;
        ProdOrderRoutingLine."Die Cut Ups" := RoutingLine."Die Cut Ups";
        ProdOrderRoutingLine."No of Joints" := RoutingLine."No of Joints";
        ProdOrderRoutingLine."Routing Unit of Measure" := RoutingLine."Routing Unit of Measure";
        ProdOrderRoutingLine."Estimate Type" := RoutingLine."Estimate Type";
        ProdOrderRoutingLine."Estimation No." := RoutingLine."Estimation No.";
        ProdOrderRoutingLine."Sub Comp No." := RoutingLine."Sub Comp No.";
        ProdOrderRoutingLine."Routing Unit of Measure" := RoutingLine."Routing Unit of Measure";
    end;

    [EventSubscriber(ObjectType::Codeunit, 99000773, 'OnAfterTransferBOMComponent', '', false, false)]
    local procedure CU99000773_OnAfterTransferBOMComponent(VAR ProdOrderLine: Record "Prod. Order Line"; VAR ProductionBOMLine: Record "Production BOM Line"; VAR ProdOrderComponent: Record "Prod. Order Component")
    var
        ItemMaster: Record Item;
        ManfSetup: Record "Manufacturing Setup";
        GetPlanningParameters: Codeunit "Planning-Get Parameters";
        SKU: Record "Stockkeeping Unit";
    begin
        GetPlanningParameters.AtSKU(
   SKU,
   ProdOrderLine."Item No.",
   ProdOrderLine."Variant Code",
   ProdOrderLine."Location Code");
        ItemMaster.RESET;
        ItemMaster.SETRANGE(ItemMaster."No.", ProdOrderComponent."Item No.");
        IF ItemMaster.FINDFIRST THEN BEGIN
            ProdOrderComponent.Description := ItemMaster.Description;
        END ELSE BEGIN
            ProdOrderComponent.Description := ProductionBOMLine.Description;//Deepak
        END;
        ManfSetup.GET();
        IF ItemMaster."Inventory Posting Group" = 'SUBJOB' THEN
            ProdOrderComponent."Location Code" := ManfSetup."Def. Location for Production"
        ELSE
            ProdOrderComponent."Location Code" := SKU."Components at Location";
        IF (ProductionBOMLine."Routing Link Code" = ManfSetup."OSP Routing Link Code") AND (ManfSetup."OSP Routing Link Code" <> '') THEN
            ProdOrderComponent."Location Code" := ManfSetup."Default Location For OSP";

        ProdOrderComponent."Take Up" := ProductionBOMLine."Take Up";
        ProdOrderComponent."Paper Position" := ProductionBOMLine."Paper Position";
        ProdOrderComponent."Flute Type" := ProductionBOMLine."Flute Type";
        ProdOrderComponent."Product Design Type" := ProductionBOMLine."Estimate Type";
        ProdOrderComponent."Product Design No." := ProductionBOMLine."Estimation No.";
        ProdOrderComponent."Sub Comp No." := ProductionBOMLine."Sub Comp No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, 99000773, 'OnAfterProdOrderCompFilter', '', false, false)]
    local procedure CU99000773_OnAfterProdOrderCompFilter(VAR ProdOrderComp: Record "Prod. Order Component"; ProdBOMLine: Record "Production BOM Line")
    begin
        ProdOrderComp.SETRANGE(ProdOrderComp."Line No.", ProdBOMLine."Line No.");
    end;
    //99000773 +
    //99000787 -
    [EventSubscriber(ObjectType::Codeunit, 99000787, 'OnInitProdOrderLineBeforeAssignItemNo', '', false, false)]
    local procedure CU99000787_OnInitProdOrderLineBeforeAssignItemNo(VAR ProdOrderLine: Record "Prod. Order Line"; ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10])
    var
        ProdOrder: Record "Production Order";
        EstimateHeader: Record 50000;
        SH: Record "Sales Header";
    begin
        ProdOrder.Get(ProdOrderLine.Status, ProdOrderLine."Prod. Order No.");
        ProdOrderLine."Sales Order No." := ProdOrder."Sales Order No."; ///deepak
        ProdOrderLine."Sales Requested Delivery Date" := ProdOrder."Sales Requested Delivery Date";
        ProdOrderLine."Sales Order Line No." := ProdOrder."Sales Order Line No.";
        ProdOrderLine."Flute Type" := ProdOrder."Flute Type";
        ProdOrderLine."No. of Ply" := ProdOrder."No. of Ply";
        ProdOrderLine."Color Code" := ProdOrder."Color Code";
        ProdOrderLine."Estimate Code" := ProdOrder."Estimate Code";
        ProdOrderLine."Product Design No." := ProdOrder."Estimate Code";
        EstimateHeader.RESET;
        EstimateHeader.SETRANGE(EstimateHeader."Product Design No.", ProdOrderLine."Estimate Code");
        EstimateHeader.SETRANGE(EstimateHeader."Item Code", ProdOrderLine."Item No.");
        IF EstimateHeader.FINDFIRST THEN BEGIN
            ProdOrderLine."Product Design Type" := EstimateHeader."Product Design Type";
            ProdOrderLine."Product Design No." := EstimateHeader."Product Design No.";
            ProdOrderLine."Sub Comp No." := EstimateHeader."Sub Comp No.";
            ProdOrderLine."Die Cut Ups" := EstimateHeader."No. of Die Cut Ups";
            ProdOrderLine."No of Joints" := EstimateHeader."No. of Joint";
        END;
        IF ProdOrder."Sales Order No." <> '' THEN BEGIN
            SH.RESET;
            SH.SETRANGE(SH."Document Type", SH."Document Type"::Order);
            SH.SETRANGE(SH."No.", ProdOrder."Sales Order No.");
            IF SH.FINDFIRST THEN
                ProdOrderLine."Sales Requested Delivery Date" := SH."Order Date";
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, 99000787, 'OnCheckMakeOrderLineBeforeInsert', '', false, false)]
    local procedure CU99000787_OnCheckMakeOrderLineBeforeInsert(VAR ProdOrderLine: Record "Prod. Order Line"; VAR ProdOrderComponent: Record "Prod. Order Component")
    var
        ProdOrderHeader: Record "Production Order";
        EstimateHeader: Record "Product Design Header";
        EstimationHeader: Record "Product Design Header";
        Item: Record Item;
    begin

        // Lines added by Deepak kumar
        MfgSetup.GET();
        ProdOrderHeader.RESET;
        ProdOrderHeader.SETRANGE(ProdOrderHeader."No.", ProdOrderLine."Prod. Order No.");
        IF ProdOrderHeader.FINDFIRST THEN BEGIN
            EstimationHeader.RESET;
            EstimationHeader.SETRANGE(EstimationHeader."Product Design No.", ProdOrderHeader."Estimate Code");
            IF EstimationHeader.FINDFIRST THEN BEGIN
                IF EstimationHeader."Board Ups" = 0 THEN
                    ERROR('The No. of Ups of Estimation No %1 cannot be zero', EstimationHeader."Product Design No.");
            END;
        END;

        IF ProdOrderLine."Board Ups" = 0 THEN
            ProdOrderLine."Board Ups" := 1;
        Item.GET(ProdOrderComponent."Item No.");
        ProdOrderLine.Description := Item.Description;

        // Lines added BY Deepak Kumar
        EstimateHeader.RESET;
        EstimateHeader.SETRANGE(EstimateHeader."Product Design No.", ProdOrderLine."Estimate Code");
        EstimateHeader.SETRANGE(EstimateHeader."Item Code", ProdOrderLine."Item No.");
        IF EstimateHeader.FINDFIRST THEN BEGIN
            ProdOrderLine."Product Design Type" := EstimateHeader."Product Design Type";
            ProdOrderLine."Product Design No." := EstimateHeader."Product Design No.";
            ProdOrderLine."Sub Comp No." := EstimateHeader."Sub Comp No.";
        END ELSE BEGIN
            ProdOrderLine."Product Design Type" := ProdOrderComponent."Product Design Type";
            ProdOrderLine."Product Design No." := ProdOrderComponent."Product Design No.";
            ProdOrderLine."Sub Comp No." := ProdOrderComponent."Sub Comp No.";
        END;
    end;
    //CU232 -
    [EventSubscriber(ObjectType::Codeunit, 232, 'OnBeforeGLRegPostingReportPrint', '', false, false)]
    local procedure CU232_OnBeforeGLRegPostingReportPrint(VAR ReportID: Integer; ReqWindow: Boolean; SystemPrinter: Boolean; VAR GLRegister: Record "G/L Register"; VAR Handled: Boolean)
    var
        GLEntry: Record "G/L Entry";
    begin
        GLEntry.SETRECFILTER;
        REPORT.RUN(ReportID, FALSE, FALSE, GLEntry);    //frz 190116
        Handled := true;
    end;
    //CU232 +
    [EventSubscriber(ObjectType::Codeunit, 6620, 'OnBeforeCopySalesInvLines', '', false, false)]
    local procedure CU6620_OnBeforeCopySalesInvLines(VAR TempDocSalesLine: Record "Sales Line" TEMPORARY; VAR ToSalesHeader: Record "Sales Header"; VAR FromSalesInvLine: Record "Sales Invoice Line")
    var
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        SalesInvHeader.Get(FromSalesInvLine."Document No.");
        ToSalesHeader."External Document No." := SalesInvHeader."External Document No.";
        ToSalesHeader.Modify();
    end;

    procedure ReleasePurchDoc(var PurchaseHeader: Record "Purchase Header")
    var
        InvtSetup: Record "Inventory Setup";
        Text001: Label 'There is nothing to release for the document of type %1 with the number %2.';
        NotOnlyDropShipment: Boolean;
        PurchSetup: Record "Purchases & Payables Setup";
        PostingDate: Date;
        PrintPostedDocuments: Boolean;
        LinesWereModified: Boolean;
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ReleasePurch: Codeunit "Release Purchase Document";
        PurchLine: Record "Purchase Line";
    begin
        WITH PurchaseHeader DO BEGIN
            IF Status = Status::Released THEN
                EXIT;
            TESTFIELD("Buy-from Vendor No.");

            PurchLine.SETRANGE("Document Type", "Document Type");
            PurchLine.SETRANGE("Document No.", "No.");
            PurchLine.SETFILTER(Type, '>0');
            PurchLine.SETFILTER(Quantity, '<>0');
            IF NOT PurchLine.FIND('-') THEN
                ERROR(Text001, "Document Type", "No.");
            InvtSetup.GET;
            IF InvtSetup."Location Mandatory" THEN BEGIN
                PurchLine.SETRANGE(Type, PurchLine.Type::Item);
                IF PurchLine.FIND('-') THEN
                    REPEAT
                        IF PurchLine.IsInventoriableItem THEN
                            PurchLine.TESTFIELD("Location Code");
                    UNTIL PurchLine.NEXT = 0;
                PurchLine.SETFILTER(Type, '>0');
            END;

            PurchLine.SETRANGE("Drop Shipment", FALSE);
            NotOnlyDropShipment := PurchLine.FIND('-');
            PurchLine.RESET;

            PurchSetup.GET;
            IF PurchSetup."Calc. Inv. Discount" THEN BEGIN
                PostingDate := "Posting Date";
                PrintPostedDocuments := "Print Posted Documents";
                CODEUNIT.RUN(CODEUNIT::"Purch.-Calc.Discount", PurchLine);
                LinesWereModified := TRUE;
                GET("Document Type", "No.");
                "Print Posted Documents" := PrintPostedDocuments;
                IF PostingDate <> "Posting Date" THEN
                    VALIDATE("Posting Date", PostingDate);
            END;

            IF PrepaymentMgt.TestPurchasePrepayment(PurchaseHeader) AND ("Document Type" = "Document Type"::Order) THEN BEGIN
                Status := Status::"Pending Prepayment";
                MODIFY(TRUE);
                EXIT;
            END;
            Status := Status::Released;

            LinesWereModified := LinesWereModified OR ReleasePurch.CalcAndUpdateVATOnLines(PurchaseHeader, PurchLine);
            MODIFY(TRUE);

        END;
    end;
}