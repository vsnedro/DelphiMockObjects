unit ExampleClassMock;

interface

uses
  ExampleClass,
  MockObjects.Impl;

type
  /// <summary>
  /// Restaurant Kitchen Mock class
  /// </summary>
  /// <remarks>
  /// The class does not do the real work, but records all calls to its methods
  /// </remarks>
  TRestaurantKitchenMock = class(
    TMockObject, IRestaurantKitchen)
  private
    procedure MakeOmelet();
    procedure MakeToast();
    procedure MakeCoffee(
      const AMilk  : Boolean;
      const ASugar : Boolean);

    procedure MakeSalad();
    procedure MakeSoup();
    procedure CookFishAndPotatoes();
    procedure CookStewedVegetables();

    function LeaveReviewForChef(
      const AReview : String) : String;
  end;

implementation

{------------------------------------------------------------------------------}
{ TRestaurantKitchenMock }
{------------------------------------------------------------------------------}

procedure TRestaurantKitchenMock.MakeOmelet();
begin
  AddCall('MakeOmelet');
end;

procedure TRestaurantKitchenMock.MakeToast();
begin
  AddCall('MakeToast');
end;

procedure TRestaurantKitchenMock.MakeCoffee(
  const AMilk  : Boolean;
  const ASugar : Boolean);
begin
  AddCall('MakeCoffee').WithParams([AMilk, ASugar]);
end;

procedure TRestaurantKitchenMock.MakeSalad();
begin
  AddCall('MakeSalad');
end;

procedure TRestaurantKitchenMock.MakeSoup();
begin
  AddCall('MakeSoup');
end;

procedure TRestaurantKitchenMock.CookFishAndPotatoes();
begin
  AddCall('CookFishAndPotatoes');
end;

procedure TRestaurantKitchenMock.CookStewedVegetables();
begin
  AddCall('CookStewedVegetables');
end;

function TRestaurantKitchenMock.LeaveReviewForChef(
  const AReview: String): String;
begin
  Result := AddCall('LeaveReviewForChef').WithParams([AReview]).Result;
end;

end.
