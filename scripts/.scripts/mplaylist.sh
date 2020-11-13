#! /bin/sh
# source: https://github.com/pts/mplaylist
# -*- mode: python; -*-
# by pts@fazekas.hu at Sat Feb 26 22:39:44 CET 2011

""":" #mplaylist: Audio playlist player using mplayer, with checkpointing

type python2.7 >/dev/null 2>&1 && exec python2.7 -- "$0" ${1+"$@"}
type python2.6 >/dev/null 2>&1 && exec python2.6 -- "$0" ${1+"$@"}
type python2.5 >/dev/null 2>&1 && exec python2.5 -- "$0" ${1+"$@"}
type python2.4 >/dev/null 2>&1 && exec python2.4 -- "$0" ${1+"$@"}
exec python -- ${1+"$@"}; exit 1

mplaylist is Python script which can play audio playlists (.m3u files),
remembering the current playback position (file and time) even when killed,
so it will resumes playback at the proper position upon restart. The playback
position is saved as an .m3u.pos file next to the .m3u file. mplaylist
uses mplayer for playing the audio files.

Requirements: Python (2.4, 2.5, 2.6 or 2.7; doesn't work with 3.x) and mplayer.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

TODO(pts): Properly resume TTY input after a SIGSTOP.
"""

import errno
import os
import os.path
import re
import signal
import sys


def ShellQuote(string):
  string = str(string)
  if string and not re.search('[^-_.+,:/a-zA-Z0-9]', string):
    return string
  else:
    return "'%s'" % string.replace("'", "'\\''")


def CrLfLines(fd):
  """Yields lines ending with CR or LF."""
  buf = []
  while True:
    data = None
    data = os.read(fd, 8192)
    if not data:
      break
    i = data.find('\r') + 1
    j = data.find('\n') + 1
    if i <= 0 or (j > 0 and j < i):
      i = j
    if i <= 0:
      buf.append(data)
      continue
    if buf:
      if len(buf) > 1:
        buf[:] = [''.join(buf)]
      yield buf.pop() + data[:i]
    else:
      yield data[:i]
    while len(data) > i:
      k = data.find('\r', i) + 1
      j = data.find('\n', i) + 1
      if k <= 0 or (j > 0 and j < k):
        k = j
      if k <= 0:
        buf.append(data[i:])
        break
      yield data[i : k]
      i = k
  data = ''.join(buf)
  if data:
    yield data


def Play(mediafns, posfn, media_prefix, seek_decisec, mplayer_flags):
  assert mediafns, 'no files to play'
  ss_flag = ''
  speed = None
  if seek_decisec:
    i = int(seek_decisec)
    if i > 0:
      ss_flag = '-ss %d.%d ' % (i / 10, i % 10)
      assert len(mediafns) == 1, 'preseeking in muliple files does not work'

  # We need an exec here to get rid of the shell, and to get a proper status
  # code.
  cmd = (
      'exec mplayer -vc null -vo null -noautosub -af-add scaletempo %s%s -- %s'
      % (ss_flag, ' '.join(map(ShellQuote, mplayer_flags)),
         ' '.join(map(ShellQuote, mediafns))))
  print >>sys.stderr, 'info: running mplayer command: %s' % cmd
  logf = None
  f = os.popen(cmd)
  try:
    mediafn = shortfn = None
    is_all_played = False
    for line in CrLfLines(f.fileno()):
      # Example: 'Playing Radiokabare.2010.Meggyuruztek.Bodocs.Tibor.I.resz-szaszkievics/09.Koszonto.Kohalmi.Zoltan-szaszkievics.mp3.\n'
      # Example: 'Starting playback...\n'
      # Example: 'A:   4.5 (04.5) of 370.0 (06:10.0)  1.4% \x1b[J\r'
      # Example: 'A:   4.6 V:   4.6 A-V: -0.001 ct: -0.007 117/117  0%  0%  1.4% 0 0 \x1b[J\r'
      # Example: 'A:1092.9 (18:12.9) of 3289.0 (54:49.0)  5.1% 1.50x \x1b[J\r'
      # Example: 'Exiting... (End of file)\n'
      # Example: 'Exiting... (Quit)\n'
      sys.stdout.write(line)
      sys.stdout.flush()
      if mediafn is not None and line.startswith('A:'):
        match = re.match(r'A: *(\d+)[.](\d)\d* ', line)
        if match:
          decisec = int(match.group(1)) * 10 + int(match.group(2))
          assert decisec <= 999999999
          decisec_str = '%09d' % decisec
          if logf is None:
            logf = open(posfn, 'w+')  # TODO(pts): Be more atomic.
            logf.write('%s %s\n' % (decisec_str, shortfn))
          else:
            logf.seek(0, 0)
            logf.write(decisec_str)
          logf.flush()
          match = re.search(r' (\d+[.]\d\d)x ', line)
          if match:
            speed = match.group(1)
          else:
            speed = '1.0'  # Implicit, not reported by mplayer.
      elif line.startswith('Playing '):
        match = re.match(r'Playing ([^\r\n]+)[.]\n\Z', line)
        if match:
          mediafn = match.group(1)
          if mediafn.startswith(media_prefix):
            shortfn = mediafn[len(media_prefix):]
          else:
            shortfn = mediafn
          if logf:
            logf.seek(0, 0)
            data = '000000000 %s\n' % shortfn
            logf.write(data)
            logf.flush()
            logf.truncate(len(data))
      elif line.startswith('Exiting... (End of file)'):
        is_all_played = True
  finally:
    if logf:
      logf.close()
    status = f.close() or 0
    print >>sys.stderr, 'info: mplayer exit status=0x%x' % status
  return mediafn, status, is_all_played, speed


def main(argv):
  if len(argv) <= 1 or argv[1] == '--help':
    print 'Usage: %s [<mplayer-flag> ...] <playlist.m3u>' % argv[0]
    return 1
  playlistfn = argv[-1]
  mediafns = []
  mediafns_set = set()
  f = open(playlistfn)
  try:
    if '/' in playlistfn:
      media_prefix = playlistfn[:playlistfn.rfind('/') + 1]
    else:
      media_prefix = ''
    for line in f:
      line = line.rstrip('\r\n')
      if line == '#EXTM3U' or not line:
        continue
      mediafn = line
      if media_prefix and not line.startswith('/'):
        mediafn = media_prefix + line
      if not os.path.isfile(mediafn):
        # TODO(pts): Maybe skip later, the user might create the
        # file while a previous file is being played.
        print >>sys.stderr, (
            'warning: media file not found, skipping: %s' % mediafn)
        continue
      if mediafn in mediafns_set:
        print >>sys.stderr, (
            'warning: duplicate media file, skipping: %s' % mediafn)
        continue
      mediafns.append(mediafn)
      mediafns_set.add(mediafn)
  finally:
    f.close()
  if not mediafns:
    print >>sys.stderr, 'error: no media files to play, exiting'
    return 2
  posfn = playlistfn + '.pos'
  mplayer_flags = argv[1 : -1]
  # TODO(pts): Remember playback speed in posfn.
  old_speed = None
  speed_idx = None
  for i in xrange(len(mplayer_flags) - 1):
    if mplayer_flags[i] == '--':
      break
    # This argument parser is not correct, because it doesn't skip an argument
    # if it's a flag value.
    if mplayer_flags[i] == '-speed':
      speed_idx = i + 1
      old_speed = mplayer_flags[speed_idx]

  # Read saved playback position from posfn.
  f = None
  data = ''
  try:
    try:
      f = open(posfn)
    except IOError, e:
      if e[0] != errno.ENOENT:
        raise
    if f:
      data = f.read()
  finally:
    if f:
      f.close()

  if data.startswith('FINISHED'):
    print >>sys.stderr, 'info: playlist had finished, exiting'
    return 3
  if not data:
    print >>sys.stderr, 'info: starting from the beginning'
    seek_decisec = 0
    mediafn = mediafns[0]
    i = 0
  else:
    match = re.match(r'(\d{9}) ([^\r\n]+)\n\Z', data)
    if not match:
      print >>sys.stderr, 'error: syntax error in pos file: %s' % posfn
      return 4
    seek_decisec = int(match.group(1))
    mediafn = match.group(2)
    if not mediafn.startswith('/'):
      mediafn = media_prefix + mediafn
    print >>sys.stderr, 'info: starting at %d.%d of %s\n' % (
        seek_decisec / 10, seek_decisec % 10, mediafn)
    if mediafn in mediafns_set:
      i = mediafns.index(mediafn)
    else:
      print >>sys.stderr, (
          'warning: start file not in playlist, starting from the beginning')
      seek_decisec = 0
      mediafn = mediafns[0]
      i = 0
  data = None

  while i < len(mediafns):
    if seek_decisec > 0:
      # Play only one file at a time if preseeking is required, because
      # mplayer -ss would preseek in all files.
      mediafns_to_play = mediafns[i : i + 1]
      i += 1
    else:  # Play as many files as fits into the command-line.
      bytes_remaining = 30000  # TODO(pts): Subtract the size of os.environ?.
      for flag in mplayer_flags:
        bytes_remaining -= 20 + len(flag)
      j = i + 1
      while j < len(mediafns) and bytes_remaining >= 20 + len(mediafns[j]):
        bytes_remaining -= 20 + len(mediafns[j])
        j += 1
      mediafns_to_play = mediafns[i : j]
      i = j
    mediafn, status, is_all_played, speed = Play(
        mediafns_to_play, posfn, media_prefix, seek_decisec, mplayer_flags)
    if speed is not None:  # Propagate playback speed to subsequent files.
      if speed_idx is None:
        mplayer_flags[:0] = ['-speed', speed]
        speed_idx = 1
        old_speed = speed
      elif abs(float(old_speed) - float(speed)) > 0.02:
        # Adjust playback speed for subsequent files, but only if new speed
        # is considerable different from the old one -- to prevent rounding
        # errors.
        mplayer_flags[speed_idx] = old_speed = speed
    seek_decisec = 0  # Start playing the next file from the beginning.
    if is_all_played:
      if i == len(mediafns):
        data = 'FINISHED\n'
      else:
        data = '000000000 %s\n' % mediafns[i:]
      f = open(posfn, 'w+')
      try:
        f.write(data)
      finally:
        f.close()
    if not is_all_played or status:
      print >>sys.stderr, 'info: exiting with status=0x%x' % status
      if os.WIFSIGNALED(status):
        sig = os.WTERMSIG(status)
        if sig != signal.SIGKILL:
          signal.signal(sig, signal.SIG_DFL)
        os.kill(os.getpid(), sig)
      if os.WIFEXITED(status):
        os._exit(os.WEXITSTATUS(status))
      os._exit(127)  # Failsafe.

  print >>sys.stderr, 'info: finished playlist'


if __name__ == '__main__':
  sys.exit(main(sys.argv))
