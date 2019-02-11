table 58000 "File Creation Log"
{    
    fields
    {
        field(1;"Id"; Guid)
        {
        }

        field(2; "Sales Shipment No."; Code[20])
        {
        }

        field(3; "Json Created"; Boolean)
        {
            InitValue = false;
        }

        field(4;"POST:ed"; Boolean)
        {
        }

        field(5;"Created At";DateTime)
        {
        }
        
        field(6; "Json Data"; Blob)
        {
        }

        field(7;"Error";Text[250])
        {
        }
    }
    
    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
    }

    trigger OnInsert();
    var
    begin
        Id := CreateGuid();
        "Created At" := CurrentDateTime();
    end;
}