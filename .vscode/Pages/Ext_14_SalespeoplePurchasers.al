pageextension 50000 Ext_SalespeoplePurchasers extends 14
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("E-Mail"; "E-Mail")
            {

            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addlast(Coupling)
        {
            action(SendStatement)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = SendConfirmation;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    RecCustomer.RESET;
                    RecCustomer.SETRANGE(RecCustomer."Salesperson Code", Code);
                    IF RecCustomer.FINDSET THEN BEGIN
                        REPEAT
                            CustNo := RecCustomer."No.";
                            CustMail := RecCustomer."E-Mail";
                            RecCustomer1.RESET;
                            RecCustomer1.SETRANGE(RecCustomer1."No.", RecCustomer."No.");
                            IF RecCustomer1.FINDFIRST THEN BEGIN
                                EVALUATE(StartDate, '01-01-2015');
                                CurDateTime := CREATEDATETIME(TODAY, TIME);
                                FileName1 := 'E:\Email Statement\' + RecCustomer1.Name + '_' + FORMAT(TODAY) + '.pdf';
                                REPORT.SAVEASPDF(50106, FileName1, RecCustomer1);
                                IF EXISTS(FileName1) THEN BEGIN
                                    SMTPMailSetup.GET();
                                    SMTPMail.CreateMessage('Universal Carton Industries', SMTPMailSetup."User ID", "E-Mail", 'SOA' + '-' + RecCustomer1.Name, '', TRUE);
                                    SMTPMail.AddAttachment(FileName1, '');
                                    SMTPMail.AppendBody('Dear ' + Code + ' ,' + '<BR><BR>');
                                    SMTPMail.AppendBody('The following statement is attached for your reference' + '<BR><BR>');
                                    SMTPMail.AppendBody('Regards' + '<BR>');
                                    SMTPMail.AppendBody('Zohaib Abdul Rauf Bilwani' + '<BR>');
                                    SMTPMail.AppendBody('AM Finance' + '<BR>');
                                    SMTPMail.AppendBody('Universal Carton Industries');
                                    SMTPMail.AddRecipients("E-Mail");
                                    SMTPMail.Send;
                                    SLEEP(10000);
                                END;
                            END;
                        UNTIL RecCustomer.NEXT = 0;
                        MESSAGE('SOA has been Successfully Sent to %1 ', Code);
                    END;
                end;
            }


        }

    }

    var

        RecCustomer: Record 18;
        CustNo: Code[20];
        CustMail: Code[50];
        RecCustomer1: Record 18;
        FileName1: Text;
        SMTPMailSetup: Record 409;
        SMTPMail: Codeunit 400;
        CurrentMonth: Integer;
        CurrentYear: Integer;
        StartDate: Date;
        EndDate: Date;
        CurDateTime: DateTime;
        ItemSale: Report 113;
        RepValue: Code[20];
        XMLParemeter: Text;
        tempBlob: Record TempBlob;
        EmailOutstream: OutStream;
        EmailInstream: InStream;

}