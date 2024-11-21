###########################################
###                                     ###
### Author: Jone Jabari                 ###
### Date: November 15th 2024            ###
### Version: 1.0                        ###
###                                     ###
###########################################

--/*
-- * --- General Rules ----
-- * Use underscore_names instead of CamelCase
-- * Table names should be plural
-- * Spell out id fields (item_id instead of id)
-- * Don't use ambiguous column names
-- * Name foreign key columns the same as the columns they refer
-- * Use caps for all SQL queries
-- */

 CREATE SCHEMA IF NOT EXISTS secureapi;

 SET NAMES 'UTF8MB4';
 SET TIME_ZONE = '+02:00';

 USE secureapi;

###########################################
###                                     ###
### Author: Jone Jabari                 ###
### Date: November 15th 2024            ###
### Version: 1.1                        ###
###                                     ###
###########################################

--/*
-- * --- General Rules ----
-- * Use underscore_names instead of CamelCase
-- * Table names should be plural
-- * Spell out id fields (item_id instead of id)
-- * Don't use ambiguous column names
-- * Name foreign key columns the same as the columns they refer
-- * Use caps for all SQL queries
-- */

CREATE SCHEMA IF NOT EXISTS secureapi;

SET NAMES 'UTF8MB4';
SET TIME_ZONE = '+02:00';

USE secureapi;

DROP TABLE IF EXISTS users;

CREATE TABLE users
(
    user_id       BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(50) NOT NULL,
    last_name     VARCHAR(50) NOT NULL,
    email         VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,  -- Changed from password for clarity
    address       VARCHAR(255) DEFAULT NULL,
    phone         VARCHAR(30) DEFAULT NULL,
    title         VARCHAR(50) DEFAULT NULL,
    bio           TEXT DEFAULT NULL,      -- Changed from VARCHAR for longer text
    enabled       BOOLEAN DEFAULT FALSE,
    non_locked    BOOLEAN DEFAULT TRUE,
    using_mfa     BOOLEAN DEFAULT FALSE,
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    image_url     VARCHAR(255) DEFAULT 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
    CONSTRAINT UQ_users_email UNIQUE (email)
);

DROP TABLE IF EXISTS roles;

CREATE TABLE roles
(
    role_id    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(50) NOT NULL,
    permission VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT UQ_roles_name UNIQUE (name)
);

DROP TABLE IF EXISTS user_roles;

CREATE TABLE user_roles
(
    user_role_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id      BIGINT UNSIGNED NOT NULL,
    role_id      BIGINT UNSIGNED NOT NULL,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles (role_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT UQ_user_roles_user_role UNIQUE (user_id, role_id)  -- Allow multiple roles per user
);

DROP TABLE IF EXISTS event_types;

CREATE TABLE event_types
(
    event_type_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(50) NOT NULL,
    description   VARCHAR(255) NOT NULL,
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT UQ_event_types_name UNIQUE (name)
);

DROP TABLE IF EXISTS user_events;

CREATE TABLE user_events
(
    user_event_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id       BIGINT UNSIGNED NOT NULL,
    event_type_id BIGINT UNSIGNED NOT NULL,
    device        VARCHAR(100) DEFAULT NULL,
    ip_address    VARCHAR(45) DEFAULT NULL,  -- Changed to 45 to accommodate IPv6
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (event_type_id) REFERENCES event_types (event_type_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

DROP TABLE IF EXISTS account_verifications;

CREATE TABLE account_verifications
(
    verification_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id        BIGINT UNSIGNED NOT NULL,
    token          VARCHAR(255) NOT NULL,    -- Changed from URL to token
    expiration_date DATETIME NOT NULL,       -- Added expiration
    created_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT UQ_account_verifications_user_id UNIQUE (user_id),
    CONSTRAINT UQ_account_verifications_token UNIQUE (token)
);

DROP TABLE IF EXISTS password_reset_tokens;

CREATE TABLE password_reset_tokens
(
    reset_token_id   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id          BIGINT UNSIGNED NOT NULL,
    token            VARCHAR(255) NOT NULL,    -- Changed from URL to token
    expiration_date  DATETIME NOT NULL,
    created_at       DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT UQ_password_reset_tokens_token UNIQUE (token)
);

DROP TABLE IF EXISTS mfa_tokens;

CREATE TABLE mfa_tokens
(
    mfa_token_id    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT UNSIGNED NOT NULL,
    code            VARCHAR(10) NOT NULL,
    expiration_date DATETIME NOT NULL,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT UQ_mfa_tokens_code UNIQUE (code)
);

-- Insert default event types
INSERT INTO event_types (name, description) VALUES
('LOGIN_ATTEMPT', 'User attempted to log in'),
('LOGIN_FAILURE', 'User login failed'),
('LOGIN_SUCCESS', 'User successfully logged in'),
('PROFILE_UPDATE', 'User profile was updated'),
('PROFILE_PICTURE_UPDATE', 'User profile picture was updated'),
('ROLE_UPDATE', 'User roles were modified'),
('ACCOUNT_SETTINGS_UPDATE', 'Account settings were modified'),
('PASSWORD_UPDATE', 'Password was changed'),
('MFA_UPDATE', 'Multi-factor authentication settings were modified');


-- DROP TABLE IF EXISTS Users;
--
-- CREATE TABLE Users
-- (
--    id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
--    first_name    VARCHAR(50) NOT NULL,
--    last_name     VARCHAR(50) NOT NULL,
--    email         VARCHAR(100) NOT NULL,
--    password      VARCHAR(255) DEFAULT NULL,
--    address       VARCHAR(255) DEFAULT NULL,
--    phone         VARCHAR(30) DEFAULT NULL,
--    title         VARCHAR(50) DEFAULT NULL,
--    bio           VARCHAR(255) DEFAULT NULL,
--    enabled       BOOLEAN DEFAULT FALSE,
--    non_locked    BOOLEAN DEFAULT TRUE,
--    using_mfa     BOOLEAN DEFAULT FALSE,
--    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
--    image_url     VARCHAR(255) DEFAULT 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
--    CONSTRAINT UQ_Users_Email UNIQUE (email)
-- );
--
--
-- DROP TABLE IF EXISTS Roles;
--
--  CREATE TABLE Roles
--  (
--     id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
--     name       VARCHAR(50) NOT NULL,
--     permission VARCHAR(255) NOT NULL,
--     CONSTRAINT UQ_Roles_Name UNIQUE (name)
--  );
--
--
-- DROP TABLE IF EXISTS UserRoles;
--
-- CREATE TABLE UserRoles
-- (
--    id        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
--    user_id   BIGINT UNSIGNED NOT NULL,
--    role_id   BIGINT UNSIGNED NOT NULL,
--    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
--    FOREIGN KEY (role_id) REFERENCES Roles (id) ON DELETE RESTRICT ON UPDATE CASCADE,
--    CONSTRAINT UQ_UserRoles_User_Id UNIQUE (user_id)
-- );
--
-- DROP TABLE IF EXISTS Events;
--
--  CREATE TABLE Events
--  (
--     id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
--     type        VARCHAR(50) NOT NULL CHECK(type IN ('LOGIN_ATTEMPT', 'LOGIN_FAILURE', 'LOGIN_SUCCESS', 'PROFILE_UPDATE', 'PROFILE_PICTURE_UPDATE', 'ROLE_UPDATE', 'ACCOUNT_SETTINGS_UPDATE', 'PASSWORD_UPDATE', 'MFA_UPDATE')),
--     description VARCHAR(255) NOT NULL,
--     CONSTRAINT UQ_Events_Type UNIQUE (type)
--  );
--
--    DROP TABLE IF EXISTS UserEvents;
--
--      CREATE TABLE UserEvents
--      (
--         id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
--         user_id    BIGINT UNSIGNED NOT NULL,
--         event_id   BIGINT UNSIGNED NOT NULL,
--         device     VARCHAR(100) DEFAULT NULL,
--         ip_address VARCHAR(100) DEFAULT NULL,
--         created_at DATETIME CURRENT_TIMESTAMP,
--         FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
--         FOREIGN KEY (event_id) REFERENCES Events (id) ON DELETE RESTRICT ON UPDATE CASCADE
--      );
--
--    DROP TABLE IF EXISTS AccountVerifications;
--
--     CREATE TABLE AccountVerifications
--     (
--        id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
--        user_id    BIGINT UNSIGNED NOT NULL,
--        url        VARCHAR(255) DEFAULT NULL,
--        -- date       DATETIME NOT NULL,
--        FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
--        CONSTRAINT UQ_AccountVerifications_User_Id UNIQUE (user_id),
--        CONSTRAINT UQ_AccountVerifications_Url UNIQUE (url)
--     );
--
--   DROP TABLE IF EXISTS ResetPasswordVerifications;
--
--       CREATE TABLE ResetPasswordVerifications
--       (
--          id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
--          user_id         BIGINT UNSIGNED NOT NULL,
--          url             VARCHAR(255) DEFAULT NULL,
--          expiration_date DATETIME NOT NULL,
--          FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
--          CONSTRAINT UQ_ResetPasswordVerifications_User_Id UNIQUE (user_id),
--          CONSTRAINT UQ_ResetPasswordVerifications_Url UNIQUE (url)
--       );
--
--   DROP TABLE IF EXISTS TwoFactorVerifications;
--
--         CREATE TABLE TwoFactorVerifications
--         (
--            id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
--            user_id         BIGINT UNSIGNED NOT NULL,
--            code            VARCHAR(10) DEFAULT NULL,
--            expiration_date DATETIME NOT NULL,
--            FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
--            CONSTRAINT UQ_TwoFactorVerifications_User_Id UNIQUE (user_id),
--            CONSTRAINT UQ_TwoFactorVerifications_Code UNIQUE (code)
--         );













