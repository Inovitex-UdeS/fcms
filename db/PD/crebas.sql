/*==============================================================*/
/* DBMS name:      PostgreSQL 8                                 */
/* Created on:     2013-05-28 12:19:54 AM                       */
/*==============================================================*/


drop index EDITION_ID_FK;

drop index CATEGORY_ID_FK;

drop index AGEGROUPS_PK;

drop table AGEGROUPS;

drop index CATEGORIES_PK;

drop table CATEGORIES;

drop index CITIES_PK;

drop table CITIES;

drop index COMPOSERS_PK;

drop table COMPOSERS;

drop index CONFIGS_PK;

drop table CONFIGS;

drop index CITY_ID_FK;

drop index CONTACTINFOS_PK;

drop table CONTACTINFOS;

drop index CONTESTS_PK;

drop table CONTESTS;

drop index EDITIONS_PK;

drop table EDITIONS;

drop index EVALUATIONS_PK;

drop table EVALUATIONS;

drop index INSTRUMENTS_PK;

drop table INSTRUMENTS;

drop index USER_ID_FK;

drop index REGISTRATION_ID_FK2;

drop index PAYMENTS_PK;

drop table PAYMENTS;

drop index REGISTRATION_ID_FK;

drop index PIECE_ID_FK;

drop index PERFORMANCES_PK;

drop table PERFORMANCES;

drop index COMPOSER_ID_FK;

drop index PIECES_PK;

drop table PIECES;

drop index USER_OWNER_ID_FK;

drop index EDITION_ID_FK2;

drop index CATEGORY_ID_FK2;

drop index SCHOOL_ID_FK;

drop index USER_TEACHER_ID_FK;

drop index REGISTRATION_ID_FK3;

drop index REGISTRATIONS_PK;

drop table REGISTRATIONS;

drop index USER_ID_FK3;

drop index REGISTRATION_ID_FK4;

drop index INSTRUMENT_ID_FK;

drop index REGISTRATIONS_USERS_PK;

drop table REGISTRATIONS_USERS;

drop index ROLES_PK;

drop table ROLES;

drop index USER_ID_FK2;

drop index ROLE_ID_FK;

drop index ROLES_USERS_PK;

drop table ROLES_USERS;

drop index ROOMS_PK;

drop table ROOMS;

drop index SCHOOLBOARDS_PK;

drop table SCHOOLBOARDS;

drop index CONTACTINFO_ID_FK2;

drop index SCHOOLTYPE_ID_FK;

drop index SCHOOLBOARD_ID_FK;

drop index SCHOOLS_PK;

drop table SCHOOLS;

drop index SCHOOLTYPES_PK;

drop table SCHOOLTYPES;

drop index CONTACTINFO_ID_FK;

drop index USERS_PK;

drop table USERS;

/*==============================================================*/
/* Table: AGEGROUPS                                             */
/*==============================================================*/
create table AGEGROUPS (
   ID                   SERIAL               not null,
   EDITION_ID           INT4                 not null,
   CATEGORY_ID          INT4                 not null,
   MIN                  DATE                 null,
   MAX                  DATE                 null,
   DESCRIPTION          VARCHAR(128)         null,
   FEE                  INT4                 null,
   MAX_DURATION         INT4                 null,
   constraint PK_AGEGROUPS primary key (ID)
);

/*==============================================================*/
/* Index: AGEGROUPS_PK                                          */
/*==============================================================*/
create unique index AGEGROUPS_PK on AGEGROUPS (
ID
);

/*==============================================================*/
/* Index: CATEGORY_ID_FK                                        */
/*==============================================================*/
create  index CATEGORY_ID_FK on AGEGROUPS (
CATEGORY_ID
);

/*==============================================================*/
/* Index: EDITION_ID_FK                                         */
/*==============================================================*/
create  index EDITION_ID_FK on AGEGROUPS (
EDITION_ID
);

/*==============================================================*/
/* Table: CATEGORIES                                            */
/*==============================================================*/
create table CATEGORIES (
   ID                   SERIAL               not null,
   NAME                 VARCHAR(256)         not null,
   NB_PERF_MIN          INT4                 not null,
   NB_PERF_MAX          INT4                 null,
   DESCRIPTION          TEXT                 null,
   constraint PK_CATEGORIES primary key (ID),
   constraint AK_NAME_CATEGORI unique (NAME)
);

/*==============================================================*/
/* Index: CATEGORIES_PK                                         */
/*==============================================================*/
create unique index CATEGORIES_PK on CATEGORIES (
ID
);

/*==============================================================*/
/* Table: CITIES                                                */
/*==============================================================*/
create table CITIES (
   ID                   SERIAL               not null,
   NAME                 VARCHAR(64)          not null,
   constraint PK_CITIES primary key (ID),
   constraint AK_NAME_CITIES unique (NAME)
);

/*==============================================================*/
/* Index: CITIES_PK                                             */
/*==============================================================*/
create unique index CITIES_PK on CITIES (
ID
);

/*==============================================================*/
/* Table: COMPOSERS                                             */
/*==============================================================*/
create table COMPOSERS (
   ID                   SERIAL               not null,
   NAME                 VARCHAR(256)         not null,
   constraint PK_COMPOSERS primary key (ID),
   constraint AK_NAME_COMPOSER unique (NAME)
);

/*==============================================================*/
/* Index: COMPOSERS_PK                                          */
/*==============================================================*/
create unique index COMPOSERS_PK on COMPOSERS (
ID
);

/*==============================================================*/
/* Table: CONFIGS                                               */
/*==============================================================*/
create table CONFIGS (
   KEY                  VARCHAR(64)          not null,
   VALUE                VARCHAR(1024)        null,
   constraint PK_CONFIGS primary key (KEY)
);

/*==============================================================*/
/* Index: CONFIGS_PK                                            */
/*==============================================================*/
create unique index CONFIGS_PK on CONFIGS (
KEY
);

/*==============================================================*/
/* Table: CONTACTINFOS                                          */
/*==============================================================*/
create table CONTACTINFOS (
   ID                   SERIAL               not null,
   CITY_ID              INT4                 not null,
   TELEPHONE            VARCHAR(16)          null,
   ADDRESS              VARCHAR(256)         null,
   ADDRESS2             VARCHAR(256)         null,
   POSTAL_CODE          CHAR(6)              null,
   PROVINCE             VARCHAR(256)         null,
   constraint PK_CONTACTINFOS primary key (ID)
);

/*==============================================================*/
/* Index: CONTACTINFOS_PK                                       */
/*==============================================================*/
create unique index CONTACTINFOS_PK on CONTACTINFOS (
ID
);

/*==============================================================*/
/* Index: CITY_ID_FK                                            */
/*==============================================================*/
create  index CITY_ID_FK on CONTACTINFOS (
CITY_ID
);

/*==============================================================*/
/* Table: CONTESTS                                              */
/*==============================================================*/
create table CONTESTS (
   ID                   SERIAL               not null,
   constraint PK_CONTESTS primary key (ID)
);

/*==============================================================*/
/* Index: CONTESTS_PK                                           */
/*==============================================================*/
create unique index CONTESTS_PK on CONTESTS (
ID
);

/*==============================================================*/
/* Table: EDITIONS                                              */
/*==============================================================*/
create table EDITIONS (
   YEAR                 INT4                 not null,
   LIMIT_DATE           DATE                 null,
   ID                   SERIAL               not null,
   constraint PK_EDITIONS primary key (ID),
   constraint AK_YEAR_EDITIONS unique (YEAR)
);

/*==============================================================*/
/* Index: EDITIONS_PK                                           */
/*==============================================================*/
create unique index EDITIONS_PK on EDITIONS (
ID
);

/*==============================================================*/
/* Table: EVALUATIONS                                           */
/*==============================================================*/
create table EVALUATIONS (
   ID                   INT4                 not null,
   constraint PK_EVALUATIONS primary key (ID)
);

/*==============================================================*/
/* Index: EVALUATIONS_PK                                        */
/*==============================================================*/
create unique index EVALUATIONS_PK on EVALUATIONS (
ID
);

/*==============================================================*/
/* Table: INSTRUMENTS                                           */
/*==============================================================*/
create table INSTRUMENTS (
   ID                   SERIAL               not null,
   NAME                 VARCHAR(64)          not null,
   constraint PK_INSTRUMENTS primary key (ID),
   constraint AK_NAME_INSTRUME unique (NAME)
);

/*==============================================================*/
/* Index: INSTRUMENTS_PK                                        */
/*==============================================================*/
create unique index INSTRUMENTS_PK on INSTRUMENTS (
ID
);

/*==============================================================*/
/* Table: PAYMENTS                                              */
/*==============================================================*/
create table PAYMENTS (
   ID                   SERIAL               not null,
   USER_ID              INT4                 not null,
   REGISTRATION_ID      INT4                 not null,
   MODE                 VARCHAR(64)          null,
   NO_CHQ               INT4                 null,
   NAME_CHQ             VARCHAR(1024)        null,
   DATE_CHQ             DATE                 null,
   DEPOT_DATE           DATE                 null,
   INVOICE              VARCHAR(64)          null,
   CASH                 MONEY                null,
   constraint PK_PAYMENTS primary key (ID)
);

/*==============================================================*/
/* Index: PAYMENTS_PK                                           */
/*==============================================================*/
create unique index PAYMENTS_PK on PAYMENTS (
ID
);

/*==============================================================*/
/* Index: REGISTRATION_ID_FK2                                   */
/*==============================================================*/
create  index REGISTRATION_ID_FK2 on PAYMENTS (
REGISTRATION_ID
);

/*==============================================================*/
/* Index: USER_ID_FK                                            */
/*==============================================================*/
create  index USER_ID_FK on PAYMENTS (
USER_ID
);

/*==============================================================*/
/* Table: PERFORMANCES                                          */
/*==============================================================*/
create table PERFORMANCES (
   ID                   SERIAL               not null,
   PIECE_ID             INT4                 not null,
   REGISTRATION_ID      INT4                 null,
   constraint PK_PERFORMANCES primary key (ID)
);

/*==============================================================*/
/* Index: PERFORMANCES_PK                                       */
/*==============================================================*/
create unique index PERFORMANCES_PK on PERFORMANCES (
ID
);

/*==============================================================*/
/* Index: PIECE_ID_FK                                           */
/*==============================================================*/
create  index PIECE_ID_FK on PERFORMANCES (
PIECE_ID
);

/*==============================================================*/
/* Index: REGISTRATION_ID_FK                                    */
/*==============================================================*/
create  index REGISTRATION_ID_FK on PERFORMANCES (
REGISTRATION_ID
);

/*==============================================================*/
/* Table: PIECES                                                */
/*==============================================================*/
create table PIECES (
   ID                   SERIAL               not null,
   COMPOSER_ID          INT4                 not null,
   TITLE                VARCHAR(256)         not null,
   constraint PK_PIECES primary key (ID),
   constraint AK_TITLE_PIECES unique (TITLE)
);

/*==============================================================*/
/* Index: PIECES_PK                                             */
/*==============================================================*/
create unique index PIECES_PK on PIECES (
ID
);

/*==============================================================*/
/* Index: COMPOSER_ID_FK                                        */
/*==============================================================*/
create  index COMPOSER_ID_FK on PIECES (
COMPOSER_ID
);

/*==============================================================*/
/* Table: REGISTRATIONS                                         */
/*==============================================================*/
create table REGISTRATIONS (
   ID                   SERIAL               not null,
   USER_OWNER_ID        INT4                 not null,
   SCHOOL_ID            INT4                 null,
   REGISTRATION_ID      INT4                 null,
   USER_TEACHER_ID      INT4                 not null,
   EDITION_ID           INT4                 not null,
   CATEGORY_ID          INT4                 not null,
   DURATION             INT4                 not null,
   constraint PK_REGISTRATIONS primary key (ID)
);

/*==============================================================*/
/* Index: REGISTRATIONS_PK                                      */
/*==============================================================*/
create unique index REGISTRATIONS_PK on REGISTRATIONS (
ID
);

/*==============================================================*/
/* Index: REGISTRATION_ID_FK3                                   */
/*==============================================================*/
create  index REGISTRATION_ID_FK3 on REGISTRATIONS (
REGISTRATION_ID
);

/*==============================================================*/
/* Index: USER_TEACHER_ID_FK                                    */
/*==============================================================*/
create  index USER_TEACHER_ID_FK on REGISTRATIONS (
USER_TEACHER_ID
);

/*==============================================================*/
/* Index: SCHOOL_ID_FK                                          */
/*==============================================================*/
create  index SCHOOL_ID_FK on REGISTRATIONS (
SCHOOL_ID
);

/*==============================================================*/
/* Index: CATEGORY_ID_FK2                                       */
/*==============================================================*/
create  index CATEGORY_ID_FK2 on REGISTRATIONS (
CATEGORY_ID
);

/*==============================================================*/
/* Index: EDITION_ID_FK2                                        */
/*==============================================================*/
create  index EDITION_ID_FK2 on REGISTRATIONS (
EDITION_ID
);

/*==============================================================*/
/* Index: USER_OWNER_ID_FK                                      */
/*==============================================================*/
create  index USER_OWNER_ID_FK on REGISTRATIONS (
USER_OWNER_ID
);

/*==============================================================*/
/* Table: REGISTRATIONS_USERS                                   */
/*==============================================================*/
create table REGISTRATIONS_USERS (
   INSTRUMENT_ID        INT4                 not null,
   REGISTRATION_ID      INT4                 not null,
   USER_ID              INT4                 not null,
   constraint PK_REGISTRATIONS_USERS primary key (INSTRUMENT_ID, REGISTRATION_ID, USER_ID)
);

/*==============================================================*/
/* Index: REGISTRATIONS_USERS_PK                                */
/*==============================================================*/
create unique index REGISTRATIONS_USERS_PK on REGISTRATIONS_USERS (
INSTRUMENT_ID,
REGISTRATION_ID,
USER_ID
);

/*==============================================================*/
/* Index: INSTRUMENT_ID_FK                                      */
/*==============================================================*/
create  index INSTRUMENT_ID_FK on REGISTRATIONS_USERS (
INSTRUMENT_ID
);

/*==============================================================*/
/* Index: REGISTRATION_ID_FK4                                   */
/*==============================================================*/
create  index REGISTRATION_ID_FK4 on REGISTRATIONS_USERS (
REGISTRATION_ID
);

/*==============================================================*/
/* Index: USER_ID_FK3                                           */
/*==============================================================*/
create  index USER_ID_FK3 on REGISTRATIONS_USERS (
USER_ID
);

/*==============================================================*/
/* Table: ROLES                                                 */
/*==============================================================*/
create table ROLES (
   ID                   SERIAL               not null,
   NAME                 VARCHAR(256)         not null,
   constraint PK_ROLES primary key (ID),
   constraint AK_NAME_ROLES unique (NAME)
);

/*==============================================================*/
/* Index: ROLES_PK                                              */
/*==============================================================*/
create unique index ROLES_PK on ROLES (
ID
);

/*==============================================================*/
/* Table: ROLES_USERS                                           */
/*==============================================================*/
create table ROLES_USERS (
   ROLE_ID              INT4                 not null,
   USER_ID              INT4                 not null,
   constraint PK_ROLES_USERS primary key (ROLE_ID, USER_ID)
);

/*==============================================================*/
/* Index: ROLES_USERS_PK                                        */
/*==============================================================*/
create unique index ROLES_USERS_PK on ROLES_USERS (
ROLE_ID,
USER_ID
);

/*==============================================================*/
/* Index: ROLE_ID_FK                                            */
/*==============================================================*/
create  index ROLE_ID_FK on ROLES_USERS (
ROLE_ID
);

/*==============================================================*/
/* Index: USER_ID_FK2                                           */
/*==============================================================*/
create  index USER_ID_FK2 on ROLES_USERS (
USER_ID
);

/*==============================================================*/
/* Table: ROOMS                                                 */
/*==============================================================*/
create table ROOMS (
   ID                   SERIAL               not null,
   CAPACITY             INT4                 null,
   NAME                 VARCHAR(255)         null,
   LOCATION             VARCHAR(1024)        null,
   DESCRIPTION          TEXT                 null,
   constraint PK_ROOMS primary key (ID)
);

/*==============================================================*/
/* Index: ROOMS_PK                                              */
/*==============================================================*/
create unique index ROOMS_PK on ROOMS (
ID
);

/*==============================================================*/
/* Table: SCHOOLBOARDS                                          */
/*==============================================================*/
create table SCHOOLBOARDS (
   ID                   SERIAL               not null,
   NAME                 VARCHAR(128)         not null,
   constraint PK_SCHOOLBOARDS primary key (ID),
   constraint AK_NAME_SCHOOLBO unique (NAME)
);

/*==============================================================*/
/* Index: SCHOOLBOARDS_PK                                       */
/*==============================================================*/
create unique index SCHOOLBOARDS_PK on SCHOOLBOARDS (
ID
);

/*==============================================================*/
/* Table: SCHOOLS                                               */
/*==============================================================*/
create table SCHOOLS (
   ID                   SERIAL               not null,
   CONTACTINFO_ID       INT4                 null,
   SCHOOLTYPE_ID        INT4                 not null,
   SCHOOLBOARD_ID       INT4                 not null,
   NAME                 VARCHAR(256)         not null,
   constraint PK_SCHOOLS primary key (ID),
   constraint AK_NAME_SCHOOLS unique (NAME)
);

/*==============================================================*/
/* Index: SCHOOLS_PK                                            */
/*==============================================================*/
create unique index SCHOOLS_PK on SCHOOLS (
ID
);

/*==============================================================*/
/* Index: SCHOOLBOARD_ID_FK                                     */
/*==============================================================*/
create  index SCHOOLBOARD_ID_FK on SCHOOLS (
SCHOOLBOARD_ID
);

/*==============================================================*/
/* Index: SCHOOLTYPE_ID_FK                                      */
/*==============================================================*/
create  index SCHOOLTYPE_ID_FK on SCHOOLS (
SCHOOLTYPE_ID
);

/*==============================================================*/
/* Index: CONTACTINFO_ID_FK2                                    */
/*==============================================================*/
create  index CONTACTINFO_ID_FK2 on SCHOOLS (
CONTACTINFO_ID
);

/*==============================================================*/
/* Table: SCHOOLTYPES                                           */
/*==============================================================*/
create table SCHOOLTYPES (
   ID                   SERIAL               not null,
   NAME                 VARCHAR(128)         not null,
   constraint PK_SCHOOLTYPES primary key (ID),
   constraint AK_NAME_SCHOOLTY unique (NAME)
);

/*==============================================================*/
/* Index: SCHOOLTYPES_PK                                        */
/*==============================================================*/
create unique index SCHOOLTYPES_PK on SCHOOLTYPES (
ID
);

/*==============================================================*/
/* Table: USERS                                                 */
/*==============================================================*/
create table USERS (
   ID                   SERIAL               not null,
   CONTACTINFO_ID       INT4                 null,
   LAST_NAME            VARCHAR(64)          not null,
   FIRST_NAME           VARCHAR(64)          not null,
   GENDER               BOOL                 null,
   BIRTHDAY             DATE                 not null,
   constraint PK_USERS primary key (ID)
);

/*==============================================================*/
/* Index: USERS_PK                                              */
/*==============================================================*/
create unique index USERS_PK on USERS (
ID
);

/*==============================================================*/
/* Index: CONTACTINFO_ID_FK                                     */
/*==============================================================*/
create  index CONTACTINFO_ID_FK on USERS (
CONTACTINFO_ID
);

alter table AGEGROUPS
   add constraint FK_AGEGROUP_CATEGORY__CATEGORI foreign key (CATEGORY_ID)
      references CATEGORIES (ID)
      on delete restrict on update restrict;

alter table AGEGROUPS
   add constraint FK_AGEGROUP_EDITION_I_EDITIONS foreign key (EDITION_ID)
      references EDITIONS (ID)
      on delete restrict on update restrict;

alter table CONTACTINFOS
   add constraint FK_CONTACTI_CITY_ID_CITIES foreign key (CITY_ID)
      references CITIES (ID)
      on delete restrict on update restrict;

alter table PAYMENTS
   add constraint FK_PAYMENTS_REGISTRAT_REGISTRA foreign key (REGISTRATION_ID)
      references REGISTRATIONS (ID)
      on delete restrict on update restrict;

alter table PAYMENTS
   add constraint FK_PAYMENTS_USER_ID_USERS foreign key (USER_ID)
      references USERS (ID)
      on delete restrict on update restrict;

alter table PERFORMANCES
   add constraint FK_PERFORMA_PIECE_ID_PIECES foreign key (PIECE_ID)
      references PIECES (ID)
      on delete restrict on update restrict;

alter table PERFORMANCES
   add constraint FK_PERFORMA_REGISTRAT_REGISTRA foreign key (REGISTRATION_ID)
      references REGISTRATIONS (ID)
      on delete restrict on update restrict;

alter table PIECES
   add constraint FK_PIECES_COMPOSER__COMPOSER foreign key (COMPOSER_ID)
      references COMPOSERS (ID)
      on delete restrict on update restrict;

alter table REGISTRATIONS
   add constraint FK_REGISTRA_CATEGORY__CATEGORI foreign key (CATEGORY_ID)
      references CATEGORIES (ID)
      on delete restrict on update restrict;

alter table REGISTRATIONS
   add constraint FK_REGISTRA_EDITION_I_EDITIONS foreign key (EDITION_ID)
      references EDITIONS (ID)
      on delete restrict on update restrict;

alter table REGISTRATIONS
   add constraint FK_REGISTRA_REGISTRAT_PAYMENTS foreign key (REGISTRATION_ID)
      references PAYMENTS (ID)
      on delete restrict on update restrict;

alter table REGISTRATIONS
   add constraint FK_REGISTRA_SCHOOL_ID_SCHOOLS foreign key (SCHOOL_ID)
      references SCHOOLS (ID)
      on delete restrict on update restrict;

alter table REGISTRATIONS
   add constraint FK_REGISTRA_USER_OWNE_USERS foreign key (USER_OWNER_ID)
      references USERS (ID)
      on delete restrict on update restrict;

alter table REGISTRATIONS
   add constraint FK_REGISTRA_USER_TEAC_USERS foreign key (USER_TEACHER_ID)
      references USERS (ID)
      on delete restrict on update restrict;

alter table REGISTRATIONS_USERS
   add constraint FK_REGISTRA_INSTRUMEN_INSTRUME foreign key (INSTRUMENT_ID)
      references INSTRUMENTS (ID)
      on delete restrict on update restrict;

alter table REGISTRATIONS_USERS
   add constraint FK_REGISTRA_REGISTRAT_REGISTRA foreign key (REGISTRATION_ID)
      references REGISTRATIONS (ID)
      on delete restrict on update restrict;

alter table REGISTRATIONS_USERS
   add constraint FK_REGISTRA_USER_ID_USERS foreign key (USER_ID)
      references USERS (ID)
      on delete restrict on update restrict;

alter table ROLES_USERS
   add constraint FK_ROLES_US_ROLE_ID_ROLES foreign key (ROLE_ID)
      references ROLES (ID)
      on delete restrict on update restrict;

alter table ROLES_USERS
   add constraint FK_ROLES_US_USER_ID_USERS foreign key (USER_ID)
      references USERS (ID)
      on delete restrict on update restrict;

alter table SCHOOLS
   add constraint FK_SCHOOLS_CONTACTIN_CONTACTI foreign key (CONTACTINFO_ID)
      references CONTACTINFOS (ID)
      on delete restrict on update restrict;

alter table SCHOOLS
   add constraint FK_SCHOOLS_SCHOOLBOA_SCHOOLBO foreign key (SCHOOLBOARD_ID)
      references SCHOOLBOARDS (ID)
      on delete restrict on update restrict;

alter table SCHOOLS
   add constraint FK_SCHOOLS_SCHOOLTYP_SCHOOLTY foreign key (SCHOOLTYPE_ID)
      references SCHOOLTYPES (ID)
      on delete restrict on update restrict;

alter table USERS
   add constraint FK_USERS_CONTACTIN_CONTACTI foreign key (CONTACTINFO_ID)
      references CONTACTINFOS (ID)
      on delete restrict on update restrict;

