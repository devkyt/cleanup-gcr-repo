source "./bin/colors.sh"


function gcloud_is_configured {
    if ! command -v gcloud &> /dev/null;
    then
        echo -e "${BoldRed}Error: could not find gcloud on the \$PATH"
        exit 1
    fi
}


function input_args_is_valid {

    local image_link=$1
    shift

    local keep=$1
    shift
    
    local dates=($@)

    image_link_is_valid $image_link || exit 1

    is_date_exist ${dates[@]} || exit 1

    for date in ${dates[@]}
    do  
        date_format_is_valid $date || exit 1
    done

    is_number $keep || exit 1

}


function image_link_is_valid {

    if  [[ -z $1 ]]; 
    then
        echo -e "${BoldRed}Error: link to the image must be specified"
        exit 1
    fi

    if [[ ! $1 =~ ^([-a-z._]{4,})(\/)([-a-z0-9._]{2,})(\/)([-a-z0-9._]{2,})$ ]];
    then
        echo -e "${BoldRed}Error: link must be in the format gcr.io/{project}/{image}"
        exit 1
    fi
}


function is_date_exist {

    local dates=($@)

    if [[ -z $dates ]];
    then
        echo -e "${BoldRed}Error: you need to pass the date by which images should be deleted"
        exit 1
    fi 

    if [[ ${#dates[@]} > 2 ]];
    then
        echo -e "${BoldRed}Error: too many arguments for date"
        exit 1
    fi 

}


function date_format_is_valid {

    if [[ ! $1 =~ ^([0-9]{4})(-)(1[0-2]|0?[1-9])(-)(3[01]|[12][0-9]|0?[1-9])$ ]];
    then 
        echo -e "${BoldRed}Date must be in the format YYYY-MM-DD. Got $1 instead"
        exit 1
    fi

}


function is_number {

    if [[ ! $1 =~ ^([0-9]*)$ ]];
    then
        echo -e "${BoldRed}Keep value must be a number. Got $1 instead"
        exit 1
    fi

}



