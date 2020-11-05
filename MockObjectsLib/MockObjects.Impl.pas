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
    /// <param name="AParams"> Method parameters <see cref="T:array of const"/> </param>
    function WithParams(
      const AParams: array of const): IMockMethod;
    /// <summary> Method call out parameters </summary>
    /// <param name="AOutParams"> Method out parameters <see cref="T:array of const"/> </param>
    function WithOutParams(
      const AOutParams: TArray<Variant>): IMockMethod;
    /// <summary> Return value </summary>
    /// <param name="AValue"> Returned value <see cref="T:Variant"/> </param>
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
begin
  Result := Self;

  SetLength(FParams, Length(AParams));
  for var i := Low(AParams) to High(AParams) do
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
  const AOutParams: TArray<Variant>): IMockMethod;
begin
  Result := Self;

  SetLength(FOutParams, Length(AOutParams));
  FOutParams := Copy(AOutParams, 0, Length(AOutParams));
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
begin
  for var i := 1 to AExpectedCalls do
  begin
    Result := TMockMethod.Create(AMethodName);
    FExpectations.Add(Result);
  end;
end;

/// <summary> Check that a method call has occurred </summary>
function TMockObject.VerifyCall(
  const AMethodName: String): Cardinal;
begin
  Result := 0;

  for var method in FCalls do
    if method.Name.Equals(AMethodName) then
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
begin
  Result   := True;
  AMessage := '';

  case FMockMode of
    mtLoose  :
      begin
        // Check that all expected methods have been called
        for var method in FExpectations do
        begin
          Result := method.EnoughCalls();
          if not Result then
          begin
            AMessage := Format(
              '%s: Expected method call: <%s> but was not called',
              [Self.ClassName, method.Name]);
            Break;
          end;
        end;
      end;

    mtStrict :
      begin
        // Check that the order of calls matches the order of expectations
        for var i := 0 to FExpectations.Count - 1 do
          if (i < FCalls.Count) then
          begin
            if not FExpectations[i].Name.Equals(FCalls[i].Name) then
            begin
              Result   := False;
              AMessage := Format(
                '%s: Expected method call: <%s> but was: <%s> (call #%d)',
                [Self.ClassName, FExpectations[i].Name, FCalls[i].Name, i + 1]);
              Break;
            end
          end
          else
          begin
            Result   := False;
            AMessage := Format(
              '%s: Expected method call: <%s> but it was not called (call #%d)',
              [Self.ClassName, FExpectations[i].Name, i + 1]);
            Break;
          end;

        // Check that there were no other calls
        if Result then
          if (FCalls.Count > FExpectations.Count) then
          begin
            Result   := False;
            AMessage := Format(
              '%s: Unexpected method call: <%s> (call #%d)',
              [Self.ClassName, FCalls[FExpectations.Count].Name, FExpectations.Count + 1]);
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
begin
  Result := TMockMethod.Create(AMethodName);
  FCalls.Add(Result);

  for var method in FExpectations do
    if method.Name.Equals(AMethodName) and
      (not method.EnoughCalls())       then
    begin
      method.AddCall();
      Result.WithOutParams(method.OutParams).Returns(method.Result);
      Break;
    end;
end;

end.
