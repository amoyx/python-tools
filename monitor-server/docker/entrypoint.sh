if [ -d "init" ]; then
  for INITFILE in `ls init/*.sh`
   do
     if [ -f $INITFILE ]; then
       bash $INITFILE
     fi
   done
fi

$PYTHON_HOME/bin/python3 manage.py runserver 0.0.0.0:8000
