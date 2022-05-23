#!/usr/bin/python3

from subprocess import getoutput, call

def main():
  files = getoutput("locate -e --regex -b '\\.pacnew$'").split('\n')
  for f in files:
    if f:
      print("Diff'ing", f)
      call(['sudo', 'vimdiff', f.rsplit('.', 1)[0], f])

if __name__ == '__main__':
  main()
