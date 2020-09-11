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
  /// Kitchen prepares the orders sent from the reception
  /// </remarks>
  IRestaurantKitchen = interface
    ['{0349C0FC-6934-46E2-B1AA-EB1B70AB20DD}']
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
  /// Kitchen prepares the orders sent from the reception
  /// </remarks>
  TRestaurantKitchen = class(
    TInterfacedObject, IRestaurantKitchen)
  private
    procedure MakeCoffee(
      const AMilk  : Boolean;
      const ASugar : Boolean);

    procedure MakeOmelet();
    procedure MakeToast();

    procedure MakeSalad();
    procedure MakeSoup();
    procedure CookFishAndPotatoes();
    procedure CookStewedVegetables();

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

procedure TRestaurantKitchen.MakeCoffee(
  const AMilk  : Boolean;
  const ASugar : Boolean);
begin
end;

procedure TRestaurantKitchen.MakeOmelet();
begin
end;

procedure TRestaurantKitchen.MakeToast();
begin
end;

procedure TRestaurantKitchen.MakeSalad();
begin
end;

procedure TRestaurantKitchen.MakeSoup();
begin
end;

procedure TRestaurantKitchen.CookFishAndPotatoes();
begin
end;

procedure TRestaurantKitchen.CookStewedVegetables();
begin
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
