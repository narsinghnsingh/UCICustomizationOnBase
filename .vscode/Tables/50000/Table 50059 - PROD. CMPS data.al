table 50059 "PROD. CMPS data"
{
    // version Prod. Schedule

    CaptionML = ENU = 'PROD. CMPS data';

    fields
    {
        field(1; "Schedule No."; Code[50])
        {
            CaptionML = ENU = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            CaptionML = ENU = 'Description';
        }
        field(3; "Line Number"; Integer)
        {
            CaptionML = ENU = 'Line Number';
            Editable = false;
        }
        field(50001; COMMAND; Code[1])
        {
        }
        field(50002; XXX; Code[3])
        {
        }
        field(50003; SEQUENCE; Code[4])
        {
        }
        field(50004; "ORDER"; Code[50])
        {
        }
        field(50005; "CUSTOMER CODE"; Code[16])
        {
        }
        field(50006; "CUSTOMER NAME"; Code[40])
        {
        }
        field(50007; GAP; Code[4])
        {
        }
        field(50008; "RUN PAPER"; Code[7])
        {
        }
        field(50009; FLUTE; Code[3])
        {
        }
        field(50010; "WIDTH mm"; Code[4])
        {
        }
        field(50011; "LENGTH mm"; Code[4])
        {
        }
        field(50012; CUT; Code[6])
        {
        }
        field(50013; STACK; Code[3])
        {
        }
        field(50014; "SC1-1 mm"; Code[4])
        {
        }
        field(50015; "SC2-1 mm"; Code[4])
        {
        }
        field(50016; "SC3-1 mm"; Code[4])
        {
        }
        field(50017; "SC4-1 mm"; Code[4])
        {
        }
        field(50018; "SC5-1 mm"; Code[4])
        {
        }
        field(50019; "OUT-1"; Code[1])
        {
        }
        field(50020; "SC6-2 mm"; Code[4])
        {
        }
        field(50021; "SC7-2"; Code[4])
        {
        }
        field(50022; "SC8-2"; Code[4])
        {
        }
        field(50023; "OUT-2"; Code[1])
        {
        }
        field(50024; REMARK; Code[20])
        {
        }
        field(50025; "DB-PAPER"; Code[30])
        {
        }
        field(50026; "1M-PAPER"; Code[30])
        {
        }
        field(50027; "1L-PAPER"; Code[30])
        {
        }
        field(50028; "2M-PAPER"; Code[30])
        {
        }
        field(50029; "2L-PAPER"; Code[30])
        {
        }
        field(50030; "3M-PAPER"; Code[30])
        {
        }
        field(50031; "3L-PAPER"; Code[30])
        {
        }
        field(50032; SCORER_TYPE; Code[1])
        {
        }
        field(50033; DELIVERY; Code[8])
        {
        }
        field(50034; "INSERT ORDER"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Schedule No.", "Line Number")
        {
        }
        key(Key2; SEQUENCE)
        {
        }
    }

    fieldgroups
    {
    }
}

