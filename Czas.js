// Functions related to time counting


// Count up Stopwatch
function stopwatchCountUp(h1, h2, m1, m2, s1, s2, ts)
{
    if (ts === 9){
        ts = 0;
        s2 += 1
        if (s2 > 9){
            s2 = 0;
            s1 += 1;
            if (s1 > 5){
                s1 = 0;
                m2 += 1;
                if (m2 > 9){
                    m2 = 0;
                    m1 += 1;
                    if (m1 > 5){
                        m1 = 0;
                        h2 += 1
                        if (h2 > 9){
                            h2 = 0;
                            h1 += 1;
                        }
                    }
                }
            }
        }
    }
    else{
        ts += 1;
    }
    return "" + h1 + h2 + ":" + m1 + m2 + ":" +s1 + s2 + "." + ts
}
// Convert miliseconds to days, hours, minutes
function milisecToDaysHoursMinutes(milisec)
{
    var d, m, h, s
    s = Math.floor(milisec / 1000);
    m = Math.floor(s / 60);
    s = s % 60;
    h = Math.floor(m / 60);
    m = m % 60;
    d = Math.floor(h / 24);
    h = h % 24;

    return d !== 0 ? d +"d " + h + "h " + m +"m" : h + "h " + m +"m"
}

// Convert miliseconds to hours, minutes, seconds
function milisecToHoursMinutes(difference)
{
    var hoursDifference = ("0" + Math.floor(difference/1000/60/60)).slice(-2);
    difference -= hoursDifference*1000*60*60
    var minutesDifference = ("0" + Math.floor(difference/1000/60)).slice(-2);
    difference -= minutesDifference*1000*60
    var secondsDifference = ("0" + Math.floor(difference/1000)).slice(-2);
    return  hoursDifference + ':' + minutesDifference + ':' + secondsDifference
}

// display hours or minutes or seconds text in timer
function unitsdisplay(units)
{
    if (units > 59){
        units = (units % 60) - 60
    }
    if (units < 0){
        units = (units % 60) + 60
    }
    if (units === 60){
        units = 0
    }

    return ("0"+units).slice(-2)
}

// Level hight for Work&Play
function calculateHightLevelWP(background_height, time_setting, time_current)
{
    var setseconds = Number(time_setting.text.slice(3, 5))
    var setminutes = Number(time_setting.text.slice(0, 2))
    var settimeinsec = Number(setminutes * 60 + setseconds)
    var currentseconds = Number(time_current.slice(-2))
    var currentminutes = Number(time_current.slice(3, 5))
    var currenthours = Number(time_current.slice(0, 2))
    var currenttimeinsec = currenthours * 3600 + currentminutes * 60 + currentseconds

    return currenttimeinsec/settimeinsec * background_height
}

// Decide if there's Work Time, Short Break or Long Break (needed for Level Hight above)
function deciteWorkOrBreak()
{
    if (wp_state.text == "Long Break"){
        return long_break_duration_setting
    }
    else if (wp_state.text == "Short Break"){
        return short_break_duration_setting
    }
    else {
        return work_duration_setting
    }
}

// Current time
function getCurrentTime(){
    var currenttime = new Date();
    return currenttime;
}

// Get time duration
function getTimeDifference(earlierDate, laterDate)
{
    var difference = laterDate.getTime() - earlierDate;
    return difference;
}

// Count up Work & Play timer
function countUp(show_counter_in_unity)
{
    var str = wp_time_text.wp_time_text_shadow
    var h1 = Number(str.charAt(0))
    var h2 = Number(str.charAt(1))
    var m1 = Number(str.charAt(3))
    var m2 = Number(str.charAt(4))
    var s1 = Number(str.charAt(6))
    var s2 = Number(str.charAt(7))
    var min1 = str.charAt(3)
    var min2 = str.charAt(4)
    var minutes = Number(min1 + min2)
    if (s2 === 9){
        s2 = 0;
        s1 += 1
        if (s1 > 5){
            s1 = 0;
            m2 += 1;
            if (m2 > 9){
                m2 = 0;
                m1 += 1;
                if(m1 > 5){
                    m1 = 0;
                    h2 += 1;
                    if(h2 > 9){
                        h2 = 0;
                        h1 +=1;
                    }
                }
            }
        }
    }
    else{
        s2 += 1;
    }

    return [wp_time_text.wp_time_text_shadow = "" + h1 + h2 + ":" +m1 + m2 + ":" + s1 + s2,
            launcher.getPomodoroCount(minutes, show_counter_in_unity),
            trayicon.onWorkplayTimeChangefromQML("True", wp_state.text + " " + wp_state2.text + " " + wp_time_text.text)]
}
