INSERT
    INTO objects (account, id, objectType, published, updated, _json)
    SELECT
            1, id, objectType, published, updated, _json
        FROM objects_old;

UPDATE objects SET
    author    = (
        SELECT _ID FROM objects AS a_n WHERE a_n.id=(
            SELECT author FROM objects_old WHERE objects_old.id=objects.id)),
    inReplyTo = (
        SELECT _ID from objects AS a_n WHERE a_n.id = (
            SELECT inReplyTo from objects_old where objects_old.id=objects.id));

INSERT
    INTO activities (_ID, account, id, verb, actor, object, target, published)
    SELECT
            (SELECT _ID FROM objects WHERE id=activities_old.id),       -- ID
            1,                                                          -- account
            activities.id,                                              -- id
            verb,                                                       -- verb
            (SELECT _ID FROM objects WHERE id=activities_old.actor),    -- actor
            (SELECT _ID FROM objects WHERE id=activities_old.object),   -- object
            (SELECT _ID FROM objects WHERE id=activities_old.target),   -- target
            published                                                   -- published
        FROM activities_old;

INSERT
    INTO feed_entries (account, activity)
    SELECT
            1, -- account
            (SELECT _ID FROM objects WHERE id=feed_entries_old.id)
        FROM feed_entries_old
        WHERE account=(SELECT name FROM accounts WHERE _ID=1);