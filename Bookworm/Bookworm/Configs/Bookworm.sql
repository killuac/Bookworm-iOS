CREATE TABLE IF NOT EXISTS KeyValue (key TEXT PRIMARY KEY, value TEXT);

CREATE TABLE IF NOT EXISTS Contact (guid INTEGER PRIMARY KEY AUTOINCREMENT, userID TEXT NOT NULL, contactID TEXT NOT NULL, bgImageName TEXT);
CREATE INDEX idx_contact_user_id ON Contact (userID);

CREATE TABLE IF NOT EXISTS Inbox (guid INTEGER PRIMARY KEY AUTOINCREMENT, messageID INTEGER, sender TEXT NOT NULL, receiver TEXT NOT NULL, content TEXT NOT NULL, timestamp INTEGER NOT NULL, isRead BOOLEAN DEFAULT 0);
CREATE INDEX idx_inbox_receiver_sender ON Inbox (receiver, sender);
CREATE INDEX idx_inbox_timestamp ON Inbox (timestamp);

CREATE TABLE IF NOT EXISTS Outbox (guid INTEGER PRIMARY KEY AUTOINCREMENT, messageID INTEGER, sender TEXT NOT NULL, receiver TEXT NOT NULL, content TEXT NOT NULL, timestamp INTEGER NOT NULL, isSent BOOLEAN DEFAULT 0);
CREATE INDEX idx_outbox_sender_receiver ON Outbox (sender, receiver);
CREATE INDEX idx_outbox_timestamp ON Outbox (timestamp);