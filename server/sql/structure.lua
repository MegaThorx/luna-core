SQL_STRUCTURE = {}


-- TABLE accounts
SQL_STRUCTURE["accounts"] = {
  id = {
    primarykey = true,
    datatype = "INT",
    notnull = true,
    autoincrement = true,
    custom = {
      storeClient = true,
      storeServer = true
    }
  },
  username = {
    datatype = "VARCHAR",
    length = 32,
    custom = {
      storeClient = true,
      storeServer = true
    }
  },
  password = {
    datatype = "VARCHAR",
    length = 64,
  },
  email = {
    datatype = "VARCHAR",
    length = 64,
  },
  salt = {
    datatype = "VARCHAR",
    length = 8,
  },
  serial = {
    datatype = "VARCHAR",
    length = 32,
  },
  autologin_token = {
    datatype = "VARCHAR",
    length = 64,
  },
  autologin_serial = {
    datatype = "VARCHAR",
    length = 32,
  },
  adminlevel = {
    datatype = "SMALLINT",
    default = 0,
    custom = {
      storeClient = true,
      storeServer = true,
      autoSave = true
    }
  },
  wantedlevel = {
    datatype = "SMALLINT",
    default = 0,
    custom = {
      storeClient = true,
      storeServer = true,
      autoSave = true
    }
  },
  playtime = {
    datatype = "BIGINT",
    default = 0,
    custom = {
      storeClient = true,
      storeServer = true,
      autoSave = true
    }
  },
  money = {
    datatype = "BIGINT",
    default = 0,
    custom = {
      storeClient = true,
      storeServer = true,
      autoSave = true
    }
  },
  lastonline = {
    datatype = "BIGINT",
    default = 0,
    custom = {
      storeServer = true,
      autoSave = true
    }
  }
}


-- TABLE vehicles
SQL_STRUCTURE["vehicles"] = {
  id = {
    primarykey = true,
    datatype = "INT",
    notnull = true,
    autoincrement = true,
    custom = {
      storeClient = true,
      storeServer = true
    }
  },
  owner = {
    datatype = "INT",
    notnull = true
  }
}

-- TABLE bank_accounts
SQL_STRUCTURE["bank_accounts"] = {
  id = {
    primarykey = true,
    datatype = "INT",
    notnull = true,
    autoincrement = true
  },
  accountNumber = {
    datatype = "INT",
    notnull = true,
  },
  owner = {
    datatype = "INT",
    notnull = true,
  },
  balance = {
    datatype = "BIGINT",
    default = 0
  },
  typ = {
    datatype = "INT",
    notnull = true,
  },
  default = {
    datatype = "INT",
    default = 0
  },
  closed = {
    datatype = "INT",
    default = 0
  }
}

-- TABLE bank_types
SQL_STRUCTURE["bank_types"] = {
  id = {
    primarykey = true,
    datatype = "INT",
    notnull = true,
    autoincrement = true
  },
  name = {
    datatype = "VARCHAR",
    length = 64
  },
  transactionProcessingTime = {
    datatype = "INT",
    notnull = true,
    default = 0
  },
  haveInterest = {
    datatype = "INT",
    notnull = true,
    default = 0
  },
  interest = {
    datatype = "INT",
    notnull = true,
    default = 0
  },
  overdraft = {
    datatype = "INT",
    notnull = true,
    default = 0
  },
  canReceiveDirectPayments = {
    datatype = "INT",
    notnull = true,
    default = 1
  }
}

-- TABLE bank_transactions
SQL_STRUCTURE["bank_transactions"] = {
  id = {
    primarykey = true,
    datatype = "INT",
    notnull = true,
    autoincrement = true
  },
  from = {
    datatype = "INT",
    notnull = true
  },
  to = {
    datatype = "INT",
    notnull = true
  },
  amount = {
    datatype = "BIGINT",
    notnull = true
  },
  reason = {
    datatype = "VARCHAR",
    length = 256
  },
  creationTime = {
    datatype = "INT",
    notnull = true
  },
  processingTime = {
    datatype = "INT",
    notnull = true
  },
  state = {
    datatype = "INT",
    default = 0
  }
}
