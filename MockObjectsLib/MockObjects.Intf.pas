unit MockObjects.Intf;

interface

type
  /// <summary>
  /// Mock Object Method
  /// </summary>
  IMockMethod = interface(IInterface)
    ['{681EE03E-C56D-461D-91F6-B7761CAA807C}']
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

    /// <summary> Method name </summary>
    property Name: String read GetName;
    /// <summary> Method call parameters </summary>
    property Params: TArray<Variant> read GetParams;
    /// <summary> Method call out parameters </summary>
    property OutParams: TArray<Variant> read GetOutParams;
    /// <summary> Method result </summary>
    property Result: Variant read GetResult;
  end;

type
  /// <summary>
  /// Mock Object
  /// </summary>
  IMockObject = interface(IInterface)
    ['{FA5F638F-7B23-4AF9-A4D9-D28D6E6416A0}']
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
  end;

implementation

end.
