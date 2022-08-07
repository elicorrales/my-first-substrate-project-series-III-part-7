#!/usr/bin/bash
#################################################################
# In case you're using cmd-line 'cargo contract blah blah',
# a convenience script useful for helping you more quickly
# do the build->upload->instantiate->call cycle.
#################################################################

projectdir=$1;
methodname1=$2;
methodname2=$3;

if [ "$projectdir" = "" ];
then
  echo;
  echo "ERROR projectdir";
  echo;
  exit 1;
fi;

if [ "$methodname1" = "" ];
then
  echo;
  echo "WARNING: no methodname1. Will not 'call' methdodname1";
  echo;
fi;


if [ "$methodname2" = "" ];
then
  echo;
  echo "WARNING: no methodname2. Will not 'call' methdodname2";
  echo;
fi;


cd ~/MySoftwareProjects/blockchain/rust/rust-substrate-blockchain-projects/my-first-substrate-projects/my-first-project/my-first-smart-contracts;

#this should be the directory where Cargo.toml and lib.rs are located.
cd $projectdir; # which rust smart contract project to work with;

# these are temp files used by this script. doesnt affect anything else.
rm -f upload.log instantiate.log 2>&1;

# you may not want to do this, so just remove if not.
echo;echo;echo "cargo update......";echo;echo;
cargo update;

# you may want to uncomment out the 2nd cargo build (for debug)
# and comment the one with '--release'.
echo;echo;echo "cargo contract build......";echo;echo;
cargo +nightly contract build --release;
#cargo +nightly contract build ;
if [ $? -ne 0 ];
then
  echo;
  echo "ERROR building";
  echo;
  exit 1;
fi;

# of course this will fail if your local node isn't running.
# this part grabs the 'Code hash' to use in the instantiate.
echo;echo;echo "cargo contract upload......";echo;echo;
cargo contract upload --suri //Alice 2>&1 | tee upload.log;
code_hash=$(cat upload.log | tail -2 | grep "Code hash" | sed -e 's/^.*Code hash *//');
if [ "$code_hash" = "" ];
then
  echo;
  echo "ERROR uploading";
  echo;
  exit 1;
fi;

# this part grabs the 'Contract' to use in the call(s).
echo;echo;echo "cargo contract instantiate......";echo;echo;
cargo contract instantiate \
  --gas 500000000000 \
  --constructor new \
  --suri //Alice \
  --code-hash $code_hash 2>&1| tee instantiate.log;

Contract=$(cat instantiate.log | tail -2 | grep "Contract"|sed -e 's/^.*Contract *//');
echo $Contract;
if [ "$Contract" = "" ];
then
  echo;
  echo "ERROR instantiating";
  echo;
  exit 1;
fi;


if [ "$methodname1" != "" ];
then
  echo;echo;echo "cargo contract call $methodname1......";echo;echo;
  cargo contract call \
    --gas 500000000000 \
    --message $methodname1 \
    --suri //Alice \
    --contract $Contract
fi;



if [ "$methodname2" != "" ];
then
  echo;echo;echo "cargo contract call $methodname2......";echo;echo;
  cargo contract call \
    --gas 500000000000 \
    --message $methodname2 \
    --suri //Alice \
    --verbose \
    --contract $Contract
fi;


rm -f upload.log instantiate.log 2>&1;


echo;
echo $code_hash;
echo;
echo $Contract;
echo;
