pageextension 50079 Ext_99000867_FinishedProdOrd extends "Finished Production Order"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter(Statistics)
        {
            action("ReOpen Job")
            {
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = JobEnabled;
                trigger OnAction()
                var
                    FinishProOrderReOpen: Codeunit "Finish Pro Order ReOpen";
                begin
                    FinishProOrderReOpen.POReOpen("No.");
                    MESSAGE('Done');
                end;
            }
        }
    }


    var
        JobEnabled: Boolean;
        UserSetup: Record "User Setup";

    trigger
    OnOpenPage()
    begin
        UserSetup.RESET;
        IF UserSetup.GET(USERID) THEN BEGIN
            IF UserSetup."Job ReOpen" THEN
                JobEnabled := TRUE
            ELSE
                JobEnabled := FALSE;
        END;
    End;
}