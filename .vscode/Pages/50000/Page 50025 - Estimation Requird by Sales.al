page 50025 "Estimation Requird by Sales"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    UsageCategory = Tasks;
    SourceTable = "Sales Line";
    SourceTableView = SORTING ("Document Type", "Document No.", "Line No.")
                      ORDER(Ascending)
                      WHERE ("Document Type" = CONST (Quote),
                            Type = CONST (Item),
                            "Quote Status" = FILTER (Open));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Document Type"; "Document Type")
                {
                    StyleExpr = SetStyleFormat;
                }
                field("Document No."; "Document No.")
                {
                    StyleExpr = SetStyleFormat;
                }
                field(EnqQuoteDate; EnqQuoteDate)
                {
                    Caption = 'Enquiry / Quote Date';
                    StyleExpr = SetStyleFormat;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    StyleExpr = SetStyleFormat;
                }
                field("Customer Name"; "Customer Name")
                {
                    Caption = 'Customer Name';
                    StyleExpr = SetStyleFormat;
                }
                field("Location Code"; "Location Code")
                {
                    StyleExpr = SetStyleFormat;
                }
                field(Description; Description)
                {
                    StyleExpr = SetStyleFormat;
                }
                field(Quantity; Quantity)
                {
                    StyleExpr = SetStyleFormat;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    StyleExpr = SetStyleFormat;
                }
                field("Estimation No."; "Estimation No.")
                {
                    StyleExpr = SetStyleFormat;
                }
                field("Estimate Price"; "Estimate Price")
                {
                }
                field("Estimate Revision Required"; "Estimate Revision Required")
                {
                }
                field("Estimate Revised"; "Estimate Revised")
                {
                }
                field("Estimate Revision Remarks"; "Estimate Revision Remarks")
                {
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                }
                field("Level of Urgency"; "Level of Urgency")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Estimate)
            {
                Caption = 'Estimate';
                action("Create / Update Estimate Card")
                {
                    Caption = 'Create / Update Estimate Card';
                    Image = ApplyEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        EstimationTable: Record "Product Design Header";
                        EstimationCard: Page "Product Design Card";
                        Estimate: Record "Product Design Header";
                    begin
                        // Lines added by deepak Kumar
                        //EstimationTable.CheckPermission;

                        TestField(Type, 2);
                        if "Estimation No." <> '' then begin
                            EstimationTable.Reset;
                            EstimationTable.SetRange(EstimationTable."Product Design No.", "Estimation No.");
                            EstimationCard.SetTableView(EstimationTable);
                            EstimationCard.RunModal;
                        end else begin
                            EstimationTable.Init;
                            //    EstimationTable."Estimate Type":=EstimationTable."Estimate Type"::Main;
                            //    EstimationTable."Estimation No.":="Document No.";
                            EstimationTable.Validate(Customer, "Sell-to Customer No.");
                            EstimationTable.Validate("Item Code", "No.");
                            EstimationTable."Sales Quote No." := "Document No.";
                            EstimationTable."Sales Quote Line Number" := "Line No.";
                            EstimationTable.Quantity := Quantity;
                            EstimationTable."Sales Person Code" := "Salesperson Code";

                            EstimationTable.Insert(true);
                            // Lines added BY Deepak Kumar

                            SaleQuoteAttributeTable.Reset;
                            SaleQuoteAttributeTable.SetRange(SaleQuoteAttributeTable."Document Type", SaleQuoteAttributeTable."Document Type"::Quote);
                            SaleQuoteAttributeTable.SetRange(SaleQuoteAttributeTable."Document No.", "Document No.");
                            SaleQuoteAttributeTable.SetRange(SaleQuoteAttributeTable."Line No.", "Line No.");
                            if SaleQuoteAttributeTable.FindFirst then begin
                                repeat
                                    if SaleQuoteAttributeTable."Item Attribute Code" = 'HEIGHT' then begin
                                        EstimationTable."Box Height (mm) - D (OD)" := SaleQuoteAttributeTable."Attribute Value Numeric";
                                    end;

                                    if SaleQuoteAttributeTable."Item Attribute Code" = 'LENGTH' then begin
                                        EstimationTable."Box Length (mm)- L (OD)" := SaleQuoteAttributeTable."Attribute Value Numeric";
                                    end;

                                    if SaleQuoteAttributeTable."Item Attribute Code" = 'WIDTH' then begin
                                        EstimationTable."Box Width (mm)- W (OD)" := SaleQuoteAttributeTable."Attribute Value Numeric";
                                    end;

                                    if SaleQuoteAttributeTable."Item Attribute Code" = 'PLY' then begin
                                        EstimationTable."No. of Ply" := SaleQuoteAttributeTable."Attribute Value Numeric";
                                    end;
                                    if SaleQuoteAttributeTable."Item Attribute Code" = 'MODEL' then begin
                                        EstimationTable."Model No" := SaleQuoteAttributeTable."Item Attribute Value";
                                    end;
                                until SaleQuoteAttributeTable.Next = 0;
                            end;
                            EstimationTable."Item Description" := Description;
                            EstimationTable.Modify(true);
                            Commit;


                            "Estimation No." := EstimationTable."Product Design No.";
                            Modify(true);

                            Estimate.Reset;
                            Estimate.SetRange(Estimate."Product Design Type", Estimate."Product Design Type"::Main);
                            Estimate.SetRange(Estimate."Product Design No.", EstimationTable."Product Design No.");
                            Estimate.FindFirst;
                            Estimate.Validate(Estimate."Model No");
                            Estimate.Validate(Estimate."No. of Ply");
                            Estimate.Validate(Estimate."Box Length (mm)- L (OD)");
                            Estimate.Validate(Estimate."Box Width (mm)- W (OD)");
                            Estimate.Validate(Estimate."Box Height (mm) - D (OD)");
                            EstimationCard.SetTableView(Estimate);
                            EstimationCard.Run;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        // Lines added  By Deepak Kumar
        Customer.Reset;
        Customer.SetRange(Customer."No.", "Sell-to Customer No.");
        if Customer.FindFirst then begin
            "Customer Name" := Customer.Name;
        end else begin
            "Customer Name" := '';
        end;
        SalesHeader.Reset;
        SalesHeader.SetRange(SalesHeader."Document Type", "Document Type");
        SalesHeader.SetRange(SalesHeader."No.", "Document No.");
        if SalesHeader.FindFirst then begin
            EnqQuoteDate := SalesHeader."Document Date";
        end else begin
            EnqQuoteDate := 0D;
        end;
        SetStyleFormat := SetStyle;
    end;

    trigger OnOpenPage()
    var
        UserSe: Record "User Setup";
    begin
        // Lines added by Deepak Kumar
        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        UserSetup.SetRange(UserSetup."Auth. For Sale E/Q/O", true);
        if UserSetup.FindFirst then begin
            UserSetup.TestField(UserSetup."Salespers./Purch. Code");
            SetRange("Salesperson Code", UserSetup."Salespers./Purch. Code");
        end;
    end;

    var
        UserSetup: Record "User Setup";
        "Customer Name": Text[250];
        Customer: Record Customer;
        EnqQuoteDate: Date;
        SalesHeader: Record "Sales Header";
        SetStyleFormat: Text;
        Sam1: Label '<>%1';
        EnquiryLineAttributeEntry: Record "Enquiry Line Attribute Entry";
        "------Samadhan": Integer;
        SaleQuoteAttributeTable: Record "Enquiry Line Attribute Entry";

    procedure SetStyle(): Text
    begin
        // Lines added By Deepak Kumar
        if "Estimate Revision Required" = true then begin
            exit('Unfavorable');
        end;

        if ("Estimation No." = '') and ("Estimate Price" = 0) then begin
            exit('Unfavorable');
        end;
        if ("Estimation No." <> '') and ("Estimate Price" = 0) then begin
            exit('StandardAccent');
        end;

        if ("Estimation No." <> '') and ("Estimate Price" <> 0) then begin
            exit('Favorable');
        end;
    end;
}

