source "./colors.sh"


function load_digests_for_image {
    local image_link=$1
    shift
    local dates=($@)

    case ${#dates[@]} in 
        2)
        filter_criteria="timestamp.datetime>=${dates[1]} AND timestamp.datetime<${dates[0]}";;
        *)
        filter_criteria="timestamp.datetime<${dates[0]}";;
    esac

    echo $( gcloud container images list-tags $image_link \
        --format="get(digest)" \
        --filter="$filter_criteria" \
        --sort-by="timestamp")
}


function delete_images_by_digests {

    local image_link=$1
    shift
    local digests="$@"
    local deleted_images_counter=0

    for digest in $digests
    do  
        echo "$image_link@$digest"
        gcloud container images delete "$image_link@$digest" \
        --force-delete-tags \
        --quiet

        ((deleted_images_counter++))
    done

    echo -e "${BoldGreen}Total images have been deleted: $deleted_images_counter "
}