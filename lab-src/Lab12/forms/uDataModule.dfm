object mainDM: TmainDM
  OldCreateOrder = False
  Height = 293
  Width = 306
  object conn: TFDConnection
    Params.Strings = (
      'DriverID=IBLite'
      'User_Name=sysdba'
      'Password=masterkey')
    LoginPrompt = False
    Left = 111
    Top = 128
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 104
    Top = 48
  end
end
