import 'package:to_do_flutter/to-do/models/ToDoListTableDetails.dart';

const TASK_UID_FIELD = 'uid';
const TASK_NAME_FIELD = 'name';
const TASK_IS_FINISHED_NAME = 'is_finished';
const TASK_TO_DO_UID_NAME = 'to_do_uid';
const TASK_TABLE_NAME = 'to_do_task_table';

const createTaskTableSQL = 'CREATE TABLE $TASK_TABLE_NAME($TASK_UID_FIELD INTEGER PRIMARY KEY, $TASK_NAME_FIELD TEXT, $TASK_IS_FINISHED_NAME INTEGER , $TASK_TO_DO_UID_NAME INTEGER, FOREIGN KEY($TASK_TO_DO_UID_NAME) REFERENCES $TO_DO_LIST_TABLE_NAME($UID_FIELD));';