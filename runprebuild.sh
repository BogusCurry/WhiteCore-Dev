#!/bin/bash
# Run prebuild to configure and create the appropriate Solution and Project files for building WhiteCore-Sim
#
# April 2015
# Rowan Deppeler <greythane@gmail.com>

ARCH="AnyCPU"
CONFIG="Debug"
BUILD=false
VERSIONONLY=false

USAGE="[-c <config>] -a <arch> -v"
LONG_USAGE="Configuration options to pass to prebuild environment

Options:
  -c|--config Build configuration Debug (default) or Release
  -a|--arch Architecture to target x86 (default), x64, or AnyCPU
  -b|--build Build after configuration No (default) or Yes
  -v|--version Update version details only
"

# check if prompting needed
if [ $# -eq 0 ]; then
    read -p "Architecture to use? (AnyCPU, x86, x64) [$ARCH]: " bits
    if [[ $bits == "x64" ]]; then ARCH="x64"; fi
    if [[ $bits == "64" ]]; then ARCH="x64"; fi
    if [[ $bits == "AnyCPU" ]]; then ARCH="AnyCPU"; fi
    if [[ $bits == "anycpu" ]]; then ARCH="AnyCPU"; fi

    read -p "Configuration? (Release, Debug) [$CONFIG]: " conf
    if [[ $conf == "Release" ]]; then CONFIG="Release"; fi
    if [[ $conf == "release" ]]; then CONFIG="Release"; fi
	
	bld="No"
	if [[ $BUILD == true ]]; then bld="Yes"; fi

    read -p "Build immediately? (Yes, No) [$bld]: " bld
    if [[ $bld == "Yes" ]]; then BUILD=true; fi
    if [[ $bld == "yes" ]]; then BUILD=true; fi
    if [[ $bld == "y" ]]; then BUILD=true; fi

else

# command line params supplied
while case "$#" in 0) break ;; esac
do
  case "$1" in
    -c|--config)
      shift
      CONFIG="$1"
      ;;
    -a|--arch)
      shift
      ARCH="$1"
      ;;
    -b|--build)
      BUILD=true
      shift
      ;;
    -v|--version)
      VERSIONONLY=true
      ;;
    -h|--help)
      echo "$USAGE"
      echo "$LONG_USAGE"
      exit
      ;;
    *)
      echo "Illegal option!"
      echo "$USAGE"
      echo "$LONG_USAGE"
      exit
      ;;
  esac
  shift
done

fi

# Configuring WhiteCore-Sim
if ! ${VERSIONONLY:=true}; then
  echo "Configuring WhiteCore-Sim $ARCH $CONFIG build"
  mono ./Prebuild.exe /target vs2010 /targetframework v4_5 /conditionals "LINUX;NET_4_5"
fi

# Update version info
if [ -d ".git" ]; then 
  git log --pretty=format:"WhiteCore (%cd.%h)" --date=short -n 1 > WhiteCoreSim/bin/.version; 
  echo "Version info updated"
fi

# Build WhiteCore-Sim
if ${BUILD:=true} ; then
  echo Building WhiteCore-Sim
  xbuild /property:Configuration="$CONFIG" /property:Platform="$ARCH"
  echo Finished Building WhiteCore
  echo Thank you for choosing WhiteCore-Sim
  echo Please report any errors to our Github Issue Tracker https://github.com/WhiteCoreSim/WhiteCore-Dev/issues
fi