# -*- coding: utf-8 -*-

PLUGIN_NAME = u"Lookup PUID"
PLUGIN_AUTHOR = u"WPME Hofland"
PLUGIN_DESCRIPTION = "Show all releases that contains a track with the generated PUID"
PLUGIN_VERSION = "0.1"
PLUGIN_API_VERSIONS = ["0.9.0", "0.10"]

from PyQt4 import QtCore, QtGui, Qt
from picard.util import webbrowser2
from picard.ui.itemviews import BaseAction, register_file_action
from picard.metadata import register_track_metadata_processor

class SearchPUID(BaseAction):
    NAME = "Lookup PUID"
    def callback(self, objs):
        cluster = objs[0]
        url = "http://musicbrainz.org/show/puid/?puid="
        url += QtCore.QUrl.toPercentEncoding(cluster.metadata["musicip_puid"])
        if len(cluster.metadata["musicip_puid"]) > 1:
            webbrowser2.open(url)
        else:
            global w
            w = NoPUID()
            w.show()
register_file_action(SearchPUID())

class NoPUID(QtGui.QDialog):
    def __init__(self, parent=None):
        QtGui.QDialog.__init__(self, parent)
        self.setWindowTitle(_("No PUID found"))
        self.doc = QtGui.QTextDocument(self)
        self.textCursor = QtGui.QTextCursor(self.doc)
        font = QtGui.QFont()
        font.setFixedPitch(True)
        font.setPointSize(8)
        font.setWeight(QtGui.QFont.Normal)
        font.setFamily("")
        self.textFormat = QtGui.QTextCharFormat()
        self.textFormat.setFont(font)
        self.browser = QtGui.QTextBrowser(self)
        self.browser.setDocument(self.doc)
        vbox = QtGui.QHBoxLayout(self)
        vbox.addWidget(self.browser)     
        self.textCursor.insertText("No PUID tag. Please scan first or create one with MusicIP.", self.textFormat)
        self.textCursor.insertBlock()

w = NoPUID()
