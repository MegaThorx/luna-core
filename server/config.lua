-- EXTENDING CONFIG

_CONFIG["password"] = "" -- Empty strings means no password
_CONFIG["db.type"] = "mysql" -- mysql is recommended
_CONFIG["db.username"] = "luna_reallife"
_CONFIG["db.password"] = "Ay94PEZrdExJG8zu"
_CONFIG["db.host"] = "127.0.0.1"
_CONFIG["db.port"] = "3306"
_CONFIG["db.autoreconnect"] = true
_CONFIG["db.dbname"] = "luna_reallife"
_CONFIG["db.charset"] = "utf8"
_CONFIG["bank.cacheRefreshTime"] = 15 * 60 * 1000-- Time after it refreshes the bank types in ms
_CONFIG["bank.transactionFeed"] = 30
_CONFIG["bank.transactionProcesserCheckTime"] = 60 * 1000
_CONFIG["bank.initialBalance"] = 2500
_CONFIG["payday.premium.10"] = 5000
_CONFIG["payday.premium.100"] = 10000
_CONFIG["payday.premium.1000"] = 25000
_CONFIG["payday.interest.max"] = 20000
_CONFIG["teamspeak.query.username"] = "serveradmin"
_CONFIG["teamspeak.query.password"] = "xxxxxxxxx"
_CONFIG["teamspeak.query.port"] = 10011
_CONFIG["teamspeak.api"] = "http://game.megathorx.at/ts_connect.php"
_CONFIG["teamspeak.token"] = "anotherKey" --"AssdkLJXVLisadkm,jNM;Asd"

-- TODO move to shared config
_CONFIG["teamspeak.ip"] = 10011
_CONFIG["teamspeak.port"] = 9987
