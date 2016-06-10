#!/usr/bin/env bash
#
# stich together harvest fields from ngwh (new good wood harvest) datasets onto an old
# pftdyn dataset so that only the harvest fields change for after 2005.
#
do_cmd () {
   cmd=$1
   verbose=$2
   execute=$3

   if [ "$verbose" = "YES" ]; then
      echo "$cmd"
   fi
   if [ "$execute" = "YES" ]; then
     $cmd
     rc=$?
   else
     rc=0
   fi
   if [ $rc != 0 ]; then
       echo "Error status returned from running command: $cmd"
       exit 4
   fi
}

   verbose="YES"
   execute="YES"

   . /glade/apps/opt/lmod/lmod/init/bash
   module load nco ncl
   sdate=`date +%y%m%d`
   export DIN_LOC_ROOT="$CESMDATAROOT/inputdata"
   filnams="input_pftdata_filename"
   harflds="HARVEST_VH1,HARVEST_VH2,HARVEST_SH1,HARVEST_SH2,HARVEST_SH3,GRAZING"
   cd ../../../bld/ 
   querydir=`pwd`
   cd -
   querynml="$querydir/queryDefaultNamelist.pl -silent -justvalue -csmdata $DIN_LOC_ROOT -var fpftdyn"

   declare -a resolutions=("10x15" "48x96" "ne30np4")
   declare -a repconpath=("6" "8.5")

   cd /glade/scratch/$USER/tmp
   for res in ${resolutions[*]}; do
      echo "Run for resolution=$res"
      for rcp in ${repconpath[*]}; do
         echo "Run for rcp=$rcp"
         querynmlres="$querynml -res $res -options rcp=$rcp"
         echo "$querynmlres"
         file=`$querynmlres -phys clm4_0`
         if [ ! -f "$file" ]; then
            echo "$file does NOT exist"
            exit 4
         fi
         fileh=`$querynmlres -phys clm4_5`
         if [ ! -f "$fileh" ]; then
            echo "$fileh does NOT exist"
            exit 4
         fi
         cesmfile=`$querynmlres  -phys clm4_0 -cesm`
         cesmfileh=`$querynmlres -phys clm4_5 -cesm`
   
         if [ ! "$execute" = "YES" ]; then
            touch surfdata.pftdyn_${res}_rcp${rcp}_harvest.simyr1850-2005_$sdate.nc
         fi
         cmd="ncks -O -v $harflds -d time,0,155 $file surfdata.pftdyn_${res}_rcp${rcp}_harvest.simyr1850-2005_$sdate.nc"
         do_cmd "$cmd" $verbose $execute
         cmd="ncks -O -v $harflds -d time,156, $fileh surfdata.pftdyn_${res}_rcp${rcp}_harvest.simyr2006-2100_$sdate.nc"
         do_cmd "$cmd" $verbose $execute
         cmd="ncrcat -O surfdata.pftdyn_${res}_rcp${rcp}_harvest.simyr1850-2005_$sdate.nc surfdata.pftdyn_${res}_rcp${rcp}_harvest.simyr2006-2100_$sdate.nc surfdata.pftdyn_${res}_rcp${rcp}_harvest.simyr1850-2100_$sdate.nc"
         do_cmd "$cmd" $verbose $execute
         outfile="surfdata.pftdyn_${res}_rcp${rcp}.simyr1850-2100_$sdate.nc"
         script="redimcharscript.ncl"
         if [[ "$res" =~ "ne" ]]; then
            gridnames="\"gridcell\""
            grdunlim="False"
         else
            gridnames="\"lsmlon\", \"lsmlat\""
            grid="$lon, $lat"
            grdunlim="False, False"
         fi
         if [[ "$res" =~ "ne" ]]; then
            if [ "$execute" = "YES" ]; then
               gridcell=`ncdump -h $file  | grep "gridcell =" | awk '{print $3}'`
            else
               gridcell=48602
            fi
            grid="$gridcell"
         else
            if [ "$execute" = "YES" ]; then
               lon=`ncdump -h $file  | grep "lsmlon =" | awk '{print $3}'`
               lat=`ncdump -h $file  | grep "lsmlat =" | awk '{print $3}'`
            else
               lon=288
               lat=192
            fi
            grid="$lon, $lat"
         fi

         if [ -z "$grid" ]; then
            echo "grid NOT found"
            exit 4
         fi
         echo "grid($gridnames) = $grid"
         if [ -f "$outfile" ];then
            /bin/rm $outfile
         fi
         cat << EOF > $script
         begin
            nco = addfile( "$outfile", "c" );
            dimnames = (/ $gridnames, "nlevurb", "numsolar", "numrad", "lsmpft", "time", "nchar" /);
            dsizes   = (/      $grid,        15,          2,        2,       17,    251,     256 /);
            is_unlim = (/  $grdunlim,     False,      False,    False,    False,   True,   False /);
            print( dimnames );
            print( dsizes   );
            filedimdef( nco, dimnames, dsizes, is_unlim );
         end
EOF
         do_cmd "ncl $script" $verbose $execute
         if [ "$execute" != "YES" ]; then
            cat $script
            touch $outfile
         fi
         /bin/rm $script
         chmod 0644 $outfile
         cmd="ncks -A  $file $outfile"
         do_cmd "$cmd"  $verbose $execute
         cmd="ncks -A -v $harflds surfdata.pftdyn_${res}_rcp${rcp}_harvest.simyr1850-2100_$sdate.nc $outfile"
         do_cmd "$cmd"  $verbose $execute
         cmd="ncks -A -v $filnams $fileh $outfile"
         do_cmd "$cmd" $verbose $execute
         if [ "$execute" = "YES" ]; then
            ncatted -A --attribute note,GLOBAL,a,c,"Frankenfile starting from $cesmfile and then overwriting the harvest fields for 2006-2100 with $cesmfileh and adding $filnams from that file as well" $outfile
         else
            echo "Do not add note to file as required to run directly in script"
            echo "$cesmfile $cesmfileh"
         fi
         ls -l $outfile
      done
   done
   pwd
