report 50037 "Renewal of LC's Credit Limit"
{
    // version LC Detail

    Caption = 'Renewal of LC''s Credit Limit';
    ProcessingOnly = true;

    dataset
    {
        dataitem("LC Detail";"LC Detail")
        {
            DataItemTableView = SORTING("No.") WHERE(Closed=CONST(true));
            RequestFilterFields = "No.","Type of Credit Limit","Revolving Cr. Limit Types";

            trigger OnAfterGetRecord()
            begin
                Window.Update(1,"No.");
                if "Type of Credit Limit" = "Type of Credit Limit"::Revolving then begin
                  LCOrders.SetRange("LC No.","No.");
                  if LCOrders.Find('-') then
                    repeat
                      if "Revolving Cr. Limit Types" = "Revolving Cr. Limit Types"::Manual then begin
                        if not LCOrders."Received Bank Receipt No." then
                          CurrReport.Skip
                          ;
                        LCOrders.Renewed := true;
                      end;
                      if "Revolving Cr. Limit Types" = "Revolving Cr. Limit Types"::Automatic then
                        LCOrders.Renewed := true;
                      LCOrders.Modify;
                    until LCOrders.Next = 0;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open('Processing LC''s #1#########');
            end;
        }
    }

    requestpage
    {

        layout
        {
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

    var
        RecDate: Date;
        Window: Dialog;
        LCOrders: Record "LC Orders";
}

