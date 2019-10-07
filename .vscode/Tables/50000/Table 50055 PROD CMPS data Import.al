table 50055 "PROD. CMPS data Import"
{
    // version Prod. Schedule

    CaptionML = ENU = 'PROD. CMPS data Import';
    DrillDownPageID = "Job WIP Warnings";

    fields
    {
        field(1; "ORDER"; Code[10])
        {
            CaptionML = ENU = 'ORDER';
        }
        field(2; "CUSTOMER CODE"; Code[16])
        {
            CaptionML = ENU = 'CUSTOMER CODE';
        }
        field(3; "CUSTOMER NAME"; Code[40])
        {
            CaptionML = ENU = 'CUSTOMER NAME';
        }
        field(4; GAP; Code[4])
        {
            CaptionML = ENU = 'GAP';
            Editable = false;
        }
        field(5; "RUN PAPER"; Code[7])
        {
            CaptionML = ENU = 'RUN PAPER';
        }
        field(50001; FLUTE; Code[3])
        {
        }
        field(50002; "WIDTH mm"; Code[4])
        {
        }
        field(50003; "LENGTH mm"; Code[4])
        {
        }
        field(50004; CUT; Code[6])
        {
        }
        field(50005; STACK; Code[3])
        {
        }
        field(50006; "SC1-1 mm"; Code[4])
        {
        }
        field(50007; "SC2-1 mm"; Code[4])
        {
        }
        field(50009; "SC3-1 mm"; Code[4])
        {
        }
        field(50010; "SC4-1 mm"; Code[4])
        {
        }
        field(50011; "SC5-1 mm"; Code[4])
        {
        }
        field(50012; "OUT-1"; Code[1])
        {
        }
        field(50013; "SC6-2"; Code[4])
        {
        }
        field(50014; "SC7-2"; Code[4])
        {
        }
        field(50015; "SC8-2"; Code[4])
        {
        }
        field(50016; "OUT-2"; Code[10])
        {
        }
        field(50017; REMARK; Code[20])
        {
        }
        field(50018; "DB-PAPER"; Code[8])
        {
        }
        field(50019; "1M-PAPER"; Code[8])
        {
        }
        field(50020; "1L-PAPER"; Code[8])
        {
        }
        field(50021; "2M-PAPER"; Code[8])
        {
        }
        field(50022; "2L-PAPER"; Code[8])
        {
        }
        field(50023; "3M-PAPER"; Code[10])
        {
        }
        field(50024; "3L-PAPER"; Code[10])
        {
        }
        field(50025; ScType; Code[1])
        {
        }
        field(50026; DELIVERY; Code[8])
        {
        }
        field(50027; MACHINE; Code[1])
        {
        }
        field(50028; SHIFT; Code[1])
        {
        }
        field(50029; "GOOD SHEET"; Integer)
        {
        }
        field(50030; "SCRAPE SHEET"; Integer)
        {
        }
        field(50031; "DB RUN METER"; Integer)
        {
        }
        field(50032; "1F RUN METER"; Integer)
        {
        }
        field(50033; "2F RUN METER"; Integer)
        {
        }
        field(50034; "3F RUN METER"; Code[10])
        {
        }
        field(50035; "START DATE"; Code[10])
        {
        }
        field(50036; "START TIME"; Time)
        {
        }
        field(50037; "RUN TIME"; Time)
        {
        }
        field(50038; "STOP TIME"; Time)
        {
        }
        field(50039; "STOP COUNT"; Code[10])
        {
        }
        field(60000; ReportDate; Code[10])
        {
        }
        field(60001; LineNumber; Integer)
        {
        }
    }

    keys
    {
        key(Key1; ReportDate, LineNumber)
        {
        }
        key(Key2; "CUSTOMER CODE", "CUSTOMER NAME")
        {
        }
        key(Key3; GAP)
        {
        }
        key(Key4;ORDER)
        {}
    }

    fieldgroups
    {
    }

    var
        Text001: Label '%1 is 0.';
        Text002: Label 'Cost completion is greater than 100%.';
        Text003: Label '%1 is negative.';
}

