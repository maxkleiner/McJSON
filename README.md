# McJSON
A **Delphi / Lazarus / C++Builder** simple and small class for fast JSON parsing.

![GUI_6_mcJsonScreenshot2024-06-17134210](https://github.com/maxkleiner/McJSON/assets/3393121/18378153-561f-42c8-8e33-bdd899df8af0)

* [Motivation](#motivation)
* [Examples](#examples)
* [Use cases](#use-cases)
* [Known issues](#known-issues)
* [Performance tests](#performance-tests)

## Motivation
Some points of interest:
 * Simple Object-Pascal native code using TList as internal data structure.
 * Single-pass string parser. 
 * Compatible (aimed):
   * Delphi 7 up to now.
   * Lazarus.
   * C++Builder 2006 up to now.
 * Tested with:
   * BDS 2006 (Delphi and BCP)
   * Lazarus 2.3.0 (FPC 3.2.2)
   * C++Builder XE2 and 10.2.
 * Just one unit (`McJSON`), just one class(`TMcJsonItem`).
 * Inspired by [badunius/myJSON](https://github.com/badunius/myJSON).
 * Improved parser after applying Tan Li Hau's [article](https://lihautan.com/json-parser-with-javascript/#understand-the-grammar).
 * Performance [tests](#performance-tests) using C++Builder and comparing:
   *  [myJSON](https://github.com/badunius/myJSON) 
   *  [LkJson](https://sourceforge.net/projects/lkjson/)
   *  [JsonTools](https://github.com/sysrpl/JsonTools)
   *  [uJSON](https://sourceforge.net/projects/is-webstart/) (Delphi Web Utils)

## Examples
### Object-Pascal for maXbox Example
Modification of missing default parameter and overloading

```pascal
function Test99(out Msg: string): Boolean;
var
  Json: TMcJsonItem;
  i: Integer;
begin
  Msg := 'Test: Github readme.md content ex. 99';
  Json := TMcJsonItem.Create();
  try
    try
      // add some pairs.
      Json.Add('key1').AsInteger := 1;
      Json.Add('key2').AsBoolean := True;
      Json.Add('key3').AsNumber  := 1.234;
      Json.Add('key4').AsString  := 'value 1';
      // add an array
      Json.Add1('array', jitArray);
      for i := 1 to 3 do
        Json['array'].Add('').AsInteger := i;
      // save a backup to file
      if (Json['array'].Count = 3) then
        Json.SaveToFile(exepath+'examples\test99.json', true, true);
      // remove an item
      Json.Delete1('array');
      // oops, load the backup
      if (Json.Count = 4) then
        Json.LoadFromFile(exepath+'examples\test99.json', true);
      // test final result
      Result := (Json.AsJSON = '{"key1":1,"key2":true,"key3":1.234,"key4":"value 1","array":[1,2,3]}');
      writeln(formatjson(Json.AsJson));
    except
      Result := False;
    end;
  finally
    Json.Free;
  end;
end;
```

### Object-Pascal Example

```pascal
uses
  McJSON;
...  
function Test99(out Msg: string): Boolean;
var
  Json: TMcJsonItem;
  i: Integer;
begin
  Msg := 'Test: Github readme.md content';
  Json := TMcJsonItem.Create();
  try
    try
      // add some pairs.
      Json.Add('key1').AsInteger := 1;
      Json.Add('key2').AsBoolean := True;
      Json.Add('key3').AsNumber  := 1.234;
      Json.Add('key4').AsString  := 'value 1';
      // add an array
      Json.Add('array', jitArray);
      for i := 1 to 3 do
        Json['array'].Add.AsInteger := i;
      // save a backup to file
      if (Json['array'].Count = 3) then
        Json.SaveToFile('test99.json');
      // remove an item
      Json.Delete('array');
      // oops, load the backup
      if (Json.Count = 4) then
        Json.LoadFromFile('test99.json');
      // test final result
      Result := (Json.AsJSON = '{"key1":1,"key2":true,"key3":1.234,"key4":"value 1","array":[1,2,3]}');
    except
      Result := False;
    end;
  finally
    Json.Free;
  end;
end;
```
Will produce `\test\test99.json`:
```json
{
  "key1": 1,
  "key2": true,
  "key3": 1.234,
  "key4": "value 1",
  "array": [
    1,
    2,
    3
  ]
}
```

### C++Builder Example

```C++
#include "McJson.hpp"
...
bool Test99(AnsiString& Msg)
{
  bool Result;
  TMcJsonItem* Json = NULL;
  Msg = "Test: Github readme.md content";
  Json = new TMcJsonItem();
  try
  {
    try
    { // add some pairs.
      Json->Add("key1")->AsInteger = 1;
      Json->Add("key2")->AsBoolean = true;
      Json->Add("key3")->AsNumber  = 1.234;
      Json->Add("key4")->AsString  = "value 1";
      // add an array
      Json->Add("array", jitArray);
      for (int i = 1; i <= 3 ; i++)
        Json->Values["array"]->Add()->AsInteger = i;
      // save a backup to file
      if (Json->Values["array"]->Count == 3)
        Json->SaveToFile("test99.json");
      // remove an item
      Json->Delete("array");
      // oops, load the backup
      if (Json->Count == 4)
        Json->LoadFromFile("test99.json");
      // test final result
      Result = (Json->AsJSON ==
                "{\"key1\":1,\"key2\":true,\"key3\":1.234,\"key4\":\"value 1\",\"array\":[1,2,3]}");      
    }
    catch(...)
    {
      Result = false;
    }
  }
  __finally
  {
    if (Json) delete (Json);
  }
  return (Result);
}
```

## Use Cases
Please considere read Unit Tests in `test` folder for a complete list of `McJSON` use cases.

### Parse a JSON string
Just use the `AsJSON` property
```pascal
var
  N: TMcJsonItem;
begin  
  N := TMcJsonItem.Create;
  N.AsJSON := '{"i": 123, "f": 123.456, "s": "abc", "b": true, "n": null}';
  // use N here
  N.Free;
end;  
```
If you want to check if a JSON string is valid:
```pascal
Answer := N.Check( '{"i":[123}' ); // Answer will be false
```
The `Check` method will not raise any exception. The example above will catch and hide the `Error while parsing text: "expected , got }" at pos "10"` exception.
If you need to catch and manage exceptions, use `CheckException` like:
```pascal
try
  Answer := N.CheckException( '{"k":1, "k":2}' ); // Answer will be false
except
  on E: Exception do
  begin
    // Error while parsing text: "duplicated key k" at pos "11" 
  end;
end;    
```

### Paths
`McJSON` allows a simple way to access items through paths. We can use '/', '\\' or '.' as path separators.
```pascal
N.AsJSON := '{"o": {"k1":"v1", "k2":"v2"}}';
// access and change second object's value
N.Path('o.k2').AsString := 'value2';
```  
Results in:
```json
{
   "o": {
      "k1":"v1",
      "k2":"value2"
   }
}
```
Note that `Path()` does not accept indexes yet, like this:
```pascal
N.AsJSON := '{"o": [{"k1":"v1"}, {"k2":"v2"}]';
N.Path('o[1].k2').AsString := 'value2';
```  

### Property shorteners
Since version 1.0.4 `McJSON` allows to use property shorteners like in Andreas Hausladen's [Json Data Objects](https://github.com/ahausladen/JsonDataObjects).
```pascal
// access (automatic creation as in JDO)
Obj.S['foo'] := 'bar';
Obj.S['bar'] := 'foo';
// array creation, Obj is the owner of 'array'
Obj.A['array'].Add.AsInteger := 10;
Obj.A['array'].Add.AsInteger := 20;
// object creation, 'array' is the owner of ChildObj
ChildObj := Obj['array'].Add(jitObject);
ChildObj.D['value'] := 12.3;
// array creation, ChildObj is the owner of 'subarray'
ChildObj.A['subarray'].Add.AsInteger := 100;
ChildObj.A['subarray'].Add.AsInteger := 200;
``` 

Results in:

```json
{
   "foo":"bar",
   "bar":"foo",
   "array":[
      10,
      20,
      {
         "value":12.3,
         "subarray":[
            100,
            200
         ]
      }
   ]
}
```

### Array or object items
Here is how to access all items (children) of a JSON object and change their value type and content.
```pascal
N.AsJSON := '{"o": {"k1":"v1", "k2":"v2"}}';
// type and value: from string to integer
for i := 0 to N['o'].Count-1 do  
  N['o'].Items[i].AsInteger := i+1;   
```
Results in:
```json
{
   "o": {
      "k1":1,
      "k2":2
   }
}
```

### Shortener for array item access
We can use the `Items[index]` and `Values['key']` properties to access items inside objects and arrays. 
Since version `0.9.5`, we can use the `At(index, 'key')` or `At('key', index)` as shorteners.
```pascal
N.AsJSON := '{"a": [{"k1":1,"k2":2},{"k1":10,"k2":20}]}';
// how to access k2 of second object.
i := N['a'].Items[1].Values['k2'].AsInteger; // i will be equal to 20
i := N['a'].Items[1]['k2'].AsInteger;        // uses the Values[] as default property
i := N['a'].At(1, 'k2').AsInteger;           // shortener: index, key
i := N.At('a', 1)['k2'].AsInteger;           // shortener: key, index
```
And there are other uses without the `key` parameter:
```pascal
N.AsJSON := '{"k1":1,"k2":2,"k3":3,"k4":4}';
i := N.Items[2].AsInteger; // i will be equal to 3
i := N.At(2).AsInteger;    // shortener: just index
i := N.At('k3').AsInteger; // shortener: just key
```

### Enumerate
Using Delphi enumerator you can browse item's object children and values.
```pascal
var
  N, item: TMcJsonItem;
begin
  N := TMcJsonItem.Create;
  N.AsJSON := '{"o": {"k1":"v1", "k2":"v2"}}';
  for item in N['o'] do
    // use item here, e.g. item.Key, item.Value, item.AsString
```

### Object and array value setters
Change all values of an object with multiple items.
Not so common out there.
```pascal
N.AsJSON := '{"o": {"k1":"v1", "k2":"v2"}}';
N['o'].AsString := 'str';
```
Results in:
```json
{
   "o": {
      "k1": "str",
      "k2": "str"
   }
}
```
And if it is necessary to change the type of `o`:
```pascal
N['o'].ItemType := jitValue;
N['o'].AsString := 'str';
```
Results in:
```json
{
  "o": "str"
}
```

### Object and array type convertions
Convert from array to object type and vice-versa.
Also, not so common out there.
```pascal
N.AsJSON := '{ "k1": ["1", "2"], "k2": {"1": "a", "2": "b"} }';
N['k1'].ItemType := jitObject; // convert array to object with items
N['k2'].ItemType := jitArray ; // convert object with items to array 
```
Results in:
```json
{
   "k1": {
      "0": "1",
      "1": "2"
   },
   "k2": [
      "a",
      "b"
   ]
}
```

### Insert items
Insert some items using keys and position.
```pascal
P.Insert('c', 0).AsInteger := 3;
P.Insert('b', 0).AsInteger := 2;
P.Insert('a', 0).AsInteger := 1;
```
Results in:
```json
{
  "a": 1,
  "b": 2,
  "c": 3
}
```
Also, it is possible to insert objects in arrays.
```pascal
Q.AsJSON := '{"x":0}';
P.ItemType := jitArray;
P.Insert(Q, 1);
```
Results in:
```json
[
  1, 
  {
    "x": 0
  }, 
  2, 
  3
]
```
*Important*: since version 0.9.3, `Add()` and  `Insert()` will clone arguments of type `TMcJsonItem`. So, we have to free memory for `Q` too:
```pascal
P.Free;
Q.Free;
```

### Escape strings
Since version 1.0.5 strings can be escaped with `McJsonEscapeString()` helper function:
```pascal
N.AsJSON := '{"path": ' + McJsonEscapeString('\dir\subdir') + '}';  
```

Results in:
```json
{
  "path": "\\dir\\subdir"
}
```

In version 1.0.6 was introduced the `TJEscapeType` enum used in `McJsonEscapeString()` with these escape levels:
- `jetNormal`  : escapes `#8 #9 #10 #12 #13 " \`.
- `jetStrict`  : Normal + `/`.
- `jetUnicode` : Strict + `\uXXXX`.
- `jetNone`    : backwards compatibility.

These levels are inspired by Lazarus' helper function `StringToJSONString()` from library [fpjson](https://www.freepascal.org/docs-html/fcl/fpjson/stringtojsonstring.html).

### Inspect the content of an object
Let's see how to inspect all the inner data structure, types and values of a `TMcJsonItem` object.
```c++
//---------------------------------------------------------------------------
void
TFormMain::Inspect(TMcJsonItem* AMcJItem, AnsiString Ident)
{
  if (!AMcJItem) return;
  // log current
  MyLog( Ident + ItemToStr(AMcJItem) );
  // log child
  if ( AMcJItem->HasChild )
  {
    Ident = "  " + Ident;
    for (int i=0; i < AMcJItem->Count; i++)
    { // use Value not Child because are note using Key[].
      Inspect( AMcJItem->Items[i], Ident );
    }
  }
}
//---------------------------------------------------------------------------
String
TFormMain::ItemToStr(TMcJsonItem* AMcJItem) const
{
  String Ans = "";
  if (AMcJItem)
    Ans =             AMcJItem->GetTypeStr() +
          "; "      + AMcJItem->GetValueStr() +
          "; Key="  + AMcJItem->Key +
          "; Value="+ AMcJItem->Value +
          "; JSON=" + AMcJItem->AsJSON;
  return (Ans);
}
//---------------------------------------------------------------------------
```
And using a example like `testInspect.json`:
```json
{
   "foo": "bar",
   "array": [
      100,
      20
   ],
   "arrayObj": [
      {
         "key1": 1.0
      },
      {
         "key2": 2.0
      }
   ],
   "Msg": [
      "#1 UTF8 example: motivação",
      "#2 Scapes: \b\t\n\f\r\\uFFFF\"\\"
   ]
}
```

Calling `Inspect()` with a `Json` object loaded with `testInspect.json`:
```c++
TMcJsonItem* Json = new TMcJsonItem();
if (Json)
{
  Json->LoadFromFile("testInspect.json");
  Inspect(Json);
  delete (Json);
}
```

Results in:
```
object; string; Key=; Value=; JSON={"foo":"bar","array":[100,20],"arrayObj":[{"key1":1.0},{"key2":2.0}],"Msg":["#1 UTF8 example: motivação","#2 Scapes: \b\t\n\f\r\u\"\\"]}
   value; string; Key=foo; Value=bar; JSON="foo":"bar"
   array; string; Key=array; Value=; JSON="array":[100,20]
     value; number; Key=; Value=100; JSON=100
     value; number; Key=; Value=20; JSON=20
   array; string; Key=arrayObj; Value=; JSON="arrayObj":[{"key1":1.0},{"key2":2.0}]
     object; string; Key=; Value=; JSON={"key1":1.0}
       value; number; Key=key1; Value=1.0; JSON="key1":1.0
     object; string; Key=; Value=; JSON={"key2":2.0}
       value; number; Key=key2; Value=2.0; JSON="key2":2.0
   array; string; Key=Msg; Value=; JSON="Msg":["#1 UTF8 example: motivação","#2 Scapes: \b\t\n\f\r\uFFFF\"\\"]
     value; string; Key=; Value=#1 UTF8 example: motivação; JSON="#1 UTF8 example: motivação"
     value; string; Key=; Value=#2 Scapes: \b\t\n\f\r\uFFFF\"\\; JSON="#2 Scapes: \b\t\n\f\r\uFFFF\"\\"
```

### A note about empty keys
Since version `0.9.0`, empty keys will be parsed and checked withou errors:
```pascal
N.AsJSON := '{"": "value"}';
```
And `ToString()` will produce a valid JSON object:
```json
{
  "": "value"
}
```
Internally, it will use the C_EMPTY_KEY constant string as content of the fKey field.

### A note about line breaks
Since version `0.9.2`, strings with not escaped line breakes will be parsed with errors:
```pascal
N.AsJSON := '{"key": "value' + #13 + '"}';
```
Will raise exception:
```
Error while parsing text: "line break" at pos "14"
```

### Load from and Save to Files
`McJSON` can load from ASCII and UTF-8 files (with or without BOM). See `LoadFromFile` method.
The `SaveToFile` method will write using UTF-8 encoding.
*Note*: since vertion 1.0.4, the test project's source code in Lazarus was converted to UTF-8, so the `asUTF8` parameter was set to `false`.

## Known issues
The world is not perfect and neither am I.
Here are some known issues:
* As `TMcJsonItem` objects are instantiated in hierarchical structure using lists `fChild`, there is a problem to create fields that propagate automatically between items. A solution under study tries to create a new parent class `TMcJson` which objects will be like roots and have `TMcJsonItem` objects as its children.
* Trying to follow and confirm the [specification](https://www.json.org/json-en.html) using [JSONLint](https://jsonlint.com/).

## Performance tests
A performance test have been done with the original `myJSON`, `LkJson`, `JsonTools` and `uJSON` units.
Here is a summary of the tests.
* Generate a JSON with 50k items like: `{... {"keyi":"valuei"}... }`
* Save to file.
* Parse from memory (copy object forcing a parse).
* Load from file (and parsing).
* Access 1k items randomly.

And about the compiler and machine used:
* C++Builder VCL examples built with BDS 2006 (the older version I have).
* Very old 32 bits machine: Intel Core 2 CPU T5500 1.66GHz 4 GB RAM.

The next table summarizes the results[^1]:

Library     | Generate  | Save     | Parse    | Load     | Access  | Total      |
:-----------|----------:|---------:|---------:|---------:|--------:|-----------:|
`McJSON`[^2]|     .11 s |    .07 s |    .12 s |    .09 s |   .83 s |     1.25 s |
`LkJson`[^2]|     .30 s |    .11 s |    .47 s |    .36 s |   .01 s |     1.24 s |
`JsonTools` |   48.00 s |    .70 s |  39.00 s |  40.00 s |   .48 s |    1.2 min |
`myJSON`    |   50.00 s |    .07 s |  5.1 min |  7.7 min |  1.60 s |   13.1 min |
`uJSON`     |  18.6 min | 20.1 min | 17.5 min |   4.31 s | 53.02 s |   57.6 min |


[^1]: Metric: average time in seconds (s) for 5 consecutive executions. Total is the average of partial tests. Some results converted to minutes (min).
[^2]: Version 1.0.5. Improved Test JSON 0.9.0 project that will be released soon.

### Notes about `McJSON`
* Good performance, but not the better about random access due to the use of TList.
* Simple and smart interface using "AsXXX" getters and setters (not invented here).
* Generate using: `Json->Add("key")->AsString = "value"`.
* Parse using: `JsonP->AsJSON = Json->AsJSON`.

### Notes about `LkJson`
* Good performance generating and parsing and even better with random access due to "Balanced Search Tree" `TlkBalTree`.
* TLkJSONBase and other derivated classes force to cast objects using the "as" operator. In C++Builder, this requires `dynamic_cast` making the code verbosy.
* Generate using: `Json->Add("key", "value")`.
* Parse using: `JsonP = dynamic_cast<TlkJSONObject*>(TlkJSON::ParseText(NULL, TlkJSON::GenerateText(NULL, Json)))`.

### Notes about `JsonTools`
* Very nice and interesting code focused on the concept of Tokens. 
* Also uses TList as internal data structure. 
* It needs a performance review.
* Generate using: `Json->Add("key", "value")`.
* Parse using: `JsonP->Value = Json->AsJson`.

### Notes about `myJSON`
* Performance deteriored due the recurrent use of wsTrim().
* Generate using: `Json->Item["key"]->setStr("value")`.
* Parse using: `JsonP->Code = Json->getJSON()`.

### Notes about `uJSON`
* Less verbosy in C++ than `LkJson`, but the colection of classes also will force casting with `dynamic_cast`.
* Uses TStringList as a "Hash Map" [string] -> [object address]. The quotation marks here is because I think the string entry is not a true hash within TStringList.
* In some aspects, the methods interface might became puzzling.
* It needs a performance review.
* With `uJSON`, there seems to be a performance problem related to `toString()`.
* This unit is used in other projects, e.g. [Diffbot API Delphi Client Library](https://github.com/diffbot/diffbot-delphi-client) (same author).
* Generate using: `Json->put("key", "value")`.
* Parse using: `JsonP = new TJSONObject(Json->toString())`.
* `SaveToFile` doesn't exist, so it has used `TStringList->SaveToFile()` after filling `Text` with `Json->toString()`.

