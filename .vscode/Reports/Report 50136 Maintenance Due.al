report 50136 "Maintenance Due"
{
    Caption = 'Maintenance Due';
    ProcessingOnly = true;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Maintenance schedule Part"; "Maintenance schedule Part")
        {

            RequestFilterFields = "Machine ID", "Next Due Date";

            trigger OnPreDataItem()
            begin
                SETRANGE("Maintenance schedule Part"."Next Due Date", WorkDate);
                CLEAR(EvaDate);
                EVALUATE(EvaDate, "Maintenance schedule Part".GETFILTER("Next Due Date"));
                NextDate := CALCDATE('+1D', EvaDate);
                SETRANGE("Next Due Date", NextDate);
            end;

            trigger OnAfterGetRecord()
            begin
                IF Rec_Equipment.GET("Maintenance schedule Part"."Machine ID") THEN BEGIN
                    Rec_Equipment."Marked for Notify" := TRUE;
                    Rec_Equipment.MODIFY;
                END;
            end;

            trigger OnPostDataItem()
            begin
                SendMail;
                Rec_Equipment.RESET;
                Rec_Equipment.SETRANGE("Date Filter", NextDate);
                CLEAR(PMJobCardPerodic);
                PMJobCardPerodic.SETTABLEVIEW(Rec_Equipment);

                COMMIT;
                PMJobCardPerodic.RUN;
                Rec_Equipment.MODIFYALL("Marked for Notify", FALSE);
                Message('DONE');
            end;
        }
    }
    Var
        NextDate: Date;
        MachineEquipment: Record Equipment;
        PlantMaintSetup: Record "Plant Maintenance Setup";
        MachineIds: Text;
        EvaDate: Date;
        Rec_Equipment: Record Equipment;
        PMJobCardPerodic: Report "PM Job Card Perodic";
        Recpmailid: Text;
        Recpmailid1: Text;
        Recpmailid2: Text;
        SMTPMailSetup: Record "SMTP Mail Setup";
        Body1: Text;
        SMTPMail: Codeunit "SMTP Mail";
        Recpmailid3: Text;
        Recpmailid4: Text;


    procedure SendMail()
    begin
        CLEAR(Recpmailid);
        CLEAR(Recpmailid1);
        CLEAR(Recpmailid2);
        PlantMaintSetup.GET;
        IF SMTPMailSetup.GET THEN BEGIN
            IF PlantMaintSetup."Maintenance Mail" <> '' THEN
                Recpmailid := PlantMaintSetup."Maintenance Mail"
            ELSE
                ERROR('Maintenance Email is not define on Maintenance Setup');
            CLEAR(MachineIds);
            Recpmailid1 := 'v.mohd.suhail@mpowersoft.com';
            //Recpmailid2 := 'arsalan@uci.ae';
            SMTPMail.CreateMessage(SMTPMailSetup."User ID", SMTPMailSetup."User ID", Recpmailid + Recpmailid3 + Recpmailid4, 'Preventive Maintenance', 'Dear Team,', TRUE);
            SMTPMail.AddCC(Recpmailid1);
            //SMTPMail.AddCC(Recpmailid2);
            SMTPMail.AppendBody('<BR>');
            SMTPMail.AppendBody('<Br></br>');
            SMTPMail.AppendBody('Please find the below Machines due for Preventive Maintenance.' + '<Br></br>');
            SMTPMail.AppendBody('<Br></br>');
            MachineEquipment.RESET;
            MachineEquipment.SETRANGE("Marked for Notify", TRUE);
            IF MachineEquipment.FINDSET THEN BEGIN
                REPEAT
                    //MachineIds := MachineIds + '' + MachineEquipment."No."                        
                    SMTPMail.AppendBody('Machine ID : ' + MachineEquipment."No." + '' + 'Machine Name : ' + MachineEquipment.Name + '<br>');
                UNTIL MachineEquipment.NEXT = 0;
            END;
            //Body1 := 'Dear '+ 'Team' +','+'<Br></br>'
            //      +'PMR for Machine Ids :-'+ MachineIds + '' + ' is due '+'<Br></br>';
            //SMTPMail.CreateMessage(SMTPMailSetup."User ID",SMTPMailSetup."User ID",Recpmailid+Recpmailid1+Recpmailid2+Recpmailid3+Recpmailid4,'Machine Breakdown',Body1,TRUE);      
            SMTPMail.Send;
        END;
    END;
}