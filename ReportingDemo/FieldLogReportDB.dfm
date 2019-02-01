object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 439
  Width = 528
  object FDConnection1: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\Jim\Documents\GitHub\FieldLogger-FMXTraining\E' +
        'MBEDDEDIBLITE.IB'
      'User_Name=sysdba'
      'Password=masterkey'
      'Protocol=TCPIP'
      'Server=127.0.0.1'
      'Port=3050'
      'DriverID=IB')
    Connected = True
    LoginPrompt = False
    Left = 112
    Top = 72
  end
  object qProjects: TFDQuery
    ActiveStoredUsage = []
    Connection = FDConnection1
    SQL.Strings = (
      'select * from projects')
    Left = 232
    Top = 88
  end
  object qLogEntries: TFDQuery
    ActiveStoredUsage = []
    MasterSource = dsProjects
    MasterFields = 'PROJ_ID'
    Connection = FDConnection1
    SQL.Strings = (
      'select * from log_Entries where proj_id = :proj_id')
    Left = 248
    Top = 200
    ParamData = <
      item
        Name = 'PROJ_ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object dsProjects: TDataSource
    DataSet = qProjects
    Left = 352
    Top = 168
  end
end
