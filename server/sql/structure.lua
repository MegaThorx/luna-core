DBSchemaIncludes = {
  coordination = {
    datatype = "double",
    default = 0,
    custom = {
      storeClient = true,
      storeServer = true,
      autoSave = false
    }
  },
  color = {
    datatype = "int",
    default = 0,
    custom = {
      storeClient = true,
      storeServer = true,
      autoSave = false
    }
  },
  id = {
    name = "id",
    datatype = "int",
    autoincrement = true,
    primarykey = true,
    custom = {
      storeClient = true,
      storeServer = true
    }
  },
  account = {
    name = "account",
    reference = {
      type = "manyToOne",
      targetEntity = "accounts",
      joinColumn = {
        name = "account_id",
        referencedColumnName = "id"
      }
    }
  }
}

DBSchema = {}

DBSchema.accounts = {
  {
    include = "id"
  },
  {
    name = "username",
    datatype = "varchar",
    length = 32,
    unique = true,
    caseSensitiv = false,
    nullable = false,
    custom = {
      storeClient = true,
      storeServer = true,
      autoSave = false
    }
  },
  {
    name = "playtime",
    datatype = "int",
    default = 0,
    nullable = false,
    custom = {
      storeClient = true,
      storeServer = true,
      autoSave = true
    }
  },
  {
    name = "password",
    datatype = "varchar",
    length = 64
  },
  {
    name = "email",
    datatype = "varchar",
    length = 64
  },
  {
    name = "salt",
    datatype = "varchar",
    length = 8,
  },
  {
    name = "autologinToken",
    datatype = "varchar",
    length = 64,
  },
  {
    name = "autologinSerial",
    datatype = "varchar",
    length = 32,
  },
  {
    name = "adminlevel",
    datatype = "smallint",
    default = 0,
    custom = {
      storeClient = true,
      storeServer = true,
      autoSave = true
    }
  },
  {
    name = "money",
    datatype = "bigint",
    default = 0,
    custom = {
      storeClient = true,
      storeServer = true,
      autoSave = true
    }
  },
  {
    name = "wantedlevel",
    datatype = "smallint",
    default = 0,
    custom = {
      storeClient = true,
      storeServer = true,
      autoSave = true
    }
  },
  {
    name = "lastonline",
    datatype = "bigint",
    default = 0,
    custom = {
      storeServer = true,
      autoSave = true
    }
  },
  {
    name = "language",
    datatype = "varchar",
    length = 5,
    default = Config.Get("defaultlanguage"),
    custom = {
      storeServer = true,
      storeClient = true,
      autoSave = true
    }
  },
  {
    name = "x",
    include = "coordination"
  },
  {
    name = "y",
    include = "coordination"
  },
  {
    name = "z",
    include = "coordination"
  }
}

DBSchema.playerVehicles = {
  {
    include = "id"
  },
  {
    include = "account"
  },
  {
    name = "model",
    datatype = "int"
  },
  {
    name = "x",
    include = "coordination"
  },
  {
    name = "y",
    include = "coordination"
  },
  {
    name = "z",
    include = "coordination"
  },
  {
    name = "rx",
    include = "coordination"
  },
  {
    name = "ry",
    include = "coordination"
  },
  {
    name = "rz",
    include = "coordination"
  },
  {
    name = "color1r",
    include = "color"
  },
  {
    name = "color1g",
    include = "color"
  },
  {
    name = "color1b",
    include = "color"
  },
  {
    name = "color2r",
    include = "color"
  },
  {
    name = "color2g",
    include = "color"
  },
  {
    name = "color2b",
    include = "color"
  },
  {
    name = "lightr",
    include = "color"
  },
  {
    name = "lightg",
    include = "color"
  },
  {
    name = "lightb",
    include = "color"
  },
  {
    name = "fuel",
    datatype = "int",
    default = 1000,
    custom = {
      storeClient = true,
      storeServer = true,
      autoSave = true
    }
  }
}

DBSchema.bankAccounts = {
  {
    include = "id"
  },
  {
    include = "account"
  },
  {
    name = "accountNumber",
    datatype = "int",
    unique = true
  },
  {
    name = "balance",
    datatype = "bigint",
    default = 0
  },
  {
    name = "typ",
    datatype = "int"
  },
  {
    name = "default",
    datatype = "int",
    default = 0
  },
  {
    name = "closed",
    datatype = "int",
    default = 0
  }
}

DBSchema.bankTypes = {
  {
    include = "id"
  },
  {
    name = "name",
    datatype = "varchar",
    length = 64
  },
  {
    name = "transactionProcessingTime",
    datatype = "int",
    default = 0
  },
  {
    name = "haveInterest",
    datatype = "int",
    default = 0
  },
  {
    name = "overdraft",
    datatype = "int",
    default = 0
  },
  {
    name = "canReceiveDirectPayments",
    datatype = "int",
    default = 1
  }
}

DBSchema.bankTransactions = {
  {
    include = "id"
  },
  {
    name = "from",
    datatype = "int"
  },
  {
    name = "to",
    datatype = "int"
  },
  {
    name = "amount",
    datatype = "bigint"
  },
  {
    name = "reason",
    datatype = "varchar",
    length = 256
  },
  {
    name = "creationTime",
    datatype = "int"
  },
  {
    name = "processingTime",
    datatype = "int"
  },
  {
    name = "state",
    datatype = "int",
    default = 0
  }
}
