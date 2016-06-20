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
