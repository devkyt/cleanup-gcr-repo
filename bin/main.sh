#!/bin/bash
source "./validators.sh"
source "./gcloud-operations.sh"

IFS=,

while getopts i:d: option 
    do
        case $option in
            i)
            image_link=${OPTARG};;
            d)
            dates=($OPTARG);;
        esac
done

IFS=$' \n\t'

gcloud_is_configured || exit 1
input_args_is_valid $image_link ${dates[@]} || exit 1


digests=$(load_digests_for_image $image_link ${dates[@]})


delete_images_by_digests $image_link $digests


