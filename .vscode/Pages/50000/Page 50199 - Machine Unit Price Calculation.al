page 50199 "Machine Unit Price Calculation"
{
    // version NAVW18.00

    CaptionML = ENU = 'Machine Unit Price Calculation';
    CardPageID = "G/L Account Card";
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "G/L Account";
    SourceTableView = SORTING ("No.") ORDER(Ascending) WHERE ("Machine Cost Matrix" = CONST (true));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                ShowCaption = false;
                field("No."; "No.")
                {
                    Style = Strong;
                    StyleExpr = NoEmphasize;
                }
                field(Name; Name)
                {
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                }
                field("Direct Posting"; "Direct Posting")
                {
                    Visible = false;
                }
                field("Net Change"; "Net Change")
                {
                    BlankZero = true;
                }
                field("Balance at Date"; "Balance at Date")
                {
                    BlankZero = true;
                }
                field(Balance; Balance)
                {
                    BlankZero = true;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("A&ccount")
            {
                CaptionML = ENU = 'A&ccount';
                Image = ChartOfAccounts;
                action("Machine Cost Matrix")
                {
                    CaptionML = ENU = 'Machine Cost Matrix';
                    Image = MachineCenterLoad;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Machine Proportion Page GL";
                    RunPageLink = "No." = FIELD ("No.");
                    RunPageView = SORTING ("No.", "Machine No.") ORDER(Ascending);
                }
                action("Calculate Machine Data")
                {
                    CaptionML = ENU = 'Calculate Machine Data';
                    Image = CalculateCost;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        // Lines added by Deepak Kumar
                        IF GETFILTER("Date Filter") = '' THEN
                            ERROR('Please make Date filter');
                        StartDate := GETRANGEMIN("Date Filter");
                        EndDate := GETRANGEMAX("Date Filter");

                        NoofDays := EndDate - StartDate + 1;
                        //MESSAGE('%1 %2 %3',StartDate,EndDate,NoofDays);
                        GLAccount.RESET;
                        GLAccount.SETRANGE(GLAccount."Machine Cost Matrix", TRUE);
                        GLAccount.SETFILTER(GLAccount."Date Filter", GETFILTER("Date Filter"));
                        IF GLAccount.FINDFIRST THEN BEGIN
                            REPEAT
                                GLAccount.CALCFIELDS(GLAccount."Net Change");
                                PerUnitAmount := GLAccount."Net Change" / 100;
                                MachineCostSheet.RESET;
                                MachineCostSheet.SETRANGE(MachineCostSheet."No.", GLAccount."No.");
                                IF MachineCostSheet.FINDFIRST THEN BEGIN
                                    REPEAT
                                        MachineCenter.GET(MachineCostSheet."Machine No.");
                                        MachineCenter.TESTFIELD(MachineCenter."Aval.Min/Day for Price Calc");

                                        MachineCostSheet."Unit Amount" := (MachineCostSheet."Machine Percentage" * PerUnitAmount) / (NoofDays * MachineCenter."Aval.Min/Day for Price Calc");
                                        MachineCostSheet.MODIFY(TRUE);
                                        // MachineCostSheetHistory.RESET;
                                        // IF MachineCostSheetHistory.FINDLAST THEN
                                        //     LastEntryNo := MachineCostSheetHistory.SalesHeadeDocNo;
                                        // // Update Machine Cost history

                                        // MachineCostSheetHistory.INIT;
                                        // LastEntryNo += 1;
                                        // MachineCostSheetHistory.SalesHeadeDocNo := LastEntryNo;
                                        // MachineCostSheetHistory."Account No." := MachineCostSheet."No.";
                                        // MachineCostSheetHistory."Account Name" := MachineCostSheet.Name;
                                        // MachineCostSheetHistory."Machine No." := MachineCostSheet."Machine No.";
                                        // MachineCostSheetHistory."Machine Name" := MachineCostSheet."Machine Name";
                                        // MachineCostSheetHistory."Machine Percentage" := MachineCostSheet."Machine Percentage";
                                        // MachineCostSheetHistory."Updated Unit Amount" := MachineCostSheet."Unit Amount";
                                        // MachineCostSheetHistory."Date Filter" := GETFILTER("Date Filter");
                                        // MachineCostSheetHistory."Aval.Min/Day for Price Calc" := MachineCenter."Aval.Min/Day for Price Calc";
                                        // MachineCostSheetHistory."Net Change Amount" := GLAccount."Net Change";
                                        // MachineCostSheetHistory."Created By" := USERID + ' ' + FORMAT(CURRENTDATETIME);
                                        MachineCostSheetHistory.INSERT(TRUE);

                                    UNTIL MachineCostSheet.NEXT = 0;
                                END;
                            UNTIL GLAccount.NEXT = 0;
                            UpdateMachineUnitCost;
                            MESSAGE('Complete');
                        END;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NoEmphasize := "Account Type" <> "Account Type"::Posting;
        NameIndent := Indentation;
        NameEmphasize := "Account Type" <> "Account Type"::Posting;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetupNewGLAcc(xRec, BelowxRec);
    end;

    var
        [InDataSet]
        NoEmphasize: Boolean;
        [InDataSet]
        NameEmphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;
        GLAccount: Record "G/L Account";
        MachineCostSheet: Record "Machine Cost Sheet";
        PerUnitAmount: Decimal;
        StartDate: Date;
        EndDate: Date;
        NoofDays: Integer;
        MachineCenter: Record "Machine Center";
        MachineCostSheetHistory: Record SalesOrderPicture;
        LastEntryNo: Integer;

    local procedure UpdateMachineUnitCost()
    begin
        // Lines added By Deepak Kumar
        MachineCenter.RESET;
        IF MachineCenter.FINDFIRST THEN BEGIN
            REPEAT
                MachineCenter.CALCFIELDS(MachineCenter."Machine Price Calculated");
                MachineCenter."Direct Unit Cost" := MachineCenter."Machine Price Calculated";
                MachineCenter.MODIFY(TRUE);
            UNTIL MachineCenter.NEXT = 0;
        END;
    end;
}

