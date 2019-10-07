codeunit 50009 Depreciation
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        PostingDate: Date;

    procedure SetPostingDate(D1: Date)
    begin
        PostingDate := D1;
    end;

    procedure GetPostingDate(): Date
    begin
        exit(PostingDate);
    end;
}

