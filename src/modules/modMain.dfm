object dmMain: TdmMain
  OldCreateOrder = False
  Height = 547
  Width = 706
  object qryProjects: TFDQuery
    Active = True
    Connection = conn
    SQL.Strings = (
      'select * from PROJECTS;')
    Left = 32
    Top = 80
  end
  object qryEntries: TFDQuery
    Active = True
    MasterSource = dsProjects
    MasterFields = 'PROJ_ID'
    DetailFields = 'PROJ_ID'
    Connection = conn
    FetchOptions.AssignedValues = [evCache]
    FetchOptions.Cache = [fiBlobs, fiMeta]
    SQL.Strings = (
      'select * from LOG_ENTRIES where PROJ_ID=:PROJ_ID;')
    Left = 32
    Top = 136
    ParamData = <
      item
        Name = 'PROJ_ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end>
  end
  object conn: TFDConnection
    Params.Strings = (
      'Database=C:\data\EMBEDDEDIBLITE.IB'
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=IBLite')
    Connected = True
    LoginPrompt = False
    Left = 23
    Top = 8
  end
  object dsProjects: TDataSource
    DataSet = qryProjects
    Left = 112
    Top = 96
  end
end
