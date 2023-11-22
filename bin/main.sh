#!/bin/bash
source "./bin/validators.sh"
source "./bin/gcloud.sh"

IFS=,

while getopts i:d:k: option 
    do
        case $option in
            i)
            image_link=${OPTARG};;
            d)
            dates=($OPTARG);;
            k)               
            keep=${OPTARG};; 
        esac
done


if [[ -z $dates ]];
then
    dates="2099-12-12"
fi


if [[ -z $keep ]];
then
    keep=0
fi


IFS=$' \n\t'


gcloud_is_configured || exit 1
input_args_is_valid $image_link $keep ${dates[@]} || exit 1


digests=$(load_digests_for_image $image_link ${dates[@]})


read -ra digests <<< "$digests"
digests=(${digests[@]:$keep})


delete_images_by_digests $image_link ${digests[@]}


