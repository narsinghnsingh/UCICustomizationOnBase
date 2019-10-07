page 50163 "CMPS Data"
{
    // version Prod. Schedule

    PageType = Worksheet;
    UsageCategory = Tasks;
    SourceTable = "PROD. CMPS data";
    SourceTableView = SORTING (SEQUENCE)
                      ORDER(Ascending)
                      WHERE (XXX = FILTER (''));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Schedule No."; "Schedule No.")
                {
                }
                field(COMMAND; COMMAND)
                {
                }
                field(XXX; XXX)
                {
                }
                field(SEQUENCE; SEQUENCE)
                {
                }
                field("ORDER"; ORDER)
                {
                }
                field("CUSTOMER CODE"; "CUSTOMER CODE")
                {
                }
                field("CUSTOMER NAME"; "CUSTOMER NAME")
                {
                }
                field(GAP; GAP)
                {
                }
                field("RUN PAPER"; "RUN PAPER")
                {
                }
                field(FLUTE; FLUTE)
                {
                }
                field("WIDTH mm"; "WIDTH mm")
                {
                }
                field("LENGTH mm"; "LENGTH mm")
                {
                }
                field(CUT; CUT)
                {
                }
                field(STACK; STACK)
                {
                }
                field("SC1-1 mm"; "SC1-1 mm")
                {
                }
                field("SC2-1 mm"; "SC2-1 mm")
                {
                }
                field("SC3-1 mm"; "SC3-1 mm")
                {
                }
                field("SC4-1 mm"; "SC4-1 mm")
                {
                }
                field("SC5-1 mm"; "SC5-1 mm")
                {
                }
                field("OUT-1"; "OUT-1")
                {
                }
                field("SC6-2 mm"; "SC6-2 mm")
                {
                }
                field("SC7-2"; "SC7-2")
                {
                }
                field("SC8-2"; "SC8-2")
                {
                }
                field("OUT-2"; "OUT-2")
                {
                }
                field(REMARK; REMARK)
                {
                }
                field("DB-PAPER"; "DB-PAPER")
                {
                }
                field("1M-PAPER"; "1M-PAPER")
                {
                }
                field("1L-PAPER"; "1L-PAPER")
                {
                }
                field("2M-PAPER"; "2M-PAPER")
                {
                }
                field("2L-PAPER"; "2L-PAPER")
                {
                }
                field("3M-PAPER"; "3M-PAPER")
                {
                }
                field("3L-PAPER"; "3L-PAPER")
                {
                }
                field(SCORER_TYPE; SCORER_TYPE)
                {
                }
                field(DELIVERY; DELIVERY)
                {
                }
                field("INSERT ORDER"; "INSERT ORDER")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("XML Port for Production Schedular")
            {
                CaptionML = ENU = 'XML Port for Production Schedular';
                Image = XMLFile;

                trigger OnAction()
                var
                    varXmlFile: File;
                    XMLPORT1: XMLport "Export Production Schedule";
                    varOutputStream: OutStream;
                begin
                    // Lines added BY Deepak Kumar
                    //varXmlFile.Create('\\192.168.5.249\Temp\officeH.TXT');
                    varXmlFile.CREATE('\\192.168.5.249\Temp\Testing File\officeH.TXT');
                    //varXmlFile.CREATE('D:\CMPS Data\officeH.TXT');
                    varXmlFile.CreateOutStream(varOutputStream);
                    XMLPORT.Export(XMLPORT::"Export Production Schedule", varOutputStream);
                    varXmlFile.Close;
                    Message('Complete');

                    // For Import Code Unit
                    /*
                    varXmlFile.OPEN(“FilePath\myXmlfile.xml”);
                    varXmlFile.CREATEINSTREAM(varInputStream);
                    XMLPORT.IMPORT(XMLPORT::XMLportName, varInputStream);
                    varXmlFile.CLOSE;
                     */

                end;
            }
        }
    }
}

