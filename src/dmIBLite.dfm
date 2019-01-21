object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 281
  Width = 541
  object FDConnectionIBLite: TFDConnection
    Params.Strings = (
      'Database=C:\data\EMBEDDEDIBLITE.IB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Server=localhost/ib2017'
      'DriverID=IB')
    Connected = True
    LoginPrompt = False
    Left = 40
    Top = 32
  end
  object qryPICTURE: TFDQuery
    Connection = FDConnectionIBLite
    SQL.Strings = (
      'select PICTURE from LOG_ENTRIES')
    Left = 128
    Top = 32
    object qryPICTUREPICTURE: TBlobField
      FieldName = 'PICTURE'
      Origin = 'PICTURE'
      Required = True
    end
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 256
    Top = 96
  end
  object FDPhysIBDriverLink1: TFDPhysIBDriverLink
    Left = 144
    Top = 96
  end
  object qryProjects: TFDQuery
    Connection = FDConnectionIBLite
    SQL.Strings = (
      'select Proj_Id from Projects')
    Left = 208
    Top = 32
  end
  object qryLOGENTRIES: TFDQuery
    Connection = FDConnectionIBLite
    SQL.Strings = (
      'select Proj_ID, PICTURE from LOG_ENTRIES')
    Left = 288
    Top = 40
  end
  object qryInsertLogEntries: TFDQuery
    Connection = FDConnectionIBLite
    SQL.Strings = (
      
        'insert into LOG_ENTRIES (PICTURE, PROJ_ID, TIMESTAMP, LONGITUDE,' +
        ' LATITUDE)'
      'values (:PICTURE, :PROJ_ID, :TIMESTAMP, :LONGITUDE, :LATITUDE)')
    Left = 136
    Top = 152
    ParamData = <
      item
        Name = 'PICTURE'
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PROJ_ID'
        ParamType = ptInput
      end
      item
        Name = 'TIMESTAMP'
        ParamType = ptInput
      end
      item
        Name = 'LONGITUDE'
        ParamType = ptInput
      end
      item
        Name = 'LATITUDE'
        ParamType = ptInput
      end>
  end
  object qryProjectsMaxId: TFDQuery
    Connection = FDConnectionIBLite
    SQL.Strings = (
      'select Max(Proj_Id) as Proj_Id from Projects')
    Left = 408
    Top = 40
  end
end
