unit _2PostEslifyFaceGen;

interface
  implementation
  uses xEditAPI, _wotrFunctions, Classes, SysUtils, StrUtils, Windows;

var slPostEslify : TStringList;

function Initialize: integer;
begin
  slPostEslify := TStringList.Create;
  slPostEslify.Add('EspName;FormID;EDID;');
end;

function Process(e: IInterface): integer;
begin
  if Signature(e) = 'NPC_' then 
  begin
    if IsMaster(e) = false then Exit;
    slPostEslify.Add(Format('%s;%s;%s;', [
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
  if  Assigned(slPostEslify) then 
  begin
    if  (slPostEslify.Count > 1) then begin
      slPostEslify.SaveToFile(ProgramPath+'FaceGenEslify\xEditOutput\_2PostEslify.csv');
    end;
    slPostEslify.Free;
  end;
 end;

end.