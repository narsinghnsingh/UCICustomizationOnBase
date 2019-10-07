report 50036 "Close LCS"
{
    // version LC Detail

    Caption = 'Close LCS';
    ProcessingOnly = true;

    dataset
    {
        dataitem("LC Detail";"LC Detail")
        {
            DataItemTableView = SORTING("No.") WHERE(Closed=CONST(false));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                Window.Update(1,"No.");
                if "Expiry Date" > RecDate then begin
                  Closed := true;
                  Modify;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(Text002);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(RecDate;RecDate)
                    {
                        Caption = 'Date';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            RecDate := WorkDate;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if RecDate = 0D then
          Error(Text001);
    end;

    var
        RecDate: Date;
        Window: Dialog;
        Text001: Label 'Date cannot be empty.';
        Text002: Label 'Processing LC''''s #1########';
}

