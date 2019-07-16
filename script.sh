#!bin/bash

cat << "EOF"
   _             _ _
  (_)           (_) |
   _  __ _ _ __  _| |_ ___  _ __
  | |/ _` | '_ \| | __/ _ \| '__|
  | | (_| | | | | | || (_) | |
  | |\__,_|_| |_|_|\__\___/|_|
_/ |
|__/
EOF

oc login ${CLUSTER} --username=${USERNAME} --password=${PASSWORD} --insecure-skip-tls-verify

oc whoami 

oc project ${PROJECT}

#get list of services NOT to delete from environment variable DONT_DELETE
dontDelete=${SAVE_THESE_SERVICES}
dontDeleteArr=$(echo $dontDelete | tr " " "\n")

echo "Services to save: $dontDelete"

#iterate through list of all builds
for build in $( oc get bc -o name ); do
    service=${build#*/}

    echo "---working with $service"

    #check if build is in list of items NOT to delete
    #if so, skip this item and continue iterating through builds
    for item in $dontDeleteArr; do
        if [ "$service" == "$item" ]; then
            echo "------$service is in the list to save. Continuing"
            continue 2
        fi
    done
    latestBuild="build/$service-"$(oc get $build -o jsonpath={.status.lastVersion})
    echo "Latest Build: $latestBuild"
    createdDateRaw=$(oc get $latestBuild -o jsonpath={.metadata.creationTimestamp})
    createdDate=${createdDateRaw%T*}
    createdDateNum=$(date -d $createdDate +"%Y%m%d")
    echo "Created Date: $createdDateNum"

    #get the date to start deleting,
    #using input from environment variables (DAYS_TO_HOLD)
    deleteDateNum=$(date --date="7 days ago" +"%Y%m%d" )
    echo "Compare to date: $deleteDateNum"

    #if build is older than DAYS_TO_HOLD, delete the service
    #and associated items
    if [ $createdDateNum -lt $deleteDateNum ];
    then
        #get service name from full build name
        service=${build#*/}

        oc delete dc/$service
        oc delete bc/$service
        oc delete route/$service
        oc delete svc/$service
    fi
done
