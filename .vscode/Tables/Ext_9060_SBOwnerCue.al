tableextension 50058 Ext_SBOwnerCue extends "SB Owner Cue"
{
    fields
    {
        field(50000; "Quantity Received Not Invoiced"; Integer)
        {
            CalcFormula = Count ("Purch. Rcpt. Line" WHERE ("Qty. Rcd. Not Invoiced" = FILTER (<> 0)));
            FieldClass = FlowField;
        }
        field(50001; "Signed Document Not Received"; Integer)
        {
            CalcFormula = Count ("Sales Invoice Header" WHERE ("Document Receiving Received" = CONST (false)));
            FieldClass = FlowField;
        }
        field(50004; "Ongoing Sales Invoices"; Integer)
        {
            CalcFormula = Count ("Sales Header" WHERE ("Document Type" = FILTER (Invoice)));
            CaptionML = ENU = 'Ongoing Sales Invoices';
            FieldClass = FlowField;
        }
        field(50005; "Ongoing Purchase Invoices"; Integer)
        {
            CalcFormula = Count ("Purchase Header" WHERE ("Document Type" = FILTER (Invoice)));
            CaptionML = ENU = 'Ongoing Purchase Invoices';
            FieldClass = FlowField;
        }
        field(50006; "Sales This Month"; Decimal)
        {
            CaptionML = ENU = 'Sales This Month';
            DecimalPlaces = 0 : 0;
        }
        field(50007; "Top 10 Customer Sales YTD"; Decimal)
        {
            AutoFormatExpression = '<Precision,1:1><Standard Format,9>%';
            AutoFormatType = 10;
            CaptionML = ENU = 'Top 10 Customer Sales YTD';
        }
        field(50008; "Overdue Purch. Invoice Amount"; Decimal)
        {
            CaptionML = ENU = 'Overdue Purch. Invoice Amount';
            DecimalPlaces = 0 : 0;
        }
        field(50009; "Overdue Sales Invoice Amount"; Decimal)
        {
            CaptionML = ENU = 'Overdue Sales Invoice Amount';
            DecimalPlaces = 0 : 0;
        }
        field(50010; "Average Collection Days"; Decimal)
        {
            CaptionML = ENU = 'Average Collection Days';
            DecimalPlaces = 1 : 1;
        }
        field(50013; "POs Pending Approval"; Integer)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            CalcFormula = Count ("Purchase Header" WHERE ("Document Type" = CONST (Order),
                                                         Status = FILTER ("Pending Approval")));
            CaptionML = ENU = 'POs Pending Approval';
            FieldClass = FlowField;
        }
        field(50014; "SOs Pending Approval"; Integer)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Count ("Sales Header" WHERE ("Document Type" = CONST (Order),
                                                      Status = FILTER ("Pending Approval")));
            CaptionML = ENU = 'SOs Pending Approval';
            FieldClass = FlowField;
        }
        field(50015; "Approved Sales Orders"; Integer)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Count ("Sales Header" WHERE ("Document Type" = CONST (Order),
                                                      Status = FILTER (Released | "Pending Prepayment")));
            CaptionML = ENU = 'Approved Sales Orders';
            FieldClass = FlowField;
        }
        field(50016; "Approved Purchase Orders"; Integer)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            CalcFormula = Count ("Purchase Header" WHERE ("Document Type" = CONST (Order),
                                                         Status = FILTER (Released | "Pending Prepayment")));
            CaptionML = ENU = 'Approved Purchase Orders';
            FieldClass = FlowField;
        }
        field(50018; "Purchase Return Orders"; Integer)
        {
            AccessByPermission = TableData "Return Shipment Header" = R;
            CalcFormula = Count ("Purchase Header" WHERE ("Document Type" = CONST ("Return Order")));
            CaptionML = ENU = 'Purchase Return Orders';
            FieldClass = FlowField;
        }
        field(50019; "Sales Return Orders - All"; Integer)
        {
            AccessByPermission = TableData "Return Receipt Header" = R;
            CalcFormula = Count ("Sales Header" WHERE ("Document Type" = CONST ("Return Order")));
            CaptionML = ENU = 'Sales Return Orders - All';
            FieldClass = FlowField;
        }
        field(50020; "Rel. Prod. Orders - Corr"; Integer)
        {
            CalcFormula = Count ("Production Order" WHERE (Status = CONST (Released)));
            CaptionML = ENU = 'Released Prod. Orders Corrugation';
            FieldClass = FlowField;
        }
        field(50021; "Rel. Prod. Orders - Corr Today"; Integer)
        {
            CalcFormula = Count ("Production Order" WHERE (Status = CONST (Released),
                                                          "Shortcut Dimension 1 Code" = CONST ('CORRUGATION'),
                                                          "Starting Date" = FIELD ("Date Filter")));
            CaptionML = ENU = 'Rel. Prod. Orders Corrugation- Today';
            FieldClass = FlowField;
        }
        field(50024; "Date Filter"; Date)
        {
            CaptionML = ENU = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }

        field(50026; "Vendor Open Balance"; Integer)
        {
            CalcFormula = Count ("Vendor Ledger Entry" WHERE (Open = CONST (true),
                                                             Positive = CONST (true)));
            FieldClass = FlowField;
        }
        field(50027; "Bank Un-reconciled"; Integer)
        {
            CalcFormula = Count ("Bank Account Ledger Entry" WHERE ("Statement Status" = CONST (Open),
                                                                   "Posting Date" = FIELD ("Overdue Date Filter")));
            FieldClass = FlowField;
        }
        field(50028; "Credit/Return This Month"; Integer)
        {
            CalcFormula = Count ("Sales Cr.Memo Header" WHERE ("Posting Date" = FIELD ("Month Filter")));
            CaptionML = ENU = 'Credit/Return This Month';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50029; "Month Filter"; Date)
        {
            CaptionML = ENU = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(50030; "Order Not Received in Period"; Integer)
        {
            CalcFormula = Count (Customer WHERE ("Last Order Date" = FIELD ("Date Filter 2")));
            FieldClass = FlowField;
        }
        field(50031; "Date Filter 2"; Date)
        {
            CaptionML = ENU = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(60001; "Order Booked Todays"; Decimal)
        {
            CalcFormula = Sum ("Sales Line".Amount WHERE ("Document Type" = CONST (Order),
                                                         Type = CONST (Item),
                                                         "Order Date" = FIELD ("Date Filter")));
            FieldClass = FlowField;
        }
        field(60002; "Order Booked Month till Date"; Decimal)
        {
            CalcFormula = Sum ("Sales Line".Amount WHERE ("Document Type" = CONST (Order),
                                                         Type = CONST (Item),
                                                         "Order Date" = FIELD ("Month Filter")));
            FieldClass = FlowField;
        }
        field(60003; "Order Booked Todays Qty-FG"; Decimal)
        {
            CalcFormula = Sum ("Sales Line"."Order Quantity (Weight)" WHERE ("Document Type" = CONST (Order),
                                                                            Type = CONST (Item),
                                                                            "Order Date" = FIELD ("Date Filter"),
                                                                            "Item Category Code" = CONST ('FG')));
            FieldClass = FlowField;
        }
        field(60004; "Order Booked MTD Qty-FG"; Decimal)
        {
            CalcFormula = Sum ("Sales Line"."Order Quantity (Weight)" WHERE ("Document Type" = CONST (Order),
                                                                            Type = CONST (Item),
                                                                            "Order Date" = FIELD ("Month Filter"),
                                                                            "Item Category Code" = CONST ('FG')));
            FieldClass = FlowField;
        }
        field(60005; "Invoice Todays"; Decimal)
        {
            CalcFormula = Sum ("Cust. Ledger Entry"."Sales (LCY)" WHERE ("Posting Date" = FIELD ("Date Filter")));
            FieldClass = FlowField;
        }
        field(60006; "Invoice Month till Date"; Decimal)
        {
            CalcFormula = Sum ("Cust. Ledger Entry"."Sales (LCY)" WHERE ("Posting Date" = FIELD ("Month Filter")));
            FieldClass = FlowField;
        }
        field(60009; "Outstanding Sales Order FG"; Integer)
        {
            CalcFormula = Count ("Sales Line" WHERE ("Document Type" = CONST (Order),
                                                    Type = CONST (Item),
                                                    "Item Category Code" = FILTER ('FG'),
                                                    "Outstanding Quantity" = FILTER (> 0),
                                                    "Short Closed Document" = CONST (false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60011; "Bank Collection Amount"; Decimal)
        {
            CalcFormula = Sum ("Bank Account Ledger Entry"."Debit Amount (LCY)" WHERE ("Posting Date" = FIELD ("Month Filter"),
                                                                                      Reversed = CONST (false),
                                                                                      Positive = CONST (true)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

}