object DM: TDM
  OldCreateOrder = False
  Height = 365
  Width = 456
  object conn: TFDConnection
    Params.Strings = (
      'DriverID=IBLite'
      'User_Name=sysdba'
      'Password=masterkey')
    LoginPrompt = False
    Left = 55
    Top = 224
  end
end
