#!/bin/bash
 
NAME="GitSpatial"                                       # Name of the application
DJANGODIR=/home/gitspatial/apps/gitspatial/gitspatial   # Django project directory
SOCKFILE=/home/gitspatial/gitspatial/run/gunicorn.sock  # we will communicte using this unix socket
USER=gitspatial                                         # the user to run as
GROUP=gitspatial                                        # the group to run as
NUM_WORKERS=3                                           # how many worker processes should Gunicorn spawn
DJANGO_SETTINGS_MODULE=gitspatial.settings.production   # which settings file should Django use
DJANGO_WSGI_MODULE=gitspatial.wsgi                      # WSGI module name
 
echo "Starting $NAME"
 
# Activate the virtual environment
cd $DJANGODIR
source ../venv/bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH
 
# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR
 
# Start your Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
exec ../venv/bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  --user=$USER --group=$GROUP \
  --log-level=debug \
  --bind=unix:$SOCKFILE