unit ExampleClass;

interface

type
  /// <summary>
  /// Restaurant
  /// </summary>
  /// <remarks>
  /// Restaurant takes orders and sends them to the kitchen
  /// </remarks>
  IRestaurant = interface
    ['{0349C0FC-6934-46E2-B1AA-EB1B70AB20DD}']
    procedure OrderCupOfCoffee(
      const AMilk  : Boolean;
      const ASugar : Boolean);
    procedure OrderBreakfast();
    procedure OrderLunch(
      const AVegetarian : Boolean);

    function LeaveReviewForChef(
      const AReview : String) : String;
  end;

type
  /// <summary>
  /// Restaurant Kitchen
  /// </summary>
  /// <remarks>
  /// Kitchen fulfills the orders sent from the restaurant reception
  /// </remarks>
  IRestaurantKitchen = interface
    ['{0349C0FC-6934-46E2-B1AA-EB1B70AB20DD}']
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

{------------------------------------------------------------------------------}

type
  /// <summary>
  /// Restaurant
  /// </summary>
  /// <remarks>
  /// Restaurant takes orders and sends them to the kitchen
  /// </remarks>
  TRestaurant = class(
    TInterfacedObject, IRestaurant)
  strict private
    FKitchen : IRestaurantKitchen;
  private
    procedure OrderCupOfCoffee(
      const AMilk  : Boolean;
      const ASugar : Boolean);
    procedure OrderBreakfast();
    procedure OrderLunch(
      const AVegetarian : Boolean);

    function LeaveReviewForChef(
      const AReview : String) : String;
  public
    constructor Create(
      const AKitchen : IRestaurantKitchen);
  end;

type
  /// <summary>
  /// Restaurant Kitchen
  /// </summary>
  /// <remarks>
  /// Kitchen fulfills the orders sent from the restaurant reception
  /// </remarks>
  TRestaurantKitchen = class(
    TInterfacedObject, IRestaurantKitchen)
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
{ TRestaurant }
{------------------------------------------------------------------------------}

constructor TRestaurant.Create(
  const AKitchen: IRestaurantKitchen);
begin
  inherited Create();

  FKitchen := AKitchen;
end;

procedure TRestaurant.OrderCupOfCoffee(
  const AMilk  : Boolean;
  const ASugar : Boolean);
begin
  FKitchen.MakeCoffee(AMilk, ASugar);
end;

procedure TRestaurant.OrderBreakfast();
begin
  FKitchen.MakeOmelet();
  FKitchen.MakeToast();
end;

procedure TRestaurant.OrderLunch(
  const AVegetarian : Boolean);
begin
  FKitchen.MakeSalad();
  FKitchen.MakeSoup();
  if AVegetarian then
    FKitchen.CookStewedVegetables()
  else
    FKitchen.CookFishAndPotatoes();
end;

function TRestaurant.LeaveReviewForChef(
  const AReview : String) : String;
begin
  Result := FKitchen.LeaveReviewForChef(AReview);
end;

{------------------------------------------------------------------------------}
{ TRestaurantKitchen }
{------------------------------------------------------------------------------}

function TRestaurantKitchen.MakeCoffee(
  const AMilk  : Boolean;
  const ASugar : Boolean) : String;
begin
  Result := 'Coffee';
  if AMilk then
    Result := Result + ', with milk';
  if ASugar then
    Result := Result + ', with sugar';
end;

function TRestaurantKitchen.MakeOmelet() : String;
begin
  Result := 'Omelet';
end;

function TRestaurantKitchen.MakeToast() : String;
begin
  Result := 'Toast';
end;

function TRestaurantKitchen.MakeSalad() : String;
begin
  Result := 'Salad';
end;

function TRestaurantKitchen.MakeSoup() : String;
begin
  Result := 'Soup';
end;

function TRestaurantKitchen.CookFishAndPotatoes() : String;
begin
  Result := 'Fish and potatoes';
end;

function TRestaurantKitchen.CookStewedVegetables() : String;
begin
  Result := 'Stewed vegetables';
end;

function TRestaurantKitchen.LeaveReviewForChef(
  const AReview : String) : String;
begin
  if (AReview = 'Thank you!') then
    Result := 'You are welcome!'
  else
    Result := '';
end;

end.
