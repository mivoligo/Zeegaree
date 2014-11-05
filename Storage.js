Qt.include("Czas.js")

function getDatabase(){
    return openDatabaseSync("Zeegaree-devel", "1.0", "zeegaree-devel", 1000000);
}

/*============== CHECKING DB VERSION ===================*/

// Create special table for DB version number
function createDBVersionTable()
{
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS dbversion' +
                                  '(dbversionvalue REAL)');
                }
                );
}

// Check if DB value exist
function checkIfDBVersionExist(db_version)
{
    var db = getDatabase();
    var result = ""
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM dbversion WHERE dbversionvalue = ?',
                                           [db_version]);
                    if (rs.rows.length > 0 ) {
                        result = "true";
                    }
                    else {
                        result = "false";
                    }
                }
                );
    return result
}

function checkIfDBVersionTableExists()
{
    var db = getDatabase();
    var result = ""
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT name FROM sqlite_master WHERE name="dbversion" AND type="table"');
                    if (rs.rows.length > 0 ) {
                        result = "exist";
                    }
                    else {
                        result = "not_exist";
                    }
                }
                );
    return result
}

// Save DB version to DB
function saveDBVersion(db_version)
{
    var db = getDatabase();
    var result = "";
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('INSERT INTO dbversion VALUES(?)',
                                           [db_version]);
                    if (rs.rowsAffected > 0) {
                        result = "DB version saved as: " + db_version;
                    } else {
                        result = "Error with saving DB version: " + db_version;
                    }
                }
                );
    console.log(result)
}
// Update DB version
function updateDBVersion(db_version)
{
    var db = getDatabase();
    var result = "";
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('UPDATE dbversion '+
                                  'SET dbversionvalue = ? ',
                                  [db_version]);
                    if (rs.rowsAffected > 0) {
                        result = "DB version saved as: " + db_version;
                    } else {
                        result = "Error with saving DB version: " + db_version;
                    }
                }
                );
    console.log(result)
}

/*============== SETTINGS ===================*/


// Create settings table for Work&Play
function createSettingsTable()
{
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS worksettings' +
                                  '(settingname TEXT,' +
                                  'settingvalue TEXT)');
                }
                );
}

// Check if setting exist for Work&Play
function checkIfSettingExist(setting)
{
    var db = getDatabase();
    var result = ""
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM worksettings WHERE settingname = ?',
                                           [setting]);
                    if (rs.rows.length > 0 ) {
                        result = "true";
                    }
                    else {
                        result = "false";
                    }
                }
                );
    return result
}

// Save setting to DB for Work&Play
function saveSetting(setting, value)
{
    var db = getDatabase();
    var result = "";
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('INSERT INTO worksettings VALUES(?,?)',
                                           [setting, value]);
                    if (rs.rowsAffected > 0) {
                        result = "Setting: " + setting + " saved as: " + value;
                    } else {
                        result = "Error with saving setting: " + setting;
                    }
                }
                );
    console.log(result)
}

// Get setting from DB for Work&Play
function getSetting(setting)
{
    var db = getDatabase();
    var result = "";
    db.transaction(
                function(tx){
                    var rs = tx.executeSql('SELECT settingvalue ' +
                                           'FROM worksettings ' +
                                           'WHERE settingname = ?',
                                           [setting]);
                    if (rs.rows.length > 0) {
                        result = rs.rows.item(0).settingvalue;
                    }
                    else {
                        result = "Unknown setting";
                    }
                }
                );
    return result
}

// Update setting in DB for Work&Play
function updateSettings(setting, value)
{
    var db = getDatabase();
    var result = "";
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('UPDATE worksettings '+
                                           'SET settingvalue = ?'+
                                           'WHERE settingname = ?',
                                           [value, setting])
                    if (rs.rowsAffected > 0) {
                        result = "Setting: " + setting + " updated to: " + value;
                    } else {
                        result = "Error with updating setting: " + setting;
                    }
                }
                );
    console.log(result)
}

// Get specific settings for Work&Play
function getSettingWP()
{
    work_duration_setting.text = checkIfSettingExist("work_duration_setting") == "true" ? getSetting("work_duration_setting") : "30:00";
    short_break_duration_setting.text = checkIfSettingExist("short_break_duration_setting") == "true" ? getSetting("short_break_duration_setting") : "05:00";
    long_break_duration_setting.text = checkIfSettingExist("long_break_duration_setting") == "true" ? getSetting("long_break_duration_setting") : "15:00";
    long_break_after_setting.work_units = checkIfSettingExist("long_break_after_setting") == "true" ? getSetting("long_break_after_setting") : "4";
    auto_work_setting.isSelected = checkIfSettingExist("auto_work_set") == "true" ? getSetting("auto_work_set") : false
    auto_break_setting.isSelected = checkIfSettingExist("auto_break_set") == "true" ? getSetting("auto_break_set") : true
    ticking_sound_setting.isSelected = checkIfSettingExist("ticking_sound") == "true" ? getSetting("ticking_sound") : false
}

// Get specific settings for Timer
function getSettingTimer()
{
    repeat_alarm_setting.isSelected = checkIfSettingExist("repeat_alarm") == "true" ? getSetting("repeat_alarm") : true
}

// Get specific setting for the app
function getSettingMain()
{
    hide_on_close_edit.isSelected = checkIfSettingExist("hide_on_close") == "true" ? getSetting("hide_on_close") : false
    lite_mode_edit.isSelected = checkIfSettingExist("lite_mode") == "true" ? getSetting("lite_mode") : false
}

/*============== STATISTICS FOR WORK&PLAY ===================*/

// Create statistics table for Work&Play
function createStatsTable()
{
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS stats' +
                                  '(monthofrec TEXT,' +
                                  'dayofrec TEXT,' +
                                  'yearofrec TEXT,' +
                                  'pomodorosnumber TEXT,' +
                                  'worktime TEXT,' +
                                  'breaktime TEXT,' +
                                  'pausetime TEXT,' +
                                  'wmtime TEXT,' +
                                  'bmtime TEXT,' +
                                  'pmtime TEXT,' +
                                  'daynote TEXT,' +
                                  'addcommims TEXT)')
                }
                );
}

// Save statistics for Work&Play
function saveStats(thismonth, thisday, thisyear, pomonumvar, workduration, breakduration, pauseduration, workmiliduration, breakmilduration, pausemiliduration)
{
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('INSERT INTO stats VALUES(?,?,?,?,?,?,?,?,?,?,?,?)',
                                  [ thismonth, thisday, thisyear,
                                   pomonumvar ,workduration, breakduration, pauseduration,
                                   workmiliduration, breakmilduration, pausemiliduration, "", "./images/add_note.png"]);
                }
                );
    workSaved()
}

// Update statistics for Work&Play
function updateStats(thismonth, thisday, thisyear, pomonumvar ,workduration, breakduration, pauseduration, workmiliduration, breakmilduration, pausemiliduration)
{
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('UPDATE stats '+
                                  'SET pomodorosnumber = ?, worktime = ?, breaktime = ?, pausetime = ?, wmtime = ?, bmtime = ?, pmtime = ? '+
                                  'WHERE monthofrec = ? AND dayofrec = ? AND yearofrec = ?',
                                  [pomonumvar ,workduration, breakduration, pauseduration,
                                   workmiliduration, breakmilduration, pausemiliduration,
                                   thismonth,
                                   thisday,
                                   thisyear]);
                }
                );
}

// Get statistics for Work&Play
function getStats()
{
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    var month = Qt.formatDateTime(new Date(), "M")
                    var day = Qt.formatDateTime(new Date(), "d")
                    var year = Qt.formatDateTime(new Date(), "yyyy")
                    var rs = tx.executeSql('SELECT * FROM stats WHERE monthofrec = ? AND dayofrec = ? AND yearofrec = ?', [month, day, year]);
                    if (rs.rows.length > 0 && rs.rows.item(0).wmtime !== "" ) {
                        pnumb = rs.rows.item(0).pomodorosnumber;
                        wmtime = rs.rows.item(0).wmtime;
                        bmtime = rs.rows.item(0).bmtime;
                        pmtime = rs.rows.item(0).pmtime;
                    }
                    else {
                        pnumb = "0";
                        wmtime = "0";
                        bmtime = "0";
                        pmtime = "0";
                    }
                }
                );
}

//Get data from database for working days in specific month

function getMonthActivityFromDB(month, year)
{
    var db = getDatabase();
    var result = ""
    var days_of_work = []
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM stats WHERE monthofrec = ? AND yearofrec = ? AND worktime != ""', [month, year])

                    if (rs.rows.length > 0) {
                        for(var i = 0; i < rs.rows.length; i++) {
                            result = rs.rows.item(i).dayofrec
                            days_of_work.push(result)
                        }
                    }
                }
                );
    return days_of_work
}

// Get data from database for specific month
function getDataForMonthfromDB(year, month)
{
    var current_month = Qt.formatDateTime(new Date(year, month, 1), "M");
    var db = getDatabase();
//    var workunits, worktime, breaktime, pausetime
    var workunits = ""
    var worktime = ""
    var breaktime = ""
    var pausetime = ""
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM stats WHERE monthofrec = ? AND yearofrec = ? AND wmtime != "" AND bmtime !="" AND pmtime !=""', [current_month, year])

                    if (rs.rows.length > 0 ) {
                        for(var i = 0; i < rs.rows.length; i++) {
                            workunits = Number(workunits + Number(rs.rows.item(i).pomodorosnumber))
                            worktime = Number(worktime + Number(rs.rows.item(i).wmtime))
                            breaktime = Number(breaktime + Number(rs.rows.item(i).bmtime))
                            pausetime = Number(pausetime + Number(rs.rows.item(i).pmtime))
                        }
                        work_view_text.day_stats.visible = true
                        work_view_text.work_u.text = workunits
                        work_view_text.work_d.text = milisecToDaysHoursMinutes(worktime)
                        work_view_text.break_d.text = milisecToDaysHoursMinutes(breaktime)
                        work_view_text.pause_d.text = milisecToDaysHoursMinutes(pausetime)
                        work_view_text.work_d_p.work_d_p_mnoznik = worktime / (worktime + breaktime + pausetime);
                        work_view_text.break_d_p.break_d_p_mnoznik = breaktime / (worktime + breaktime + pausetime);
                        work_view_text.pause_d_p.pause_d_p_mnoznik = pausetime / (worktime + breaktime + pausetime);
                    }
                    else {
                        work_view_text.day_stats.visible = false
                        work_view_text.work_u.text = "0";
                        work_view_text.work_d.text = "0";
                        work_view_text.break_d.text = "0";
                        work_view_text.pause_d.text = "0";
                        work_view_text.work_d_p.work_d_p_mnoznik = 0;
                        work_view_text.break_d_p.break_d_p_mnoznik = 0;
                        work_view_text.pause_d_p.pause_d_p_mnoznik = 0;
                    }
                }
                )
}

// Get data from database for specific day
function getStuffFromDB(year, month, day)
{
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM stats WHERE yearofrec = ? AND monthofrec = ? AND dayofrec = ?', [year, month, day])

                    if (rs.rows.length > 0 ) {
                        var wmtime = Number(rs.rows.item(0).wmtime);
                        var bmtime = Number(rs.rows.item(0).bmtime);
                        var pmtime = Number(rs.rows.item(0).pmtime);
                        work_view_text.work_u.text = rs.rows.item(0).pomodorosnumber;
                        work_view_text.work_d.text = rs.rows.item(0).worktime;
                        work_view_text.break_d.text = rs.rows.item(0).breaktime;
                        work_view_text.pause_d.text = rs.rows.item(0).pausetime;
                        work_view_text.work_d_p.work_d_p_mnoznik = wmtime / (wmtime + bmtime + pmtime);
                        work_view_text.break_d_p.break_d_p_mnoznik = bmtime / (wmtime + bmtime + pmtime);
                        work_view_text.pause_d_p.pause_d_p_mnoznik = pmtime / (wmtime + bmtime + pmtime);
                        day_note_text.text = rs.rows.item(0).daynote;
                        work_view_text.day_stats.visible = rs.rows.item(0).worktime !== "";
                        day_note_view.visible = rs.rows.item(0).daynote !== ""
                        new_notes.visible = !day_note_view.visible
                    }
                    else {
                        day_note_view.visible = false;
                        new_notes.visible = !day_note_view.visible
                        work_view_text.day_stats.visible = false
                        work_view_text.work_u.text = "0";
                        work_view_text.work_d.text = "0";
                        work_view_text.break_d.text = "0";
                        work_view_text.pause_d.text = "0";
                        work_view_text.work_d_p.work_d_p_mnoznik = 0;
                        work_view_text.break_d_p.break_d_p_mnoznik = 0;
                        work_view_text.pause_d_p.pause_d_p_mnoznik = 0;
                    }
                }
                )
}

// Check if record for a given day already exist
function checkIfRecordExist(month, day, year)
{
    var db = getDatabase();
    var result = ""
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM stats WHERE monthofrec = ? AND dayofrec = ? AND yearofrec = ?',
                                           [month, day, year])
                    if (rs.rows.length > 0 ) {
                        result = "true"
                    }
                    else {
                        result =  "false"
                    }
                }
                );
    return result
}

// Save note for a given day
function saveNote(thismonth, thisday, thisyear, textofnote)
{
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('INSERT INTO stats VALUES(?,?,?,?,?,?,?,?,?,?,?,?)',
                                  [ thismonth, thisday, thisyear, "" ,"", "", "", "", "", "", textofnote, "./images/add_note.png"]);
                }
                );
}

// Update note for a given day
function updateNote(thismonth, thisday, thisyear, textofnote)
{
    var db = getDatabase();
    db.transaction(
                function(tx){
                    tx.executeSql('UPDATE stats '+
                                  'SET daynote = ?'+
                                  'WHERE monthofrec = ? AND dayofrec = ? AND yearofrec = ?',
                                  [textofnote, thismonth, thisday, thisyear])
                }
                );
}

// Delete note for a given day
function deleteNote(thismonth, thisday, thisyear)
{
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('DELETE FROM stats WHERE monthofrec = ? AND dayofrec = ? AND yearofrec = ?',
                                  [thismonth, thisday, thisyear])
                }
                );
}

// Get data from database for days with notes in specific month

function getMonthNotesFromDB(month, year)
{
    var db = getDatabase();
    var result = ""
    var days_with_notes = []
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM stats WHERE monthofrec = ? AND yearofrec = ? AND daynote != ""', [month, year])

                    if (rs.rows.length > 0) {
                        for(var i = 0; i < rs.rows.length; i++) {
                            result = rs.rows.item(i).dayofrec
                            days_with_notes.push(result)
                        }
                    }
                }

                )
    return days_with_notes
}

/*============== TASKS FOR WORK&PLAY ===================*/

// Check if tasks table already exists
function checkIfTasksTableExists()
{
    var db = getDatabase();
    var result = ""
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT name FROM sqlite_master WHERE name="tasks" AND type="table"');
                    if (rs.rows.length > 0 ) {
                        result = "exist";
                    }
                    else {
                        result = "not_exist";
                    }
                }
                );
    return result
}

// Add column to a table for visibility of task notes
function addTaskNoteVizColumnToTable(){
    var db = getDatabase();
    db.transaction(
                function(tx){
                    tx.executeSql('ALTER TABLE tasks ADD COLUMN tasknotevisible TEXT')
                }
                );
}


// Create tasks table for Work&Play
function createTasksTable(){
    var db = getDatabase();
    db.transaction(
                function(tx){
                    tx.executeSql('CREATE TABLE IF NOT EXISTS tasks' +
                                  '(listidtimestamp TEXT,' +
                                  'timestamp TEXT,' +
                                  'taskname TEXT,' +
                                  'color TEXT,' +
                                  'unitsplan REAL,' +
                                  'unitsdone REAL,' +
                                  'note TEXT,' +
                                  'finished TEXT,' +
                                  'tracked TEXT,' +
                                  'tasknotevisible TEXT)')
                }
                );
}

// Create finished tasks table for Work&PLay
function createFinishedTasksTable(){
    var db = getDatabase();
    db.transaction(
                function(tx){
                    tx.executeSql('CREATE TABLE IF NOT EXISTS finishedtasks' +
                                  '(timestamp TEXT,' +
                                  'taskname TEXT,' +
                                  'listname TEXT,' +
                                  'color TEXT,' +
                                  'unitsplan TEXT,' +
                                  'unitsdone TEXT,' +
                                  'note TEXT,' +
                                  'fday TEXT,' +
                                  'fmonth TEXT,' +
                                  'fyear TEXT)')
                }
                );
}

// Save task for Work&Play
function saveTask(listidtimestamp, timestamp, taskname, color, unitsplan, unitsdone, note, finished, tracked, tasknotevisible)
{
    var db = getDatabase();
    var result = "";
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('INSERT INTO tasks VALUES(?,?,?,?,?,?,?,?,?,?)',
                                           [listidtimestamp, timestamp, taskname, color, unitsplan, unitsdone, note, finished, tracked, tasknotevisible]);
                    if (rs.rowsAffected > 0) {
                        result = "Task: " + taskname + " saved";
                    }
                    else {
                        result = "Error with saving task: " + taskname;
                    }
                }
                );
    console.log(result);
}

// Save _finished_ tasks for Work&Play
function saveFinishedTaskInDB(timestamp, taskname, listname, color, unitsplan, unitsdone, note, fday, fmonth, fyear)
{
    var db = getDatabase();
    var result = "";
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('INSERT INTO finishedtasks VALUES(?,?,?,?,?,?,?,?,?,?)',
                                           [timestamp, taskname, listname, color, unitsplan, unitsdone, note, fday, fmonth, fyear]);
                    if (rs.rowsAffected > 0) {
                        result = "Finished task: " + taskname + " saved";
                    }
                    else {
                        result = "Error with saving finished task: " + taskname;
                    }
                }
                );
    console.log(result);
}

// Update task for Work&Play
function updateTask(timestamp, taskname, color, unitsplan, unitsdone, note)
{
    var db = getDatabase();
    var result = "";
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('UPDATE tasks '+
                                           'SET taskname = ?, color = ?, unitsplan = ?, unitsdone = ?, note = ?'+
                                           'WHERE timestamp = ?',
                                           [taskname, color, unitsplan, unitsdone, note, timestamp])
                    if (rs.rowsAffected > 0) {
                        result = "Task: " + taskname + " was updated";
                    }
                    else {
                        result = "Error with updating task: " + taskname+  " rows: " + rs.rowsAffected;
                    }
                }
                );
    console.log(result);
}

// Update _finished_ task for Work&Play
function updateFinishedTask(timestamp, taskname, listname, color, unitsplan, unitsdone, note)
{
    var db = getDatabase();
    var result = "";
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('UPDATE finishedtasks '+
                                  'SET taskname = ?, listname = ?, color = ?, unitsplan = ?, unitsdone = ?, note = ?'+
                                  'WHERE timestamp = ?',
                                  [taskname, listname, color, unitsplan, unitsdone, note, timestamp])
                    if (rs.rowsAffected > 0) {
                        result = "Finished task: " + taskname + " was updated";
                    }
                    else {
                        result = "Error with updating finished task: " + taskname +  " rows: " + rs.rowsAffected;
                    }
                }
                );
    console.log(result);
}

// Delete task for Work&Play
function deleteTask(timestamp)
{
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('DELETE FROM tasks WHERE timestamp = ?', [timestamp])
                }
                );
}

// Delete all finished tasks for a given list for Work&Play
function deleteAllFinishedTasks(listidtimestamp)
{
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('DELETE FROM tasks WHERE listidtimestamp = ? AND finished = "true"', [listidtimestamp])
                }
                );
}

// Remove task from finished for Work&Play
function removeFinishedTask(timestamp)
{
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('DELETE FROM finishedtasks WHERE timestamp = ?', [timestamp])
                }
                );
}

// Get tasks from DB to ListView for Work&Play
function getTasksFromDB(listidtimestamp, taskslistmodel)
{
    var db = getDatabase();

    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM tasks WHERE listidtimestamp = ?',
                                           [listidtimestamp]);
                    var timestamp = "";
                    var taskname = "";
                    var color = "";
                    var unitsplan = "";
                    var unitsdone = "";
                    var tasknote = "";
                    var finished = "";
                    var tracked = "";
                    var tasknotevisible = "";
                    for(var i = 0; i < rs.rows.length; i++) {
                        timestamp = rs.rows.item(i).timestamp;
                        taskname = rs.rows.item(i).taskname;
                        color = rs.rows.item(i).color;
                        unitsplan = rs.rows.item(i).unitsplan;
                        unitsdone = rs.rows.item(i).unitsdone;
                        tasknote = rs.rows.item(i).note;
                        finished = rs.rows.item(i).finished;
                        tracked = rs.rows.item(i).tracked;
                        tasknotevisible = rs.rows.item(i).tasknotevisible;
                        taskslistmodel.append({"todoname": taskname,
                                                  "todotimestamp": timestamp,
                                                  "task_color": color,
                                                  "unitsplanned": unitsplan,
                                                  "unitsdone": unitsdone,
                                                  "visibility": tasknote !== "",
                                                  "todonote": tasknote,
                                                  "selectedvisible": finished,
                                                  "istracked": tracked,
                                                  "noteviz": tasknotevisible});
                    }

                }
                );
}

// Get _notfinished_ tasks from DB to ListView for Work&Play
function getNotFinishedTasksFromDB(listidtimestamp, notfinished, tasklistmodel)
{
    var db = getDatabase();

    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM tasks WHERE listidtimestamp = ? AND finished = ?',
                                           [listidtimestamp, notfinished]);
                    var timestamp = "";
                    var taskname = "";
                    var color = "";
                    var unitsplan = "";
                    var unitsdone = "";
                    var tasknote = "";
                    var finished = "";
                    var tracked = "";
                    var tasknotevisible = "";
                    for(var i = 0; i < rs.rows.length; i++) {
                        timestamp = rs.rows.item(i).timestamp;
                        taskname = rs.rows.item(i).taskname;
                        color = rs.rows.item(i).color;
                        unitsplan = rs.rows.item(i).unitsplan;
                        unitsdone = rs.rows.item(i).unitsdone;
                        tasknote = rs.rows.item(i).note;
                        finished = rs.rows.item(i).finished;
                        tracked = rs.rows.item(i).tracked;
                        tasknotevisible = rs.rows.item(i).tasknotevisible;
                        tasklistmodel.append({"todoname": taskname,
                                                 "todotimestamp": timestamp,
                                                 "task_color": color,
                                                 "unitsplanned": unitsplan,
                                                 "unitsdone": unitsdone,
                                                 "visibility": tasknote !== "",
                                                 "todonote": tasknote,
                                                 "selectedvisible": finished,
                                                 "istracked": tracked,
                                                 "noteviz": tasknotevisible});
                    }
                }
                );
}

// Get finished tasks from DB to ListView for Work&Play
function getFinishedTasksFromDB(fday, fmonth, fyear, taskfinishedlistmodel)
{
    var db = getDatabase();

    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM finishedtasks WHERE fday = ? AND fmonth = ? AND fyear = ?',
                                           [fday, fmonth, fyear]);
                    var timestamp = "";
                    var taskname = "";
                    var color = "";
                    var unitsplan = "";
                    var unitsdone = "";
                    var tasknote = "";
                    var listname = "";
                    for(var i = 0; i < rs.rows.length; i++) {
                        timestamp = rs.rows.item(i).timestamp;
                        taskname = rs.rows.item(i).taskname;
                        color = rs.rows.item(i).color;
                        unitsplan = rs.rows.item(i).unitsplan;
                        unitsdone = rs.rows.item(i).unitsdone;
                        tasknote = rs.rows.item(i).note;
                        listname = rs.rows.item(i).listname;
                        taskfinishedlistmodel.append({"todoname": taskname,
                                                         "todotimestamp": timestamp,
                                                         "task_color": color,
                                                         "unitsplanned": unitsplan,
                                                         "unitsdone": unitsdone,
                                                         "visibility": tasknote !== "",
                                                         "todonote": tasknote,
                                                         "tasklistname": listname});
                    }
                }
                );
}

// Get finished tasks in a given month
function getFinishedTasksinMonth(fmonth, fyear, taskfinishedlistmodel)
{
    var db = getDatabase();

    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM finishedtasks WHERE fmonth = ? AND fyear = ?',
                                           [fmonth, fyear]);
                    var timestamp = "";
                    var taskname = "";
                    var color = "";
                    var unitsplan = "";
                    var unitsdone = "";
                    var tasknote = "";
                    var listname = "";
                    for(var i = 0; i < rs.rows.length; i++) {
                        timestamp = rs.rows.item(i).timestamp;
                        taskname = rs.rows.item(i).taskname;
                        color = rs.rows.item(i).color;
                        unitsplan = rs.rows.item(i).unitsplan;
                        unitsdone = rs.rows.item(i).unitsdone;
                        tasknote = rs.rows.item(i).note;
                        listname = rs.rows.item(i).listname;
                        taskfinishedlistmodel.append({"todoname": taskname,
                                                         "todotimestamp": timestamp,
                                                         "task_color": color,
                                                         "unitsplanned": unitsplan,
                                                         "unitsdone": unitsdone,
                                                         "visibility": tasknote !== "",
                                                         "todonote": tasknote,
                                                         "tasklistname": listname});
                    }
                }
                );
}

// Get data from database for days with finished tasks in specific month
function getMonthFinishedTasksFromDB(month, year)
{
    var db = getDatabase();
    var result = ""
    var days_with_finished_tasks = []
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM finishedtasks WHERE fmonth = ? AND fyear = ?', [month, year])

                    if (rs.rows.length > 0) {
                        for(var i = 0; i < rs.rows.length; i++) {
                            result = rs.rows.item(i).fday
                            days_with_finished_tasks.push(result)
                        }
                    }
                }
                );
    return days_with_finished_tasks
}

// Get tasks with specific color for specific list
function getTasksWithColor(listidtimestamp, selectedcolor, taskslistmodel)
{
    var db = getDatabase();

    db.transaction(
                function(tx){
                    var rs = tx.executeSql('SELECT * FROM tasks WHERE listidtimestamp = ? AND color = ?',
                                           [listidtimestamp, selectedcolor]);
                    var timestamp = "";
                    var taskname = "";
                    var color = "";
                    var unitsplan = "";
                    var unitsdone = "";
                    var tasknote = "";
                    var finished = "";
                    var tracked = "";
                    var tasknotevisible = "";
                    for(var i = 0; i < rs.rows.length; i++) {
                        timestamp = rs.rows.item(i).timestamp;
                        taskname = rs.rows.item(i).taskname;
                        color = rs.rows.item(i).color;
                        unitsplan = rs.rows.item(i).unitsplan;
                        unitsdone = rs.rows.item(i).unitsdone;
                        tasknote = rs.rows.item(i).note;
                        finished = rs.rows.item(i).finished;
                        tracked = rs.rows.item(i).tracked;
                        tasknotevisible = rs.rows.item(i).tasknotevisible;
                        taskslistmodel.append({"todoname": taskname,
                                                  "todotimestamp": timestamp,
                                                  "task_color": color,
                                                  "unitsplanned": unitsplan,
                                                  "unitsdone": unitsdone,
                                                  "visibility": tasknote !== "",
                                                  "todonote": tasknote,
                                                  "selectedvisible": finished,
                                                  "istracked": tracked,
                                                  "noteviz": tasknotevisible});
                    }
                }
                );
}

// Get _notfinished_ tasks with specific color for specific list
function getNotFinishedTasksWithColor(listidtimestamp, selectedcolor, notfinished, tasklistmodel)
{
    var db = getDatabase();

    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM tasks WHERE listidtimestamp = ? AND color = ? AND finished = ?',
                                           [listidtimestamp, selectedcolor, notfinished]);
                    var timestamp = "";
                    var taskname = "";
                    var color = "";
                    var unitsplan = "";
                    var unitsdone = "";
                    var tasknote = "";
                    var finished = "";
                    var tracked = "";
                    var tasknotevisible = "";

                    for(var i = 0; i < rs.rows.length; i++) {
                        timestamp = rs.rows.item(i).timestamp;
                        taskname = rs.rows.item(i).taskname;
                        color = rs.rows.item(i).color;
                        unitsplan = rs.rows.item(i).unitsplan;
                        unitsdone = rs.rows.item(i).unitsdone;
                        tasknote = rs.rows.item(i).note;
                        finished = rs.rows.item(i).finished;
                        tracked = rs.rows.item(i).tracked;
                        tasknotevisible = rs.rows.item(i).tasknotevisible;
                        tasklistmodel.append({"todoname": taskname,
                                                 "todotimestamp": timestamp,
                                                 "task_color": color,
                                                 "unitsplanned": unitsplan,
                                                 "unitsdone": unitsdone,
                                                 "visibility": tasknote !== "",
                                                 "todonote": tasknote,
                                                 "selectedvisible": finished,
                                                 "istracked": tracked,
                                                 "noteviz": tasknotevisible});
                    }
                }
                );
}

// Mark task as finished/unfinished in DB
function selectTaskFinished(timestamp, finished)
{
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('UPDATE tasks '+
                                  'SET finished = ?'+
                                  'WHERE timestamp = ?',
                                  [finished, timestamp])
                }
                );
}

// Mark task as tracked/untracked in DB
function selectTaskTrackedInDB(timestamp, tracked)
{
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('UPDATE tasks '+
                                  'SET tracked = ?'+
                                  'WHERE timestamp = ?',
                                  [tracked, timestamp])
                }
                );
}

// Set task note visibility in DB
function setTaskNoteVisibleInDB(timestamp, tasknotevisible)
{
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('UPDATE tasks '+
                                  'SET tasknotevisible = ?'+
                                  'WHERE timestamp = ?',
                                  [tasknotevisible, timestamp])
                }
                );
}

// Count how many tasks are tracked
function countTrackedTasks()
{
    var db = getDatabase();
    var result
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM tasks WHERE tracked = "true"');
                    result = rs.rows.length;
                }
                );
    return tracked_tasks_number.number_of_tracked = result
}

// Add work units to tracked tasks
function addWorkUnitToTrackedTask()
{
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('UPDATE tasks '+
                                  'SET unitsdone = unitsdone + 1 '+
                                  'WHERE tracked = "true"'
                                  )
                }
                );
}

/*============== LISTS FOR WORK&PLAY ===================*/

// Create lists table for Work&PLay
function createListsTable(){
    var db = getDatabase();
    db.transaction(
                function(tx){
                    tx.executeSql('CREATE TABLE IF NOT EXISTS lists' +
                                  '(listname TEXT,' +
                                  'timestamp TEXT)')
                }
                );
}

// Save list for Work&Play
function saveList(listname, timestamp)
{
    var db = getDatabase();
    var result = ""
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('INSERT INTO lists VALUES(?,?)',
                                           [listname, timestamp]);
                    if (rs.rowsAffected > 0) {
                        result = "List: " + listname + " saved";
                    }
                    else {
                        result = "Error with saving list: " + listname;
                    }
                }
                );
    console.log(result);
}

// Update list for Work&Play
function updateList(listname, timestamp)
{
    var db = getDatabase();
    var result = "";
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('UPDATE lists '+
                                           'SET listname = ?'+
                                           'WHERE timestamp = ?',
                                           [listname, timestamp])
                    if (rs.rowsAffected > 0) {
                        result = "List was updated to: " + listname;
                    }
                    else {
                        result = "Error with updating list: " + listname;
                    }
                }
                );
    console.log(result);
}

// Delete list for Work&Play
function deleteList(timestamp)
{
    var db = getDatabase();
    var result = "";
    db.transaction(
                function(tx) {
                    tx.executeSql('DELETE FROM lists WHERE timestamp = ?', [timestamp]);
                    tx.executeSql('DELETE FROM tasks WHERE listidtimestamp = ?', [timestamp]);
                }
                );
}

// Get lists from DB to ListView for Work&Play
function getListsFromDB(listslistmodel)
{
    var db = getDatabase();

    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM lists');
                    var listname = "";
                    var timestamp = "";
                    for(var i = 0; i < rs.rows.length; i++) {
                        listname = rs.rows.item(i).listname;
                        timestamp = rs.rows.item(i).timestamp;
                        listslistmodel.append({"taskslistname": listname, "timestamp": timestamp});
                    }
                }
                );
}

/*============== FAVOURITES FOR TIMER ===================*/

// Create favourites table for Timer
function createFavsTable(){
    var db = getDatabase();
    db.transaction(
                function(tx){
                    tx.executeSql('CREATE TABLE IF NOT EXISTS favs' +
                                  '(fname TEXT,' +
                                  'ftime TEXT,' +
                                  'tstamp TEXT)')
                }
                );
}

// Save favourites for Timer
function saveFavs(favname, favtime, favtimestamp){
    var db = getDatabase();
    var result = "";
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('INSERT INTO favs VALUES(?, ?, ?)',
                                           [favname, favtime, favtimestamp]);
                    if (rs.rowsAffected > 0) {
                        result = "Favourite: " + favname + " saved with time: " + favtime;
                    }
                    else {
                        result = "Error with saving favourite: " + favname;
                    }
                }
                );
    console.log(result);
}

// Update favourites for Timer
function updateFavs(favname, favtime, favtimestamp){
    var db = getDatabase();
    var result = ""
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('UPDATE favs '+
                                           'SET fname = ?, ftime = ? '+
                                           'WHERE tstamp = ?',
                                           [favname, favtime, favtimestamp]);
                    if (rs.rowsAffected > 0) {
                        result = "Favourite: " + favname + " updated to: " + favtime;
                    }
                    else {
                        result = "Error with updating favourite: " + favname;
                    }
                }
                );
    console.log(result);
}

// Delete favourites for Timer
function deleteFavs(favtimestamp){
    var db = getDatabase();
    var result = ""
    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('DELETE FROM favs WHERE tstamp = ?',[favtimestamp]);
                    if (rs.rowsAffected > 0) {
                        result = "Favourite with timestamp: " + favtimestamp + " deleted";
                    }
                    else {
                        result = "Error with deleting favourite with timestamp: " + favtimestamp;
                    }
                }
                );
    console.log(result);
}

// Get favourites from DB to ListView for Timer
function getFavs(favlistmodel)
{
    var db = getDatabase();

    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM favs');
                    var fname = "";
                    var ftime = "";
                    var tstamp = "";
                    for(var i = 0; i < rs.rows.length; i++) {
                        fname = rs.rows.item(i).fname;
                        ftime = rs.rows.item(i).ftime;
                        tstamp = rs.rows.item(i).tstamp;
                        favlistmodel.append({"nameoffav": fname, "timeoffav": ftime, "favtimestamp": tstamp});
                    }
                }
                );
}
