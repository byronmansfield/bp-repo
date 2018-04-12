#!/bin/bash

#
# A bash script to parse flags in a more flexible way than getopts allows.
# I have put in a few typical cli tool expectancies such as version and help.
# There is also multiple examples of how you can handle different combinations of flags like combining short flags together, handling short and long flags that require an argument passed. They are just put there in case you care to handle these things. In most cases they are probably not necessary.
#

# strict mode
set -euo pipefail
set +x

# Global variables
VERSION="0.0.1"

# Set variable from env var that is a required env var with custom message
: "${X_API_KEY:?Need to set X_API_KEY}"

# Set variable from env var if env var is set, otherwise default to provided
USER=${USER:=`whoami`}

help() {
  echo "Usage: ./cli-script [OPTIONS]... [OPTIONS=VALUE]..."
  echo "Command line tool to do awesome things"
  echo ""
  echo "Options:"
  echo "  -b, --byron          Print byron name"
  echo "  -m, --meng           Print meng name"
  echo "  -n NAME, -n=NAME, --name NAME, --name=NAME"
  echo "                       Print value of NAME passed"
  echo "  -h, --help           Display the help text"
  echo "  -v, --version        Output the version information"
  echo ""
  echo "You can combine short flags like ./cli-script -bm"
  exit 0
}

version() {
  echo "./cli-script version ${VERSION}"
  exit 0
}

byron() {
  echo "Byron function"
}

meng() {
  echo "Meng Meng"
}

special() {
  echo "You only passed two tac's, where is the flag?"
}

long() {
  echo "Long Error"
}

short() {
  echo "Short Error"
}

_done() {
  echo "Done!"
}

main() {

  if [ $# -lt 1 ]; then
    echo "no arguments were passed"
    help
  fi

  while [ $# -gt 0 ]; do
    case $1 in

      # typical bash script flags
      -h | --help)
        help
        ;;
      -v | --version)
        version
        ;;

      # cmd-script flags

      # basic simple long or short ones
      -b | --byron)
        byron
        # shift - makes script ignore all the rest of the args
        ;;
      -m | --meng)
        meng
        # shift
        ;;

      # short args that require a second value be passed
      -n | -n=*)
        if [ -z $2 ]; then
          name="${1#*=}"
        else
          name="$2"
        fi
        echo "name is ${name}"
        # shift 2
        ;;
      -p)
        pidfile="$2"
        shift 2
        ;;
      -l | -l=*)
        if [ -z $2 ]; then
          logfile="${1#*=}"
        else
          logfile="$2"
        fi
        echo "logfile is ${logfile}"
        # shift 2
        ;;
      -n|-p|-l)
        echo "$1 requires an argument" >&2
        exit 1
        ;;

      # long args that require a second value be passed
      --name=*)
        name="${1#*=}"
        echo "name is ${name}"
        # shift 1
        ;;
      --pidfile=*)
        pidfile="${1#*=}"
        shift 1
        ;;
      --logfile=*)
        logfile="${1#*=}"
        echo "logfile is ${logfile}"
        # shift 1
        ;;
      --name|--pidfile|--logfile)
        echo "$1 requires an argument with format of $1=[value]" >&2
        exit 1
        ;;

      # Special cases
      --)
        special
        break
        ;;
      --*)
        # error unknown (long) option $1
        long
        ;;
      -?)
        # error unknown (short) option $1
        short
        ;;

      # FUN STUFF HERE:
      # Split apart combined short options
      -*)

        #
        # You can catch anything other than defined ones and thrown and error and message and exit out like this, which is easy and straight forward
        #
        # echo "unknown option: $1" >&2; exit 1;;
        #
        # Or you can do something more creative like handling combined flags.
        # The issue is if you have combined flags along with an unknown one, it is still going to try and parse it.
        # Alternatively you can try to brute force it with a long ugly if else statement that includes checking for every single flag.
        # Unless there is a better way I have not found yet.
        # If you want to combine the flags you can do so like this:
        #

        split=$1
        echo "split is ${split}"
        shift

        echo ""
        echo "arg count before is $#"
        echo ""

        set -- $(echo "$split" | cut -c 2- | sed 's/./-& /g') "$@"

        echo "arg count after is $#"
        echo ""

        for arg in "$@"; do
          echo "arg is ${arg}"
        done

        continue
        ;;

      # Done with options
      *)
        # This is where you would catch everything else and throw an error
        # handle_argument "$1"
        # shift 1
        # ;;

        _done
        break
        ;;
    esac

    # for testing purposes:
    # echo "$1"

    shift

  done

}

main "$@"

