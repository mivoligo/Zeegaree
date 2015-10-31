#!/usr/bin/python
# -*- coding: utf-8 -*-

from gi.repository import Notify
from PySide import QtCore, QtGui, QtDeclarative
import subprocess
import os
import datetime
import dbus.service
from dbus.mainloop.glib import DBusGMainLoop

try:
    from gi.repository import Unity
    LAUNCHER = Unity.LauncherEntry.get_for_desktop_id("zeegaree.desktop")
except ImportError:
    class NullLauncher:
        def set_property(self, prop_name, enabled): pass
    LAUNCHER = NullLauncher()

NOTIFICATION_ICON = os.path.join(os.path.dirname(__file__), "./images/z_128.png")
TRAY_ICON = os.path.join(os.path.dirname(__file__), "./images/mono_color_32.png")
HOME = os.path.expanduser("~")


def _get_path(app_id):
    return '/' + app_id.replace('.', '/')

def listen_for_activation(app_id, window):
    """
    Listen for 'activate' events. If one is sent, activate 'window'.
    """
    class MyDBUSService(dbus.service.Object):                                                                                                       
        def __init__(self, window):
            self.window = window
            
            bus_name = dbus.service.BusName(app_id, bus=dbus.SessionBus())                                                     
            dbus.service.Object.__init__(self, bus_name, _get_path(app_id))
    
        @dbus.service.method(app_id)                                                                         
        def activate(self):
            trayIcon.onShowMainWindow()
    
    DBusGMainLoop(set_as_default=True)
    _myservice = MyDBUSService(window)

def activate_if_already_running(app_id):
    """
    Activate the existing window if it's already running. Return True if found
    an existing window, and False otherwise.
    """
    bus = dbus.SessionBus()
    try:
        programinstance = bus.get_object(app_id, _get_path(app_id))
        activate = programinstance.get_dbus_method('activate', app_id)
    except dbus.exceptions.DBusException:
        return False
    else:
        print("A running process was found. Activating it.")
        activate()
        return True
    finally:
        bus.close()

class Notification(QtCore.QObject):
    """ Notification about Timer and Pomodoro events
    
    Notification uses Ubuntu Notify and sound played with paplay"""
    @QtCore.Slot(str, str, str)
    
    def somethingFinished(self, subject, body, soundfile):
        timerSound = os.path.join(os.path.dirname(__file__), soundfile)
        Notify.init("Timer finished")
        notification = Notify.Notification.new (subject, body, NOTIFICATION_ICON)
        notification.set_urgency(Notify.Urgency.CRITICAL)
        notification.show()
        subprocess.Popen(["paplay", timerSound])

class Ticking(QtCore.QObject):
    """ Ticking sound when doing work """
    
    @QtCore.Slot(str)
    
    def tickTick(self, soundfile):
        tickingSound = os.path.join(os.path.dirname(__file__), soundfile)
        subprocess.Popen(["paplay", tickingSound])

class Launcher(QtCore.QObject):
    
    """ Stuff specific to Unity Launcher """
    @QtCore.Slot(str)
    def setUrgent(self, value):
        """ Setting urgent state of icon in Unity launcher """
        LAUNCHER.set_property("urgent", value)

    
    @QtCore.Slot(int, str)
    
    def getPomodoroCount(self, value, booleen):
        """ Display number of minutes of pomodoro in Unity Launcher """
        LAUNCHER.set_property("count", value)
        LAUNCHER.set_property("count_visible", booleen)
    
    @QtCore.Slot(float)
    def getTimerProgress(self, value):
        """ Display timer progress """
        LAUNCHER.set_property("progress", value)
        if value > 0:
            LAUNCHER.set_property("progress_visible", True)
        else:
            LAUNCHER.set_property("progress_visible", False)


class SaveClass(QtGui.QMainWindow):
    """ Save Lap times and/or Split times from Stopwatch """
    @QtCore.Slot(str, str)

    def getSomethingToSave(self, file_title, text_to_write):
        now = datetime.datetime.now()
        file_name = file_title+" "+str(now.strftime("%x %X")+".txt")
        fileName, filtr = QtGui.QFileDialog.getSaveFileName(self,
                "Save "+file_title,
                file_name,
                "Text Files (*.txt);;All Files (*)")

        if fileName:
            laptimefile = open(fileName, "w+")
            laptimefile.write(text_to_write)
            laptimefile.close()

            
class SystemTrayIcon(QtGui.QSystemTrayIcon):
    
    def __init__(self, icon, parent=None):
        QtGui.QSystemTrayIcon.__init__(self, icon, parent)
        menu = QtGui.QMenu(parent)

        self.setContextMenu(menu)
        self.showMainWindow = QtGui.QAction("Show", self, triggered = self.onShowMainWindow)
        self.showMainWindow.setVisible(False)
        
        self.hideMainWindow =QtGui.QAction("Hide", self)
        self.hideMainWindow.setVisible(True)
        self.hideMainWindow.triggered.connect(self.onHideMainWindow)
        
        self.stopwatchMenuTitle = QtGui.QAction("Stopwatch", self)
        self.stopwatchMenuTitle.setDisabled(True)

        self.stopwatchMenuStart = QtGui.QAction("Start stopwatch", self, triggered = self.onStopwatchStart)
    
        self.stopwatchMenuPause = QtGui.QAction("Pause stopwatch", self, triggered = self.onStopwatchPause)
        self.stopwatchMenuPause.setVisible(False)
        
        self.stopwatchMenuResume = QtGui.QAction("Resume stopwatch", self, triggered = self.onStopwatchStart)
        self.stopwatchMenuResume.setVisible(False)
        
        self.stopwatchMenuLap = QtGui.QAction("Lap", self, triggered = self.onStopwatchLap)
        self.stopwatchMenuLap.setVisible(False)
        
        self.stopwatchMenuSplit = QtGui.QAction("Split", self, triggered = self.onStopwatchSplit)
        self.stopwatchMenuSplit.setVisible(False)
        
        self.stopwatchMenuReset = QtGui.QAction("Reset stopwatch", self, triggered = self.onStopwatchReset)
        self.stopwatchMenuReset.setVisible(False)
        
        self.timerMenuTitle = QtGui.QAction("Timer", self)
        self.timerMenuTitle.setDisabled(True)
        
        self.timerMenuSet = QtGui.QAction("Set timer", self, triggered = self.onTimerSet)
        
        self.timerMenuStop = QtGui.QAction("Stop timer", self, triggered = self.onTimerStop)
        self.timerMenuStop.setVisible(False)
        
        self.timerMenuReset = QtGui.QAction("Reset timer", self, triggered = self.onTimerReset)
        self.timerMenuReset.setVisible(False)
        
        self.workplayMenuTitle = QtGui.QAction("Work && Play", self)
        self.workplayMenuTitle.setDisabled(True)
        
        self.workplayMenuTime = QtGui.QAction("", self)
        self.workplayMenuTime.setDisabled(True)
        self.workplayMenuTime.setVisible(False)
        
        self.workplayMenuStart = QtGui.QAction("Start Work", self, triggered = self.onWorkplayStart)
        
        self.workplayMenuPause = QtGui.QAction("Pause Work", self, triggered = self.onWorkplayPause)
        self.workplayMenuPause.setVisible(False)
        
        self.workplayMenuResume = QtGui.QAction("Resume Work", self, triggered = self.onWorkplayResume)
        self.workplayMenuResume.setVisible(False)
        
        self.workplayMenuStartNextWork = QtGui.QAction("Start next Work unit", self, triggered = self.onWorkplayStartNextWork)
        self.workplayMenuStartNextWork.setVisible(False)
        
        self.workplayMenuStartNextBreak = QtGui.QAction("Start Break time", self, triggered = self.onWorkplayStartNextBreak)
        self.workplayMenuStartNextBreak.setVisible(False)
        
        self.workplayMenuStop = QtGui.QAction("Stop Work && Play", self, triggered = self.onWorkplayStop)
        self.workplayMenuStop.setVisible(False)

       
        menu.addAction(self.showMainWindow)
        menu.addAction(self.hideMainWindow)
    
        menu.addSeparator()
        
        menu.addAction(self.stopwatchMenuTitle)
        menu.addAction(self.stopwatchMenuStart)
        menu.addAction(self.stopwatchMenuPause)
        menu.addAction(self.stopwatchMenuResume)
        menu.addAction(self.stopwatchMenuLap)
        menu.addAction(self.stopwatchMenuSplit)
        menu.addAction(self.stopwatchMenuReset)
        
        menu.addSeparator()
    
        menu.addAction(self.timerMenuTitle)
        menu.addAction(self.timerMenuSet)
        menu.addAction(self.timerMenuStop)
        menu.addAction(self.timerMenuReset)

        menu.addSeparator()

        menu.addAction(self.workplayMenuTitle)
        menu.addAction(self.workplayMenuTime)
        menu.addAction(self.workplayMenuStart)
        menu.addAction(self.workplayMenuPause)
        menu.addAction(self.workplayMenuResume)
        menu.addAction(self.workplayMenuStartNextWork)
        menu.addAction(self.workplayMenuStartNextBreak)
        menu.addAction(self.workplayMenuStop)
    
        menu.addSeparator()
    
        menu.addAction(QtGui.QAction("Quit", self, triggered= app.exit))
    
    def iconActivated(self, reason):
        
        if reason == QtGui.QSystemTrayIcon.Trigger:
            trayIcon.showMainWindow.setVisible(False)
            trayIcon.hideMainWindow.setVisible(True)
            view.show()
            view.activateWindow()
        
    def onShowMainWindow(self):
        
        self.showMainWindow.setVisible(False)
        self.hideMainWindow.setVisible(True)
        view.show()
        view.activateWindow()
        view.raise_()
    
    def onHideMainWindow(self):
        
        self.hideMainWindow.setVisible(False)
        self.showMainWindow.setVisible(True)
        view.hide()
    
    def onStopwatchStart(self):
        
        self.stopwatchMenuStart.setVisible(False)
        self.stopwatchMenuPause.setVisible(True)
        self.stopwatchMenuLap.setVisible(True)
        self.stopwatchMenuSplit.setVisible(True)
        self.stopwatchMenuReset.setVisible(True)
        rootObject.startStopwatch()
        
    @QtCore.Slot()

    def onStopwatchStartFromQML(self):
        
        trayIcon.stopwatchMenuStart.setVisible(False)
        trayIcon.stopwatchMenuResume.setVisible(False)
        trayIcon.stopwatchMenuPause.setVisible(True)
        trayIcon.stopwatchMenuLap.setVisible(True)
        trayIcon.stopwatchMenuSplit.setVisible(True)
        trayIcon.stopwatchMenuReset.setVisible(True)
        
    
    def onStopwatchPause(self):
        
        self.stopwatchMenuPause.setVisible(False)
        self.stopwatchMenuResume.setVisible(True)
        rootObject.pauseStopwatch()
        
        
    @QtCore.Slot()
    
    def onStopwatchPauseFromQML(self):
        trayIcon.stopwatchMenuPause.setVisible(False)
        trayIcon.stopwatchMenuResume.setVisible(True)
    

    def onStopwatchReset(self):
        
        self.stopwatchMenuStart.setVisible(True)
        self.stopwatchMenuPause.setVisible(False)
        self.stopwatchMenuResume.setVisible(False)
        self.stopwatchMenuLap.setVisible(False)
        self.stopwatchMenuSplit.setVisible(False)
        self.stopwatchMenuReset.setVisible(False)
        rootObject.resetStopwatch()
        
    @QtCore.Slot()
    
    def onStopwatchResetFromQML(self):
        trayIcon.stopwatchMenuStart.setVisible(True)
        trayIcon.stopwatchMenuPause.setVisible(False)
        trayIcon.stopwatchMenuResume.setVisible(False)
        trayIcon.stopwatchMenuLap.setVisible(False)
        trayIcon.stopwatchMenuSplit.setVisible(False)
        trayIcon.stopwatchMenuReset.setVisible(False)
    
    def onStopwatchLap(self):
        rootObject.getLap()
        
    def onStopwatchSplit(self):
        rootObject.getSplit()
        
    def onTimerSet(self):
        self.showMainWindow.setVisible(False)
        self.hideMainWindow.setVisible(True)
        view.show()
        view.activateWindow()       
        view.raise_()
        rootObject.showTimer()
        
    @QtCore.Slot()
    
    def onTimerStartFromQML(self):
        trayIcon.timerMenuSet.setVisible(False)
        trayIcon.timerMenuStop.setVisible(True)
        trayIcon.timerMenuReset.setVisible(True)
    
    @QtCore.Slot()
    
    def onTimerStopFromQML(self):
        trayIcon.timerMenuSet.setVisible(True)
        trayIcon.timerMenuStop.setVisible(False)
        trayIcon.timerMenuReset.setVisible(False)
    
    def onTimerStop(self):
        self.timerMenuSet.setVisible(True)
        self.timerMenuStop.setVisible(False)
        self.timerMenuReset.setVisible(False)
        rootObject.stopTimer()
    
    def onTimerReset(self):
        self.timerMenuSet.setVisible(True)
        self.timerMenuStop.setVisible(False)
        self.timerMenuReset.setVisible(False)
        rootObject.resetTimer()
    
    @QtCore.Slot()
    
    def onWorkplayStartFromQML(self):
        trayIcon.workplayMenuStart.setVisible(False)
        trayIcon.workplayMenuPause.setVisible(True)
        trayIcon.workplayMenuResume.setVisible(False)
        trayIcon.workplayMenuStartNextWork.setVisible(False)
        trayIcon.workplayMenuStartNextBreak.setVisible(False)
        trayIcon.workplayMenuStop.setVisible(True)
    
    @QtCore.Slot(bool, str)
    
    def onWorkplayTimeChangefromQML(self, boolin, time):
        trayIcon.workplayMenuTime.setVisible(boolin)
        trayIcon.workplayMenuTime.setText(time)
        view.setWindowTitle("Zeegaree  |  " + time)
    
    
    @QtCore.Slot()
    
    def onWorkplayPauseFromQML(self):
        trayIcon.workplayMenuStart.setVisible(False)
        trayIcon.workplayMenuPause.setVisible(False)
        trayIcon.workplayMenuResume.setVisible(True)
        trayIcon.workplayMenuStartNextWork.setVisible(False)
        trayIcon.workplayMenuStartNextBreak.setVisible(False)
    
    @QtCore.Slot()
    
    def onWorkplayStopFromQML(self):
        trayIcon.workplayMenuStart.setVisible(True)
        trayIcon.workplayMenuPause.setVisible(False)
        trayIcon.workplayMenuResume.setVisible(False)
        trayIcon.workplayMenuTime.setVisible(False)
        trayIcon.workplayMenuStartNextWork.setVisible(False)
        trayIcon.workplayMenuStartNextBreak.setVisible(False)
        trayIcon.workplayMenuStop.setVisible(False)
        view.setWindowTitle("Zeegaree")

    
    @QtCore.Slot()
    
    def onWorkplayBreakFromQML(self):
        trayIcon.workplayMenuStart.setVisible(False)
        trayIcon.workplayMenuPause.setVisible(False)
        trayIcon.workplayMenuResume.setVisible(False)
        trayIcon.workplayMenuStartNextWork.setVisible(True)
        trayIcon.workplayMenuStartNextBreak.setVisible(False)
        trayIcon.workplayMenuStop.setVisible(True)
    
    @QtCore.Slot()
    
    def onWorkplayBreakWarnFromQML(self):
        trayIcon.workplayMenuStart.setVisible(False)
        trayIcon.workplayMenuPause.setVisible(False)
        trayIcon.workplayMenuResume.setVisible(False)
        trayIcon.workplayMenuStartNextWork.setVisible(False)
        trayIcon.workplayMenuStartNextBreak.setVisible(True)
        trayIcon.workplayMenuStop.setVisible(True)
    
    def onWorkplayStart(self):
        rootObject.startWorkplay()
    
    def onWorkplayPause(self):
        rootObject.pauseWorkplay()
    
    def onWorkplayResume(self):
        rootObject.resumeWorkplay()
    
    def onWorkplayStartNextWork(self):
        rootObject.startNextWorkWorkplay()
    
    def onWorkplayStartNextBreak(self):
        rootObject.startNextBreakWorkplay()
    
    def onWorkplayStop(self):
        rootObject.stopWorkplay()
        view.setWindowTitle("Zeegaree")

            
class MainWindow(QtDeclarative.QDeclarativeView):
        
    def closeEvent(self, event):
        """ Don't quit app if user set so """
        if rootObject.checkHideOnClose() == True: 
            event.ignore()
            self.hide()
            trayIcon.onHideMainWindow()
            trayIcon.showMessage('Zeegaree', 'Running in the background.')
            
if __name__ == '__main__':

    import sys
    
    APP_ID = 'com.mivoligo.zeegaree'
    activated = activate_if_already_running(APP_ID)
    if activated:
        sys.exit(0)
        
    app = QtGui.QApplication(sys.argv)
    view = MainWindow()
    view.setSource(QtCore.QUrl(os.path.join(os.path.dirname(__file__),'main.qml')))
    # Fit root object to be able to resize window
    view.setResizeMode(view.SizeRootObjectToView)
    view.setMinimumSize(QtCore.QSize(580, 480))
    view.setWindowIcon(QtGui.QIcon(NOTIFICATION_ICON))
    view.setWindowTitle("Zeegaree")

    # Get the root object of the user interface
    rootObject = view.rootObject()
    
    icon = QtGui.QIcon(TRAY_ICON)
    trayIcon = SystemTrayIcon(icon)
    
    notification = Notification()
    ticking = Ticking()
    launcher = Launcher()
    somethingtosave = SaveClass()
    trayicon = SystemTrayIcon(trayIcon)
    mainwindow = MainWindow()

    context = view.rootContext()
    context.setContextProperty("notification", notification)
    context.setContextProperty("ticking", ticking)
    context.setContextProperty("launcher", launcher)
    context.setContextProperty("somethingtosave", somethingtosave)
    context.setContextProperty("trayicon", trayicon)
    context.setContextProperty("mainwindow", mainwindow)

    trayIcon.show()
    trayIcon.activated.connect(trayicon.iconActivated)
    view.show()

    listen_for_activation(APP_ID, view)

    sys.exit(app.exec_()) 
