/*MIGRATION_DESCRIPTION
--CREATE: notes-Note
New object Note will be created in schema notes
--CREATE: notes-Note-ID
New property ID will be created for Note in notes
--CREATE: notes-Note-urls
New property urls will be created for Note in notes
--CREATE: notes-Note-markup
New property markup will be created for Note in notes
--CREATE: notes-Note-tasks
New property tasks will be created for Note in notes
--CREATE: notes-Note-bucketID
New property bucketID will be created for Note in notes
--CREATE: notes-AddTask
New object AddTask will be created in schema notes
--CREATE: notes-AddTask-name
New property name will be created for AddTask in notes
--CREATE: notes-AddTask-noteID
New property noteID will be created for AddTask in notes
--CREATE: notes-Task
New object Task will be created in schema notes
--CREATE: notes-Task-name
New property name will be created for Task in notes
--CREATE: notes-Task-body
New property body will be created for Task in notes
--CREATE: notes-Task-status
New property status will be created for Task in notes
--CREATE: notes-Bucket
New object Bucket will be created in schema notes
--CREATE: notes-Bucket-ID
New property ID will be created for Bucket in notes
--CREATE: notes-Bucket-name
New property name will be created for Bucket in notes
--CREATE: notes-Status
New object Status will be created in schema notes
--CREATE: notes-Status-Pending
New enum label Pending will be added to enum object Status in schema notes
--CREATE: notes-Status-Finished
New enum label Finished will be added to enum object Status in schema notes
MIGRATION_DESCRIPTION*/

DO $$ BEGIN
    IF EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = '-NGS-' AND c.relname = 'database_setting') THEN
        IF EXISTS(SELECT * FROM "-NGS-".Database_Setting WHERE Key ILIKE 'mode' AND NOT Value ILIKE 'unsafe') THEN
            RAISE EXCEPTION 'Database upgrade is forbidden. Change database mode to allow upgrade';
        END IF;
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM pg_namespace WHERE nspname = 'notes') THEN
        CREATE SCHEMA "notes";
        COMMENT ON SCHEMA "notes" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'notes' AND t.typname = '-ngs_Note_type-') THEN
        CREATE TYPE "notes"."-ngs_Note_type-" AS ();
        COMMENT ON TYPE "notes"."-ngs_Note_type-" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'notes' AND c.relname = 'Note') THEN
        CREATE TABLE "notes"."Note" ();
        COMMENT ON TABLE "notes"."Note" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'notes' AND c.relname = 'Note_sequence') THEN
        CREATE SEQUENCE "notes"."Note_sequence";
        COMMENT ON SEQUENCE "notes"."Note_sequence" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'notes' AND c.relname = 'AddTask') THEN
        CREATE TABLE "notes"."AddTask"
        (
            _event_id BIGSERIAL PRIMARY KEY,
            _queued_at TIMESTAMPTZ NOT NULL DEFAULT(NOW()),
            _processed_at TIMESTAMPTZ
        );
        COMMENT ON TABLE "notes"."AddTask" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'notes' AND t.typname = '-ngs_Task_type-') THEN
        CREATE TYPE "notes"."-ngs_Task_type-" AS ();
        COMMENT ON TYPE "notes"."-ngs_Task_type-" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'notes' AND t.typname = 'Task') THEN
        CREATE TYPE "notes"."Task" AS ();
        COMMENT ON TYPE "notes"."Task" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'notes' AND t.typname = '-ngs_Bucket_type-') THEN
        CREATE TYPE "notes"."-ngs_Bucket_type-" AS ();
        COMMENT ON TYPE "notes"."-ngs_Bucket_type-" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'notes' AND c.relname = 'Bucket') THEN
        CREATE TABLE "notes"."Bucket" ();
        COMMENT ON TABLE "notes"."Bucket" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'notes' AND c.relname = 'Bucket_sequence') THEN
        CREATE SEQUENCE "notes"."Bucket_sequence";
        COMMENT ON SEQUENCE "notes"."Bucket_sequence" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'notes' AND t.typname = 'Status') THEN
        CREATE TYPE "notes"."Status" AS ENUM ('Pending', 'Finished');
        COMMENT ON TYPE "notes"."Status" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = '-ngs_Note_type-' AND column_name = 'ID') THEN
        ALTER TYPE "notes"."-ngs_Note_type-" ADD ATTRIBUTE "ID" INT;
        COMMENT ON COLUMN "notes"."-ngs_Note_type-"."ID" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = 'Note' AND column_name = 'ID') THEN
        ALTER TABLE "notes"."Note" ADD COLUMN "ID" INT;
        COMMENT ON COLUMN "notes"."Note"."ID" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = '-ngs_Note_type-' AND column_name = 'urls') THEN
        ALTER TYPE "notes"."-ngs_Note_type-" ADD ATTRIBUTE "urls" VARCHAR[];
        COMMENT ON COLUMN "notes"."-ngs_Note_type-"."urls" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = 'Note' AND column_name = 'urls') THEN
        ALTER TABLE "notes"."Note" ADD COLUMN "urls" VARCHAR[];
        COMMENT ON COLUMN "notes"."Note"."urls" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = '-ngs_Note_type-' AND column_name = 'markup') THEN
        ALTER TYPE "notes"."-ngs_Note_type-" ADD ATTRIBUTE "markup" VARCHAR;
        COMMENT ON COLUMN "notes"."-ngs_Note_type-"."markup" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = 'Note' AND column_name = 'markup') THEN
        ALTER TABLE "notes"."Note" ADD COLUMN "markup" VARCHAR;
        COMMENT ON COLUMN "notes"."Note"."markup" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = '-ngs_Note_type-' AND column_name = 'tasks') THEN
        ALTER TYPE "notes"."-ngs_Note_type-" ADD ATTRIBUTE "tasks" "notes"."-ngs_Task_type-"[];
        COMMENT ON COLUMN "notes"."-ngs_Note_type-"."tasks" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = 'Note' AND column_name = 'tasks') THEN
        ALTER TABLE "notes"."Note" ADD COLUMN "tasks" "notes"."Task"[];
        COMMENT ON COLUMN "notes"."Note"."tasks" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = '-ngs_Note_type-' AND column_name = 'bucketURI') THEN
        ALTER TYPE "notes"."-ngs_Note_type-" ADD ATTRIBUTE "bucketURI" TEXT;
        COMMENT ON COLUMN "notes"."-ngs_Note_type-"."bucketURI" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = '-ngs_Note_type-' AND column_name = 'bucketID') THEN
        ALTER TYPE "notes"."-ngs_Note_type-" ADD ATTRIBUTE "bucketID" INT;
        COMMENT ON COLUMN "notes"."-ngs_Note_type-"."bucketID" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = 'Note' AND column_name = 'bucketID') THEN
        ALTER TABLE "notes"."Note" ADD COLUMN "bucketID" INT;
        COMMENT ON COLUMN "notes"."Note"."bucketID" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$
BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = 'AddTask' AND column_name = 'name') THEN
        ALTER TABLE "notes"."AddTask" ADD COLUMN "name" VARCHAR;
    END IF;
END $$ LANGUAGE plpgsql;

DO $$
BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = 'AddTask' AND column_name = 'noteID') THEN
        ALTER TABLE "notes"."AddTask" ADD COLUMN "noteID" INT;
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = '-ngs_Task_type-' AND column_name = 'name') THEN
        ALTER TYPE "notes"."-ngs_Task_type-" ADD ATTRIBUTE "name" VARCHAR;
        COMMENT ON COLUMN "notes"."-ngs_Task_type-"."name" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = 'Task' AND column_name = 'name') THEN
        ALTER TYPE "notes"."Task" ADD ATTRIBUTE "name" VARCHAR;
        COMMENT ON COLUMN "notes"."Task"."name" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = '-ngs_Task_type-' AND column_name = 'body') THEN
        ALTER TYPE "notes"."-ngs_Task_type-" ADD ATTRIBUTE "body" VARCHAR;
        COMMENT ON COLUMN "notes"."-ngs_Task_type-"."body" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = 'Task' AND column_name = 'body') THEN
        ALTER TYPE "notes"."Task" ADD ATTRIBUTE "body" VARCHAR;
        COMMENT ON COLUMN "notes"."Task"."body" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = '-ngs_Task_type-' AND column_name = 'status') THEN
        ALTER TYPE "notes"."-ngs_Task_type-" ADD ATTRIBUTE "status" "notes"."Status";
        COMMENT ON COLUMN "notes"."-ngs_Task_type-"."status" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = 'Task' AND column_name = 'status') THEN
        ALTER TYPE "notes"."Task" ADD ATTRIBUTE "status" "notes"."Status";
        COMMENT ON COLUMN "notes"."Task"."status" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = '-ngs_Bucket_type-' AND column_name = 'ID') THEN
        ALTER TYPE "notes"."-ngs_Bucket_type-" ADD ATTRIBUTE "ID" INT;
        COMMENT ON COLUMN "notes"."-ngs_Bucket_type-"."ID" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = 'Bucket' AND column_name = 'ID') THEN
        ALTER TABLE "notes"."Bucket" ADD COLUMN "ID" INT;
        COMMENT ON COLUMN "notes"."Bucket"."ID" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = '-ngs_Bucket_type-' AND column_name = 'name') THEN
        ALTER TYPE "notes"."-ngs_Bucket_type-" ADD ATTRIBUTE "name" VARCHAR;
        COMMENT ON COLUMN "notes"."-ngs_Bucket_type-"."name" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = 'Bucket' AND column_name = 'name') THEN
        ALTER TABLE "notes"."Bucket" ADD COLUMN "name" VARCHAR;
        COMMENT ON COLUMN "notes"."Bucket"."name" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = '-ngs_Bucket_type-' AND column_name = 'notesURI') THEN
        ALTER TYPE "notes"."-ngs_Bucket_type-" ADD ATTRIBUTE "notesURI" TEXT[];
        COMMENT ON COLUMN "notes"."-ngs_Bucket_type-"."notesURI" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$
BEGIN
    IF NOT EXISTS(SELECT * FROM pg_enum e JOIN pg_type t ON e.enumtypid = t.oid JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'notes' AND t.typname = 'Status' AND e.enumlabel = 'Pending') THEN
        --ALTER TYPE "notes"."Status" ADD VALUE IF NOT EXISTS 'Pending'; -- this doesn't work inside a transaction ;( use a hack to add new values...
        --TODO: detect OID wraparounds and throw an exception in that case
        INSERT INTO pg_enum(enumtypid, enumlabel, enumsortorder)
        SELECT t.oid, 'Pending', (SELECT MAX(enumsortorder) + 1 FROM pg_enum e WHERE e.enumtypid = t.oid)
        FROM pg_type t
        INNER JOIN pg_namespace n ON n.oid = t.typnamespace
        WHERE n.nspname = 'notes' AND t.typname = 'Status';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$
BEGIN
    IF NOT EXISTS(SELECT * FROM pg_enum e JOIN pg_type t ON e.enumtypid = t.oid JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname = 'notes' AND t.typname = 'Status' AND e.enumlabel = 'Finished') THEN
        --ALTER TYPE "notes"."Status" ADD VALUE IF NOT EXISTS 'Finished'; -- this doesn't work inside a transaction ;( use a hack to add new values...
        --TODO: detect OID wraparounds and throw an exception in that case
        INSERT INTO pg_enum(enumtypid, enumlabel, enumsortorder)
        SELECT t.oid, 'Finished', (SELECT MAX(enumsortorder) + 1 FROM pg_enum e WHERE e.enumtypid = t.oid)
        FROM pg_type t
        INNER JOIN pg_namespace n ON n.oid = t.typnamespace
        WHERE n.nspname = 'notes' AND t.typname = 'Status';
    END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "notes"."cast_Task_to_type"("notes"."Task") RETURNS "notes"."-ngs_Task_type-" AS $$ SELECT $1::text::"notes"."-ngs_Task_type-" $$ IMMUTABLE LANGUAGE sql COST 1;
CREATE OR REPLACE FUNCTION "notes"."cast_Task_to_type"("notes"."-ngs_Task_type-") RETURNS "notes"."Task" AS $$ SELECT $1::text::"notes"."Task" $$ IMMUTABLE LANGUAGE sql COST 1;
CREATE OR REPLACE FUNCTION cast_to_text("notes"."Task") RETURNS text AS $$ SELECT $1::VARCHAR $$ IMMUTABLE LANGUAGE sql COST 1;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM pg_cast c JOIN pg_type s ON c.castsource = s.oid JOIN pg_type t ON c.casttarget = t.oid JOIN pg_namespace n ON n.oid = s.typnamespace AND n.oid = t.typnamespace
                    WHERE n.nspname = 'notes' AND s.typname = 'Task' AND t.typname = '-ngs_Task_type-') THEN
        CREATE CAST ("notes"."-ngs_Task_type-" AS "notes"."Task") WITH FUNCTION "notes"."cast_Task_to_type"("notes"."-ngs_Task_type-") AS IMPLICIT;
        CREATE CAST ("notes"."Task" AS "notes"."-ngs_Task_type-") WITH FUNCTION "notes"."cast_Task_to_type"("notes"."Task") AS IMPLICIT;
        CREATE CAST ("notes"."Task" AS text) WITH FUNCTION cast_to_text("notes"."Task") AS ASSIGNMENT;
    END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW "notes"."Note_entity" AS
SELECT _entity."ID", _entity."urls", _entity."markup", _entity."tasks", CAST(_entity."bucketID" as TEXT) AS "bucketURI", _entity."bucketID"
FROM
    "notes"."Note" _entity
    ;
COMMENT ON VIEW "notes"."Note_entity" IS 'NGS volatile';

CREATE OR REPLACE FUNCTION "URI"("notes"."Note_entity") RETURNS TEXT AS $$
SELECT CAST($1."ID" as TEXT)
$$ LANGUAGE SQL IMMUTABLE SECURITY DEFINER;

CREATE OR REPLACE VIEW "notes"."AddTask_event" AS
SELECT _event._event_id AS "_event_id", _event._queued_at AS "QueuedAt", _event._processed_at AS "ProcessedAt" , _event."name", _event."noteID"
FROM
    "notes"."AddTask" _event
;

CREATE OR REPLACE FUNCTION "URI"("notes"."AddTask_event") RETURNS TEXT AS $$
SELECT $1."_event_id"::text
$$ LANGUAGE SQL IMMUTABLE SECURITY DEFINER;

CREATE OR REPLACE VIEW "notes"."Bucket_entity" AS
SELECT _entity."ID", _entity."name", COALESCE((SELECT array_agg(CAST(sq."ID" as TEXT) ORDER BY sq."ID") FROM "notes"."Note" sq WHERE sq."bucketID" = _entity."ID"), '{}') AS "notesURI"
FROM
    "notes"."Bucket" _entity
    ;
COMMENT ON VIEW "notes"."Bucket_entity" IS 'NGS volatile';

CREATE OR REPLACE FUNCTION "URI"("notes"."Bucket_entity") RETURNS TEXT AS $$
SELECT CAST($1."ID" as TEXT)
$$ LANGUAGE SQL IMMUTABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "notes"."mark_AddTask"(_events BIGINT[])
    RETURNS VOID AS
$$
BEGIN
    UPDATE "notes"."AddTask" SET _processed_at = CURRENT_TIMESTAMP WHERE _event_id = ANY(_events) AND _processed_at IS NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "notes"."cast_Note_to_type"("notes"."-ngs_Note_type-") RETURNS "notes"."Note_entity" AS $$ SELECT $1::text::"notes"."Note_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "notes"."cast_Note_to_type"("notes"."Note_entity") RETURNS "notes"."-ngs_Note_type-" AS $$ SELECT $1::text::"notes"."-ngs_Note_type-" $$ IMMUTABLE LANGUAGE sql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM pg_cast c JOIN pg_type s ON c.castsource = s.oid JOIN pg_type t ON c.casttarget = t.oid JOIN pg_namespace n ON n.oid = s.typnamespace AND n.oid = t.typnamespace
                    WHERE n.nspname = 'notes' AND s.typname = 'Note_entity' AND t.typname = '-ngs_Note_type-') THEN
        CREATE CAST ("notes"."-ngs_Note_type-" AS "notes"."Note_entity") WITH FUNCTION "notes"."cast_Note_to_type"("notes"."-ngs_Note_type-") AS IMPLICIT;
        CREATE CAST ("notes"."Note_entity" AS "notes"."-ngs_Note_type-") WITH FUNCTION "notes"."cast_Note_to_type"("notes"."Note_entity") AS IMPLICIT;
    END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW "notes"."Note_unprocessed_events" AS
SELECT _aggregate."ID"
FROM
    "notes"."Note_entity" _aggregate
;
COMMENT ON VIEW "notes"."Note_unprocessed_events" IS 'NGS volatile';

CREATE OR REPLACE FUNCTION "notes"."insert_Note"(IN _inserted "notes"."Note_entity"[]) RETURNS VOID AS
$$
BEGIN
    INSERT INTO "notes"."Note" ("ID", "urls", "markup", "tasks", "bucketID") VALUES(_inserted[1]."ID", _inserted[1]."urls", _inserted[1]."markup", _inserted[1]."tasks", _inserted[1]."bucketID");

    PERFORM pg_notify('aggregate_roots', 'notes.Note:Insert:' || array["URI"(_inserted[1])]::TEXT);
END
$$
LANGUAGE plpgsql SECURITY DEFINER;;

CREATE OR REPLACE FUNCTION "notes"."persist_Note"(
IN _inserted "notes"."Note_entity"[], IN _updated_original "notes"."Note_entity"[], IN _updated_new "notes"."Note_entity"[], IN _deleted "notes"."Note_entity"[])
    RETURNS VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE _update_count int = array_upper(_updated_original, 1);
DECLARE _delete_count int = array_upper(_deleted, 1);

BEGIN

    SET CONSTRAINTS ALL DEFERRED;



    INSERT INTO "notes"."Note" ("ID", "urls", "markup", "tasks", "bucketID")
    SELECT _i."ID", _i."urls", _i."markup", _i."tasks", _i."bucketID"
    FROM unnest(_inserted) _i;



    UPDATE "notes"."Note" as _tbl SET "ID" = (_u.changed)."ID", "urls" = (_u.changed)."urls", "markup" = (_u.changed)."markup", "tasks" = (_u.changed)."tasks", "bucketID" = (_u.changed)."bucketID"
    FROM (SELECT unnest(_updated_original) as original, unnest(_updated_new) as changed) _u
    WHERE _tbl."ID" = (_u.original)."ID";

    GET DIAGNOSTICS cnt = ROW_COUNT;
    IF cnt != _update_count THEN
        RETURN 'Updated ' || cnt || ' row(s). Expected to update ' || _update_count || ' row(s).';
    END IF;



    DELETE FROM "notes"."Note"
    WHERE ("ID") IN (SELECT _d."ID" FROM unnest(_deleted) _d);

    GET DIAGNOSTICS cnt = ROW_COUNT;
    IF cnt != _delete_count THEN
        RETURN 'Deleted ' || cnt || ' row(s). Expected to delete ' || _delete_count || ' row(s).';
    END IF;


    PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'notes.Note', 'Insert', (SELECT array_agg(_i."URI") FROM unnest(_inserted) _i));
    PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'notes.Note', 'Update', (SELECT array_agg(_u."URI") FROM unnest(_updated_original) _u));
    PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'notes.Note', 'Change', (SELECT array_agg((_u.changed)."URI") FROM (SELECT unnest(_updated_original) as original, unnest(_updated_new) as changed) _u WHERE (_u.changed)."ID" != (_u.original)."ID"));
    PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'notes.Note', 'Delete', (SELECT array_agg(_d."URI") FROM unnest(_deleted) _d));

    SET CONSTRAINTS ALL IMMEDIATE;

    RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "notes"."update_Note"(IN _original "notes"."Note_entity"[], IN _updated "notes"."Note_entity"[]) RETURNS VARCHAR AS
$$
DECLARE cnt int;
BEGIN

    UPDATE "notes"."Note" AS _tab SET "ID" = _updated[1]."ID", "urls" = _updated[1]."urls", "markup" = _updated[1]."markup", "tasks" = _updated[1]."tasks", "bucketID" = _updated[1]."bucketID" WHERE _tab."ID" = _original[1]."ID";
    GET DIAGNOSTICS cnt = ROW_COUNT;

    PERFORM pg_notify('aggregate_roots', 'notes.Note:Update:' || array["URI"(_original[1])]::TEXT);
    IF (_original[1]."ID" != _updated[1]."ID") THEN
        PERFORM pg_notify('aggregate_roots', 'notes.Note:Change:' || array["URI"(_updated[1])]::TEXT);
    END IF;
    RETURN CASE WHEN cnt = 0 THEN 'No rows updated' ELSE NULL END;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;;

CREATE OR REPLACE FUNCTION "bucket"("notes"."Note_entity") RETURNS "notes"."Bucket_entity" AS $$
SELECT _r FROM "notes"."Bucket_entity" _r WHERE _r."ID" = $1."bucketID"
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION "notes"."submit_AddTask"(IN events "notes"."AddTask_event"[], OUT "URI" VARCHAR)
    RETURNS SETOF VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;
DECLARE newUris VARCHAR[];
BEGIN



    FOR uri IN
        INSERT INTO "notes"."AddTask" (_queued_at, _processed_at, "name", "noteID")
        SELECT i."QueuedAt", i."ProcessedAt" , i."name", i."noteID"
        FROM unnest(events) i
        RETURNING _event_id::text
    LOOP
        "URI" = uri;
        newUris = array_append(newUris, uri);
        RETURN NEXT;
    END LOOP;

    PERFORM "-NGS-".Safe_Notify('events', 'notes.AddTask', 'Insert', newUris);
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "notes"."cast_AddTask_to_type"(int8) RETURNS "notes"."AddTask_event" AS $$ SELECT _e FROM "notes"."AddTask_event" _e WHERE _e."_event_id" = $1 $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "notes"."cast_AddTask_to_type"("notes"."AddTask_event") RETURNS int8 AS $$ SELECT $1."_event_id" $$ IMMUTABLE LANGUAGE sql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM pg_cast c JOIN pg_type s ON c.castsource = s.oid JOIN pg_type t ON c.casttarget = t.oid JOIN pg_namespace n ON n.oid = s.typnamespace AND n.oid = t.typnamespace
                    WHERE n.nspname = 'notes' AND s.typname = 'AddTask_event' AND t.typname = 'int8') THEN
        CREATE CAST (int8 AS "notes"."AddTask_event") WITH FUNCTION "notes"."cast_AddTask_to_type"(int8) AS IMPLICIT;
        CREATE CAST ("notes"."AddTask_event" AS int8) WITH FUNCTION "notes"."cast_AddTask_to_type"("notes"."AddTask_event") AS IMPLICIT;
    END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "notes"."cast_Bucket_to_type"("notes"."-ngs_Bucket_type-") RETURNS "notes"."Bucket_entity" AS $$ SELECT $1::text::"notes"."Bucket_entity" $$ IMMUTABLE LANGUAGE sql;
CREATE OR REPLACE FUNCTION "notes"."cast_Bucket_to_type"("notes"."Bucket_entity") RETURNS "notes"."-ngs_Bucket_type-" AS $$ SELECT $1::text::"notes"."-ngs_Bucket_type-" $$ IMMUTABLE LANGUAGE sql;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM pg_cast c JOIN pg_type s ON c.castsource = s.oid JOIN pg_type t ON c.casttarget = t.oid JOIN pg_namespace n ON n.oid = s.typnamespace AND n.oid = t.typnamespace
                    WHERE n.nspname = 'notes' AND s.typname = 'Bucket_entity' AND t.typname = '-ngs_Bucket_type-') THEN
        CREATE CAST ("notes"."-ngs_Bucket_type-" AS "notes"."Bucket_entity") WITH FUNCTION "notes"."cast_Bucket_to_type"("notes"."-ngs_Bucket_type-") AS IMPLICIT;
        CREATE CAST ("notes"."Bucket_entity" AS "notes"."-ngs_Bucket_type-") WITH FUNCTION "notes"."cast_Bucket_to_type"("notes"."Bucket_entity") AS IMPLICIT;
    END IF;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW "notes"."Bucket_unprocessed_events" AS
SELECT _aggregate."ID"
FROM
    "notes"."Bucket_entity" _aggregate
;
COMMENT ON VIEW "notes"."Bucket_unprocessed_events" IS 'NGS volatile';

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = '>tmp-Bucket-insert<' AND column_name = 'tuple') THEN
        DROP TABLE IF EXISTS "notes".">tmp-Bucket-insert<";
    END IF;
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = '>tmp-Bucket-update<' AND column_name = 'old') THEN
        DROP TABLE IF EXISTS "notes".">tmp-Bucket-update<";
    END IF;
    IF NOT EXISTS(SELECT * FROM "-NGS-".Load_Type_Info() WHERE type_schema = 'notes' AND type_name = '>tmp-Bucket-delete<' AND column_name = 'tuple') THEN
        DROP TABLE IF EXISTS "notes".">tmp-Bucket-delete<";
    END IF;
    IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'notes' AND c.relname = '>tmp-Bucket-insert<') THEN
        CREATE UNLOGGED TABLE "notes".">tmp-Bucket-insert<" AS SELECT 0::int as i, t as tuple FROM "notes"."Bucket_entity" t LIMIT 0;
    END IF;
    IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'notes' AND c.relname = '>tmp-Bucket-update<') THEN
        CREATE UNLOGGED TABLE "notes".">tmp-Bucket-update<" AS SELECT 0::int as i, t as old, t as new FROM "notes"."Bucket_entity" t LIMIT 0;
    END IF;
    IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'notes' AND c.relname = '>tmp-Bucket-delete<') THEN
        CREATE UNLOGGED TABLE "notes".">tmp-Bucket-delete<" AS SELECT 0::int as i, t as tuple FROM "notes"."Bucket_entity" t LIMIT 0;
    END IF;

END $$ LANGUAGE plpgsql;

--TODO: temp fix for rename
DROP FUNCTION IF EXISTS "notes"."persist_Bucket_internal"(int, int);

CREATE OR REPLACE FUNCTION "notes"."persist_Bucket_cleanup"() RETURNS VOID AS
$$
BEGIN

    DELETE FROM "notes".">tmp-Bucket-insert<";
    DELETE FROM "notes".">tmp-Bucket-update<";
    DELETE FROM "notes".">tmp-Bucket-delete<";
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "notes"."persist_Bucket_internal"(_update_count int, _delete_count int)
    RETURNS VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;

BEGIN

    SET CONSTRAINTS ALL DEFERRED;



    INSERT INTO "notes"."Bucket" ("ID", "name")
    SELECT (tuple)."ID", (tuple)."name"
    FROM "notes".">tmp-Bucket-insert<" i;




    UPDATE "notes"."Bucket" as tbl SET
        "ID" = (new)."ID", "name" = (new)."name"
    FROM "notes".">tmp-Bucket-update<" u
    WHERE
        tbl."ID" = (old)."ID";

    GET DIAGNOSTICS cnt = ROW_COUNT;
    IF cnt != _update_count THEN
        PERFORM "notes"."persist_Bucket_cleanup"();
        RETURN 'Updated ' || cnt || ' row(s). Expected to update ' || _update_count || ' row(s).';
    END IF;



    DELETE FROM "notes"."Bucket"
    WHERE ("ID") IN (SELECT (tuple)."ID" FROM "notes".">tmp-Bucket-delete<" d);

    GET DIAGNOSTICS cnt = ROW_COUNT;
    IF cnt != _delete_count THEN
        PERFORM "notes"."persist_Bucket_cleanup"();
        RETURN 'Deleted ' || cnt || ' row(s). Expected to delete ' || _delete_count || ' row(s).';
    END IF;


    PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'notes.Bucket', 'Insert', (SELECT array_agg((tuple)."URI") FROM "notes".">tmp-Bucket-insert<"));
    PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'notes.Bucket', 'Update', (SELECT array_agg((old)."URI") FROM "notes".">tmp-Bucket-update<"));
    PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'notes.Bucket', 'Change', (SELECT array_agg((new)."URI") FROM "notes".">tmp-Bucket-update<" WHERE (old)."ID" != (new)."ID"));
    PERFORM "-NGS-".Safe_Notify('aggregate_roots', 'notes.Bucket', 'Delete', (SELECT array_agg((tuple)."URI") FROM "notes".">tmp-Bucket-delete<"));

    SET CONSTRAINTS ALL IMMEDIATE;


    DELETE FROM "notes".">tmp-Bucket-insert<";
    DELETE FROM "notes".">tmp-Bucket-update<";
    DELETE FROM "notes".">tmp-Bucket-delete<";

    RETURN NULL;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "notes"."persist_Bucket"(
IN _inserted "notes"."Bucket_entity"[], IN _updated_original "notes"."Bucket_entity"[], IN _updated_new "notes"."Bucket_entity"[], IN _deleted "notes"."Bucket_entity"[])
    RETURNS VARCHAR AS
$$
DECLARE cnt int;
DECLARE uri VARCHAR;
DECLARE tmp record;

BEGIN

    INSERT INTO "notes".">tmp-Bucket-insert<"
    SELECT row_number() over (), unnest(_inserted);

    INSERT INTO "notes".">tmp-Bucket-update<"
    SELECT row_number() over (), unnest(_updated_original), unnest(_updated_new);

    INSERT INTO "notes".">tmp-Bucket-delete<"
    SELECT row_number() over (), unnest(_deleted);



    RETURN "notes"."persist_Bucket_internal"(array_upper(_updated_original, 1), array_upper(_deleted, 1));
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION "notes"("notes"."Bucket_entity") RETURNS "notes"."Note_entity"[] AS $$
SELECT COALESCE(array_agg(r), '{}') FROM "notes"."Note_entity" r WHERE r."URI" = ANY($1."notesURI"::VARCHAR[])
$$ LANGUAGE SQL;
COMMENT ON VIEW "notes"."AddTask_event" IS 'NGS volatile';

SELECT "-NGS-".Create_Type_Cast('"notes"."cast_Note_to_type"("notes"."-ngs_Note_type-")', 'notes', '-ngs_Note_type-', 'Note_entity');
SELECT "-NGS-".Create_Type_Cast('"notes"."cast_Note_to_type"("notes"."Note_entity")', 'notes', 'Note_entity', '-ngs_Note_type-');
CREATE OR REPLACE FUNCTION "notes"."Note.nadjiPoBucketNameu"("it" "notes"."Note_entity", "ime" VARCHAR) RETURNS BOOL AS
$$
    SELECT      (((("it"))."bucket")."name" = "Note.nadjiPoBucketNameu"."ime")
$$ LANGUAGE SQL IMMUTABLE SECURITY DEFINER;
CREATE OR REPLACE FUNCTION "notes"."Note.nadjiPoBucketNameu"("ime" VARCHAR) RETURNS SETOF "notes"."Note_entity" AS
$$SELECT * FROM "notes"."Note_entity" "it"  WHERE      (((("it"))."bucket")."name" = "Note.nadjiPoBucketNameu"."ime")
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

SELECT "-NGS-".Create_Type_Cast('"notes"."cast_Task_to_type"("notes"."-ngs_Task_type-")', 'notes', '-ngs_Task_type-', 'Task');
SELECT "-NGS-".Create_Type_Cast('"notes"."cast_Task_to_type"("notes"."Task")', 'notes', 'Task', '-ngs_Task_type-');

SELECT "-NGS-".Create_Type_Cast('"notes"."cast_Bucket_to_type"("notes"."-ngs_Bucket_type-")', 'notes', '-ngs_Bucket_type-', 'Bucket_entity');
SELECT "-NGS-".Create_Type_Cast('"notes"."cast_Bucket_to_type"("notes"."Bucket_entity")', 'notes', 'Bucket_entity', '-ngs_Bucket_type-');
UPDATE "notes"."Note" SET "ID" = 0 WHERE "ID" IS NULL;
UPDATE "notes"."Note" SET "urls" = '{}' WHERE "urls" IS NULL;
UPDATE "notes"."Note" SET "markup" = '' WHERE "markup" IS NULL;
UPDATE "notes"."Note" SET "tasks" = '{}' WHERE "tasks" IS NULL;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM pg_index i JOIN pg_class r ON i.indexrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace WHERE n.nspname = 'notes' AND r.relname = 'ix_unprocessed_events_notes_AddTask') THEN
        CREATE INDEX "ix_unprocessed_events_notes_AddTask" ON "notes"."AddTask" (_event_id) WHERE _processed_at IS NULL;
        COMMENT ON INDEX "notes"."ix_unprocessed_events_notes_AddTask" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;
UPDATE "notes"."Bucket" SET "ID" = 0 WHERE "ID" IS NULL;
UPDATE "notes"."Bucket" SET "name" = '' WHERE "name" IS NULL;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM pg_index i JOIN pg_class r ON i.indexrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace WHERE n.nspname = 'notes' AND r.relname = 'ix_Note_bucketID') THEN
        CREATE INDEX "ix_Note_bucketID" ON "notes"."Note" ("bucketID");
        COMMENT ON INDEX "notes"."ix_Note_bucketID" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$
DECLARE _pk VARCHAR;
BEGIN
    IF EXISTS(SELECT * FROM pg_index i JOIN pg_class c ON i.indrelid = c.oid JOIN pg_namespace n ON c.relnamespace = n.oid WHERE i.indisprimary AND n.nspname = 'notes' AND c.relname = 'Note') THEN
        SELECT array_to_string(array_agg(sq.attname), ', ') INTO _pk
        FROM
        (
            SELECT atr.attname
            FROM pg_index i
            JOIN pg_class c ON i.indrelid = c.oid
            JOIN pg_attribute atr ON atr.attrelid = c.oid
            WHERE
                c.oid = '"notes"."Note"'::regclass
                AND atr.attnum = any(i.indkey)
                AND indisprimary
            ORDER BY (SELECT i FROM generate_subscripts(i.indkey,1) g(i) WHERE i.indkey[i] = atr.attnum LIMIT 1)
        ) sq;
        IF ('ID' != _pk) THEN
            RAISE EXCEPTION 'Different primary key defined for table notes.Note. Expected primary key: ID. Found: %', _pk;
        END IF;
    ELSE
        ALTER TABLE "notes"."Note" ADD CONSTRAINT "pk_Note" PRIMARY KEY("ID");
        COMMENT ON CONSTRAINT "pk_Note" ON "notes"."Note" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;

DO $$
DECLARE _pk VARCHAR;
BEGIN
    IF EXISTS(SELECT * FROM pg_index i JOIN pg_class c ON i.indrelid = c.oid JOIN pg_namespace n ON c.relnamespace = n.oid WHERE i.indisprimary AND n.nspname = 'notes' AND c.relname = 'Bucket') THEN
        SELECT array_to_string(array_agg(sq.attname), ', ') INTO _pk
        FROM
        (
            SELECT atr.attname
            FROM pg_index i
            JOIN pg_class c ON i.indrelid = c.oid
            JOIN pg_attribute atr ON atr.attrelid = c.oid
            WHERE
                c.oid = '"notes"."Bucket"'::regclass
                AND atr.attnum = any(i.indkey)
                AND indisprimary
            ORDER BY (SELECT i FROM generate_subscripts(i.indkey,1) g(i) WHERE i.indkey[i] = atr.attnum LIMIT 1)
        ) sq;
        IF ('ID' != _pk) THEN
            RAISE EXCEPTION 'Different primary key defined for table notes.Bucket. Expected primary key: ID. Found: %', _pk;
        END IF;
    ELSE
        ALTER TABLE "notes"."Bucket" ADD CONSTRAINT "pk_Bucket" PRIMARY KEY("ID");
        COMMENT ON CONSTRAINT "pk_Bucket" ON "notes"."Bucket" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;
ALTER TABLE "notes"."Note" ALTER "ID" SET NOT NULL;

DO $$
BEGIN
    IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON c.relnamespace = n.oid WHERE n.nspname = 'notes' AND c.relname = 'Note_ID_seq' AND c.relkind = 'S') THEN
        CREATE SEQUENCE "notes"."Note_ID_seq";
        ALTER TABLE "notes"."Note"    ALTER COLUMN "ID" SET DEFAULT NEXTVAL('"notes"."Note_ID_seq"');
        PERFORM SETVAL('"notes"."Note_ID_seq"', COALESCE(MAX("ID"), 0) + 1000) FROM "notes"."Note";
    END IF;
END $$ LANGUAGE plpgsql;
ALTER TABLE "notes"."Note" ALTER "urls" SET NOT NULL;
ALTER TABLE "notes"."Note" ALTER "markup" SET NOT NULL;
ALTER TABLE "notes"."Note" ALTER "tasks" SET NOT NULL;

DO $$ BEGIN
    IF NOT EXISTS(SELECT * FROM pg_constraint c JOIN pg_class r ON c.conrelid = r.oid JOIN pg_namespace n ON n.oid = r.relnamespace WHERE c.conname = 'fk_bucket' AND n.nspname = 'notes' AND r.relname = 'Note') THEN
        ALTER TABLE "notes"."Note"
            ADD CONSTRAINT "fk_bucket"
                FOREIGN KEY ("bucketID") REFERENCES "notes"."Bucket" ("ID")
                ON UPDATE CASCADE ON DELETE CASCADE;
        COMMENT ON CONSTRAINT "fk_bucket" ON "notes"."Note" IS 'NGS generated';
    END IF;
END $$ LANGUAGE plpgsql;
ALTER TABLE "notes"."Bucket" ALTER "ID" SET NOT NULL;

DO $$
BEGIN
    IF NOT EXISTS(SELECT * FROM pg_class c JOIN pg_namespace n ON c.relnamespace = n.oid WHERE n.nspname = 'notes' AND c.relname = 'Bucket_ID_seq' AND c.relkind = 'S') THEN
        CREATE SEQUENCE "notes"."Bucket_ID_seq";
        ALTER TABLE "notes"."Bucket"    ALTER COLUMN "ID" SET DEFAULT NEXTVAL('"notes"."Bucket_ID_seq"');
        PERFORM SETVAL('"notes"."Bucket_ID_seq"', COALESCE(MAX("ID"), 0) + 1000) FROM "notes"."Bucket";
    END IF;
END $$ LANGUAGE plpgsql;
ALTER TABLE "notes"."Bucket" ALTER "name" SET NOT NULL;

SELECT "-NGS-".Persist_Concepts('"dsl/notes.dsl"=>"module notes
{
    aggregate Note {
        List<URL> urls;
        String markup;
        List<Task> tasks;
        Bucket? *bucket;

        specification nadjiPoBucketNameu ''it => it.bucket.name == ime'' {
            String ime;
        }
    }

    event AddTask {
        String name;
        int noteID;
    }

    value Task {
        String name;
        String body;
        Status status;
    }

    aggregate Bucket {
        String name;
        detail<Note.bucket> notes;
    }

    enum Status {
        Pending;
        Finished;
    }
}
", "dsl/social.dsl"=>"module social
{
  aggregate Person {
    String  name;
  }
}
"', '\x','1.3.5786.14810');
