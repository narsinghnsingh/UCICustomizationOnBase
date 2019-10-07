page 50005 "Product Design Box Details"
{
    // version Estimate Samadhan

    DeleteAllowed = false;
    InsertAllowed = false;
    UsageCategory = Lists;
    PageType = Worksheet;
    SourceTable = "Product Design Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Product Design Type"; "Product Design Type")
                {
                    Editable = false;
                }
                field("Product Design No."; "Product Design No.")
                {
                    Editable = false;
                }
                field("Sub Comp No."; "Sub Comp No.")
                {
                    Editable = false;
                }
            }
            group(Model)
            {
                CaptionML = ENU = 'Model';
                Editable = Status <> Status::Approved;
                field("Model No"; "Model No")
                {

                    trigger OnValidate()
                    begin
                        // Lines added BY Deepak Kumar
                        if ("Model No" = '0201') or ("Model No" = '0200') or ("Model No" = '0202') then begin
                            DieCutType := false;
                            RSCType := true;
                        end else begin
                            DieCutType := true;
                            RSCType := false;
                        end;
                    end;
                }
                field("Model Description"; "Model Description")
                {
                }
                field("Corrugation Machine"; "Corrugation Machine")
                {
                }
                field("Corrugation Machine Name"; "Corrugation Machine Name")
                {
                }
                field("Machine Deckle Size (mm)"; "Machine Deckle Size (mm)")
                {
                }
                field("Paper Deckle Size (mm)"; "Paper Deckle Size (mm)")
                {
                }
                field("Basis for No.of Up Calc"; "Basis for No.of Up Calc")
                {
                }
                field("Machine Maximum Deckle Ups"; "Machine Maximum Deckle Ups")
                {
                    Editable = false;
                }
                field("Corrugation Direction"; "Corrugation Direction")
                {
                }
            }
            group(Control61)
            {
                Editable = Status <> Status::Approved;
                ShowCaption = false;
                grid(Control30)
                {
                    GridLayout = Rows;
                    ShowCaption = false;
                    group("In Millimetre(mm)")
                    {
                        CaptionML = ENU = 'In Millimetre(mm)';
                        field("Box Length (mm)- L (OD)"; "Box Length (mm)- L (OD)")
                        {
                            CaptionML = ENU = 'Box Length';
                            Editable = RSCType;

                            trigger OnValidate()
                            begin
                                "Input Size Option" := "Input Size Option"::OD;
                            end;
                        }
                        field("Box Width (mm)- W (OD)"; "Box Width (mm)- W (OD)")
                        {
                            CaptionML = ENU = 'Box Width';
                            Editable = RSCType;

                            trigger OnValidate()
                            begin
                                "Input Size Option" := "Input Size Option"::OD;
                            end;
                        }
                        field("Box Height (mm) - D (OD)"; "Box Height (mm) - D (OD)")
                        {
                            CaptionML = ENU = 'Box Height';
                            Editable = RSCType;

                            trigger OnValidate()
                            begin
                                "Input Size Option" := "Input Size Option"::OD;
                            end;
                        }
                        field("Board Length"; "Board Length (mm)- L")
                        {
                            CaptionML = ENU = 'Board Length';
                            Editable = DieCutType;
                            Importance = Promoted;
                        }
                        field("Board Width"; "Board Width (mm)- W")
                        {
                            CaptionML = ENU = 'Board Width';
                            Editable = DieCutType;
                            Importance = Promoted;
                        }
                        field("Cut Size (mm)"; "Cut Size (mm)")
                        {
                            CaptionML = ENU = 'Cut Size';
                        }
                        field("Roll Width (mm)"; "Roll Width (mm)")
                        {
                            CaptionML = ENU = 'Roll Width';
                        }
                    }
                    group("In Centimetre(cm)")
                    {
                        CaptionML = ENU = 'In Centimetre(cm)';
                        field("Box Length (cm)"; "Box Length (cm)")
                        {
                            Editable = RSCType;
                            ShowCaption = false;
                        }
                        field("Box Width (cm)"; "Box Width (cm)")
                        {
                            Editable = RSCType;
                            ShowCaption = false;
                        }
                        field("Box Height (cm)"; "Box Height (cm)")
                        {
                            Editable = RSCType;
                            ShowCaption = false;
                        }
                        field("Board Length (cm)"; "Board Length (cm)")
                        {
                            Editable = DieCutType;
                            ShowCaption = false;
                        }
                        field("Board Width (cm)"; "Board Width (cm)")
                        {
                            Editable = DieCutType;
                            ShowCaption = false;
                        }
                        field("Cut Size (cm)"; "Cut Size (cm)")
                        {
                            ShowCaption = false;
                        }
                        field("Roll Width (cm)"; "Roll Width (cm)")
                        {
                            ShowCaption = false;
                        }
                    }
                    group("In Inch(inch)")
                    {
                        CaptionML = ENU = 'In Inch(inch)';
                        field("Box Length (inch)"; "Box Length (inch)")
                        {
                            Editable = RSCType;
                            ShowCaption = false;
                        }
                        field("Box Width (inch)"; "Box Width (inch)")
                        {
                            Editable = RSCType;
                            ShowCaption = false;
                        }
                        field("Box Height (inch)"; "Box Height (inch)")
                        {
                            Editable = RSCType;
                            ShowCaption = false;
                        }
                        field("Board Length (inch)"; "Board Length (inch)")
                        {
                            Editable = DieCutType;
                            ShowCaption = false;
                        }
                        field("Board Width (inch)"; "Board Width (inch)")
                        {
                            Editable = DieCutType;
                            ShowCaption = false;
                        }
                        field("Cut Size (Inch)"; "Cut Size (Inch)")
                        {
                            ShowCaption = false;
                        }
                        field("Roll Width ( Inch)"; "Roll Width ( Inch)")
                        {
                            ShowCaption = false;
                        }
                    }
                    group("Box ID (mm)")
                    {
                        CaptionML = ENU = 'Box ID (mm)';
                        field("Box Length (mm)- L (ID)"; "Box Length (mm)- L (ID)")
                        {
                            CaptionML = ENU = 'Box Length';
                            Editable = RSCType;
                            ShowCaption = false;
                        }
                        field("Box Width (mm)- W (ID)"; "Box Width (mm)- W (ID)")
                        {
                            CaptionML = ENU = 'Box Width';
                            Editable = RSCType;
                            ShowCaption = false;
                        }
                        field("Box Height (mm) - D (ID)"; "Box Height (mm) - D (ID)")
                        {
                            CaptionML = ENU = 'Box Height';
                            Editable = RSCType;
                            ShowCaption = false;
                        }
                    }
                }
                field("Box Size"; "Box Size")
                {
                }
                field("Board Size"; "Board Size")
                {
                }
                field("Product GSM"; "Product GSM")
                {
                }
                field(Grammage; Grammage)
                {
                    CaptionML = ENU = 'Calculated Grammage';
                }
                field("Per Box Weight (Gms)"; "Per Box Weight (Gms)")
                {
                    CaptionML = ENU = 'Per Box Weight (Gms)';
                }
                field("Box BS"; "Box BS")
                {
                }
                field("Box LBS"; "Box LBS")
                {
                }
            }
            group("Box Calculation Detail")
            {
                CaptionML = ENU = 'Box Calculation Detail';
                group(Control60)
                {
                    ShowCaption = false;
                }
                field("Board Ups"; "Board Ups")
                {
                    CaptionML = ENU = 'Board/Deckle Ups';
                }
                field("Die Punching"; "Die Punching")
                {
                }
                field("No. of Die Cut Ups"; "No. of Die Cut Ups")
                {
                    Enabled = "Die Punching";
                }
                field("Corrugation Ups"; "Corrugation Ups")
                {
                }
                field("No. of Joint"; "No. of Joint")
                {
                    CaptionML = ENU = 'No. of Joint (Cutting)';
                }
                field("No. of Ply"; "No. of Ply")
                {
                }
                field(Stitching; Stitching)
                {
                }
                field("Flute Type"; "Flute Type")
                {
                }
                field("Flute 1"; "Flute 1")
                {
                    CaptionML = ENU = 'Flute 1';
                    Editable = false;
                }
                field("Flute 2"; "Flute 2")
                {
                    CaptionML = ENU = 'Flute 2';
                    Editable = false;
                }
                field("Joint Flap Size(mm)"; "Joint Flap Size(mm)")
                {
                }
                grid(Control69)
                {
                    GridLayout = Rows;
                    ShowCaption = false;
                }
                field("With Flap Gap"; "With Flap Gap")
                {
                }
                field("Flap Gap Size(mm)"; "Flap Gap Size(mm)")
                {
                    Editable = "With Flap Gap";
                }
                group(Control52)
                {
                    ShowCaption = false;
                    field("Trim Size (mm)"; "Trim Size (mm)")
                    {
                    }
                    field("Left Trim Size (mm)"; "Left Trim Size (mm)")
                    {
                    }
                    field("Right Trim Size (mm)"; "Right Trim Size (mm)")
                    {
                    }
                    field("Manual Trim"; "Manual Trim")
                    {
                    }
                }
                field("Model Pic 1"; "Picture 1")
                {
                }
                field("Model Pic 2"; "Picture 2")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        // Lines added BY Deepak Kumar
        if ("Model No" = '0201') or ("Model No" = '0200') or ("Model No" = '0202') then begin
            DieCutType := false;
            RSCType := true;
        end else begin
            DieCutType := true;
            RSCType := false;
        end;
    end;

    var
        [InDataSet]
        RSCType: Boolean;
        DieCutType: Boolean;
}

