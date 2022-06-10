WORKDIR=`pwd`
rm lambda.zip
virtualenv buildenv
source buildenv/bin/activate
pip install -r requirements.txt
pip install -e .
cd buildenv/lib/python3.8/site-packages
zip -r ../../../../lambda.zip .
cd $WORKDIR
zip -r lambda.zip rasfi_method -x "rasfi_method/__pycache__/*"
rm -r buildenv