object dmMain: TdmMain
  OldCreateOrder = False
  Height = 547
  Width = 706
  object qryProjects: TFDQuery
    Connection = conn
    SQL.Strings = (
      'select * from PROJECTS;')
    Left = 32
    Top = 80
    object qryProjectsPROJ_ID: TIntegerField
      FieldName = 'PROJ_ID'
      Origin = 'PROJ_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryProjectsPROJ_TITLE: TStringField
      FieldName = 'PROJ_TITLE'
      Origin = 'PROJ_TITLE'
      Required = True
      Size = 30
    end
    object qryProjectsPROJ_DESC: TMemoField
      FieldName = 'PROJ_DESC'
      Origin = 'PROJ_DESC'
      BlobType = ftMemo
    end
  end
  object qryEntries: TFDQuery
    MasterSource = dsProjects
    MasterFields = 'PROJ_ID'
    DetailFields = 'PROJ_ID'
    Connection = conn
    FetchOptions.AssignedValues = [evCache]
    FetchOptions.Cache = [fiBlobs, fiMeta]
    SQL.Strings = (
      'select * from LOG_ENTRIES where PROJ_ID=:PROJ_ID;'
      ' ')
    Left = 32
    Top = 136
    ParamData = <
      item
        Name = 'PROJ_ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end>
    object qryEntriesPROJ_ID: TIntegerField
      FieldName = 'PROJ_ID'
      Origin = 'PROJ_ID'
      Required = True
    end
    object qryEntriesPICTURE: TBlobField
      FieldName = 'PICTURE'
      Origin = 'PICTURE'
      Required = True
    end
    object qryEntriesLONGITUDE: TSingleField
      FieldName = 'LONGITUDE'
      Origin = 'LONGITUDE'
    end
    object qryEntriesLATITUDE: TSingleField
      FieldName = 'LATITUDE'
      Origin = 'LATITUDE'
    end
    object qryEntriesTIMEDATESTAMP: TSQLTimeStampField
      FieldName = 'TIMEDATESTAMP'
      Origin = 'TIMEDATESTAMP'
    end
    object qryEntriesOR_X: TSingleField
      FieldName = 'OR_X'
      Origin = 'OR_X'
    end
    object qryEntriesOR_Y: TSingleField
      FieldName = 'OR_Y'
      Origin = 'OR_Y'
    end
    object qryEntriesOR_Z: TSingleField
      FieldName = 'OR_Z'
      Origin = 'OR_Z'
    end
    object qryEntriesOR_DISTANCE: TSingleField
      FieldName = 'OR_DISTANCE'
      Origin = 'OR_DISTANCE'
    end
    object qryEntriesHEADING_X: TSingleField
      FieldName = 'HEADING_X'
      Origin = 'HEADING_X'
    end
    object qryEntriesHEADING_Y: TSingleField
      FieldName = 'HEADING_Y'
      Origin = 'HEADING_Y'
    end
    object qryEntriesHEADING_Z: TSingleField
      FieldName = 'HEADING_Z'
      Origin = 'HEADING_Z'
    end
    object qryEntriesV_X: TSingleField
      FieldName = 'V_X'
      Origin = 'V_X'
    end
    object qryEntriesV_Y: TSingleField
      FieldName = 'V_Y'
      Origin = 'V_Y'
    end
    object qryEntriesV_Z: TSingleField
      FieldName = 'V_Z'
      Origin = 'V_Z'
    end
    object qryEntriesANGLE_X: TSingleField
      FieldName = 'ANGLE_X'
      Origin = 'ANGLE_X'
    end
    object qryEntriesANGLE_Y: TSingleField
      FieldName = 'ANGLE_Y'
      Origin = 'ANGLE_Y'
    end
    object qryEntriesANGLE_Z: TSingleField
      FieldName = 'ANGLE_Z'
      Origin = 'ANGLE_Z'
    end
    object qryEntriesMOTION: TSingleField
      FieldName = 'MOTION'
      Origin = 'MOTION'
    end
    object qryEntriesSPEED: TSingleField
      FieldName = 'SPEED'
      Origin = 'SPEED'
    end
    object qryEntriesNOTE: TMemoField
      FieldName = 'NOTE'
      Origin = 'NOTE'
      BlobType = ftMemo
    end
    object qryEntriesLOG_ID: TIntegerField
      FieldName = 'LOG_ID'
      Origin = 'LOG_ID'
    end
  end
  object conn: TFDConnection
    Params.Strings = (
      'Database=C:\data\EMBEDDEDIBLITE.IB'
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=IBLite')
    LoginPrompt = False
    Left = 23
    Top = 8
  end
  object dsProjects: TDataSource
    DataSet = qryProjects
    Left = 32
    Top = 184
  end
end
