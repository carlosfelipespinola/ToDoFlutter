const NAME_FIELD = 'name';
const UID_FIELD = 'uid';
const TO_DO_LIST_TABLE_NAME = 'to_do_lists';

const createToDoListTableSQL = 'CREATE TABLE $TO_DO_LIST_TABLE_NAME($UID_FIELD INTEGER PRIMARY KEY, $NAME_FIELD TEXT);';
