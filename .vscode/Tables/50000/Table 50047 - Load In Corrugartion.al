table 50047 "Load In Corrugartion"
{
    // version Prod. Schedule

    DrillDownPageID = "Load In Corrugation";
    LookupPageID = "Load In Corrugation";

    fields
    {
        field(1; "Schedule No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Schedule Date"; Date)
        {
        }
        field(3; "Prod. Order No."; Code[20])
        {
            Editable = false;
            TableRelation = "Production Order"."No." WHERE (Status = CONST (Released));
        }
        field(4; "Prod. Order Line No."; Integer)
        {
            Editable = false;
            TableRelation = "Prod. Order Line"."Line No." WHERE (Status = CONST (Released),
                                                                 "Prod. Order No." = FIELD ("Prod. Order No."));
        }
        field(5; "Requested Delivery Date"; Date)
        {
            Editable = false;
        }
        field(6; "Machine No."; Code[30])
        {
            Editable = false;
            TableRelation = "Machine Center"."No." WHERE ("Work Center Category" = CONST (Corrugation));
        }
        field(7; "Operation No"; Code[10])
        {
        }
        field(8; "Machine Name"; Text[250])
        {
            Editable = false;
        }
        field(10; "Prod. Order Quanity"; Decimal)
        {
            Editable = false;
        }
        field(11; "Quantity To Schedule"; Decimal)
        {

            trigger OnValidate()
            var
                ManufacturingSetup: Record "Manufacturing Setup";
            begin
                // Lines added BY Deepak Kumar
                CalcFields("RPO Finished Quantity", "RPO Remaining Quantity", "Quantity in Other Schedules");
                ManufacturingSetup.Get;
                if ("Quantity To Schedule" > (("Prod. Order Quanity" + ("Prod. Order Quanity" * (ManufacturingSetup."Output Tolerance %" / 100))) - ("RPO Finished Quantity" + "Quantity in Other Schedules"))) then
                    Error('Maximum Schedule Quantity is %1', (("Prod. Order Quanity" + ("Prod. Order Quanity" * (ManufacturingSetup."Output Tolerance %" / 100))) - ("RPO Finished Quantity" + "Quantity in Other Schedules")));

                "Available Quantity to Schedule" := (("Prod. Order Quanity" + ("Prod. Order Quanity" * (ManufacturingSetup."Output Tolerance %" / 100))) - ("RPO Finished Quantity" + "Quantity in Other Schedules" + "Quantity To Schedule"));
                "Box Quantity" := Round((("Quantity To Schedule" * "No of Die Cut") / "No. of Joint"), 1, '>');
            end;
        }
        field(12; "Item Code"; Code[50])
        {
            Editable = false;
        }
        field(13; "Item Description"; Text[250])
        {
            Editable = false;
        }
        field(14; "Customer Name"; Text[150])
        {
            Editable = false;
        }
        field(19; "Planned Deckle Size(mm)"; Decimal)
        {
            Editable = false;
        }
        field(20; "Deckle Size Schedule(mm)"; Code[50])
        {
            Editable = false;
        }
        field(21; "No. Of Ply"; Integer)
        {
            Editable = false;
        }
        field(25; "Top Colour"; Code[50])
        {
            Editable = false;
        }
        field(26; "Board Length(mm)"; Decimal)
        {
            Editable = false;
        }
        field(27; "Board Width(mm)"; Decimal)
        {
            Editable = false;
        }
        field(28; "Product Design No."; Code[20])
        {
            Editable = false;
        }
        field(29; "Priority By System"; Integer)
        {
            Editable = false;
            MaxValue = 999;
            MinValue = 10;
        }
        field(30; "Modified Priority"; Integer)
        {
            MaxValue = 999;
            MinValue = 10;

            trigger OnValidate()
            var
                TempProdLine: Record "Production Schedule Line";
            begin
            end;
        }
        field(31; "GSM Identifier"; Code[200])
        {
            Editable = false;
        }
        field(32; "Extra Trim(mm)"; Decimal)
        {
            Editable = false;
        }
        field(33; Possible; Boolean)
        {
            Editable = false;
        }
        field(34; "Trim %"; Decimal)
        {
            Editable = false;
        }
        field(35; "Schedule Line"; Boolean)
        {
            Editable = false;
        }
        field(36; "No of Die Cut"; Integer)
        {
            Editable = false;
        }
        field(37; "No. of Joint"; Integer)
        {
            Editable = false;
            InitValue = 1;
        }
        field(40; Flute; Text[30])
        {
            Editable = false;
        }
        field(41; "Flute 1"; Option)
        {
            Editable = false;
            OptionCaption = ' ,A,B,C,D,E,F';
            OptionMembers = " ",A,B,C,D,E,F;
        }
        field(42; "Flute 2"; Option)
        {
            Editable = false;
            OptionCaption = ' ,A,B,C,D,E,F';
            OptionMembers = " ",A,B,C,D,E,F;
        }
        field(43; "Flute 3"; Option)
        {
            Editable = false;
            OptionCaption = ' ,A,B,C,D,E,F';
            OptionMembers = " ",A,B,C,D,E,F;
        }
        field(50; "Linear Length(Mtr)"; Decimal)
        {
            Editable = false;
        }
        field(51; "Calculated No. of Ups"; Integer)
        {
            Editable = false;
        }
        field(52; "No. of Ups (Estimated)"; Integer)
        {
            Editable = false;
        }
        field(53; "Estimation Sub Job No."; Code[20])
        {
            Editable = false;
        }
        field(54; "Trim Product Design"; Decimal)
        {
            Editable = false;
        }
        field(55; "Trim (mm)"; Decimal)
        {
            Editable = false;
        }
        field(56; "Trim Weight"; Decimal)
        {
            Editable = false;
        }
        field(57; "Extra Trim Weight"; Decimal)
        {
            Editable = false;
        }
        field(58; "Cut Size (mm)"; Decimal)
        {
            Editable = false;
        }
        field(59; "FG GSM"; Decimal)
        {
            Editable = false;
        }
        field(60; "Sales Order No"; Code[50])
        {
        }
        field(61; "Customer Order No."; Code[50])
        {
            Editable = false;
        }
        field(63; "Sales Order Quantity"; Decimal)
        {
            Editable = false;
        }
        field(64; "Net Weight"; Decimal)
        {
            Editable = false;
        }
        field(65; "M2 Weight"; Decimal)
        {
            Editable = false;
        }
        field(66; "Box Quantity"; Decimal)
        {
            Editable = false;
        }
        field(67; "Net Weight (Other Schedule)"; Decimal)
        {
        }
        field(100; "DB Paper"; Code[20])
        {
            Editable = false;
        }
        field(101; "1M Paper"; Code[20])
        {
            Editable = false;
        }
        field(102; "1L Paper"; Code[20])
        {
            Editable = false;
        }
        field(103; "2M Paper"; Code[20])
        {
            Editable = false;
        }
        field(105; "2L Paper"; Code[20])
        {
            Editable = false;
        }
        field(106; "3M Paper"; Code[20])
        {
            Editable = false;
        }
        field(107; "3L paper"; Code[20])
        {
            Editable = false;
        }
        field(500; "RPO Finished Quantity"; Decimal)
        {
            CalcFormula = Lookup ("Prod. Order Line"."Finished Quantity" WHERE (Status = CONST (Released),
                                                                               "Prod. Order No." = FIELD ("Prod. Order No."),
                                                                               "Line No." = FIELD ("Prod. Order Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(501; "RPO Remaining Quantity"; Decimal)
        {
            CalcFormula = Lookup ("Prod. Order Line"."Remaining Quantity" WHERE (Status = CONST (Released),
                                                                                "Prod. Order No." = FIELD ("Prod. Order No."),
                                                                                "Line No." = FIELD ("Prod. Order Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(502; "Quantity in Other Schedules"; Decimal)
        {
            CalcFormula = Sum ("Production Schedule Line"."Quantity To Schedule" WHERE ("Prod. Order No." = FIELD ("Prod. Order No."),
                                                                                       "Prod. Order Line No." = FIELD ("Prod. Order Line No."),
                                                                                       Published = CONST (true),
                                                                                       "Schedule Closed" = FILTER (false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(503; "Available Quantity to Schedule"; Decimal)
        {
            Editable = false;
        }
        field(1000; "Marked for Publication"; Boolean)
        {

            trigger OnValidate()
            var
                ScheduleHeader: Record "Production Schedule";
                ScheduleLine: Record "Production Schedule Line";
                Answer: Boolean;
                Question: Text[150];
                Sam001: Label 'Prod. Order No. %1 Line No. %2 is already marked in Deckle Size %3. Do you want to update in this deckle size.';
            begin
                // Lines added BY Deepak Kumar
                TestField("Quantity To Schedule");
                if "Marked for Publication" = true then begin
                    ScheduleHeader.Reset;
                    ScheduleHeader.SetRange(ScheduleHeader."Schedule No.", "Schedule No.");
                    ScheduleHeader.SetRange(ScheduleHeader."Manual Assortment", true);
                    if ScheduleHeader.FindFirst then begin
                        ScheduleLine.Reset;
                        ScheduleLine.SetRange(ScheduleLine."Schedule No.", "Schedule No.");
                        ScheduleLine.SetRange(ScheduleLine."Prod. Order No.", "Prod. Order No.");
                        ScheduleLine.SetRange(ScheduleLine."Prod. Order Line No.", "Prod. Order Line No.");
                        ScheduleLine.SetRange(ScheduleLine."Marked for Publication", true);
                        ScheduleLine.SetFilter(ScheduleLine."Deckle Size Schedule(mm)", '<>%1', "Deckle Size Schedule(mm)");
                        if ScheduleLine.FindFirst then begin
                            Question := ('Prod. Order No. ' + ScheduleLine."Prod. Order No." + ' Line No. ' +
                            Format(ScheduleLine."Prod. Order Line No.") + ' is already marked in Deckle Size' + ScheduleLine."Deckle Size Schedule(mm)" + '. Do you want to update in this deckle size.');
                            Answer := DIALOG.Confirm(Question, false);
                            if Answer = true then begin
                                ScheduleLine."Marked for Publication" := false;
                                ScheduleLine."Force Schedule by" := '';
                                ScheduleLine.Modify(true);
                            end else begin
                                "Marked for Publication" := false;
                            end;
                        end;
                    end;
                end;
            end;
        }
        field(1001; "Force Schedule by"; Text[150])
        {
            Editable = false;
        }
        field(1002; Published; Boolean)
        {
            Editable = false;
        }
        field(1003; "Schedule Closed"; Boolean)
        {
            Editable = false;
        }
        field(2000; "Ideal Deckle Size"; Decimal)
        {
            Editable = false;
        }
        field(2001; SchedulerIdentifier; Code[50])
        {
        }
        field(2002; "Total Linear Length(Mtr)"; Decimal)
        {
            CalcFormula = Sum ("Load In Corrugartion"."Linear Length(Mtr)");
            FieldClass = FlowField;
        }
        field(2003; "Total Net Weight"; Decimal)
        {
            CalcFormula = Sum ("Load In Corrugartion"."Net Weight");
            Editable = false;
            FieldClass = FlowField;
        }
        field(2004; "Total M2 Weight"; Decimal)
        {
            CalcFormula = Sum ("Load In Corrugartion"."M2 Weight");
            Editable = false;
            FieldClass = FlowField;
        }
        field(2005; "Total Box Quantity"; Decimal)
        {
            CalcFormula = Sum ("Load In Corrugartion"."Box Quantity");
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Schedule No.", "Prod. Order No.", "Prod. Order Line No.", "Deckle Size Schedule(mm)", "Schedule Line")
        {
        }
        key(Key2; "Schedule No.", "No. Of Ply", Flute, "GSM Identifier")
        {
        }
        key(Key3; "Schedule No.", "Deckle Size Schedule(mm)", "No. Of Ply", Flute, "GSM Identifier", "Requested Delivery Date")
        {
        }
        key(Key4; "Schedule No.", Flute, "No. Of Ply", "Top Colour", "FG GSM", "Net Weight", "Deckle Size Schedule(mm)")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Prod. Order No.", "Prod. Order Line No.", "Prod. Order Quanity", "Quantity To Schedule", "Item Code", "Item Description", "Customer Name")
        {
        }
    }

    var
        Schedular: Codeunit Scheduler;
        ProdScheduleHeader: Record "Production Schedule";
}
