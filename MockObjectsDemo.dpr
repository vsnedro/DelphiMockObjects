program MockObjectsDemo;

uses
  TestFramework,
  GUITestRunner,
  MockObjects.Intf in 'MockObjectsLib\MockObjects.Intf.pas',
  MockObjects.Impl in 'MockObjectsLib\MockObjects.Impl.pas',
  ExampleClass in 'ExampleClass.pas',
  ExampleClassMock in 'ExampleClassMock.pas',
  ExampleClassTest in 'ExampleClassTest.pas';

{$R *.res}

begin
  GUITestRunner.RunRegisteredTests();
end.
