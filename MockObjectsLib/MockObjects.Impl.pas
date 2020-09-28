unit MockObjects.Impl;

interface

uses
  System.Generics.Collections,
  {Mock}
  MockObjects.Intf;

type
  /// <summary>
  /// Mock Object Method
  /// </summary>
  TMockMethod = class(
    TInterfacedObject,
    IMockMethod)
  strict private
    /// <summary> Method name </summary>
    FName: String;
    /// <summary> Number of method calls </summary>
    FCalls: Cardinal;
    /// <summary> Method call parameters </summary>
    FParams: TArray<Variant>;
    /// <summary> Method call out parameters </summary>
    FOutParams: TArray<Variant>;
    /// <summary> Method result </summary>
    FResult: Variant;
  private
    {$REGION ' IMockMethod '}
    /// <summary> Method name </summary>
    function GetName(): String;
    /// <summary> Method call parameters </summary>
    function GetParams(): TArray<Variant>;
    /// <summary> Method call out parameters </summary>
    function GetOutParams(): TArray<Variant>;
    /// <summary> Method result </summary>
    function GetResult(): Variant;

    /// <summary> Add method call </summary>
    procedure AddCall();
    /// <summary> Enough method calls made </summary>
    function  EnoughCalls(): Boolean;

    /// <summary> Method call parameters </summary>
    function WithParams(
      const AParams: array of const): IMockMethod;
    /// <summary> Method call out parameters </summary>
    function WithOutParams(
      const AParams: TArray<Variant>): IMockMethod;
    /// <summary> Return value </summary>
    procedure Returns(
      const AValue: Variant);
    {$ENDREGION}
  public
    /// <summary> Constructor </summary>
    /// <param name="AName"> Method name <see cref="T:System.String"/> </param>
    constructor Create(
      const AName: String);
  end;

type
  /// <summary>
  /// Mock Object
  /// </summary>
  TMockObject = class(
    TInterfacedObject,
    IMockObject)
  public
  type
    /// <summary> Check mode of the mock object </summary>
    TMockMode = (
      /// <summary> Check that all expected methods have been called </summary>
      mtLoose,
      /// <summary> Check that there were no other calls and that the order of calls matches the order of expectations </summary>
      mtStrict,
      /// <summary> Same as mtLoose </summary>
      mtDefault = mtLoose
    );
  strict private
    /// <summary> Check mode of the mock object </summary>
    FMockMode: TMockMode;
    /// <summary> List of expected method calls </summary>
    FExpectations: TList<IMockMethod>;
    /// <summary> Method call list </summary>
    FCalls: TList<IMockMethod>;
  private
    {$REGION ' IMockObject '}
    /// <summary> Set expected method call </summary>
    /// <param name="AMethodName"> Method name <see cref="T:System.String"/> </param>
    /// <param name="AExpectedCalls"> Number of method calls expected <see cref="T:System.Cardinal"/> </param>
    /// <returns> Returns a method of mock object <see cref="T:IMockMethod"/> </returns>
    function Expects(
      const AMethodName   : String;
      const AExpectedCalls: Cardinal = 1): IMockMethod;

    /// <summary> Check that a method call has occurred </summary>
    /// <param name="AMethodName"> Method name <see cref="T:System.String"/> </param>
    /// <returns> Returns the number of method calls <see cref="T:System.Cardinal"/> </returns>
    function VerifyCall(
      const AMethodName: String): Cardinal;
    /// <summary> Check that the number and order of method calls matches the expected calls </summary>
    /// <returns> Returns True if the check is successful <see cref="T:System.Boolean"/> </returns>
    function Verify(): Boolean; overload;
    /// <summary> Check that the number and order of method calls matches the expected calls </summary>
    /// <param name="AMessage"> Verification error message <see cref="T:System.String"/> </param>
    /// <returns> Returns True if the check is successful <see cref="T:System.Boolean"/> </returns>
    function Verify(
      out AMessage: String): Boolean; overload;
    {$ENDREGION}
  strict protected
    /// <summary> Add method call </summary>
    /// <param name="AMethodName"> Method name <see cref="T:System.String"/> </param>
    /// <returns> Returns a method of mock object <see cref="T:IMockMethod"/> </returns>
    function AddCall(
      const AMethodName: String): IMockMethod;
  public
    /// <summary> Constructor </summary>
    /// <param name="AMockMode"> Check mode of the mock object <see cref="T:TMockMode"/> </param>
    constructor Create(
      const AMockMode: TMockMode = mtDefault);
    /// <summary> Destructor </summary>
    destructor  Destroy(); override;
  end;

implementation

uses
  System.SysUtils,
  System.Variants;

{------------------------------------------------------------------------------}
{ TMockMethod }
{------------------------------------------------------------------------------}

/// <summary> Constructor </summary>
constructor TMockMethod.Create(
  const AName: String);
begin
  inherited Create();

  FName := AName;
end;

{$REGION ' IMockMethod '}
/// <summary> Method name </summary>
function TMockMethod.GetName(): String;
begin
  Result := FName;
end;

/// <summary> Method call parameters </summary>
function TMockMethod.GetParams(): TArray<Variant>;
begin
  Result := FParams;
end;

/// <summary> Method call out parameters </summary>
function TMockMethod.GetOutParams(): TArray<Variant>;
begin
  Result := FOutParams;
end;

/// <summary> Method result </summary>
function TMockMethod.GetResult(): Variant;
begin
  Result := FResult;
end;

/// <summary> Добавить вызов метода </summary>
procedure TMockMethod.AddCall();
begin
  Inc(FCalls);
end;

/// <summary> Enough method calls made </summary>
function TMockMethod.EnoughCalls(): Boolean;
begin
  Result := FCalls >= 1;
end;

/// <summary> Method call parameters </summary>
function TMockMethod.WithParams(
  const AParams: array of const): IMockMethod;
var
  i: Integer;
begin
  Result := Self;

  SetLength(FParams, Length(AParams));
  for i := 0 to High(AParams) do
    with AParams[i] do
      case VType of
        vtInteger:
          FParams[i] := VInteger;
        vtBoolean:
          FParams[i] := VBoolean;
        vtChar:
          FParams[i] := VChar;
        vtExtended:
          FParams[i] := VExtended^;
        vtString:
          FParams[i] := VString^;
        vtPointer:
          FParams[i] := Integer(VPointer);
        vtPChar:
          FParams[i] := String(AnsiString(VPChar));
        vtObject:
          FParams[i] := Integer(VObject);
        vtClass:
          FParams[i] := VClass.ClassName;
        vtWideChar:
          FParams[i] := VWideChar;
        vtPWideChar:
          FParams[i] := WideString(VPWideChar);
        vtAnsiString:
          FParams[i] := AnsiString(VAnsiString);
        vtCurrency:
          FParams[i] := VCurrency^;
        vtVariant:
          FParams[i] := VVariant^;
        vtInterface:
          FParams[i] := Integer(VPointer);
        vtWideString:
          FParams[i] := WideString(VWideString);
        vtInt64:
          FParams[i] := VInt64^;
        vtUnicodeString:
          FParams[i] := UnicodeString(VUnicodeString);
        else
          FParams[i] := Null;
      end;
end;

/// <summary> Method call out parameters </summary>
function TMockMethod.WithOutParams(
  const AParams: TArray<Variant>): IMockMethod;
var
  i: Integer;
begin
  Result := Self;

  SetLength(FParams, Length(AParams));
  for i := Low(AParams) to High(AParams) do
    FParams[i] := AParams[i];
end;

/// <summary> Return value </summary>
procedure TMockMethod.Returns(
  const AValue: Variant);
begin
  FResult := AValue;
end;
{$ENDREGION}

{------------------------------------------------------------------------------}
{ TMockObject }
{------------------------------------------------------------------------------}

/// <summary> Constructor </summary>
constructor TMockObject.Create(
  const AMockMode: TMockMode = mtDefault);
begin
  inherited Create();

  FMockMode     := AMockMode;
  FExpectations := TList<IMockMethod>.Create();
  FCalls        := TList<IMockMethod>.Create();
end;

/// <summary> Destructor </summary>
destructor TMockObject.Destroy();
begin
  FreeAndNil(FCalls);
  FreeAndNil(FExpectations);

  inherited Destroy();
end;

{$REGION ' IMockObject '}
/// <summary> Set expected method call </summary>
function TMockObject.Expects(
  const AMethodName   : String;
  const AExpectedCalls: Cardinal = 1): IMockMethod;
var
  i: Integer;
begin
  for i := 1 to AExpectedCalls do
  begin
    Result := TMockMethod.Create(AMethodName);
    FExpectations.Add(Result);
  end;
end;

/// <summary> Check that a method call has occurred </summary>
function TMockObject.VerifyCall(
  const AMethodName: String): Cardinal;
var
  i: Integer;
begin
  Result := 0;

  for i := 0 to FCalls.Count - 1 do
    if FCalls[i].Name.Equals(AMethodName) then
      Inc(Result);
end;

/// <summary> Check that the number and order of method calls matches the expected calls </summary>
function TMockObject.Verify(): Boolean;
var
  S: String;
begin
  Result := Verify({out}S);
end;

/// <summary> Check that the number and order of method calls matches the expected calls </summary>
function TMockObject.Verify(
  out AMessage: String): Boolean;
var
  i: Integer;
begin
  AMessage := '';

  case FMockMode of
    mtLoose  :
      begin
        Result := True;
        // Check that all expected methods have been called
        for i := 0 to FExpectations.Count - 1 do
        begin
          Result := FExpectations[i].EnoughCalls();
          if not Result then
          begin
            AMessage := Format(
              '%s: Expected method call: <%s> but was not called',
              [Self.ClassName, FExpectations[i].Name]);
            Break;
          end;
        end;
      end;

    mtStrict :
      begin
        // Check that there were no other calls
        Result := FExpectations.Count = FCalls.Count;
        if not Result then
          AMessage := Format(
            '%s: Expected methods calls: <%d> but was: <%d>',
            [Self.ClassName, FExpectations.Count, FCalls.Count])
        else
        // Check that the order of calls matches the order of expectations
        if Result then
          for i := 0 to FExpectations.Count - 1 do
            if not FExpectations[i].Name.Equals(FCalls[i].Name) then
            begin
              Result   := False;
              AMessage := Format(
                '%s: Expected method call: <%s> but was: <%s>',
                [Self.ClassName, FExpectations[i].Name, FCalls[i].Name]);
              Break;
            end;
      end

    else
      raise ENotImplemented.Create('Mock type check not implemented');
  end;
end;
{$ENDREGION}

/// <summary> Add method call </summary>
function TMockObject.AddCall(
  const AMethodName: String): IMockMethod;
var
  i: Integer;
begin
  Result := TMockMethod.Create(AMethodName);
  FCalls.Add(Result);

  for i := 0 to FExpectations.Count - 1 do
    if FExpectations[i].Name.Equals(AMethodName) and
      (not FExpectations[i].EnoughCalls())       then
    begin
      FExpectations[i].AddCall();
      Result.WithOutParams(FExpectations[i].OutParams).Returns(FExpectations[i].Result);
      Break;
    end;
end;

end.
