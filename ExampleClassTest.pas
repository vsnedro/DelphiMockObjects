unit ExampleClassTest;

interface

uses
  TestFramework,
  {App}
  ExampleClass,
  ExampleClassMock,
  {Mock}
  MockObjects.Intf;

type
  /// <summary>
  /// Test for Restaurant Kitchen
  /// </summary>
  TRestaurantKitchenTest = class(TTestCase)
  strict private
    FRestaurant: IRestaurant;
    FKitchen   : IMockObject;
  strict protected
    procedure SetUp(); override;
    procedure TearDown(); override;
  published
    procedure Test_OrderCupOfCoffee_VerifyMethodCallNumber();
    procedure Test_OrderCupOfCoffee_VerifyMethodCalls();

    procedure Test_OrderBreakfast();
    procedure Test_OrderBreakfast_LooseVerifyWithWrongCallOrder();
    procedure Test_OrderBreakfast_StrictVerifyWithWrongCallOrder();
    procedure Test_OrderBreakfast_StrictVerifyWithWrongCallsNumber();

    procedure Test_OrderLunch();
    procedure Test_OrderVegetarianLunch();

    procedure Test_LeaveReviewForChef();
    procedure Test_LeaveReviewForChef_VerifyResult();
  end;

implementation

uses
  MockObjects.Impl;

{------------------------------------------------------------------------------}
{ TRestaurantKitchenTest }
{------------------------------------------------------------------------------}

procedure TRestaurantKitchenTest.SetUp();
begin
  inherited;

  // Kitchen will be called from the calling context
  // Restaurant is the calling context
  FKitchen    := TRestaurantKitchenMock.Create();
  FRestaurant := TRestaurant.Create(FKitchen as IRestaurantKitchen);
end;

procedure TRestaurantKitchenTest.TearDown();
begin
  // Optional, just for clarity
  FRestaurant := nil;
  FKitchen    := nil;

  inherited;
end;

procedure TRestaurantKitchenTest.Test_OrderCupOfCoffee_VerifyMethodCallNumber();
begin
  // Step 1
  // We set the names of the methods that are expected to be called from the calling context
  FKitchen.Expects('MakeCoffee').WithParams([True, False]).Returns('Coffee, with milk');

  // Step 2
  // The Restaurant as the calling context does its work and calls methods of the Kitchen
  FRestaurant.OrderCupOfCoffee(True, False);

  // Step 3
  // Check the number of method calls
  // The number of method calls must be one, so the test passes
  CheckEquals(1, FKitchen.VerifyCall('MakeCoffee'));
end;

procedure TRestaurantKitchenTest.Test_OrderCupOfCoffee_VerifyMethodCalls;
begin
  // Step 1
  // We set the names of the methods that are expected to be called from the calling context
  FKitchen.Expects('MakeCoffee').WithParams([True, False]).Returns('Coffee, with milk');;

  // Step 2
  // The Restaurant as the calling context does its work and calls methods of the Kitchen
  FRestaurant.OrderCupOfCoffee(True, False);

  // Step 3
  // Check that all expected methods have been called
  CheckTrue(FKitchen.Verify());
end;

procedure TRestaurantKitchenTest.Test_OrderBreakfast();
begin
  // Step 1
  // We set the names of the methods that are expected to be called from the calling context
  FKitchen.Expects('MakeOmelet');
  FKitchen.Expects('MakeToast');

  // Step 2
  // The Restaurant as the calling context does its work and calls methods of the Kitchen
  FRestaurant.OrderBreakfast();

  // Step 3
  // Check that all expected methods have been called
  CheckTrue(FKitchen.Verify());
end;

procedure TRestaurantKitchenTest.Test_OrderBreakfast_LooseVerifyWithWrongCallOrder();
begin
  // Step 1
  // We set the names of the methods that are expected to be called from the calling context
  // Let's set the wrong order of methods calls
  FKitchen.Expects('MakeToast');
  FKitchen.Expects('MakeOmelet');

  // Step 2
  // The Restaurant as the calling context does its work and calls methods of the Kitchen
  FRestaurant.OrderBreakfast();

  // Step 3
  // Check that all expected methods have been called
  // We use a loose check mode by default, so the order of method calls IS NOT taken into account,
  // so the test _PASSES_
  CheckTrue(FKitchen.Verify());
end;

procedure TRestaurantKitchenTest.Test_OrderBreakfast_StrictVerifyWithWrongCallOrder();
var
  Msg : String;
begin
  // Step 0
  // Let's use a strict check mode
  FKitchen    := TRestaurantKitchenMock.Create(mtStrict);
  FRestaurant := TRestaurant.Create(FKitchen as IRestaurantKitchen);

  // Step 1.
  // We set the names of the methods that are expected to be called from the calling context
  // Let's set the wrong order of methods calls
  FKitchen.Expects('MakeToast');
  FKitchen.Expects('MakeOmelet');

  // Step 2.
  // The Restaurant as the calling context does its work and calls methods of the Kitchen
  FRestaurant.OrderBreakfast();

  // Step 3.
  // Check that all expected methods have been called
  // We use a strict check mode, so the order of method calls IS taken into account,
  // so the test _FAILS_
  // We can also get a detailed error message and display it in the log
  CheckTrue(FKitchen.Verify({out}Msg), Msg);
end;

procedure TRestaurantKitchenTest.Test_OrderBreakfast_StrictVerifyWithWrongCallsNumber();
var
  Msg : String;
begin
  // Step 0
  // Let's use a strict check mode
  FKitchen    := TRestaurantKitchenMock.Create(mtStrict);
  FRestaurant := TRestaurant.Create(FKitchen as IRestaurantKitchen);

  // Step 1.
  // We set the names of the methods that are expected to be called from the calling context
  // Let's set the correct order of method calls, but add an extra call
  FKitchen.Expects('MakeOmelet');
  FKitchen.Expects('MakeToast');
  FKitchen.Expects('MakeCoffee');

  // Step 2.
  // The Restaurant as the calling context does its work and calls methods of the Kitchen
  FRestaurant.OrderBreakfast();

  // Step 3.
  // Check that all expected methods have been called
  // We use a strict check mode, so an extra method call IS taken into account,
  // so the test _FAILS_
  // We can also get a detailed error message and display it in the log
  CheckTrue(FKitchen.Verify({out}Msg), Msg);
end;

procedure TRestaurantKitchenTest.Test_OrderLunch();
begin
  // Step 1
  // We set the names of the methods that are expected to be called from the calling context
  FKitchen.Expects('MakeSalad');
  FKitchen.Expects('MakeSoup');
  FKitchen.Expects('CookFishAndPotatoes');

  // Step 2
  // The Restaurant as the calling context does its work and calls methods of the Kitchen
  // Let's order a non vegetarian lunch
  FRestaurant.OrderLunch({AVegetarian}False);

  // Step 3
  // Check that all expected methods have been called
  CheckTrue(FKitchen.Verify());
end;

procedure TRestaurantKitchenTest.Test_OrderVegetarianLunch();
begin
  // Step 1
  // We set the names of the methods that are expected to be called from the calling context
  FKitchen.Expects('MakeSalad');
  FKitchen.Expects('MakeSoup');
  FKitchen.Expects('CookStewedVegetables');

  // Step 2
  // The Restaurant as the calling context does its work and calls methods of the Kitchen
  // Let's order a vegetarian lunch
  FRestaurant.OrderLunch({AVegetarian}True);

  // Step 3
  // Check that all expected methods have been called
  CheckTrue(FKitchen.Verify());
end;

procedure TRestaurantKitchenTest.Test_LeaveReviewForChef();
begin
  // We set the names of the methods that are expected to be called from the calling context
  FKitchen.Expects('LeaveReviewForChef');

  // Step 2
  // The Restaurant as the calling context does its work and calls methods of the Kitchen
  FRestaurant.LeaveReviewForChef('Thank you!');

  // Step 3
  // Check that all expected methods have been called
  CheckTrue(FKitchen.Verify());
end;

procedure TRestaurantKitchenTest.Test_LeaveReviewForChef_VerifyResult();
var
  Answer : String;
begin
  // We set the names of the methods that are expected to be called from the calling context
  FKitchen.Expects('LeaveReviewForChef').Returns('You are welcome!');

  // Step 2
  // The Restaurant as the calling context does its work and calls methods of the Kitchen
  Answer := FRestaurant.LeaveReviewForChef('Thank you!');

  // Step 3
  // Check that the calling context gets the expected value from the called method
  CheckEquals('You are welcome!', Answer);
end;

initialization

TestFramework.RegisterTest('RestaurantKitchen', TRestaurantKitchenTest.Suite);

end.
