report 50058 "Customer Items Details"
{
    // version Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Customer Items Details.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = SORTING ("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE ("Estimation No." = FILTER (<> ''), "Document Type" = CONST (Order), "External Doc. No." = FILTER (<> ''));
            RequestFilterFields = "Posting Date", "Sell-to Customer No.";
            column(ItemNo; "Sales Line"."No.")
            {
            }
            column(LPONo; "Sales Line"."External Doc. No.")
            {
            }
            column(LPODate; "Sales Line"."LPO(Order) Date")
            {
            }
            column(OrderQty; "Sales Line".Quantity)
            {
            }
            column(ShippedQty; "Sales Line"."Quantity Shipped")
            {
            }
            column(InvoicedQty; "Sales Line"."Quantity Invoiced")
            {
            }
            column(RemainingQty; "Sales Line".Quantity - "Sales Line"."Quantity Invoiced")
            {
            }
            column(InvoicedAmt; "Sales Line"."Quantity Invoiced" * "Sales Line"."Unit Price")
            {
            }
            column(Description; "Sales Line".Description)
            {
            }
            column(BOXGSM; BOXGSM)
            {
            }
            column(BoxType; BoxType)
            {
            }
            column(Ply; Ply)
            {
            }
            column(flute; flute)
            {
            }
            column(topColor; topColor)
            {
            }
            column(BoxLength; BoxLength)
            {
            }
            column(BoxWidth; BoxWidth)
            {
            }
            column(BoxHeight; BoxHeight)
            {
            }
            column(JointType; JointType)
            {
            }
            column(Print; Print)
            {
            }
            column(FilterDate; 'Date: ' + FilterDate)
            {
            }
            column(Desc; Desc)
            {
            }
            column(CustNo; "Sales Line"."Sell-to Customer No.")
            {
            }
            column(CustName; "Sales Line"."Cust. Name")
            {
            }
            column(CompName; CompInfo.Name)
            {
            }
            column(Dimens; Dimens)
            {
            }
            column(SysDate; WorkDate)
            {
            }
            column(CUST_SEGMENT; CUST_SEGMENT)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CompInfo.Get;

                FilterDate := "Sales Line".GetFilter("Sales Line"."Posting Date");

                /*
                EstimateHeader.RESET;
                EstimateHeader.SETRANGE(EstimateHeader."Sales Order No.","Document No.");
                EstimateHeader.SETRANGE(EstimateHeader."Estimation No.","Estimation No.");
                EstimateHeader.SETRANGE(EstimateHeader."Item Code","Sales Line"."No.");
                IF EstimateHeader.FINDFIRST THEN BEGIN
                   BOXGSM:=0;
                   Type:=EstimateHeader."Component Type";
                  // Ply:=EstimateHeader."No. of Ply";
                   flute:=EstimateHeader."Flute Type";
                   topColor:=EstimateHeader."Top Colour";
                   BoxLength:=EstimateHeader."Box Length (mm)- L (ID)";
                   BoxWidth:=EstimateHeader."Box Width (mm)- W (ID)";
                   BoxHeight:=EstimateHeader."Box Height (mm) - D (ID)";
                   Print:=EstimateHeader.Printing;
                END;
                 */

                Ply := '';
                AttributeEntry.Reset;
                AttributeEntry.SetRange(AttributeEntry."Item No.", "No.");
                if AttributeEntry.FindFirst then begin
                    repeat
                        if AttributeEntry."Item Attribute Code" = 'PLY' then
                            Ply := AttributeEntry."Item Attribute Value";
                        //MESSAGE(Ply);
                    until AttributeEntry.Next = 0;
                end;


                //flute:='';
                AttributeEntry.Reset;
                AttributeEntry.SetRange(AttributeEntry."Item No.", "Sales Line"."No.");
                //AttributeEntry.SETRANGE(AttributeEntry."Item Category Code",AttributeEntry."Item Category Code",'FLUTE');
                if AttributeEntry.FindFirst then begin
                    repeat
                        if AttributeEntry."Item Attribute Code" = 'FLUTE' then
                            flute := AttributeEntry."Item Attribute Value";
                    until AttributeEntry.Next = 0;
                    //   MESSAGE(topColor);
                end;
                topColor := '';
                AttributeEntry.Reset;
                AttributeEntry.SetRange(AttributeEntry."Item No.", "No.");
                //AttributeEntry.SETRANGE(AttributeEntry."Item Category Code",AttributeEntry."Item Category Code",'COLOUR');
                if AttributeEntry.FindFirst then begin
                    repeat
                        if AttributeEntry."Item Attribute Code" = 'COLOUR' then
                            topColor := AttributeEntry."Item Attribute Value";
                        //MESSAGE(topColor);
                    until AttributeEntry.Next = 0;
                end;


                BoxType := '';
                AttributeEntry.Reset;
                AttributeEntry.SetRange(AttributeEntry."Item No.", "No.");
                //AttributeEntry.SETRANGE(AttributeEntry."Item Category Code",AttributeEntry."Item Category Code",'TYPE');
                if AttributeEntry.FindFirst then begin
                    repeat
                        if AttributeEntry."Item Attribute Code" = 'TYPE' then
                            BoxType := AttributeEntry."Item Attribute Value";
                        //MESSAGE(BoxType);
                    until AttributeEntry.Next = 0;
                end;


                BOXGSM := '';
                AttributeEntry.Reset;
                AttributeEntry.SetRange(AttributeEntry."Item No.", "No.");
                //AttributeEntry.SETRANGE(AttributeEntry."Item Category Code",AttributeEntry."Item Category Code",'FG_GSM');
                if AttributeEntry.FindFirst then begin
                    repeat
                        if AttributeEntry."Item Attribute Code" = 'FG_GSM' then
                            BOXGSM := AttributeEntry."Item Attribute Value";
                        //MESSAGE(BOXGSM);
                    until AttributeEntry.Next = 0;
                end;


                JointType := '';
                AttributeEntry.Reset;
                AttributeEntry.SetRange(AttributeEntry."Item No.", "No.");
                //AttributeEntry.SETRANGE(AttributeEntry."Item Category Code",AttributeEntry."Item Category Code",'JOINT_TYPE');
                if AttributeEntry.FindFirst then begin
                    repeat
                        if AttributeEntry."Item Attribute Code" = 'JOINT_TYPE' then
                            JointType := AttributeEntry."Item Attribute Value";
                        //MESSAGE(JointType);
                    until AttributeEntry.Next = 0;
                end;


                Print := '';
                AttributeEntry.Reset;
                AttributeEntry.SetRange(AttributeEntry."Item No.", "No.");
                //AttributeEntry.SETRANGE(AttributeEntry."Item Category Code",AttributeEntry."Item Category Code",'PRINT');
                if AttributeEntry.FindFirst then begin
                    repeat
                        if AttributeEntry."Item Attribute Code" = 'PRINT' then
                            Print := AttributeEntry."Item Attribute Value";
                        // MESSAGE(Print);
                    until AttributeEntry.Next = 0;
                end;


                Desc := '';
                AttributeEntry.Reset;
                AttributeEntry.SetRange(AttributeEntry."Item No.", "No.");
                //AttributeEntry.SETRANGE(AttributeEntry."Item Category Code",AttributeEntry."Item Category Code",'FG_DESC');
                if AttributeEntry.FindFirst then begin
                    repeat
                        if AttributeEntry."Item Attribute Code" = 'FG_DESC' then
                            Desc := AttributeEntry."Item Attribute Value";
                        //MESSAGE(Desc);
                    until AttributeEntry.Next = 0;
                end;

                BoxLength := '';
                AttributeEntry.Reset;
                AttributeEntry.SetRange(AttributeEntry."Item No.", "No.");
                //AttributeEntry.SETRANGE(AttributeEntry."Item Category Code",AttributeEntry."Item Category Code",'LENGTH');
                if AttributeEntry.FindFirst then begin
                    repeat
                        if AttributeEntry."Item Attribute Code" = 'LENGTH' then
                            BoxLength := AttributeEntry."Item Attribute Value";
                    until AttributeEntry.Next = 0;
                end;



                BoxWidth := '';
                AttributeEntry.Reset;
                AttributeEntry.SetRange(AttributeEntry."Item No.", "No.");
                //AttributeEntry.SETRANGE(AttributeEntry."Item Category Code",AttributeEntry."Item Category Code",'WIDTH');
                if AttributeEntry.FindFirst then begin
                    repeat
                        if AttributeEntry."Item Attribute Code" = 'WIDTH' then
                            BoxWidth := AttributeEntry."Item Attribute Value";
                    until AttributeEntry.Next = 0;
                end;


                BoxHeight := '';
                AttributeEntry.Reset;
                AttributeEntry.SetRange(AttributeEntry."Item No.", "No.");
                //AttributeEntry.SETRANGE(AttributeEntry."Item Category Code",AttributeEntry."Item Category Code",'HEIGHT');
                if AttributeEntry.FindFirst then begin
                    repeat
                        if AttributeEntry."Item Attribute Code" = 'HEIGHT' then

                            BoxHeight := AttributeEntry."Item Attribute Value";
                        //MESSAGE(BoxHeight);
                    until AttributeEntry.Next = 0;
                end;


                Dimens := '';
                AttributeEntry.Reset;
                AttributeEntry.SetRange(AttributeEntry."Item No.", "No.");
                //AttributeEntry.SETRANGE(AttributeEntry."Item Category Code",AttributeEntry."Item Category Code",'HEIGHT');
                if AttributeEntry.FindFirst then begin
                    repeat
                        if AttributeEntry."Item Attribute Code" = 'OD-ID' then

                            Dimens := AttributeEntry."Item Attribute Value";
                        //MESSAGE(BoxHeight);
                    until AttributeEntry.Next = 0;
                end;


                Customer.Reset;
                Customer.SetRange(Customer."No.", "Sell-to Customer No.");
                if Customer.FindFirst then begin
                    CUST_SEGMENT := Customer."Customer Segment";
                end else begin
                    CUST_SEGMENT := '';
                end;

            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        BOXGSM: Code[20];
        Type: Option;
        Ply: Code[30];
        flute: Code[30];
        topColor: Code[30];
        Dimension: Code[30];
        BoxLength: Code[30];
        BoxWidth: Code[30];
        BoxHeight: Code[30];
        JointType: Code[30];
        Print: Code[60];
        EstimateHeader: Record "Product Design Header";
        AttributeEntry: Record "Item Attribute Entry";
        BoxType: Code[30];
        Desc: Text[100];
        FilterDate: Text[60];
        CompInfo: Record "Company Information";
        Dimens: Code[20];
        Customer: Record Customer;
        CUST_SEGMENT: Code[30];
}

