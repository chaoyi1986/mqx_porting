#! /bin/sh

# Copy BSP environment from old chip, including generator/ config/ and mqx/source/bsp files
# Running under MQX Repo root directory

# Written by Peter Wang.
# Changelist
# 20131023 v0.1 
#     Implement copy dir and file for config/ generator/ and mqx/source/bsp

if [ "$1" = "-v" ] || [ "$1" = "--version" ]; then
   echo "copybsp version 0.1"
   exit 1
fi

if [ $# -ne 2 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
   echo "Usage: copybsp bsp_from_name bsp_to_name"
   echo "Copy bsp environment from old chip, including generator/ config/ and mqx/source/bsp files"
   echo "Example: copybsp twrk60f120m twrk65f180m"
 exit 1
fi

# for name read
oldbsp=`echo "$1" | tr "A-Z" "a-z"`
newbsp=`echo "$2" | tr "A-Z" "a-z"`

oldbspup=`echo "${oldbsp}" | tr "a-z" "A-Z"`
newbspup=`echo "${newbsp}" | tr "a-z" "A-Z"`

echo "Copy BSP from ${oldbsp} to ${newbsp}"
echo "There are two steps:"

echo ""
echo "Step1: copy dir in config,generator,mqx/source/bsp"
# for generator, config,bsp DIR copy
for dir in `find config generator mqx/source/bsp -iname "*${oldbsp}*" -type d`;
do
    # for new dir name
    newdir=$(echo $dir | sed -e "s/\(.*\)${oldbsp}\(.*\)/\1${newbsp}\2/");

    if [ "$dir" != "$newdir" ]; then
        echo "$dir copy to $newdir"

        # for dir copy
        cp -r $dir $newdir

        # for bsp name replase
        echo "    replace string form ${oldbsp} to ${newbsp}"
        sed -i "s/${oldbsp}/${newbsp}/g" `find $newdir -type f`

        echo "    replace string form ${oldbspup} to ${newbspup}"
        sed -i "s/${oldbspup}/${newbspup}/g" `find $newdir -type f`

        # for file rename
        for file in `find $newdir -iname "*${oldbsp}*" -type f`;
        do
            newfile=$(echo $file | sed -e "s/\(.*\)${oldbsp}\(.*\)/\1${newbsp}\2/");
            echo "    $file rename to $newfile"
            mv $file $newfile
        done
    fi
done

echo ""
echo "Step2: copy files in generator"
# for generator file copy
for file in `find generator -iname "*${oldbsp}*" -type f`;
do
    # for new dir name
    filedir=$(dirname $file)

    if [ "" = "`echo $filedir | grep -i ${oldbsp}`" ]; then
        newfile=$(echo $file | sed -e "s/\(.*\)${oldbsp}\(.*\)/\1${newbsp}\2/");

        echo "$file copy to $newfile"
        cp $file $newfile

        # for bsp name replase
        echo "    replace string form ${oldbsp} to ${newbsp}"
        sed -i "s/${oldbsp}/${newbsp}/g" $newfile

        echo "    replace string form ${oldbspup} to ${newbspup}"
        sed -i "s/${oldbspup}/${newbspup}/g" $newfile
    fi
done

echo "Copy BSP finished"
