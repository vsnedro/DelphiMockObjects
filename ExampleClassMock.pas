unit ExampleClassMock;

interface

uses
  ExampleClass,
  {Mock}
  MockObjects.Impl;

type
  /// <summary>
  /// Restaurant Kitchen Mock class
  /// </summary>
  /// <remarks>
  /// The class does not do the real work, but records all methods calls
  /// </remarks>
  TRestaurantKitchenMock = class(
    TMockObject, IRestaurantKitchen)
  private
    function MakeCoffee(
      const AMilk  : Boolean;
      const ASugar : Boolean) : String;

    function MakeOmelet() : String;
    function MakeToast() : String;

    function MakeSalad() : String;
    function MakeSoup() : String;
    function CookFishAndPotatoes() : String;
    function CookStewedVegetables() : String;

    function LeaveReviewForChef(
      const AReview : String) : String;
  end;

implementation

{------------------------------------------------------------------------------}
{ TRestaurantKitchenMock }
{------------------------------------------------------------------------------}

function TRestaurantKitchenMock.MakeCoffee(
  const AMilk  : Boolean;
  const ASugar : Boolean) : String;
begin
  Result := AddCall('MakeCoffee').WithParams([AMilk, ASugar]).Result;
end;

function TRestaurantKitchenMock.MakeOmelet() : String;
begin
  Result := AddCall('MakeOmelet').Result;
end;

function TRestaurantKitchenMock.MakeToast() : String;
begin
  Result := AddCall('MakeToast').Result;
end;

function TRestaurantKitchenMock.MakeSalad() : String;
begin
  Result := AddCall('MakeSalad').Result;
end;

function TRestaurantKitchenMock.MakeSoup() : String;
begin
  Result := AddCall('MakeSoup').Result;
end;

function TRestaurantKitchenMock.CookFishAndPotatoes() : String;
begin
  Result := AddCall('CookFishAndPotatoes').Result;
end;

function TRestaurantKitchenMock.CookStewedVegetables() : String;
begin
  Result := AddCall('CookStewedVegetables').Result;
end;

function TRestaurantKitchenMock.LeaveReviewForChef(
  const AReview: String): String;
begin
  Result := AddCall('LeaveReviewForChef').WithParams([AReview]).Result;
end;

end.
