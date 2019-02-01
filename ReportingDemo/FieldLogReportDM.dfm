object dmFieldLogger: TdmFieldLogger
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
      'CharacterSet=UTF8'
      'DriverID=IB')
    Connected = True
    LoginPrompt = False
    Left = 112
    Top = 64
  end
  object qProjects: TFDQuery
    ActiveStoredUsage = []
    Connection = FDConnection1
    SQL.Strings = (
      'select * from projects')
    Left = 80
    Top = 120
    object qProjectsPROJ_ID: TIntegerField
      FieldName = 'PROJ_ID'
      Origin = 'PROJ_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qProjectsPROJ_TITLE: TWideStringField
      FieldName = 'PROJ_TITLE'
      Origin = 'PROJ_TITLE'
      Required = True
      Size = 30
    end
    object qProjectsPROJ_DESC: TWideMemoField
      FieldName = 'PROJ_DESC'
      Origin = 'PROJ_DESC'
      BlobType = ftWideMemo
    end
  end
  object qLogEntries: TFDQuery
    ActiveStoredUsage = []
    AfterInsert = qLogEntriesAfterInsert
    MasterSource = dsProjects
    MasterFields = 'PROJ_ID'
    Connection = FDConnection1
    SQL.Strings = (
      'select * from log_Entries where proj_id = :proj_id')
    Left = 144
    Top = 120
    ParamData = <
      item
        Name = 'PROJ_ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qLogEntriesPROJ_ID: TIntegerField
      FieldName = 'PROJ_ID'
      Origin = 'PROJ_ID'
      Required = True
    end
    object qLogEntriesNOTE: TWideMemoField
      FieldName = 'NOTE'
      Origin = 'NOTE'
      BlobType = ftWideMemo
    end
    object qLogEntriesPICTURE: TBlobField
      FieldName = 'PICTURE'
      Origin = 'PICTURE'
      Required = True
    end
    object qLogEntriesLONGITUDE: TSingleField
      FieldName = 'LONGITUDE'
      Origin = 'LONGITUDE'
    end
    object qLogEntriesLATITUDE: TSingleField
      FieldName = 'LATITUDE'
      Origin = 'LATITUDE'
    end
    object qLogEntriesTIMEDATESTAMP: TSQLTimeStampField
      FieldName = 'TIMEDATESTAMP'
      Origin = 'TIMEDATESTAMP'
    end
    object qLogEntriesOR_X: TSingleField
      FieldName = 'OR_X'
      Origin = 'OR_X'
      Required = True
    end
    object qLogEntriesOR_Y: TSingleField
      FieldName = 'OR_Y'
      Origin = 'OR_Y'
      Required = True
    end
    object qLogEntriesOR_Z: TSingleField
      FieldName = 'OR_Z'
      Origin = 'OR_Z'
      Required = True
    end
    object qLogEntriesOR_DISTANCE: TSingleField
      FieldName = 'OR_DISTANCE'
      Origin = 'OR_DISTANCE'
      Required = True
    end
    object qLogEntriesHEADING_X: TSingleField
      FieldName = 'HEADING_X'
      Origin = 'HEADING_X'
      Required = True
    end
    object qLogEntriesHEADING_Y: TSingleField
      FieldName = 'HEADING_Y'
      Origin = 'HEADING_Y'
      Required = True
    end
    object qLogEntriesHEADING_Z: TSingleField
      FieldName = 'HEADING_Z'
      Origin = 'HEADING_Z'
      Required = True
    end
    object qLogEntriesV_X: TSingleField
      FieldName = 'V_X'
      Origin = 'V_X'
      Required = True
    end
    object qLogEntriesV_Y: TSingleField
      FieldName = 'V_Y'
      Origin = 'V_Y'
      Required = True
    end
    object qLogEntriesV_Z: TSingleField
      FieldName = 'V_Z'
      Origin = 'V_Z'
      Required = True
    end
    object qLogEntriesANGLE_X: TSingleField
      FieldName = 'ANGLE_X'
      Origin = 'ANGLE_X'
      Required = True
    end
    object qLogEntriesANGLE_Y: TSingleField
      FieldName = 'ANGLE_Y'
      Origin = 'ANGLE_Y'
      Required = True
    end
    object qLogEntriesANGLE_Z: TSingleField
      FieldName = 'ANGLE_Z'
      Origin = 'ANGLE_Z'
      Required = True
    end
    object qLogEntriesMOTION: TSingleField
      FieldName = 'MOTION'
      Origin = 'MOTION'
      Required = True
    end
    object qLogEntriesSPEED: TSingleField
      FieldName = 'SPEED'
      Origin = 'SPEED'
      Required = True
    end
  end
  object dsProjects: TDataSource
    DataSet = qProjects
    Left = 80
    Top = 176
  end
end
