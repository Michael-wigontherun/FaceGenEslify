unit _1PreEslify;

interface
  implementation
  uses xEditAPI, _wotrFunctions, Classes, SysUtils, StrUtils, Windows;

var slPreEslify : TStringList;

function Initialize: integer;
begin
  slPreEslify := TStringList.Create;
  slPreEslify.Add('EspName;FormID;EDID;');
end;

function Process(e: IInterface): integer;
begin
  if Signature(e) = 'NPC_' then 
  begin
    if IsMaster(e) = false then Exit;
    slPreEslify.Add(Format('%s;%s;%s;', [
      Name(GetFile(e)),
      GetStringFormID(e),
      GetElementEditValues(e, 'EDID - Editor ID')
    ]));
  end;
end;

function Finalize: integer;
var folderDirectory : TStringList;
begin
  folderDirectory := TStringList.Create;
  folderDirectory.add('FaceGenEslify');
  folderDirectory.add('FaceGenEslify\xEditOutput');
  createOutputFolder(folderDirectory);
  if  Assigned(slPreEslify) then 
  begin
    if  (slPreEslify.Count > 1) then begin
      slPreEslify.SaveToFile(ProgramPath+'FaceGenEslify\xEditOutput\_1PreEslify.csv');
    end;
    slPreEslify.Free;
  end;
 end;

end.