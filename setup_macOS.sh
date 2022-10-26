# This script fixes the dynamic libraries on macOS.
# Because of System Integrity measures, relative paths to libs are no longer valid, so we need to change those
# macOS brings a tool to do exactly that

# To get the correct results for the site packages, we want to be in the angr python context
echo "Installing VirtualEnvWrapper"
pip3 install virtualenvwrapper
echo "Installing Unicorn"
pip3 install unicorn
echo "Installing Angr"
pip3 install angr
echo "Setting up Virtual Environment"
virtualenv angr_testing
source angr_testing/bin/activate

echo "Virtual Environment is now setup. Deactivate virtual environment using 'deactivate' command"

if [ -z "$VIRTUAL_ENV" ]
then
	echo "Please activate your angr virtualenv before executing this script."
	echo "If you installed angr on your default python (bad idea) and want to continue, type 'continue'"
	read ans
	if ["$ans" != "continue"]
	then
		exit 1
	fi
fi
# To work for any setup, we get the paths to the relevant packages from python itself. (May not be in site packages)

echo "Setting up relevant packages from python"
PYVEX=`python3 -c 'import pyvex; print(pyvex.__path__[0])'`
UNICORN=`python3 -c 'import unicorn; print(unicorn.__path__[0])'`
ANGR=`python3 -c 'import angr; print(angr.__path__[0])'`

install_name_tool -change libunicorn.1.dylib "$UNICORN"/lib/libunicorn.dylib "$ANGR"/lib/angr_native.dylib
install_name_tool -change libpyvex.dylib "$PYVEX"/lib/libpyvex.dylib "$ANGR"/lib/angr_native.dylib

echo "Done with setup, all ready to use angr. Use 'deactivate' to exit virtual environment"
