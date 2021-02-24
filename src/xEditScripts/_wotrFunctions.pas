unit _wotrFunctions;

interface
  implementation
  uses xEditAPI, Classes, SysUtils, StrUtils, Windows;

//AddMessage(Name(GetFile(e)));//gets name of file
//AddMessage(GetEditValue(ElementByIndex(ElementByPath(e, 'KWDA'),1)));//gets the keyword in the second index of the array
//AddMessage(GetElementEditValues(e, 'EDID') + '  ' + Name(ElementByIndex(ElementByPath(e, 'DATA\Flags'),0)));

//Send ArmorHideBoots "Hide Boots" [ARMO:00013910] get 00013910
//the full formID comes from Name(e) inside the Process function on script run
procedure createOutputFolder(folderDirectory: TStringList);
var 
  i : integer;
begin
  for i := 0 to folderDirectory.Count -1 do
  begin 
    if not DirectoryExists(folderDirectory[i]) then 
    begin 
      if not CreateDir(folderDirectory[i]) then AddMessage('Could not create "' + folderDirectory[i] + '" Directory.')
      else AddMessage('Created "' + folderDirectory[i] + '" Directory.');
    end;
  end;
end;

function GetStringFormID(e : IInterface): string;
begin
  Result := IntToHex(GetLoadOrderFormID(e), 8);
end;

//send a record and it will check for the keyword and return 
//sending the record ArmorHideBoots "Hide Boots" [ARMO:00013910] and the keyword 'ArmorMaterialHide [KYWD:0006BBDD]' will return true
function HasKeywordFormID(e: IInterface; keywordFullformID: string): boolean;
var i: integer;
begin
  Result := false;
  if GetElementEditValues(e, 'KSIZ') = '' then 
  begin 
    Exit;
  end;
  for i := 0 to StrToInt(GetElementEditValues(e, 'KSIZ')) do
  begin 
    if GetEditValue(ElementByIndex(ElementByPath(e, 'KWDA'), i)) = keywordFullformID then 
    begin 
      Result := true;
      Exit;
    end;
  end;
  
end;

//will return the armor type 
//sending the record ArmorHideBoots "Hide Boots" [ARMO:00013910] will return 'Light Armor'
function ArmorType(e: IInterface) : string;
begin
  Result := GetElementEditValues(e, 'BOD2 - Biped Body Template\Armor Type');
end;

//will return the armor type keyword
//sending the record IronSword "Iron Sword" [WEAP:00012EB7] will return Sword
function WeaponType(e: IInterface) : string;
var 
  i : integer;
  keyword : string;
begin
  Result := 'Other / Keywords missing';
  if GetElementEditValues(e, 'KSIZ') = '' then Exit;
  for i := 0 to StrToInt(GetElementEditValues(e, 'KSIZ')) do
  begin
    keyword := GetEditValue(ElementByIndex(ElementByPath(e, 'KWDA'), i));
    if copy(keyword, 0, 8) = 'WeapType' then
    begin
      i := pos(' [', keyword) - 9;
      Result := copy(keyword, 9, i);
    end;
  end;
End;
//will return the armor type keyword
//sending the record IronSword "Iron Sword" [WEAP:00012EB7] will return WeapTypeSword [KYWD:0001E711]
function WeaponTypeKeyword(e: IInterface) : string;
var 
  i : integer;
  keyword : string;
begin
  Result := 'Other / Keyword missing';
  if GetElementEditValues(e, 'KSIZ') = '' then 
  begin 
    Result := 'Cant define -  no keywords';
    Exit;
  end;
  for i := 0 to StrToInt(GetElementEditValues(e, 'KSIZ')) do
  begin
    keyword := GetEditValue(ElementByIndex(ElementByPath(e, 'KWDA'), i));
    if copy(keyword, 0, 8) = 'WeapType' then Result := keyword;
  end;
End;

function SpellType(e: IInterface) : string;
begin
  Result := 'Other';
  if pos('Alteration',GetElementEditValues(e, 'SPIT - Data\Half-cost Perk')) > 0 then begin Result := 'Alteration'; Exit; end;
  if pos('Illusion',GetElementEditValues(e, 'SPIT - Data\Half-cost Perk')) > 0 then begin Result := 'Illusion'; Exit; end;
  if pos('Conjuration',GetElementEditValues(e, 'SPIT - Data\Half-cost Perk')) > 0 then begin Result := 'Conjuration'; Exit; end;
  if pos('Restoration',GetElementEditValues(e, 'SPIT - Data\Half-cost Perk')) > 0 then begin Result := 'Restoration'; Exit; end;
  if pos('Destruction',GetElementEditValues(e, 'SPIT - Data\Half-cost Perk')) > 0 then begin Result := 'Destruction'; Exit; end;
end;

function EdibleType(e: IInterface) : string;
begin
    Result := 'Other / Keyword missing';
    if HasKeyword(e, 'VendorItemDrinkAlcohol') then
    begin 
        Result := 'Alcohol';
        Exit;
    end;
    if HasKeywordFormID(e, 'VendorItemPotion [KYWD:0008CDEC]') then
    begin 
        Result := 'Potion';
        Exit;
    end;
    if HasKeywordFormID(e, 'VendorItemFoodRaw [KYWD:000A0E56]') then
    begin 
        Result := 'Raw Food';
        Exit;
    end;
    if HasKeywordFormID(e, 'VendorItemFood [KYWD:0008CDEA]') then
    begin 
        Result := 'Food';
        Exit;
    end;
    if HasKeywordFormID(e, 'VendorItemPoison [KYWD:0008CDED]') then
    begin 
        Result := 'Poison';
        Exit;
    end;
    if GetElementEditValues(e, 'ENIT - Effect Data\Sound - Consume') = 'ITMPotionUse [SNDR:000B6435]' then
    begin 
        Result := 'Potion';
        Exit;
    end;
    if  (GetElementEditValues(e, 'ENIT - Effect Data\Sound - Consume') = 'ITMFoodEat [SNDR:000CAF94]') or 
        (GetElementEditValues(e, 'ENIT - Effect Data\Sound - Consume') = 'NPCHumanEatSoup [SNDR:0010E2EA]') then
    begin 
        Result := 'Food';
        Exit;
    end;
    if GetElementEditValues(e, 'ENIT - Effect Data\Sound - Consume') = 'ITMPoisonUse [SNDR:00106614]' then
    begin 
        Result := 'Poison';
        Exit;
    end;
end;

end.