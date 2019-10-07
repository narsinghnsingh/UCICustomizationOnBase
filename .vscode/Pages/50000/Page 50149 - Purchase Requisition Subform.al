page 50149 "Purchase Requisition Subform"
{
    // version Requisition

    PageType = CardPart;
    SourceTable = "Requisition Line SAM";

    layout
    {
        area(content)
        {
            repeater(Control10)
            {
                ShowCaption = false;
                field("Item No."; "Item No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Quantity; Quantity)
                {
                    trigger OnValidate()
                    var
                    begin
                        CalcFields("Available Inventory");
                        IF "Available Inventory" < Quantity THEN begin
                            IF CONFIRM('Available quantity is low, Do you want to notify to Store', true) then
                                SendMailToStore(Rec)
                            else
                                exit;
                        end;
                    end;
                }
                field("Unit Of Measure"; "Unit Of Measure")
                {
                }
                field("Requested Date"; "Requested Date")
                {
                }
                field("Issued Quantity"; "Issued Quantity")
                {
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                }
                field("Available Inventory"; "Available Inventory")
                {
                }
                field("Short Closed Quantity"; "Short Closed Quantity")
                {
                }
                field("Short Closed"; "Short Closed")
                {
                }
                field("Item Category Code"; "Item Category Code")
                {
                }
                field("Part Code"; "Part Code")
                {
                }
                field("Line Remark"; "Line Remark")
                {
                    Caption = 'Remarks';
                }
                field("Marked Purchase Requisition"; "Marked Purchase Requisition")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Update to Store")
            {
                Image = SendMail;
                Promoted = true;
                trigger OnAction()
                begin
                    CalcFields("Available Inventory");
                    IF "Available Inventory" < Quantity then
                        SendMailToStore(Rec)
                    else
                        ERROR('Required inventory is available');
                End;
            }
        }
    }

    procedure SendMailToStore(var RequisitionLine: Record "Requisition Line SAM")
    var
        Recpmailid: Text;
        Recpmailid1: Text;
        Recpmailid2: Text;
        SMTPMailSetup: Record "SMTP Mail Setup";
        Body1: Text;
        SMTPMail: Codeunit "SMTP Mail";
        Recpmailid3: Text;
        Recpmailid4: Text;
        PlantMaintSetup: Record "Plant Maintenance Setup";
    begin
        CLEAR(Recpmailid);
        CLEAR(Recpmailid1);
        CLEAR(Recpmailid2);
        PlantMaintSetup.GET;
        IF SMTPMailSetup.GET THEN BEGIN
            IF PlantMaintSetup."Store Mail" <> '' THEN
                Recpmailid := PlantMaintSetup."Store Mail"
            ELSE
                ERROR('"Store Email is not define on Maintenance Setup');
            SMTPMail.CreateMessage(SMTPMailSetup."User ID", SMTPMailSetup."User ID", Recpmailid + Recpmailid1 + Recpmailid2 + Recpmailid3 + Recpmailid4, 'Machine Breakdown', 'Dear Team', TRUE);
            SMTPMail.AppendBody('Dear ' + 'Team' + ',' + '<Br></Br>');
            SMTPMail.AppendBody('Inventory for Item No. :- ' + RequisitionLine."Item No." + '' + ' is low ' + '<br></br>');

            //Body1 := 'Dear '+ 'Team' +','+'<Br></br>'
            //      +'PMR for Machine Ids :-'+ MachineIds + '' + ' is due '+'<Br></br>';
            //SMTPMail.CreateMessage(SMTPMailSetup."User ID",SMTPMailSetup."User ID",Recpmailid+Recpmailid1+Recpmailid2+Recpmailid3+Recpmailid4,'Machine Breakdown',Body1,TRUE);      
            SMTPMail.Send;
        END;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // Lines added bY Deepak Kumar

        ReqLine.Reset;
        ReqLine.SetRange(ReqLine."Requisition No.", "Requisition No.");
        if ReqLine.FindLast then begin
            "Requisition Line No." := ReqLine."Requisition Line No." + 1;
        end else begin
            "Requisition Line No." := 1000;
        end;
    end;

    var
        ReqLine: Record "Requisition Line SAM";
}

