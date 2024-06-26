unit uPSI_McJSON;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility
  for the last in the past must

}
interface
 

 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_McJSON = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMcJsonItemEnumerator(CL: TPSPascalCompiler);
procedure SIRegister_TMcJsonItem(CL: TPSPascalCompiler);
procedure SIRegister_McJSON(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_McJSON_Routines(S: TPSExec);
procedure RIRegister_TMcJsonItemEnumerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMcJsonItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_McJSON(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   McJSON
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_McJSON]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMcJsonItemEnumerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TMcJsonItemEnumerator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TMcJsonItemEnumerator') do
  begin
    RegisterMethod('Constructor Create( aItem : TMcJsonItem)');
    RegisterMethod('Function GetCurrent : TMcJsonItem');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterProperty('Current', 'TMcJsonItem', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMcJsonItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TMcJsonItem') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TMcJsonItem') do
  begin
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Key', 'string', iptrw);
    RegisterProperty('Value', 'string', iptr);
    RegisterProperty('ItemType', 'TJItemType', iptrw);
    RegisterProperty('Keys', 'string Integer', iptr);
    RegisterProperty('Items', 'TMcJsonItem Integer', iptr);
    RegisterProperty('Values', 'TMcJsonItem string', iptr);
    SetDefaultPropery('Values');
    RegisterProperty('HasChild', 'Boolean', iptr);
    RegisterProperty('IsNull', 'Boolean', iptr);
    RegisterProperty('J', 'string string', iptrw);
    RegisterProperty('O', 'TMcJsonItem string', iptrw);
    RegisterProperty('A', 'TMcJsonItem string', iptrw);
    RegisterProperty('I', 'Integer string', iptrw);
    RegisterProperty('D', 'Double string', iptrw);
    RegisterProperty('S', 'string string', iptrw);
    RegisterProperty('B', 'Boolean string', iptrw);
    RegisterProperty('N', 'string string', iptrw);
    RegisterProperty('AsJSON', 'string', iptrw);
    RegisterProperty('AsObject', 'TMcJsonItem', iptrw);
    RegisterProperty('AsArray', 'TMcJsonItem', iptrw);
    RegisterProperty('AsInteger', 'Integer', iptrw);
    RegisterProperty('AsNumber', 'Double', iptrw);
    RegisterProperty('AsString', 'string', iptrw);
    RegisterProperty('AsBoolean', 'Boolean', iptrw);
    RegisterProperty('AsNull', 'string', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Constructor Create0( aJItemType : TJItemType);');
    RegisterMethod('Constructor Create1( const aItem : TMcJsonItem);');
    RegisterMethod('Constructor Create2( const aCode : string);');
      RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function IndexOf( const aKey : string) : Integer;');
    RegisterMethod('Function Path( const aPath : string) : TMcJsonItem;');
    RegisterMethod('Function Add( const aKey : string) : TMcJsonItem;');
    RegisterMethod('Function Add1( const aKey : string; aItemType : TJItemType) : TMcJsonItem;');
    RegisterMethod('Function Add2( aItemType : TJItemType) : TMcJsonItem;');
    RegisterMethod('Function Add3( const aItem : TMcJsonItem) : TMcJsonItem;');
    RegisterMethod('Function Copy( const aItem : TMcJsonItem) : TMcJsonItem;');
    RegisterMethod('Function Clone : TMcJsonItem;');
    RegisterMethod('Function Insert( const aKey : string; aIdx : Integer) : TMcJsonItem;');
    RegisterMethod('Function Insert1( const aItem : TMcJsonItem; aIdx : Integer) : TMcJsonItem;');
    RegisterMethod('Function Delete( aIdx : Integer) : Boolean;');
    RegisterMethod('Function Delete1( const aKey : string) : Boolean;');
    RegisterMethod('Function HasKey( const aKey : string) : Boolean');
    RegisterMethod('Function IsEqual( const aItem : TMcJsonItem) : Boolean');
    RegisterMethod('Function Check( const aStr : string; aSpeed : Boolean) : Boolean');
    RegisterMethod('Function CheckException( const aStr : string; aSpeed : Boolean) : Boolean');
    RegisterMethod('Function CountItems : Integer');
    RegisterMethod('Function At( aIdx : Integer; const aKey : string) : TMcJsonItem;');
    RegisterMethod('Function At1( const aKey : string; aIdx : Integer) : TMcJsonItem;');
    RegisterMethod('Function ToString2( aHuman : Boolean) : string;');
    RegisterMethod('Function ToString1: string;');
    RegisterMethod('Function ToString: string;');
    RegisterMethod('Function Minify( const aCode : string) : string');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream; asUTF8 : Boolean)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream; asHuman : Boolean; asUTF8 : Boolean)');
    RegisterMethod('Procedure LoadFromFile( const aFileName : string; asUTF8 : Boolean)');
    RegisterMethod('Procedure SaveToFile( const aFileName : string; asHuman : Boolean; asUTF8 : Boolean)');
    RegisterMethod('Function GetEnumerator : TMcJsonItemEnumerator');
    RegisterMethod('Function GetTypeStr : string');
    RegisterMethod('Function GetValueStr : string');
    RegisterMethod('Function Qot( const aMsg : string) : string');
    RegisterMethod('Function QotKey( const aKey : string) : string');
    RegisterMethod('Procedure Error( const Msg : string; const S1 : string; const S2 : string; const S3 : string)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_McJSON(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EMcJsonException');
  CL.AddTypeS('TJItemType', '( jitUnset, jitValue, jitObject, jitArray )');
  CL.AddTypeS('TJValueType', '( jvtString, jvtNumber, jvtBoolean, jvtNull )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TMcJsonItemEnumerator');
  SIRegister_TMcJsonItem(CL);
  SIRegister_TMcJsonItemEnumerator(CL);
  CL.AddTypeS('TJEscapeType', '( jetNormal, jetStrict, jetUnicode, jetNone )');
 CL.AddDelphiFunction('Function McJsonEscapeString( const aStr : string; aEsc : TJEscapeType) : string');
 CL.AddDelphiFunction('Function McJsonUnEscapeString( const aStr : string) : string');
 CL.AddDelphiFunction('Function GetItemTypeStr( aType : TJItemType) : string');
 CL.AddDelphiFunction('Function GetValueTypeStr( aType : TJValueType) : string');

 CL.AddDelphiFunction('function escapeChar(const aStr: string; aPos, aLen: Integer; out aUnk: Boolean): Integer;');
 CL.AddDelphiFunction('function findUtf8BOM(const Stream: TStream): Int64;');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMcJsonItemEnumeratorCurrent_R(Self: TMcJsonItemEnumerator; var T: TMcJsonItem);
begin T := Self.Current; end;

(*----------------------------------------------------------------------------*)
Function TMcJsonItemToString2_P(Self: TMcJsonItem;  aHuman : Boolean) : string;
Begin Result := {ParserU.}self.ToString(aHuman); END;

(*----------------------------------------------------------------------------*)
Function TMcJsonItemToString_P(Self: TMcJsonItem) : string;
Begin Result := TMcJsonItem(self).ToString1; END;

(*----------------------------------------------------------------------------*)
Function TMcJsonItemAt1_P(Self: TMcJsonItem;  const aKey : string; aIdx : Integer) : TMcJsonItem;
Begin Result := self.At(aKey, aIdx); END;

(*----------------------------------------------------------------------------*)
Function TMcJsonItemAt_P(Self: TMcJsonItem;  aIdx : Integer; const aKey : string) : TMcJsonItem;
Begin Result := self.At(aIdx, aKey); END;

(*----------------------------------------------------------------------------*)
Function TMcJsonItemDelete1_P(Self: TMcJsonItem;  const aKey : string) : Boolean;
Begin Result := self.Delete(aKey); END;

(*----------------------------------------------------------------------------*)
Function TMcJsonItemDelete_P(Self: TMcJsonItem;  aIdx : Integer) : Boolean;
Begin Result := self.Delete(aIdx); END;

(*----------------------------------------------------------------------------*)
Function TMcJsonItemInsert1_P(Self: TMcJsonItem;  const aItem : TMcJsonItem; aIdx : Integer) : TMcJsonItem;
Begin Result := self.Insert(aItem, aIdx); END;

(*----------------------------------------------------------------------------*)
Function TMcJsonItemInsert_P(Self: TMcJsonItem;  const aKey : string; aIdx : Integer) : TMcJsonItem;
Begin Result := self.Insert(aKey, aIdx); END;

(*----------------------------------------------------------------------------*)
Function TMcJsonItemClone_P(Self: TMcJsonItem) : TMcJsonItem;
Begin Result := self.Clone; END;

(*----------------------------------------------------------------------------*)
Function TMcJsonItemCopy_P(Self: TMcJsonItem;  const aItem : TMcJsonItem) : TMcJsonItem;
Begin Result := self.Copy(aItem); END;

(*----------------------------------------------------------------------------*)
Function TMcJsonItemAdd3_P(Self: TMcJsonItem;  const aItem : TMcJsonItem) : TMcJsonItem;
Begin Result := self.Add(aItem); END;

(*----------------------------------------------------------------------------*)
Function TMcJsonItemAdd2_P(Self: TMcJsonItem;  aItemType : TJItemType) : TMcJsonItem;
Begin Result := self.Add(aItemType); END;

(*----------------------------------------------------------------------------*)
Function TMcJsonItemAdd1_P(Self: TMcJsonItem;  const aKey : string; aItemType : TJItemType) : TMcJsonItem;
Begin Result := self.Add(aKey, aItemType); END;

(*----------------------------------------------------------------------------*)
Function TMcJsonItemAdd_P(Self: TMcJsonItem;  const aKey : string) : TMcJsonItem;
Begin Result := self.Add(aKey); END;

(*----------------------------------------------------------------------------*)
Function TMcJsonItemPath_P(Self: TMcJsonItem;  const aPath : string) : TMcJsonItem;
Begin Result := self.Path(aPath); END;

(*----------------------------------------------------------------------------*)
Function TMcJsonItemIndexOf_P(Self: TMcJsonItem;  const aKey : string) : Integer;
Begin Result := self.IndexOf(aKey); END;

(*----------------------------------------------------------------------------*)
Function TMcJsonItemCreate2_P(Self: TClass; CreateNewInstance: Boolean;  const aCode : string):TObject;
Begin Result := TMcJsonItem.Create(aCode); END;

(*----------------------------------------------------------------------------*)
Function TMcJsonItemCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const aItem : TMcJsonItem):TObject;
Begin Result := TMcJsonItem.Create(aItem); END;

(*----------------------------------------------------------------------------*)
Function TMcJsonItemCreate_P(Self: TClass; CreateNewInstance: Boolean;  aJItemType : TJItemType):TObject;
Begin Result := TMcJsonItem.Create(aJItemType); END;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemAsNull_W(Self: TMcJsonItem; const T: string);
begin Self.AsNull := T; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemAsNull_R(Self: TMcJsonItem; var T: string);
begin T := Self.AsNull; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemAsBoolean_W(Self: TMcJsonItem; const T: Boolean);
begin Self.AsBoolean := T; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemAsBoolean_R(Self: TMcJsonItem; var T: Boolean);
begin T := Self.AsBoolean; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemAsString_W(Self: TMcJsonItem; const T: string);
begin Self.AsString := T; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemAsString_R(Self: TMcJsonItem; var T: string);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemAsNumber_W(Self: TMcJsonItem; const T: Double);
begin Self.AsNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemAsNumber_R(Self: TMcJsonItem; var T: Double);
begin T := Self.AsNumber; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemAsInteger_W(Self: TMcJsonItem; const T: Integer);
begin Self.AsInteger := T; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemAsInteger_R(Self: TMcJsonItem; var T: Integer);
begin T := Self.AsInteger; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemAsArray_W(Self: TMcJsonItem; const T: TMcJsonItem);
begin Self.AsArray := T; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemAsArray_R(Self: TMcJsonItem; var T: TMcJsonItem);
begin T := Self.AsArray; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemAsObject_W(Self: TMcJsonItem; const T: TMcJsonItem);
begin Self.AsObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemAsObject_R(Self: TMcJsonItem; var T: TMcJsonItem);
begin T := Self.AsObject; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemAsJSON_W(Self: TMcJsonItem; const T: string);
begin Self.AsJSON := T; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemAsJSON_R(Self: TMcJsonItem; var T: string);
begin T := Self.AsJSON; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemN_W(Self: TMcJsonItem; const T: string; const t1: string);
begin Self.N[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemN_R(Self: TMcJsonItem; var T: string; const t1: string);
begin T := Self.N[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemB_W(Self: TMcJsonItem; const T: Boolean; const t1: string);
begin Self.B[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemB_R(Self: TMcJsonItem; var T: Boolean; const t1: string);
begin T := Self.B[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemS_W(Self: TMcJsonItem; const T: string; const t1: string);
begin Self.S[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemS_R(Self: TMcJsonItem; var T: string; const t1: string);
begin T := Self.S[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemD_W(Self: TMcJsonItem; const T: Double; const t1: string);
begin Self.D[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemD_R(Self: TMcJsonItem; var T: Double; const t1: string);
begin T := Self.D[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemI_W(Self: TMcJsonItem; const T: Integer; const t1: string);
begin Self.I[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemI_R(Self: TMcJsonItem; var T: Integer; const t1: string);
begin T := Self.I[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemA_W(Self: TMcJsonItem; const T: TMcJsonItem; const t1: string);
begin Self.A[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemA_R(Self: TMcJsonItem; var T: TMcJsonItem; const t1: string);
begin T := Self.A[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemO_W(Self: TMcJsonItem; const T: TMcJsonItem; const t1: string);
begin Self.O[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemO_R(Self: TMcJsonItem; var T: TMcJsonItem; const t1: string);
begin T := Self.O[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemJ_W(Self: TMcJsonItem; const T: string; const t1: string);
begin Self.J[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemJ_R(Self: TMcJsonItem; var T: string; const t1: string);
begin T := Self.J[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemIsNull_R(Self: TMcJsonItem; var T: Boolean);
begin T := Self.IsNull; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemHasChild_R(Self: TMcJsonItem; var T: Boolean);
begin T := Self.HasChild; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemValues_R(Self: TMcJsonItem; var T: TMcJsonItem; const t1: string);
begin T := Self.Values[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemItems_R(Self: TMcJsonItem; var T: TMcJsonItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemKeys_R(Self: TMcJsonItem; var T: string; const t1: Integer);
begin T := Self.Keys[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemItemType_W(Self: TMcJsonItem; const T: TJItemType);
begin Self.ItemType := T; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemItemType_R(Self: TMcJsonItem; var T: TJItemType);
begin T := Self.ItemType; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemValue_R(Self: TMcJsonItem; var T: string);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemKey_W(Self: TMcJsonItem; const T: string);
begin Self.Key := T; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemKey_R(Self: TMcJsonItem; var T: string);
begin T := Self.Key; end;

(*----------------------------------------------------------------------------*)
procedure TMcJsonItemCount_R(Self: TMcJsonItem; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
Function TMcJsonItemparse1_P(Self: TMcJsonItem;  const aCode : string; aPos, aLen : Integer; aSpeed : Boolean) : Integer;
Begin //Result := self.parse(aCode, aPos, aLen, aSpeed);
END;

(*----------------------------------------------------------------------------*)
Procedure TMcJsonItemparse_P(Self: TMcJsonItem;  const aCode : string; aSpeed : Boolean);
Begin //self.parse(aCode, aSpeed);
END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_McJSON_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@McJsonEscapeString, 'McJsonEscapeString', cdRegister);
 S.RegisterDelphiFunction(@McJsonUnEscapeString, 'McJsonUnEscapeString', cdRegister);
 S.RegisterDelphiFunction(@GetItemTypeStr, 'GetItemTypeStr', cdRegister);
  S.RegisterDelphiFunction(@GetValueTypeStr, 'GetValueTypeStr', cdRegister);
  S.RegisterDelphiFunction(@escapeChar, 'escapeChar', cdRegister);
  S.RegisterDelphiFunction(@findUtf8BOM, 'findUtf8BOM', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMcJsonItemEnumerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMcJsonItemEnumerator) do
  begin
    RegisterConstructor(@TMcJsonItemEnumerator.Create, 'Create');
    RegisterMethod(@TMcJsonItemEnumerator.GetCurrent, 'GetCurrent');
    RegisterMethod(@TMcJsonItemEnumerator.MoveNext, 'MoveNext');
    RegisterPropertyHelper(@TMcJsonItemEnumeratorCurrent_R,nil,'Current');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMcJsonItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMcJsonItem) do
  begin
    RegisterPropertyHelper(@TMcJsonItemCount_R,nil,'Count');
    RegisterPropertyHelper(@TMcJsonItemKey_R,@TMcJsonItemKey_W,'Key');
    RegisterPropertyHelper(@TMcJsonItemValue_R,nil,'Value');
    RegisterPropertyHelper(@TMcJsonItemItemType_R,@TMcJsonItemItemType_W,'ItemType');
    RegisterPropertyHelper(@TMcJsonItemKeys_R,nil,'Keys');
    RegisterPropertyHelper(@TMcJsonItemItems_R,nil,'Items');
    RegisterPropertyHelper(@TMcJsonItemValues_R,nil,'Values');
    RegisterPropertyHelper(@TMcJsonItemHasChild_R,nil,'HasChild');
    RegisterPropertyHelper(@TMcJsonItemIsNull_R,nil,'IsNull');
    RegisterPropertyHelper(@TMcJsonItemJ_R,@TMcJsonItemJ_W,'J');
    RegisterPropertyHelper(@TMcJsonItemO_R,@TMcJsonItemO_W,'O');
    RegisterPropertyHelper(@TMcJsonItemA_R,@TMcJsonItemA_W,'A');
    RegisterPropertyHelper(@TMcJsonItemI_R,@TMcJsonItemI_W,'I');
    RegisterPropertyHelper(@TMcJsonItemD_R,@TMcJsonItemD_W,'D');
    RegisterPropertyHelper(@TMcJsonItemS_R,@TMcJsonItemS_W,'S');
    RegisterPropertyHelper(@TMcJsonItemB_R,@TMcJsonItemB_W,'B');
    RegisterPropertyHelper(@TMcJsonItemN_R,@TMcJsonItemN_W,'N');
    RegisterPropertyHelper(@TMcJsonItemAsJSON_R,@TMcJsonItemAsJSON_W,'AsJSON');
    RegisterPropertyHelper(@TMcJsonItemAsObject_R,@TMcJsonItemAsObject_W,'AsObject');
    RegisterPropertyHelper(@TMcJsonItemAsArray_R,@TMcJsonItemAsArray_W,'AsArray');
    RegisterPropertyHelper(@TMcJsonItemAsInteger_R,@TMcJsonItemAsInteger_W,'AsInteger');
    RegisterPropertyHelper(@TMcJsonItemAsNumber_R,@TMcJsonItemAsNumber_W,'AsNumber');
    RegisterPropertyHelper(@TMcJsonItemAsString_R,@TMcJsonItemAsString_W,'AsString');
    RegisterPropertyHelper(@TMcJsonItemAsBoolean_R,@TMcJsonItemAsBoolean_W,'AsBoolean');
    RegisterPropertyHelper(@TMcJsonItemAsNull_R,@TMcJsonItemAsNull_W,'AsNull');
    RegisterConstructor(@TMcJsonItem.Create, 'Create');
    RegisterConstructor(@TMcJsonItemCreate_P, 'Create0');
    RegisterConstructor(@TMcJsonItemCreate1_P, 'Create1');
    RegisterConstructor(@TMcJsonItemCreate2_P, 'Create2');
     RegisterMethod(@TMcJsonItem.Destroy, 'Free');
    RegisterMethod(@TMcJsonItem.Clear, 'Clear');
    RegisterMethod(@TMcJsonItemIndexOf_P, 'IndexOf');
    RegisterMethod(@TMcJsonItemPath_P, 'Path');
    RegisterMethod(@TMcJsonItemAdd_P, 'Add');
    RegisterMethod(@TMcJsonItemAdd1_P, 'Add1');
    RegisterMethod(@TMcJsonItemAdd2_P, 'Add2');
    RegisterMethod(@TMcJsonItemAdd3_P, 'Add3');
    RegisterMethod(@TMcJsonItemCopy_P, 'Copy');
    RegisterMethod(@TMcJsonItemClone_P, 'Clone');
    RegisterMethod(@TMcJsonItemInsert_P, 'Insert');
    RegisterMethod(@TMcJsonItemInsert1_P, 'Insert1');
    RegisterMethod(@TMcJsonItemDelete_P, 'Delete');
    RegisterMethod(@TMcJsonItemDelete1_P, 'Delete1');
    RegisterMethod(@TMcJsonItem.HasKey, 'HasKey');
    RegisterMethod(@TMcJsonItem.IsEqual, 'IsEqual');
    RegisterMethod(@TMcJsonItem.Check, 'Check');
    RegisterMethod(@TMcJsonItem.CheckException, 'CheckException');
    RegisterMethod(@TMcJsonItem.CountItems, 'CountItems');
    RegisterMethod(@TMcJsonItemAt_P, 'At');
    RegisterMethod(@TMcJsonItemAt1_P, 'At1');
    RegisterMethod(@TMcJsonItemToString2_P, 'ToString2');
    RegisterMethod(@TMcJsonItem.ToString1, 'ToString1');
    RegisterMethod(@TMcJsonItem.ToString1, 'ToString');
    RegisterMethod(@TMcJsonItem.Minify, 'Minify');
    RegisterMethod(@TMcJsonItem.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TMcJsonItem.SaveToStream, 'SaveToStream');
    RegisterMethod(@TMcJsonItem.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TMcJsonItem.SaveToFile, 'SaveToFile');
    RegisterMethod(@TMcJsonItem.GetEnumerator, 'GetEnumerator');
    RegisterMethod(@TMcJsonItem.GetTypeStr, 'GetTypeStr');
    RegisterMethod(@TMcJsonItem.GetValueStr, 'GetValueStr');
    RegisterMethod(@TMcJsonItem.Qot, 'Qot');
    RegisterMethod(@TMcJsonItem.QotKey, 'QotKey');
    RegisterMethod(@TMcJsonItem.Error, 'Error');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_McJSON(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EMcJsonException) do
  with CL.Add(TMcJsonItemEnumerator) do
  RIRegister_TMcJsonItem(CL);
  RIRegister_TMcJsonItemEnumerator(CL);
end;

 
 
{ TPSImport_McJSON }
(*----------------------------------------------------------------------------*)
procedure TPSImport_McJSON.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_McJSON(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_McJSON.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_McJSON(ri);
  RIRegister_McJSON_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
