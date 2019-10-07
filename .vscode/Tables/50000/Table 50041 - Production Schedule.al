table 50041 "Production Schedule"
{
    // version Prod. Schedule

    // // Table Created By Deepak Kumar for Production Schedule


    fields
    {
        field(1;"Schedule No.";Code[20])
        {
            Editable = false;
        }
        field(2;"Schedule Date";Date)
        {
            Editable = true;
        }
        field(20;Status;Option)
        {
            Editable = true;
            OptionCaption = 'Open,Confirmed,Closed';
            OptionMembers = Open,Confirmed,Closed;
        }
        field(30;"Linear Length (mm)";Decimal)
        {
            Editable = false;
        }
        field(89;"Schedule Published";Boolean)
        {
            Editable = false;
        }
        field(90;"Schedule Closed";Boolean)
        {
            Editable = true;
        }
        field(108;"Shift Code";Code[10])
        {
            TableRelation = "Work Shift".Code;

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                WorkShift.Reset;
                WorkShift.SetRange(WorkShift.Code,"Shift Code");
                if WorkShift.FindFirst then begin
                  if WorkShift."Next Day" then begin
                   "Total Avail Time(Min/Shift)":=(((235900T-WorkShift."Shift Start Time")+(WorkShift."Shift End Time"-000100T))/60000)+2;
                  end else
                  "Total Avail Time(Min/Shift)":=(WorkShift."Shift End Time"-WorkShift."Shift Start Time")/60000;
                end;
                UpdateTotalLinearCapacity();
            end;
        }
        field(109;"Manual Assortment";Boolean)
        {
            Editable = false;
        }
        field(110;"Total Avail Time(Min/Shift)";Integer)
        {
            Editable = false;
        }
        field(1001;"Created By";Text[150])
        {
            Editable = false;
        }
        field(1002;"Created Date and Time";Text[100])
        {
            Editable = false;
        }
        field(1003;"Approved By";Text[100])
        {
            Editable = false;
        }
        field(1004;"Approval Date and Time";Text[100])
        {
            Editable = false;
        }
        field(1005;"Machine No.";Code[20])
        {
            TableRelation = "Machine Center"."No." WHERE ("Work Center Category"=CONST(Corrugation));

            trigger OnValidate()
            begin
                // Lines Added By Deepak Kumar
                MachineCenter.Reset;
                MachineCenter.SetRange(MachineCenter."No.","Machine No.");
                if MachineCenter.FindFirst then begin
                    "Machine Name":=MachineCenter.Name;
                    "Machine Max Deckle Size":=MachineCenter."Maximum Deckle Size (mm)";
                    "Machine Max Ups":=MachineCenter."Maximum Deckle Ups";
                    "Avg. Machine Speed Per Min":=MachineCenter."Corrugation Speed (Mtr)/min";


                  end else begin
                   "Machine Name":='';
                   "Machine Max Deckle Size":=0;
                   "Machine Max Ups":=0;
                   "Avg. Machine Speed Per Min":=0;
                end;
                MfgSetup.Get;
                "Min Trim":=MfgSetup."Extra Trim - Min";
                "Maximum Extra Trim":=MfgSetup."Extra Trim - Max";
                UpdateTotalLinearCapacity();
            end;
        }
        field(1006;"Machine Name";Text[150])
        {
            Editable = false;
        }
        field(1007;"Machine Max Deckle Size";Decimal)
        {
            Editable = false;
        }
        field(1008;"Machine Max Ups";Integer)
        {
            Editable = false;
        }
        field(1009;"Avg. Machine Speed Per Min";Integer)
        {

            trigger OnValidate()
            begin
                UpdateTotalLinearCapacity();
            end;
        }
        field(1010;"Total Linear Capacity";Decimal)
        {
            Editable = false;
        }
        field(1011;"Linear Cap.Marked for Publish";Decimal)
        {
            CalcFormula = Sum("Production Schedule Line"."Linear Length(Mtr)" WHERE ("Schedule No."=FIELD("Schedule No."),
                                                                                     "Marked for Publication"=CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(1012;"Linear Capacity Published";Decimal)
        {
            CalcFormula = Sum("Production Schedule Line"."Linear Length(Mtr)" WHERE ("Schedule No."=FIELD("Schedule No."),
                                                                                     "Marked for Publication"=CONST(true),
                                                                                     Published=FILTER(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(1013;"Schedule Net Weight";Decimal)
        {
            CalcFormula = Sum("Production Schedule Line"."Qty to Schedule Net Weight" WHERE ("Schedule No."=FIELD("Schedule No."),
                                                                                             "Marked for Publication"=CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(1014;"Schedule M2 Weight";Decimal)
        {
            CalcFormula = Sum("Production Schedule Line"."Qty to Schedule M2 Weight" WHERE ("Schedule No."=FIELD("Schedule No."),
                                                                                            "Marked for Publication"=CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(3004;"Min Trim";Decimal)
        {
            Editable = false;
            InitValue = 30;
        }
        field(3005;"Maximum Extra Trim";Decimal)
        {
            Editable = false;
            InitValue = 15;
        }
        field(3006;"Trim Calculation Type";Option)
        {
            OptionCaption = 'Product Design, Scheduler';
            OptionMembers = "Product Design"," Scheduler";
        }
        field(4000;"Update Existing Schedule";Boolean)
        {
        }
        field(4001;"Existing Schedule No.";Code[20])
        {
            TableRelation = "Production Schedule"."Schedule No." WHERE (Status=CONST(Confirmed));
        }
    }

    keys
    {
        key(Key1;"Schedule No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        // Lines added BY Deepak Kuamr
          MfgSetup.Get;
          if "Schedule No." = '' then begin
          MfgSetup.TestField(MfgSetup."Prod. Order Schedule");
          NoSeriesMgt.InitSeries(MfgSetup."Prod. Order Schedule",MfgSetup."Prod. Order Schedule",0D,"Schedule No.",MfgSetup."Prod. Order Schedule");
          end;
         "Schedule Date":=WorkDate;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        MfgSetup: Record "Manufacturing Setup";
        MachineCenter: Record "Machine Center";
        WorkShift: Record "Work Shift";

    procedure UpdateTotalLinearCapacity()
    begin
        "Total Linear Capacity":="Total Avail Time(Min/Shift)"*"Avg. Machine Speed Per Min";
    end;
}

